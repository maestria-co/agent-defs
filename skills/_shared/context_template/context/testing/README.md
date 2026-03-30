# testing/

Test strategies and conventions for this project.

## What belongs here

- **Unit testing conventions** — framework, file placement, mocking strategy, coverage targets
- **Integration testing conventions** — what gets integration tested, environment setup, database state management

## Files

| File                     | Purpose                                                                     |
| ------------------------ | --------------------------------------------------------------------------- |
| `unit-testing.md`        | Framework config, test file conventions, mocking strategy, coverage targets |
| `integration-testing.md` | What to integration test, environment setup, request/response patterns      |

## When to update

- The test framework or configuration changes
- A new mocking strategy is adopted
- A test anti-pattern causes flaky tests (document the fix)
- Coverage requirements change
- A retrospective entry reveals a testing lesson worth preserving
