"""
Weekly build job: download MTGJSON's AllPrintings.sqlite, project + transform
into the mtg-companion app's Drift `cards` schema, compress, upload to R2.

Outputs uploaded to R2:
  - cards-<YYYY-MM-DD>.sqlite.gz   (versioned, immutable)
  - cards-latest.sqlite.gz         (mutable pointer to newest)
  - latest.json                    (manifest: version, sha256, size, schema_version)

The web client polls latest.json on startup, compares schema_version + version
to AppSettings, downloads if newer, imports into Drift.
"""

from __future__ import annotations

import gzip
import hashlib
import json
import os
import shutil
import sqlite3
import sys
import urllib.request
from datetime import datetime, timezone
from pathlib import Path

import boto3

# ─────────────────────────────────────────────────────────────────────────────
# Config
# ─────────────────────────────────────────────────────────────────────────────

MTGJSON_PRINTINGS_URL = "https://mtgjson.com/api/v5/AllPrintings.sqlite.gz"
MTGJSON_PRICES_URL = "https://mtgjson.com/api/v5/AllPricesToday.json.gz"

# Bump when the Drift `cards` schema in the app changes incompatibly.
# Web clients refuse to import a bundle whose schema_version doesn't match
# their local Drift version, so this gates rollout safety.
SCHEMA_VERSION = 10

WORK_DIR = Path("/tmp/mtg-bundle") if sys.platform != "win32" else Path.cwd() / "build"
WORK_DIR.mkdir(parents=True, exist_ok=True)

R2_BUCKET = os.environ.get("R2_BUCKET", "card-bundles")
R2_ENDPOINT = os.environ["R2_ENDPOINT"]  # e.g. https://<acc>.r2.cloudflarestorage.com
R2_ACCESS_KEY = os.environ["R2_ACCESS_KEY_ID"]
R2_SECRET_KEY = os.environ["R2_SECRET_ACCESS_KEY"]
# Public base URL where the bucket is served (Custom domain or r2.dev URL).
PUBLIC_BASE_URL = os.environ["PUBLIC_BASE_URL"].rstrip("/")


# ─────────────────────────────────────────────────────────────────────────────
# Drift `cards` schema — keep in sync with
#   flutter_mtg_app/lib/core/database/drift/tables/cards.dart
# ─────────────────────────────────────────────────────────────────────────────

