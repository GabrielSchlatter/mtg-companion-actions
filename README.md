# mtg-companion-actions

Weekly job that downloads MTGJSON's `AllPrintings.sqlite`, projects + transforms
it into the mtg-companion app's Drift `cards` schema, and uploads the result to
Cloudflare R2 for the web client to download once per release.

## What it produces

In the configured R2 bucket (root):

- `cards-<YYYY-MM-DD>.sqlite.gz` — versioned, immutable bundle.
- `cards-latest.sqlite.gz` — mutable pointer to the newest bundle.
- `latest.json` — manifest the client polls:
  ```json
  {
    "version": "2026-04-30",
    "schema_version": 10,
    "url": "https://<base>/cards-2026-04-30.sqlite.gz",
    "latest_url": "https://<base>/cards-latest.sqlite.gz",
    "sha256": "…",
    "size_bytes": …,
    "row_count": …,
    "generated_at": "…"
  }
  ```

The web client compares `schema_version` to its local Drift schema version and
`version` to the last imported value (stored in `app_settings`). If newer and
the schema matches, it downloads the bundle and imports it.

## Configuration

Set as **Repository secrets** in GitHub:

| Secret                  | Example                                                      |
| ----------------------- | ------------------------------------------------------------ |
| `R2_BUCKET`             | `card-bundles`                                               |
| `R2_ENDPOINT`           | `https://<account-id>.r2.cloudflarestorage.com`              |
| `R2_ACCESS_KEY_ID`      | from R2 → Manage R2 API Tokens                               |
| `R2_SECRET_ACCESS_KEY`  | from R2 → Manage R2 API Tokens                               |
| `PUBLIC_BASE_URL`       | `https://card-bundles.example.com` (custom domain or r2.dev) |

The workflow runs every Thursday 06:00 UTC (MTGJSON refreshes on Wednesdays).
You can also trigger it manually via Actions → "Build card bundle" → Run workflow.

## Why not pre-built MTGJSON SQLite directly?

MTGJSON's schema (`cards`, `cardIdentifiers`, `cardLegalities` etc.) doesn't
match the app's Drift `cards` table — different column names, normalised
differently, missing Scryfall-specific fields like image URLs and
`imageStatus`. This script projects MTGJSON into the app's schema so the web
client can read it via the existing Drift `CardRepository` with no code branch.

## Status — known TODOs

The first build is intentionally a scaffold. Things still to wire up before
shipping:

- `set_name` / `set_type` — need to join MTGJSON's `sets` table.
- `digital` / `booster` — derive from set availability or MTGJSON flags.
- `legal_*` columns — join `cardLegalities` and project per-format.
- `card_faces_json` — handle DFCs from MTGJSON's `faceName` / `otherFaceIds`.
- `rulings_json` — pull from MTGJSON's rulings table if present, or skip.
- `produced_mana_json` — derive from oracle text or MTGJSON's `producedMana`.
- Prices — separate fetch from `AllPricesToday.json.gz` and JOIN by `uuid`.
- Image URL pattern — verify Scryfall's `cards.scryfall.io/<size>/front/<a>/<b>/<id>.jpg`
  pattern still produces the right URLs (it's stable but worth double-checking
  with a few sample cards).

The first manual run will log MTGJSON's actual table/column names — use that
output to validate or fix the SELECT in `build_bundle.py::build_cards_db`.

## Running locally

```bash
pip install -r requirements.txt
export R2_BUCKET=card-bundles
export R2_ENDPOINT=https://<account>.r2.cloudflarestorage.com
export R2_ACCESS_KEY_ID=…
export R2_SECRET_ACCESS_KEY=…
export PUBLIC_BASE_URL=https://card-bundles.example.com
python build_bundle.py
```

To inspect the output without uploading, comment out the `upload_to_r2` calls
in `main()` and run the script — the result is at `/tmp/mtg-bundle/cards.sqlite`.

## Schema sync

The `CREATE TABLE cards` SQL in `build_bundle.py` and the `Cards` Drift table
in `flutter_mtg_app/lib/core/database/drift/tables/cards.dart` must match. When
you add a column to the Drift table:

1. Bump `SCHEMA_VERSION` in `build_bundle.py`.
2. Add the column to `CREATE_CARDS_SQL`.
3. Map it in the `INSERT_SQL` block (or set a default).
4. Bump the Drift schema version in the app and add a migration.

The web client's import check refuses bundles whose `schema_version` doesn't
match its local Drift, so a mismatch is a soft failure (client falls back to
its previous bundle), not a crash.
