# Migration Guide

> **Purpose:** Document every database migration, API version change, or major refactor so that developers and agents can understand what changed, why, and how to roll it back.

> **Rule:** A migration is not complete until its rollback procedure is documented here. Do not merge a migration PR without this entry.

---

## Migration Entry Format

```
### [Migration Title]
**Date:** YYYY-MM-DD
**Type:** Schema / API / Refactor
**Status:** Planned / In Progress / Complete / Rolled Back
**Breaking:** Yes / No

**Context:** Why was this migration needed?

**Migration Steps:**
1. [Step 1 — be specific, include commands]
2. [Step 2]
3. ...

**Rollback Procedure:**
1. [Step 1 — if something goes wrong, how do you undo this?]
2. [Step 2]

**Affected Files:**
- `[path/to/file]` — [what changed]
```

---

## Migration Log

### Add OAuth Fields to Users Table
**Date:** [YYYY-MM-DD]
**Type:** Schema
**Status:** [Planned]
**Breaking:** No — all new columns are nullable

**Context:** Adding GitHub and Google OAuth support requires storing provider tokens and provider-specific user IDs alongside the existing email/password credentials. The `users` table needs three new nullable columns.

**Migration Steps:**
1. Run `npm run db:migrate` — applies `migrations/0012_add_oauth_fields.sql`
2. Migration adds: `provider` (varchar), `provider_id` (varchar), `provider_token` (text, nullable)
3. Deploy application code that reads/writes the new columns
4. Verify with: `SELECT COUNT(*) FROM users WHERE provider IS NOT NULL` (should be 0 immediately after)

**Rollback Procedure:**
1. Deploy previous application version (does not read new columns — safe)
2. Run `npm run db:rollback` — drops the three new columns
3. Verify with: `\d users` in psql — columns should be gone

**Affected Files:**
- `migrations/0012_add_oauth_fields.sql` — the migration file
- `src/repositories/user.ts` — updated `create` and `findByEmail` to include new fields
- `src/features/auth/oauth.ts` — new file, handles OAuth callback
- `src/lib/db/schema.ts` — Drizzle schema updated with new columns

---

<!-- Add new migrations above this comment, in reverse chronological order (newest first) -->
