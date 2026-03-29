---
name: verification-checklist
description: >
  Evidence-based verification process to run before marking any task complete.
  Use this skill every time you're about to report that work is done — for features,
  bug fixes, refactoring, or any code change. This catches the most common failure
  mode: declaring "done" without proof. If you're finishing up and about to tell
  the user the task is complete, run this checklist first.
user-invocable: false
---

# Skill: Verification Checklist

## Purpose

Prevent premature "done" declarations. This checklist runs after implementation
and before reporting completion. Every item requires evidence — not just a check mark.

---

## The Checklist

### 1. Functional Verification

Does the implementation actually work?

- [ ] **Requirements match** — each acceptance criterion is addressed
- [ ] **Happy path works** — primary use case produces expected output (show evidence)
- [ ] **Edge cases handled** — empty inputs, boundary values, concurrent access
- [ ] **Error cases handled** — invalid inputs produce clear error messages, not crashes
- [ ] **No regressions** — existing functionality still works

**Evidence format:** Paste command output, test results, or log excerpts.

### 2. Standards Compliance

Does the code follow project conventions?

- [ ] **Code style** — matches `.context/standards/code-style.md`
- [ ] **Naming** — matches `.context/standards/naming-conventions.md`
- [ ] **Error handling** — matches `.context/standards/error-handling.md`
- [ ] **Architecture patterns** — consistent with `.context/architecture/`
- [ ] **No new patterns** — didn't introduce conventions that conflict with existing ones

**Evidence format:** Reference the specific standard and show your code follows it.

### 3. Test Coverage

Are tests adequate?

- [ ] **Unit tests pass** — all existing + new tests green (show output)
- [ ] **New code has tests** — non-trivial logic is tested
- [ ] **Edge cases tested** — at least the cases from Functional Verification above
- [ ] **Regression test added** — if this was a bug fix, a test prevents recurrence
- [ ] **Integration tests pass** — if applicable for this change

**Evidence format:** Test command output with pass/fail counts.

### 4. Integration Safety

Does this change play well with the rest of the system?

- [ ] **No breaking API changes** — or migration path documented if intentional
- [ ] **Dependencies updated** — if new deps added, they're in manifest files
- [ ] **Config changes documented** — environment variables, feature flags, etc.
- [ ] **Build succeeds** — full build completes without errors or new warnings

**Evidence format:** Build output, API compatibility check, dependency diff.

### 5. Self-Review

Would you approve this in a code review?

- [ ] **Code is readable** — another developer could understand it without explanation
- [ ] **No dead code** — commented-out code, unused imports, or orphaned functions removed
- [ ] **No hardcoded values** — magic numbers and strings extracted to constants/config
- [ ] **No security issues** — credentials not hardcoded, inputs validated, outputs sanitized
- [ ] **Commit-ready** — changes are atomic, well-scoped, and properly described

---

## How to Use This Checklist

### Full Check (default)

Run all 5 sections. Use for feature implementations and complex bug fixes.

### Quick Check

Run sections 1 + 5 only. Use for documentation changes, config tweaks, and trivial fixes.

### When to Skip

Never skip entirely. The Quick Check is the minimum.

---

## Escalation

If any checklist item fails:

1. Fix the issue
2. Re-run the specific section
3. If the fix introduces new concerns, re-run from section 1

If you cannot fix an item:

1. Document why in the progress log
2. Note it as a known limitation in the task completion report
3. Do not silently skip it

---

## Output Format

When reporting completion, include a summary:

```
## Verification Summary
- Functional: ✅ All acceptance criteria verified (see test output above)
- Standards: ✅ Follows code-style.md and naming-conventions.md
- Tests: ✅ 23 tests passing, 3 new tests added
- Integration: ✅ Build succeeds, no breaking changes
- Self-review: ✅ Code reviewed, no issues found
```

---

## Constraints

- Every check requires evidence — a bare `[x]` without proof defeats the purpose,
  because the checklist exists precisely to catch "I think it works" assumptions
- The checklist applies to the agent's own work, not the existing codebase
- Do not spend more than 5 minutes on the checklist — it's a gate, not an audit
- If you find issues during self-review, fix them — don't just note them