CREATE_CARDS_SQL = """
CREATE TABLE cards (
  id INTEGER PRIMARY KEY AUTOINCREMENT,

  scryfall_id TEXT NOT NULL,
  mtgjson_uuid TEXT,
  oracle_id TEXT NOT NULL,
  name TEXT NOT NULL,
  flavor_name TEXT,
  lang TEXT NOT NULL,

  released_at TEXT NOT NULL,
  uri TEXT NOT NULL,
  scryfall_uri TEXT NOT NULL,
  layout TEXT NOT NULL,

  mana_cost TEXT,
  cmc REAL NOT NULL,

  type_line TEXT NOT NULL,
  oracle_text TEXT,
  flavor_text TEXT,
  power TEXT,
  toughness TEXT,

  colors_json TEXT NOT NULL DEFAULT '[]',
  color_identity_json TEXT NOT NULL DEFAULT '[]',
  keywords_json TEXT,
  colors_string TEXT NOT NULL DEFAULT '',
  color_identity_string TEXT NOT NULL DEFAULT '',

  legal_in_any_format INTEGER NOT NULL DEFAULT 0,
  is_canonical_printing INTEGER NOT NULL DEFAULT 0,

  set_code TEXT NOT NULL,
  set_name TEXT NOT NULL,
  set_type TEXT NOT NULL,
  collector_number TEXT NOT NULL,
  digital INTEGER NOT NULL,
  rarity TEXT NOT NULL,
  rarity_order INTEGER NOT NULL DEFAULT 0,

  power_numeric REAL,
  toughness_numeric REAL,

  artist TEXT,
  border_color TEXT NOT NULL,
  frame TEXT NOT NULL,
  full_art INTEGER NOT NULL,
  textless INTEGER NOT NULL,
  booster INTEGER NOT NULL,
  story_spotlight INTEGER NOT NULL,

  image_status TEXT NOT NULL,
  image_small TEXT,
  image_normal TEXT,
  image_large TEXT,
  image_png TEXT,
  image_art_crop TEXT,
  image_border_crop TEXT,

  legal_standard TEXT NOT NULL,
  legal_future TEXT NOT NULL,
  legal_historic TEXT NOT NULL,
  legal_gladiator TEXT NOT NULL,
  legal_pioneer TEXT NOT NULL,
  legal_explorer TEXT,
  legal_modern TEXT NOT NULL,
  legal_legacy TEXT NOT NULL,
  legal_pauper TEXT NOT NULL,
  legal_vintage TEXT NOT NULL,
  legal_penny TEXT NOT NULL,
  legal_commander TEXT NOT NULL,
  legal_oathbreaker TEXT NOT NULL,
  legal_brawl TEXT NOT NULL,
  legal_historicbrawl TEXT,
  legal_alchemy TEXT NOT NULL,
  legal_paupercommander TEXT NOT NULL,
  legal_duel TEXT NOT NULL,
  legal_oldschool TEXT NOT NULL,
  legal_premodern TEXT NOT NULL,
  legal_predh TEXT NOT NULL,

  price_usd TEXT,
  price_usd_foil TEXT,
  price_usd_etched TEXT,
  price_eur TEXT,
  price_eur_foil TEXT,
  price_tix TEXT,
  price_numeric REAL,

  card_faces_json TEXT,
  rulings_json TEXT,

  object TEXT NOT NULL,
  oversized INTEGER NOT NULL,
  promo INTEGER NOT NULL,
  reprint INTEGER NOT NULL,
  variation INTEGER NOT NULL,

  games_json TEXT NOT NULL DEFAULT '[]',
  reserved INTEGER NOT NULL,
  foil INTEGER NOT NULL,
  nonfoil INTEGER NOT NULL,
  finishes_json TEXT NOT NULL DEFAULT '[]',
  produced_mana_json TEXT NOT NULL DEFAULT '[]',

  edhrec_rank INTEGER,
  is_game_changer INTEGER,

  related_token_ids_json TEXT NOT NULL DEFAULT '[]',

  mtgo_id INTEGER,
  arena_id INTEGER,
  tcgplayer_id INTEGER,
  cardmarket_id INTEGER
);
"""

CREATE_INDEXES_SQL = [
    "CREATE UNIQUE INDEX idx_card_scryfall_id ON cards(scryfall_id)",
    "CREATE INDEX idx_card_mtgjson_uuid ON cards(mtgjson_uuid)",
    "CREATE INDEX idx_card_oracle_id ON cards(oracle_id)",
    "CREATE INDEX idx_card_name ON cards(name)",
    "CREATE INDEX idx_card_flavor_name ON cards(flavor_name)",
    "CREATE INDEX idx_card_lang ON cards(lang)",
    "CREATE INDEX idx_card_type_line ON cards(type_line)",
    "CREATE INDEX idx_card_colors_string ON cards(colors_string)",
    "CREATE INDEX idx_card_color_identity_string ON cards(color_identity_string)",
    "CREATE INDEX idx_card_legal_in_any_format ON cards(legal_in_any_format)",
    "CREATE INDEX idx_card_is_canonical_printing ON cards(is_canonical_printing)",
    "CREATE INDEX idx_card_set_code ON cards(set_code)",
    "CREATE INDEX idx_card_rarity ON cards(rarity)",
    "CREATE INDEX idx_card_price_numeric ON cards(price_numeric)",
]


# ─────────────────────────────────────────────────────────────────────────────
# Pipeline
# ─────────────────────────────────────────────────────────────────────────────

