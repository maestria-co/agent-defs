---
name: workaround-detector
description: >
  Use when reviewing code to identify temporary workarounds, hacks, and
  technical debt that should become permanent fixes. Triggers on "find tech
  debt", "review this code for hacks", "what needs to be cleaned up", "find
  all the TODOs", or as part of a code review or refactoring planning session.
---

# Skill: Workaround Detector

## Purpose

Systematically detect workarounds in code and prioritize them for proper remediation.
Prevents accumulation of shortcuts that degrade maintainability and reliability.

---

## Detection Patterns

### Look for these indicators:

**Comments:**

- `TODO`, `FIXME`, `HACK`, `XXX`, `TEMPORARY`, `workaround`, `kludge`
- `@deprecated` without migration path
- Commented-out code blocks

**Unusual error suppression:**

- `try/catch` with empty bodies or generic handlers
- `// eslint-disable`, `// @ts-ignore`, `@SuppressWarnings`
- Global error handlers that swallow exceptions

**Hard-coded values that should be configurable:**

- Magic numbers embedded in logic
- Environment-specific strings in code (URLs, paths, credentials)
- Feature flags hard-coded instead of using config

**Duplicated logic:**

- Same code appearing in 2+ places (DRY violation)
- Copy-pasted functions with minor variations
- Redundant validation or transformation logic

**Bypassed validation or security checks:**

- `if (skipValidation)` or `if (process.env.DISABLE_AUTH)`
- Commented-out authentication/authorization
- Conditional logic that disables safeguards

**Overly defensive code that masks a deeper problem:**

- Excessive null/undefined checks around specific values
- Try/catch around everything "just in case"
- Fallback logic that papers over unreliable behavior

---

## Process

### 1. Search for Workaround Patterns

Run language-appropriate searches:

**Bash/general:**

```bash
grep -rn "TODO\|FIXME\|HACK\|XXX\|TEMPORARY\|workaround" src/
grep -rn "eslint-disable\|@ts-ignore\|@SuppressWarnings" src/
```

**For specific patterns:**

```bash
# Empty catch blocks
grep -A 2 "catch" src/ | grep -B 1 "{\s*}"

# Hard-coded URLs/IPs
grep -rn "http://\|https://\|[0-9]\{1,3\}\.[0-9]\{1,3\}" src/
```

### 2. Evaluate Each Match

For each detected workaround, answer:

| Question          | Purpose                                    |
| ----------------- | ------------------------------------------ |
| **Why it exists** | What is the root cause it's papering over? |
| **Risk level**    | What could go wrong if this breaks?        |
| **Proper fix**    | What is the correct long-term solution?    |
| **Effort**        | How long to implement the proper fix?      |

### 3. Prioritize by Risk

Use this severity classification:

| Priority     | Characteristics                                  | Timeline              |
| ------------ | ------------------------------------------------ | --------------------- |
| **Critical** | Security bypass, data integrity risk, silent failures | Fix immediately   |
| **High**     | Performance issue, user-facing unreliability, frequent failures | This sprint |
| **Medium**   | Tech debt, fragile logic, maintenance burden    | Backlog               |
| **Low**      | Style/clarity issues, minor duplication          | Defer or fix opportunistically |

### 4. Document Findings

Create tickets or add to `.context/decisions.md` with:

- **Location:** File path and line number
- **Description:** What the workaround does
- **Reason:** Why it exists (if known)
- **Risk:** What could go wrong
- **Proper fix:** Long-term solution
- **Priority:** Critical/High/Medium/Low
- **Effort estimate:** S/M/L/XL

---

## Output Format

```
## Workaround Report

Scanned: [directory/files scanned]
Total found: N (Critical: X, High: Y, Medium: Z, Low: W)

### Critical
- `path/to/file.ts:42` — **Description:** [what the workaround does]
  - Why: [root cause or "unknown"]
  - Risk: [what could break]
  - Fix: [proper solution]
  - Effort: [S/M/L/XL]

### High
- `path/to/another.js:103` — **Description:** [what the workaround does]
  - Why: [root cause or "unknown"]
  - Risk: [what could break]
  - Fix: [proper solution]
  - Effort: [S/M/L/XL]

### Medium
[... same format ...]

### Low
[... same format ...]

---

## Recommended Actions

1. [Critical item 1] — assign immediately
2. [Critical item 2] — assign immediately
3. [High item 1] — schedule for this sprint
4. Create backlog tickets for Medium priority items
5. Document Low priority items for opportunistic fixes
```

---

## Constraints

- **Do not fix workarounds during this analysis** — document and prioritize only
- Every workaround entry **must include a "proper fix" description** — no "fix later" without a plan
- **Do not dismiss a workaround just because it "has always been there"** — age doesn't reduce risk
- If you don't know the root cause, mark it as "unknown" and note that investigation is needed
- **Do not conflate effort with priority** — a 5-minute fix can be Critical, a 3-day fix can be Low
- If a workaround is in a hot path or security-critical code, escalate priority by one level
- When scanning, respect `.gitignore` — don't scan `node_modules`, build artifacts, etc.
