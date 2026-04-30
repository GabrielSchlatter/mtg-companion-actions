# mtg-companion-actions

Weekly job that downloads MTGJSON's `AllPrintings.json.gz`, runs the same
parser the mtg-companion mobile app uses, and uploads the resulting
SQLite bundle (matching the app's Drift `cards` schema) to Cloudflare R2 for
the web client to pull on first load.

## What it produces

In R2:

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

The web client compares `schema_version` to its local Drift schema version
and `version` to the last imported value (stored in `app_settings`). If
newer and the schema matches, it downloads the bundle and imports it.

## How it stays in sync with the app

The parser (`lib/mtgjson_card_mapper.dart`) is **mirrored** from the app's
`flutter_mtg_app/lib/services/mtgjson_sync_service.dart` — the two should
be byte-identical for the functions ported over (`mapMtgjsonCard` and its
helpers, `singleSideLayouts`).

The schema (`lib/cards_schema.dart`) is **mirrored** from
`flutter_mtg_app/lib/core/database/drift/tables/cards.dart`.

When you change the parser or the Drift schema in the app:

1. Copy the changed function(s) into this repo.
2. If the schema changed: update `createCardsSql`, `createIndexesSql`,
   `columnOrder`, and bump `schemaVersion` in `lib/cards_schema.dart`.
   Bump the same number in the app's `AppDatabase.schemaVersion` and add
   the corresponding Drift migration.
3. Push and trigger a manual run.

The web client's import check refuses bundles whose `schema_version`
doesn't match its local Drift, so a forgotten schema bump is a soft
failure (client falls back to its previous bundle), not a crash.

## Configuration

Set as **environment secrets** under the `Prod` environment in GitHub
(Settings → Environments → Prod → Secrets):

| Secret                  | Example                                                      |
| ----------------------- | ------------------------------------------------------------ |
| `R2_BUCKET`             | `card-bundles`                                               |
| `R2_ENDPOINT`           | `https://<account-id>.r2.cloudflarestorage.com`              |
| `R2_ACCESS_KEY_ID`      | from R2 → Manage R2 API Tokens                               |
| `R2_SECRET_ACCESS_KEY`  | from R2 → Manage R2 API Tokens                               |
| `PUBLIC_BASE_URL`       | `https://card-bundles.example.com` (custom domain or r2.dev) |

The workflow runs every Thursday 06:00 UTC (MTGJSON refreshes Wednesdays).
Manual triggers via Actions → "Build card bundle" → Run workflow.

## Running locally

```bash
dart pub get
export PUBLIC_BASE_URL=https://card-bundles.example.com
dart run bin/build_bundle.dart
```

Output lands at `/tmp/mtg-bundle/cards.sqlite.gz` (set `WORK_DIR` to override).
The R2 upload step is workflow-only — locally you'll just produce the file.

## Layout

```
.
├── bin/build_bundle.dart        # entry point: orchestrates download → parse → write → gzip
├── lib/
│   ├── cards_schema.dart        # CREATE TABLE + INSERT plumbing, mirrored from Drift
│   └── mtgjson_card_mapper.dart # parser, mirrored from mtgjson_sync_service.dart
└── .github/workflows/
    └── build-bundle.yml         # weekly cron + R2 upload via `aws s3 cp`
```