def log(msg: str) -> None:
    print(f"[{datetime.now(timezone.utc).isoformat(timespec='seconds')}] {msg}", flush=True)


def download(url: str, dst: Path) -> None:
    """Stream-download with a real User-Agent. MTGJSON's CDN 403s the
    bare `Python-urllib/x.y` default UA."""
    log(f"Downloading {url} → {dst}")
    req = urllib.request.Request(
        url,
        headers={"User-Agent": "mtg-companion-bundle-builder/1.0 (+https://github.com/GabrielSchlatter/mtg-companion-actions)"},
    )
    with urllib.request.urlopen(req) as resp, open(dst, "wb") as out:
        shutil.copyfileobj(resp, out, length=1024 * 1024)
    log(f"  size: {dst.stat().st_size / 1_000_000:.1f} MB")


def gunzip(src: Path, dst: Path) -> None:
    log(f"Decompressing {src} → {dst}")
    with gzip.open(src, "rb") as f_in, open(dst, "wb") as f_out:
        shutil.copyfileobj(f_in, f_out)
    log(f"  size: {dst.stat().st_size / 1_000_000:.1f} MB")


def inspect_mtgjson_schema(db: sqlite3.Connection) -> None:
    """Log MTGJSON's tables + columns so we can verify our transform assumptions."""
    log("MTGJSON schema:")
    cur = db.cursor()
    cur.execute("SELECT name FROM sqlite_master WHERE type='table' ORDER BY name")
    tables = [r[0] for r in cur.fetchall()]
    log(f"  tables: {tables}")
    for tbl in ("cards", "cardIdentifiers", "cardLegalities"):
        if tbl in tables:
            cur.execute(f"PRAGMA table_info({tbl})")
            cols = [r[1] for r in cur.fetchall()]
            log(f"  {tbl} ({len(cols)} cols): {cols[:25]}{'...' if len(cols) > 25 else ''}")
            cur.execute(f"SELECT COUNT(*) FROM {tbl}")
            log(f"    rows: {cur.fetchone()[0]}")


