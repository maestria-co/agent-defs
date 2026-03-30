# Recipe: Simple Task

> **When to use:** Single change, clear spec, no ambiguity.
> **Patterns:** `implementing-features` only (+ `writing-tests` after).
> **Total time:** Minutes to a couple of hours.

---

## Example: Fix a bug

**Situation:** A known bug — case-sensitive email comparison in login.

### Step 1 — Run implementing-features

```
Use the implementing-features skill.

<task>Fix the case-sensitive email comparison in the login endpoint.</task>
<context>
Spec:
- [ ] Email comparison is case-insensitive
- [ ] Existing users with mixed-case emails can still log in
- [ ] No change to email storage (keep as stored)
Relevant files: src/auth/login.js, src/models/User.js
Existing tests: tests/auth/login.test.js
</context>
```

### Step 2 — Run writing-tests

```
Use the writing-tests skill.

<task>Write a regression test for the case-insensitive email fix.</task>
<context>
Implementation: src/auth/login.js (email normalized with .toLowerCase() before query)
Test file: tests/auth/login.test.js
Required: test must FAIL on original code, PASS on fix
</context>
```

### Step 3 — Verify and commit

```bash
git add src/auth/login.js tests/auth/login.test.js
git commit -m "fix: case-insensitive email comparison in login"
```

---

## When This Recipe Applies

- ✅ The change is in 1-3 files
- ✅ Acceptance criteria are clear before you start
- ✅ No new architecture or patterns introduced
- ✅ No external library research needed

## When to Upgrade

Upgrade to `complex-task` recipe if:
- You realize the fix requires touching 5+ files
- The fix requires a design decision (e.g., where to normalize email — client vs. DB vs. app layer)
- The existing test suite is missing coverage for the area being changed
