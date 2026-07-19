# Writing Tests — Troubleshooting & Regression Testing

**See also**: [`../SKILL.md`](../SKILL.md) | [`../../implementing-features/SKILL.md`](../../implementing-features/SKILL.md)

**In this guide:**
- Why tests fail and how to debug
- Scenario 1: Writing regression tests for bug fixes
- Scenario 2: Flaky and timing-dependent tests
- Scenario 3: Coverage targets not met
- Reporting test failures

---

## Why Tests Fail and How to Debug

Tests fail for three main reasons:

1. **The implementation is wrong** — the code does not do what it claims
2. **The test is wrong** — the test has a bad assumption or setup
3. **The test is flaky** — the test sometimes passes and sometimes fails (timing issues)

**Debug process:**

1. Read the failure message carefully. Look for:
   - Expected vs. Actual values
   - File and line number where assertion failed
   - Stack trace (does it point to your code or a dependency?)

2. Run the test in isolation:
   ```bash
   # Jest
   npm test -- --testNamePattern="test name"
   
   # pytest
   pytest -k test_name
   ```

3. Add debug logging to understand what the code is actually doing:
   ```javascript
   console.log('Input:', userId);
   console.log('Result:', result);
   ```

4. Decide: is the implementation wrong or the test wrong?
   - If implementation is wrong → route to `implementing-features` for a fix
   - If test is wrong → fix the test

---

## Scenario 1: Writing Regression Tests for Bug Fixes

When a bug is fixed, write a test that reproduces the bug and verifies the fix. This prevents the bug from regressing.

**Key pattern: Write the test so it FAILS with the old code and PASSES with the fixed code.**

**Example: Case-sensitive email bug**

```
Task: Add regression test for the case-sensitive email bug fix.

Context:
- Bug: login failed for mixed-case emails (e.g., User@Example.com)
- Fix applied in src/services/auth.js:47 — .toLowerCase() added before DB lookup
- Existing tests: tests/services/auth.test.js
```

**Test design:**

```javascript
describe('auth.login', () => {
  // Existing happy path tests...
  
  // NEW: Regression test for case-sensitive email bug
  it('login succeeds for mixed-case email', async () => {
    // Setup: user exists with lowercase email in DB
    await User.create({ email: 'alice@example.com', password: 'hashed123' });
    
    // Action: login with mixed-case email
    const result = await auth.login({
      email: 'Alice@Example.COM',
      password: 'hashed123'
    });
    
    // Verify: login succeeds (bug is fixed)
    expect(result.status).toBe(200);
    expect(result.user.email).toBe('alice@example.com');
  });
});
```

**Output format:**

```
Tests: ✅ All passing
Coverage: 91% (unchanged) | Tests: 8 (7 existing + 1 new)
Files: tests/services/auth.test.js (added 1 test)

Added test: "login succeeds for mixed-case email"
- Input: { email: "User@Example.COM", password: "correct" }
- Expected: 200 with user session
- Validates: bug does not regress
```

**Checklist:**
- [ ] Test reproduces the original bug (fails without the fix)
- [ ] Test passes with the fix applied
- [ ] Existing tests still pass (no regressions introduced)
- [ ] Test is in the same file as related tests
- [ ] Test has a clear name that describes the bug being prevented

---

## Scenario 2: Flaky Tests & Timing Issues

**Flaky tests** pass sometimes and fail other times. They're usually caused by:
- Timing assumptions (code assumes something completes in X ms)
- Test order dependencies (one test affects another)
- Async code not being awaited
- Mock setup not isolated between tests

**Diagnosing flakiness:**

```bash
# Run the test multiple times
for i in {1..5}; do npm test -- --testNamePattern="test name"; done
```

If it sometimes passes and sometimes fails, you have a flaky test.

**Common causes and fixes:**

| Cause | Example | Fix |
|-------|---------|-----|
| Async not awaited | `user.save(); expect(...)`  | `await user.save(); expect(...)` |
| Mock state leaking | Mock from test A affects test B | Add `beforeEach(() => jest.clearAllMocks())` |
| Timing assumption | `setTimeout(() => expect(...), 100)` | Use `jest.useFakeTimers()` or `jest.runAllTimers()` |
| Database not reset | Test A inserts data; Test B finds it | Add `beforeEach(() => db.clear())` |
| Concurrent test execution | Tests run in parallel; conflict | Use `test.concurrent.each` carefully or add `--runInBand` flag |

**Example fix:**

```javascript
describe('User model', () => {
  beforeEach(() => {
    // Clear mocks before each test
    jest.clearAllMocks();
    // Clear database before each test
    return db.clear();
  });

  it('creates a user', async () => {
    // Always await async operations
    const user = await User.create({ email: 'alice@example.com' });
    expect(user.id).toBeDefined();
  });
});
```

---

## Scenario 3: Coverage Targets Not Met

If tests pass but coverage is below the target (90% for new code), you're missing test cases.

**Identify gaps:**

```bash
npm test -- --coverage
```

Look at the output:
- **Lines**: Is every line executed by at least one test?
- **Branches**: Are all `if/else` and `switch` paths tested?
- **Functions**: Is every function called in a test?

**Example: Missing branch coverage**

```javascript
// src/auth.js
export function validateEmail(email) {
  if (!email) {
    return 'Email required'; // NOT TESTED
  }
  if (!email.includes('@')) {
    return 'Invalid email'; // TESTED
  }
  return null; // TESTED
}

// tests/auth.test.js
it('rejects invalid email format', () => {
  expect(validateEmail('alice')).toBe('Invalid email'); // covers line 3
});
// Missing: test for empty email (line 2)
```

**Add the missing test:**

```javascript
it('rejects empty email', () => {
  expect(validateEmail('')).toBe('Email required');
});
```

**Checklist:**
- [ ] All code paths are tested (happy + error)
- [ ] All branches (`if/else`, `switch`) are exercised
- [ ] All functions are called
- [ ] Edge cases (null, empty, boundary values) are covered
- [ ] Coverage ≥90% for new code

---

## Reporting Test Failures

Use this format when reporting test failures:

```
Tests: ⚠️ N failing

Bugs:
- Bug: [description of what's wrong]
  | File: [path:line]
  | Input: [what was passed in]
  | Expected: [what should happen]
  | Actual: [what actually happened]
  | Severity: [low/medium/high]

Suggested next: implementing-features (fix bugs, then return to writing-tests)
```

**Example:**

```
Tests: ⚠️ 2 failing

Bugs:
- Bug: login fails for mixed-case emails
  | File: src/services/auth.js:47
  | Input: { email: "User@Example.com", password: "correct" }
  | Expected: 200 with session
  | Actual: 401 Unauthorized
  | Severity: high

- Bug: token refresh returns stale data
  | File: src/services/tokenRefresh.js:12
  | Input: userId = 42 (user with cached token)
  | Expected: fresh token with current timestamp
  | Actual: returns cached token from 1 hour ago
  | Severity: medium

Suggested next: implementing-features (fix auth.js and tokenRefresh.js, then return to writing-tests)
```

---

## See Also

- **Step 6 (Run the Suite)** in main SKILL.md — coverage targets and passing criteria
- **Output Format (Tests failing)** in main SKILL.md — what to include when reporting failures
- **implementing-features skill** — use this to fix bugs that tests uncover
- **code-patterns.md** in this directory — test structure and examples

