# Retrospectives

Rolling log of lessons learned from completed tasks. Keep the last 10-15 entries. Older lessons should be promoted to the appropriate `.context/` subdirectory.

## Format

Each retrospective entry:

### [TASK-ID] - [Task Name] - [Date]

**What went well:**
- [Lesson learned]

**What could be improved:**
- [Issue encountered]
- [Solution applied]

**Promote to .context/:**
- [ ] standards/ - [specific lesson]
- [ ] architecture/ - [specific lesson]
- [ ] testing/ - [specific lesson]

---

## Example Entry

### TASK-001 - Add User Authentication - 2026-02-15

**What went well:**
- JWT token handling pattern worked cleanly
- Test mocking strategy was clear

**What could be improved:**
- Missed that auth middleware needs error handling for expired tokens
- Had to refactor after initial implementation

**Promote to .context/:**
- [x] standards/error-handling.md - JWT token expiration handling pattern
- [x] testing/unit-testing.md - Mocking JWT verification

---

*Keep 10-15 most recent entries. Archive or promote older entries.*
