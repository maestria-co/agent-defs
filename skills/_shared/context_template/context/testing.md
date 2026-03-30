# Testing

> **AI Instruction:** Read this before writing or modifying tests. Follow the patterns here — don't introduce new test frameworks or patterns without updating this file.

## Framework & Setup

<!-- What test framework is used and how are tests run? -->

- **Framework:** [e.g., Jest / Vitest / pytest / RSpec]
- **Run tests:** `[e.g., npm test / pytest / bundle exec rspec]`
- **Watch mode:** `[e.g., npm run test:watch]`
- **Coverage:** `[e.g., npm run test:coverage — target 80%]`

## File Conventions

<!-- Where do test files live and how are they named? Use real examples from this codebase -->

- **Location:** [e.g., colocated `__tests__/` folders / `tests/` at root / `.spec.ts` next to source]
- **Naming:** [e.g., `user.service.spec.ts` mirrors `user.service.ts`]
- **Example test file:** [e.g., `src/services/__tests__/user.service.spec.ts`]

## Mocking

<!-- How are dependencies mocked in tests? -->

- **Approach:** [e.g., `jest.mock()` for modules / manual factory functions / test doubles]
- **Example:** [paste a representative mock pattern from the codebase]

## What to Test

- **Unit tests:** [e.g., pure functions and service methods in isolation]
- **Integration tests:** [e.g., API routes with a real test database / supertest]
- **What we don't test:** [e.g., third-party library internals / UI snapshot tests]

## Test Data

<!-- How is test data created? -->

- [e.g., factory functions in `tests/factories/` / fixtures in `tests/fixtures/` / inline literals]