def build_cards_db(src_path: Path, dst_path: Path) -> int:
    """Project MTGJSON's `cards` table into the app's Drift schema.

    Returns row count. Schema gaps (Scryfall-specific fields like image URLs,
    imageStatus, etc.) are filled with computed values or sane defaults.
    """
    if dst_path.exists():
        dst_path.unlink()

    src = sqlite3.connect(f"file:{src_path}?mode=ro", uri=True)
    src.row_factory = sqlite3.Row
    dst = sqlite3.connect(dst_path)
    inspect_mtgjson_schema(src)

    dst.execute(CREATE_CARDS_SQL)
    for stmt in CREATE_INDEXES_SQL:
        dst.execute(stmt)
    dst.commit()

    # NOTE: This SELECT is a placeholder — the real column names depend on
    # MTGJSON's actual schema (which we inspect above on first run). Adjust
    # after seeing the first build's logs.
    #
    # MTGJSON's `cards` is normalized: card-level fields live there;
    # identifiers (scryfallId, etc.) in `cardIdentifiers`; legalities in
    # `cardLegalities`. We join all three by uuid.
    src_cur = src.cursor()
    try:
        src_cur.execute("""
            SELECT
              c.uuid                       AS mtgjson_uuid,
              c.name                       AS name,
              c.faceName                   AS face_name,
              c.flavorName                 AS flavor_name,
              c.language                   AS lang,
              c.manaCost                   AS mana_cost,
              c.manaValue                  AS cmc,
              c.type                       AS type_line,
              c.text                       AS oracle_text,
              c.flavorText                 AS flavor_text,
              c.power                      AS power,
              c.toughness                  AS toughness,
              c.colors                     AS colors_csv,
              c.colorIdentity              AS color_identity_csv,
              c.keywords                   AS keywords_csv,
              c.setCode                    AS set_code,
              c.number                     AS collector_number,
              c.rarity                     AS rarity,
              c.borderColor                AS border_color,
              c.frameVersion               AS frame,
              c.layout                     AS layout,
              c.artist                     AS artist,
              c.isFullArt                  AS full_art,
              c.isTextless                 AS textless,
              c.isReserved                 AS reserved,
              c.isPromo                    AS promo,
              c.isReprint                  AS reprint,
              c.isOversized                AS oversized,
              c.hasFoil                    AS foil,
              c.hasNonFoil                 AS nonfoil,
              c.hasContentWarning          AS content_warning,
              c.edhrecRank                 AS edhrec_rank,
              c.isGameChanger              AS is_game_changer,
              c.originalReleaseDate        AS released_at,
              ci.scryfallId                AS scryfall_id,
              ci.scryfallOracleId          AS oracle_id,
              ci.mtgoId                    AS mtgo_id,
              ci.mtgArenaId                AS arena_id,
              ci.tcgplayerProductId        AS tcgplayer_id,
              ci.mcmId                     AS cardmarket_id
            FROM cards c
            LEFT JOIN cardIdentifiers ci ON ci.uuid = c.uuid
            WHERE c.language = 'English'
        """)
    except sqlite3.OperationalError as e:
        log(f"⚠ Initial SELECT failed: {e}")
        log("  This means MTGJSON's column names differ from our assumptions.")
        log("  Check the inspect_mtgjson_schema output above and update the SELECT.")
        raise

    inserted = 0
    skipped_no_scryfall = 0
    batch: list[tuple] = []
    BATCH_SIZE = 1000

    INSERT_SQL = """
        INSERT INTO cards (
          scryfall_id, mtgjson_uuid, oracle_id, name, flavor_name, lang,
          released_at, uri, scryfall_uri, layout,
          mana_cost, cmc,
          type_line, oracle_text, flavor_text, power, toughness,
          colors_json, color_identity_json, keywords_json,
          colors_string, color_identity_string,
          set_code, set_name, set_type, collector_number,
          digital, rarity, rarity_order,
          power_numeric, toughness_numeric,
          artist, border_color, frame,
          full_art, textless, booster, story_spotlight,
          image_status, image_small, image_normal, image_large, image_png,
          image_art_crop, image_border_crop,
          legal_standard, legal_future, legal_historic, legal_gladiator,
          legal_pioneer, legal_explorer, legal_modern, legal_legacy,
          legal_pauper, legal_vintage, legal_penny, legal_commander,
          legal_oathbreaker, legal_brawl, legal_historicbrawl, legal_alchemy,
          legal_paupercommander, legal_duel, legal_oldschool, legal_premodern,
          legal_predh,
          price_usd, price_usd_foil, price_usd_etched,
          price_eur, price_eur_foil, price_tix, price_numeric,
          card_faces_json, rulings_json,
          object, oversized, promo, reprint, variation,
          games_json, reserved, foil, nonfoil,
          finishes_json, produced_mana_json,
          edhrec_rank, is_game_changer,
          related_token_ids_json,
          mtgo_id, arena_id, tcgplayer_id, cardmarket_id
        ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,
                  ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,
                  ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,
                  ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,
                  ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
    """

    rarity_order_map = {"common": 0, "uncommon": 1, "rare": 2, "mythic": 3, "special": 4, "bonus": 5}

    for row in src_cur:
        scryfall_id = row["scryfall_id"]
        if not scryfall_id:
            skipped_no_scryfall += 1
            continue

        colors = (row["colors_csv"] or "").split(",") if row["colors_csv"] else []
        colors = [c for c in colors if c]
        color_identity = (row["color_identity_csv"] or "").split(",") if row["color_identity_csv"] else []
        color_identity = [c for c in color_identity if c]
        keywords = (row["keywords_csv"] or "").split(",") if row["keywords_csv"] else []
        keywords = [k for k in keywords if k]

        wubrg = "WUBRG"
        colors_string = "".join(c for c in wubrg if c in colors)
        color_identity_string = "".join(c for c in wubrg if c in color_identity)

        # Scryfall image URLs are deterministic given scryfall_id (UUID).
        # Pattern: https://cards.scryfall.io/<size>/front/<a>/<b>/<id>.jpg
        # where <a><b> are the first two chars of the id.
        sid = scryfall_id
        a, b = sid[0], sid[1]
        img_base = f"https://cards.scryfall.io/{{size}}/front/{a}/{b}/{sid}.jpg"
        image_small = img_base.format(size="small")
        image_normal = img_base.format(size="normal")
        image_large = img_base.format(size="large")
        image_png = f"https://cards.scryfall.io/png/front/{a}/{b}/{sid}.png"
        image_art_crop = img_base.format(size="art_crop")
        image_border_crop = img_base.format(size="border_crop")

        scryfall_uri = f"https://scryfall.com/card/{row['set_code'].lower()}/{row['collector_number']}"
        api_uri = f"https://api.scryfall.com/cards/{sid}"

        # power_numeric / toughness_numeric for sorting
        def _to_num(v):
            if v is None:
                return None
            try:
                return float(v)
            except (ValueError, TypeError):
                return None

        rarity = (row["rarity"] or "").lower()

        batch.append((
            sid,                                         # scryfall_id
            row["mtgjson_uuid"],
            row["oracle_id"] or "",
            row["name"] or "",
            row["flavor_name"],
            row["lang"] or "English",
            row["released_at"] or "",
            api_uri,                                     # uri
            scryfall_uri,
            row["layout"] or "normal",
            row["mana_cost"],
            float(row["cmc"]) if row["cmc"] is not None else 0.0,
            row["type_line"] or "",
            row["oracle_text"],
            row["flavor_text"],
            row["power"],
            row["toughness"],
            json.dumps(colors),
            json.dumps(color_identity),
            json.dumps(keywords) if keywords else None,
            colors_string,
            color_identity_string,
            row["set_code"] or "",
            "",                                          # set_name (TODO: join sets table)
            "",                                          # set_type (TODO: join sets table)
            row["collector_number"] or "",
            0,                                           # digital (TODO: derive from set or availability)
            rarity,
            rarity_order_map.get(rarity, 0),
            _to_num(row["power"]),
            _to_num(row["toughness"]),
            row["artist"],
            row["border_color"] or "black",
            row["frame"] or "2015",
            int(bool(row["full_art"])),
            int(bool(row["textless"])),
            1,                                           # booster (TODO: derive)
            0,                                           # story_spotlight
            "highres_scan",                              # image_status (default)
            image_small, image_normal, image_large, image_png,
            image_art_crop, image_border_crop,
            # Legalities — TODO: join cardLegalities table and project per-format.
            # Defaults to "not_legal" so the card is hidden in legality-filtered views.
            "not_legal", "not_legal", "not_legal", "not_legal",
            "not_legal", None, "not_legal", "not_legal",
            "not_legal", "not_legal", "not_legal", "not_legal",
            "not_legal", "not_legal", None, "not_legal",
            "not_legal", "not_legal", "not_legal", "not_legal",
            "not_legal",
            None, None, None, None, None, None, None,    # prices — wired up via AllPricesToday separately
            None,                                        # card_faces_json (TODO)
            None,                                        # rulings_json (TODO)
            "card",                                      # object
            int(bool(row["oversized"])),
            int(bool(row["promo"])),
            int(bool(row["reprint"])),
            0,                                           # variation
            '["paper"]',                                 # games_json (default)
            int(bool(row["reserved"])),
            int(bool(row["foil"])),
            int(bool(row["nonfoil"])),
            json.dumps([f for f, v in [("foil", row["foil"]), ("nonfoil", row["nonfoil"])] if v]),
            "[]",                                        # produced_mana_json (TODO)
            row["edhrec_rank"],
            int(bool(row["is_game_changer"])) if row["is_game_changer"] is not None else None,
            "[]",                                        # related_token_ids_json
            row["mtgo_id"],
            row["arena_id"],
            row["tcgplayer_id"],
            row["cardmarket_id"],
        ))

        if len(batch) >= BATCH_SIZE:
            dst.executemany(INSERT_SQL, batch)
            inserted += len(batch)
            batch.clear()
            if inserted % 10_000 == 0:
                log(f"  inserted {inserted}")

    if batch:
        dst.executemany(INSERT_SQL, batch)
        inserted += len(batch)

    dst.commit()
    log(f"Inserted {inserted} cards (skipped {skipped_no_scryfall} without scryfall_id)")

    # VACUUM to compact the file before shipping.
    dst.execute("VACUUM")
    dst.close()
    src.close()

    return inserted


