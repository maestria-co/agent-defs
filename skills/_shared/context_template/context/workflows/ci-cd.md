# CI/CD Pipeline

> **Purpose:** Document what runs in CI, how to replicate it locally, and how deployments work. Read this before pushing — knowing what CI will check prevents surprises.

---

## Pipeline Overview

[PLACEHOLDER — document what runs at each trigger point]

| Trigger | Jobs that run |
|---|---|
| Pull request opened/updated | lint → typecheck → unit tests → integration tests → build |
| Merge to `develop` | All PR jobs → deploy to staging |
| Tag pushed (`v*`) | All jobs → deploy to production (requires manual approval) |

See `.github/workflows/ci.yml` for the full pipeline definition.

---

## Running CI Checks Locally

[PLACEHOLDER — document how to replicate CI checks on a dev machine]

Run these in order before pushing — same as what CI runs:

```bash
# 1. Lint
npm run lint

# 2. Type check
npm run typecheck

# 3. Unit tests
npm test -- --run

# 4. Integration tests (requires test DB running)
docker compose -f docker-compose.test.yml up -d
npm run test:integration

# 5. Build
npm run build
```

Or run everything at once: `npm run ci` (defined in `package.json`)

---

## Environment Variables

[PLACEHOLDER] **Local dev:** Copy `.env.example` → `.env.local`. **CI:** Set in GitHub Secrets (Settings → Secrets → Actions). **Never commit** `.env*` files — `.gitignore` covers them but double-check.

Secrets in production: [e.g., AWS Secrets Manager / Vercel / Doppler]

## Deployment Process

[PLACEHOLDER] **Staging:** Automatic on merge to `develop`. **Production:** Tag-triggered with manual approval.

```bash
git tag v1.2.3 && git push origin v1.2.3
# → pipeline runs → pauses for manual approval → Approver: [role] in Actions UI
```

**Rollback:** Staging: revert commit. Production: re-tag the previous release.

## Common CI Failures

[PLACEHOLDER]

| Failure | Fix |
|---|---|
| `Cannot find module '@/...'` | `vitest.config.ts` → `resolve.alias` must match `tsconfig.json` |
| Integration tests fail on clean checkout | `npm run db:migrate:test && npm run db:seed:test` |
| Build passes locally, fails in CI | Missing env var — check `ci.yml`; add to GitHub Secrets |
