# Unit Testing

> **Purpose:** Document the conventions for writing unit tests in this project. Read this before writing any test. Inconsistent test patterns make the suite hard to trust and maintain.

---

## Test Framework & Config

[PLACEHOLDER — document the test framework, config location, and how to run tests]

**Convention in this project:**
- Framework: [e.g., Vitest / Jest]
- Config: [`vitest.config.ts` / `jest.config.ts`] at project root
- Run all tests: `npm test`
- Run without watch mode: `npm test -- --run` (use this in scripts/CI)
- Run single file: `npm test -- src/features/auth/login.test.ts`
- Run with coverage: `npm test -- --coverage`

---

## Test File Convention

[PLACEHOLDER — document where test files live and how they're named]

**Convention:** Co-located with the source file. Test file name matches source file name with `.test.ts` suffix.

```
src/features/auth/
├── login.ts
├── login.test.ts     ✅ co-located
└── login.schema.ts
```

Integration tests that span multiple modules live in `tests/integration/`.

---

## Mocking Strategy

[PLACEHOLDER — document what to mock, what not to mock, and which library to use]

**What to mock:**
- External HTTP services (Stripe, SendGrid, etc.) — mock at the adapter boundary
- The database — mock repository classes, not the ORM directly
- Time (`Date.now()`, `new Date()`) — use `vi.setSystemTime()` / `jest.useFakeTimers()`
- Environment variables — set in test setup, not in individual tests

**What NOT to mock:**
- The code under test (obvious, but worth saying)
- Internal utility functions — test them directly or let them run
- Pure functions with no side effects

**Library:** `vi.mock()` (Vitest) / `jest.mock()` (Jest)

```ts
vi.mock('@/repositories/user');
const mockUserRepo = vi.mocked(UserRepository);
```

## Test Structure Convention

[PLACEHOLDER] **Convention:** One `describe` per exported function. `beforeEach` resets mocks. `it` states the expected outcome.

```ts
describe('login', () => {
  beforeEach(() => { vi.clearAllMocks(); });
  describe('when credentials are valid', () => {
    it('should return a session token', async () => {});
  });
  describe('when password is incorrect', () => {
    it('should throw UnauthorizedError', async () => {});
  });
});
```

## Coverage Targets

- **New code:** ≥90% line coverage
- **Bug fixes:** Test must reproduce the bug before the fix, then validate the fix
- **Refactors:** Coverage must not decrease

## Common Gotchas

[PLACEHOLDER] Key traps for async tests and timers:

- **Always `await` assertions** — missing `await` causes async tests to silently pass
- **Reset timer mocks in `afterEach`** — fake timers leak between tests
- **Repositories are mocked in unit tests** — need a real DB? write an integration test
- **Set env vars via `vi.stubEnv()`** — mutating `process.env` directly leaks between tests