def gzip_file(src: Path, dst: Path) -> None:
    log(f"Compressing {src} → {dst}")
    with open(src, "rb") as f_in, gzip.open(dst, "wb", compresslevel=9) as f_out:
        shutil.copyfileobj(f_in, f_out, length=1024 * 1024)
    log(f"  size: {dst.stat().st_size / 1_000_000:.1f} MB")


def sha256_of(path: Path) -> str:
    h = hashlib.sha256()
    with open(path, "rb") as f:
        for chunk in iter(lambda: f.read(1024 * 1024), b""):
            h.update(chunk)
    return h.hexdigest()


def upload_to_r2(local: Path, key: str, content_type: str = "application/octet-stream") -> None:
    log(f"Uploading {local} → r2://{R2_BUCKET}/{key}")
    s3 = boto3.client(
        "s3",
        endpoint_url=R2_ENDPOINT,
        aws_access_key_id=R2_ACCESS_KEY,
        aws_secret_access_key=R2_SECRET_KEY,
        region_name="auto",
    )
    s3.upload_file(
        str(local),
        R2_BUCKET,
        key,
        ExtraArgs={"ContentType": content_type},
    )


# ─────────────────────────────────────────────────────────────────────────────
# Main
# ─────────────────────────────────────────────────────────────────────────────

