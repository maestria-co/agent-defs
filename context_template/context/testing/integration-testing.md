# Integration Testing

> **Purpose:** Document what gets integration tested, how to run those tests, and the conventions that keep the test suite reliable. Integration tests are slower and more fragile than unit tests — these conventions exist to minimize that cost.

---

## What Gets Integration Tested

[PLACEHOLDER — document which parts of the system are covered by integration tests]

**Convention in this project:**
- All API endpoints (happy path + common error paths)
- Database interactions for complex queries (anything with joins, aggregations, or transactions)
- External service integrations — using recorded responses (not live calls)

Unit tests cover individual functions. Integration tests cover: does this endpoint actually work end-to-end?

---

## Test Environment Setup

[PLACEHOLDER] **Requirements:** Test database + required env file.

```bash
docker compose -f docker-compose.test.yml up -d  # start test DB
npm run db:migrate:test                           # apply schema
# .env.test — required (see .env.test.example — never commit real values)
DATABASE_URL=postgresql://localhost:5432/app_test
```

## Running Integration Tests

[PLACEHOLDER] Integration tests do NOT run with `npm test` (unit tests only). Separate command:

```bash
npm run test:integration                                     # all integration tests
npm run test:integration -- tests/integration/auth.test.ts  # single file
# CI: integration tests run in a separate job after unit tests pass
```

---

## Request / Response Testing Patterns

[PLACEHOLDER — document the HTTP testing library and auth setup]

**Convention:** Use `supertest` (Node.js) / `httpx` (Python) / `[project's chosen library]` to make requests against the running app.

```ts
// tests/integration/auth.test.ts
import request from 'supertest';
import { app } from '@/app';
import { seedUser } from '../helpers/seeds';

it('should return 200 with session token on valid login', async () => {
  const user = await seedUser({ password: 'correct-password' });

  const res = await request(app)
    .post('/api/auth/login')
    .send({ email: user.email, password: 'correct-password' });

  expect(res.status).toBe(200);
  expect(res.body).toMatchObject({ token: expect.any(String) });
});
```

For authenticated endpoints, use the `withAuth(request, userId)` test helper in `tests/helpers/auth.ts`.

---

## Database State Management

[PLACEHOLDER — document how the test database is cleaned between tests]

**Convention:** Each test runs inside a database transaction that is rolled back after the test. This ensures isolation without truncating tables.

```ts
// tests/helpers/db.ts — wraps each test in a transaction
beforeEach(async () => { await db.beginTransaction(); });
afterEach(async () => { await db.rollbackTransaction(); });
```

If a test explicitly needs to test commit behavior, it must clean up its own data in `afterEach`.

---

## Never Do

- ❌ **Never make real external API calls in integration tests** — use recorded responses (`nock`, `msw`, `vcr`) or a test double
- ❌ **Never share state between tests** — each test must be able to run in any order
- ❌ **Never hardcode test user IDs** — use seed helpers that return the created entity
- ❌ **Never test implementation details** — test what the API returns, not how it does it internally
