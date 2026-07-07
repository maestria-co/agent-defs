# Writing Tests — Code Patterns

**See also**: [`../SKILL.md`](../SKILL.md)

**In this guide:**
- Test anatomy: happy path, edge cases, error cases, security
- Pattern 1: Unit testing database models with Sequelize + Jest
- Pattern 2: Unit testing services
- Pattern 3: Integration testing API endpoints
- Coverage benchmarks

---

## Test Anatomy: Happy Path, Edge Cases, Error Cases, Security

Every test suite should cover multiple categories of test cases:

**Happy path:** Valid input → expected output (the "normal" case)
**Edge cases:** Boundary conditions (null, empty, zero, max values, special characters)
**Error cases:** Invalid input, missing required fields, downstream failures
**State cases:** Before/after transitions, concurrent writes
**Security cases:** SQL injection, malformed input, authentication/authorization violations

Before writing tests, list all test cases in a comment block:

```javascript
// Happy path:     valid input → expected output
// Edge cases:     null, empty, boundary values, special chars
// Error cases:    invalid input, missing required fields, downstream failures
// State cases:    before/after state transitions, concurrent writes
// Security cases: [if applicable]
//   - SQL injection / NoSQL injection
//   - Malformed or oversized inputs
//   - Missing/expired/tampered tokens
```

---

## Pattern 1: Unit Testing Database Models with Sequelize + Jest

When writing tests for database models created with Sequelize and Jest, verify both the happy path and edge cases. Include security tests for encrypted fields.

**Key principles:**
- Use Jest's mock framework to isolate the model from the database
- Mock the database connection; test the model logic, not the ORM
- Test encrypted fields: verify stored value differs from plaintext input
- Include tests for associations (foreign keys, relationships)
- Target ≥90% coverage for new code

**Example: Testing OAuthProvider model**

```
Task: Write tests for OAuthProvider model and migration.

Context:
- src/models/OAuthProvider.js — just implemented (Sequelize + encrypted tokens)
- db/migrations/20240315-create-oauth-provider.js — just implemented
- Existing test style: tests/models/User.test.js (Jest, Sequelize mock)
- Coverage target: ≥90%
```

**Output:**

```
Tests: ✅ All passing
Coverage: 94% | Tests: 12 (unit: 12)
Files: tests/models/OAuthProvider.test.js

Test cases covered:
Happy path: create valid OAuthProvider, retrieve by userId+provider
Edge cases: null userId, empty provider string, token at max length
Error cases: duplicate (userId+provider) raises unique constraint, invalid provider value
Security cases: accessToken encrypted at rest (stored value differs from plaintext input)
```

**Checklist for this pattern:**
- [ ] Model can be created with valid input
- [ ] Model rejects invalid input (wrong type, missing required field)
- [ ] Foreign key constraint is enforced
- [ ] Unique constraints are enforced
- [ ] Timestamps (`createdAt`, `updatedAt`) are set automatically
- [ ] Encrypted fields are actually encrypted (stored value ≠ plaintext)
- [ ] Associations work (e.g., `oAuthProvider.getUser()`)
- [ ] All code paths are tested (≥90% coverage)

---

## Pattern 2: Unit Testing Services

Services typically encapsulate business logic. Test services by mocking their dependencies (database models, external APIs, caches) and verifying the service behavior for all input categories.

**Key checklist:**
- [ ] Mock all external dependencies (database, APIs, caches)
- [ ] Test success path with valid input
- [ ] Test all error paths (invalid input, service failures)
- [ ] Test state transitions (before/after)
- [ ] Verify error messages are informative
- [ ] Target ≥85-90% coverage

---

## Pattern 3: Integration Testing API Endpoints

Integration tests verify the full request-response cycle (HTTP layer included). Test endpoints by mocking external services (not the application's own handlers) and verifying responses.

**Key checklist:**
- [ ] Test each HTTP method and status code (200, 400, 401, 403, 404, 500)
- [ ] Verify request validation (missing fields, wrong type)
- [ ] Test authorization (authenticated users only, correct role required)
- [ ] Test happy path (valid input → correct response)
- [ ] Test error paths (invalid input, service failure)
- [ ] Verify response format matches spec (fields, types)
- [ ] Target ≥80% coverage

---

## Coverage Benchmarks

**Coverage targets:**
- **New code**: ≥90% (lines covered / lines written)
- **Bug fixes**: must include a test that reproduces the bug and passes after the fix
- **Refactors**: coverage must not decrease from before the refactor

**Measuring coverage:**

For Jest:
```bash
npm test -- --coverage
```

For pytest:
```bash
pytest --cov=src
```

**Interpreting coverage:**
- 90%+ → comprehensive testing, low risk of missed bugs
- 70-89% → adequate testing, some edge cases may be uncovered
- <70% → insufficient testing, unacceptable for new code

---

## See Also

- **Pre-flight Checks** in main SKILL.md — verify implementation exists before writing tests
- **Execution Steps** (Step 1) in main SKILL.md — list test cases before writing code
- **edge-cases.md** in this directory — for untestable code patterns and how to unblock them
- **troubleshooting.md** in this directory — for common test failures and diagnostics