def main() -> None:
    today = datetime.now(timezone.utc).strftime("%Y-%m-%d")

    mtgjson_gz = WORK_DIR / "AllPrintings.sqlite.gz"
    mtgjson_db = WORK_DIR / "AllPrintings.sqlite"
    out_db = WORK_DIR / "cards.sqlite"
    out_gz = WORK_DIR / "cards.sqlite.gz"

    download(MTGJSON_PRINTINGS_URL, mtgjson_gz)
    gunzip(mtgjson_gz, mtgjson_db)

    rows = build_cards_db(mtgjson_db, out_db)
    log(f"Built {out_db} ({out_db.stat().st_size / 1_000_000:.1f} MB, {rows} rows)")

    gzip_file(out_db, out_gz)
    digest = sha256_of(out_gz)
    size = out_gz.stat().st_size

    versioned_key = f"cards-{today}.sqlite.gz"
    upload_to_r2(out_gz, versioned_key, content_type="application/x-sqlite3")
    upload_to_r2(out_gz, "cards-latest.sqlite.gz", content_type="application/x-sqlite3")

    manifest = {
        "version": today,
        "schema_version": SCHEMA_VERSION,
        "url": f"{PUBLIC_BASE_URL}/{versioned_key}",
        "latest_url": f"{PUBLIC_BASE_URL}/cards-latest.sqlite.gz",
        "sha256": digest,
        "size_bytes": size,
        "row_count": rows,
        "generated_at": datetime.now(timezone.utc).isoformat(timespec="seconds"),
    }
    manifest_path = WORK_DIR / "latest.json"
    manifest_path.write_text(json.dumps(manifest, indent=2))
    upload_to_r2(manifest_path, "latest.json", content_type="application/json")

    log(f"✅ Build complete: {versioned_key} ({size / 1_000_000:.1f} MB, sha256={digest[:12]}…)")


if __name__ == "__main__":
    main()
