# Visual Guide: Skill Refactoring Layout

## Before Refactoring

```
┌─────────────────────────────────────────────────────────┐
│  implementing-features/SKILL.md  (215 lines)           │
├─────────────────────────────────────────────────────────┤
│ ▢ Frontmatter (10 lines)                               │
│ ▢ Purpose (8 lines)              ← KEEP               │
│ ▢ Pre-flight Checks (24 lines)   ← KEEP               │
│ ▢ Execution Steps (54 lines)     ← KEEP               │
│ ▢ Output Format (18 lines)       ← KEEP               │
│ ▢ Examples (83 lines)            ← EXTRACT            │
│   • Example 1 (31 lines)                              │
│   • Example 2 (26 lines)                              │
│   • Example 3 (19 lines)                              │
│ ▢ Constraints (9 lines)          ← KEEP               │
└─────────────────────────────────────────────────────────┘
           Total: 215 lines
```

```
┌─────────────────────────────────────────────────────────┐
│  writing-tests/SKILL.md  (230 lines)                   │
├─────────────────────────────────────────────────────────┤
│ ▢ Frontmatter (10 lines)                               │
│ ▢ Purpose (10 lines)             ← KEEP               │
│ ▢ Pre-flight Checks (22 lines)   ← KEEP               │
│ ▢ Execution Steps (53 lines)     ← KEEP               │
│ ▢ Output Formats (28 lines)      ← KEEP               │
│ ▢ Examples (67 lines)            ← EXTRACT to 3       │
│   • Example 1 (22 lines) → code-patterns.md           │
│   • Example 2 (20 lines) → troubleshooting.md         │
│   • Example 3 (18 lines) → edge-cases.md              │
│ ▢ Constraints (9 lines)          ← KEEP               │
└─────────────────────────────────────────────────────────┘
           Total: 230 lines
```

---

## After Refactoring

### Implementing Features Structure

```
skills/implementing-features/
│
├── SKILL.md  (160 lines) ✓ CORE WORKFLOW
│   ├─ Frontmatter (10 lines)
│   ├─ Purpose (8 lines)
│   ├─ Pre-flight Checks (24 lines)
│   ├─ Execution Steps (54 lines)
│   ├─ Output Format (18 lines)
│   │  "See references/code-patterns.md for detailed examples"
│   └─ Constraints (9 lines)
│
└── references/
    └── code-patterns.md  (65 lines) ✓ PATTERNS
        ├─ Header + Navigation (8 lines)
        ├─ Pattern 1: Models + Migrations (Example 1, 31 lines)
        ├─ Pattern 2: Bug Fixing (Example 2, 26 lines)
        └─ Pattern 3: Spec Clarification (Example 3, 19 lines)
```

### Writing Tests Structure

```
skills/writing-tests/
│
├── SKILL.md  (160 lines) ✓ CORE WORKFLOW
│   ├─ Frontmatter (10 lines)
│   ├─ Purpose (10 lines)
│   ├─ Pre-flight Checks (22 lines)
│   ├─ Execution Steps (53 lines)
│   │  "See references/code-patterns.md for test structure examples"
│   │  "See references/troubleshooting.md if tests fail"
│   ├─ Output Formats (28 lines)
│   └─ Constraints (9 lines)
│      "See references/edge-cases.md for untestable code patterns"
│
└── references/
    ├── code-patterns.md  (60 lines) ✓ PATTERNS
    │   ├─ Header + Navigation (8 lines)
    │   ├─ Test Structure Intro (8 lines)
    │   ├─ Pattern 1: Models (Example 1, 22 lines)
    │   ├─ Pattern 2: Services (5 lines)
    │   ├─ Pattern 3: API Endpoints (5 lines)
    │   └─ Coverage Benchmarks (8 lines)
    │
    ├── edge-cases.md  (50 lines) ✓ EDGE CASES
    │   ├─ Header + Navigation (8 lines)
    │   ├─ Testability Blockers Intro (10 lines)
    │   ├─ Case 1: Global Singletons (Example 3, 18 lines)
    │   ├─ Case 2: Circular Dependencies (5 lines)
    │   ├─ Case 3: Hard-coded Calls (5 lines)
    │   └─ How to Unblock (10 lines)
    │
    └── troubleshooting.md  (45 lines) ✓ TROUBLESHOOTING
        ├─ Header + Navigation (8 lines)
        ├─ Common Failures + Diagnosis (15 lines)
        ├─ Scenario 1: Regression Testing (Example 2, 20 lines)
        └─ Coverage Targets Not Met (5 lines)
```

---

## Content Flow Map

### Implementing Features

```
USER READS SKILL.MD FIRST
    ↓
    ├─→ "I'm implementing a feature"
    │   ├─→ Read: Purpose, Pre-flight Checks
    │   ├─→ Follow: 5 Execution Steps
    │   ├─→ Format: Output Format section
    │   └─→ Verify: Constraints before starting
    │
    └─→ "I want to see examples" / "How do I do [X]?"
        └─→ Read: references/code-patterns.md
            ├─→ Example 1: Models & Migrations
            ├─→ Example 2: Bug Fixing
            └─→ Example 3: Spec Clarification
```

### Writing Tests

```
USER READS SKILL.MD FIRST
    ↓
    ├─→ "I need to write tests"
    │   ├─→ Read: Purpose (contract vs internals)
    │   ├─→ Check: Pre-flight Checks (is code ready?)
    │   ├─→ Follow: 7 Execution Steps
    │   ├─→ Check: Output Formats (what "done" looks like)
    │   └─→ Verify: Constraints (no production code, etc.)
    │
    ├─→ "I want to see examples" / "How do I structure tests?"
    │   └─→ Read: references/code-patterns.md
    │       ├─→ Test Anatomy (happy/edge/error/security)
    │       ├─→ Pattern 1: Models
    │       ├─→ Pattern 2: Services
    │       └─→ Pattern 3: API Endpoints
    │
    ├─→ "My tests are blocked" / "What's untestable?"
    │   └─→ Read: references/edge-cases.md
    │       ├─→ Global singletons
    │       ├─→ Circular dependencies
    │       └─→ How to refactor
    │
    └─→ "Tests failed" / "What went wrong?"
        └─→ Read: references/troubleshooting.md
            ├─→ Why tests fail
            ├─→ Regression testing
            └─→ Coverage not met
```

---

## Cross-Reference Callouts in Main Files

### In implementing-features/SKILL.md

```markdown
## Pre-flight Checks

**Check 2 — Read before writing**

Read in this order before writing a single line of code:

1. The spec and acceptance criteria
2. Existing code in the area being changed (patterns, naming, error handling)
   → See: `references/code-patterns.md` for pattern examples
3. `.context/decisions/` ADRs relevant to this area
```

```markdown
## Step 3 — Implement Minimally

Write the smallest change that satisfies the spec:
- Match existing naming conventions, error handling patterns, and code style
  → See: `references/code-patterns.md` for real examples
- No speculative refactors ("while I'm here I'll also...")
- No unasked features (YAGNI)
```

---

### In writing-tests/SKILL.md

```markdown
## Step 1 — List Test Cases Before Writing

Write a comment block listing every test case you plan to write, grouped by category:

// Happy path:     valid input → expected output
// Edge cases:     null, empty, boundary values, special chars
// Error cases:    invalid input, missing required fields, downstream failures
// State cases:    before/after state transitions, concurrent writes
// Security cases: [only if code handles auth, external input, or file I/O]

→ See: `references/code-patterns.md` for detailed test structure examples
```

```markdown
## Step 6 — Run the Suite

Run tests with the no-watch flag...

- If tests fail → diagnose and fix tests
  → See: `references/troubleshooting.md` for common failures
- If code is untestable...
  → See: `references/edge-cases.md` for untestable patterns
```

```markdown
## Constraints

...
- Do not mock the code under test or its internal utilities
  → See: `references/edge-cases.md` for what makes code untestable
...
```

---

## Line Count Visualization

### Before
```
implementing-features:  215 lines ████████████████████
writing-tests:          230 lines █████████████████████
                        ──────────────────
Total:                  445 lines
```

### After
```
SKILL.md Files:
  implementing-features: 160 lines ████████████
  writing-tests:         160 lines ████████████

References:
  code-patterns (impl):   65 lines █████
  code-patterns (tests):  60 lines ████
  edge-cases:             50 lines ████
  troubleshooting:        45 lines ███
                         ──────────────────
Total:                  540 lines

Reduction in main files: -110 lines (-55%)
Gain in modularity: +95 lines of organized references
```

---

## Navigation: How Users Find Things

### Scenario 1: "I'm starting a new feature"
```
START
  └─→ Read: implementing-features/SKILL.md
      ├─ Purpose: Confirms this is the right skill
      ├─ Pre-flight: Gates bad starts
      ├─ Steps: How to implement
      └─ Output Format: How to present the work
          └─ If you want patterns/examples:
             → Go to: references/code-patterns.md
```

### Scenario 2: "I'm writing tests but blocked"
```
START
  └─→ Read: writing-tests/SKILL.md
      ├─ Purpose: What testing is
      ├─ Pre-flight: Is code ready?
      ├─ Steps: How to test
      └─ Step 6 (Run Suite) mentions issues
          └─ If "code is untestable":
             → Go to: references/edge-cases.md
             → Learn: What makes it untestable
             → Action: Link to implementing-features (refactor)
```

### Scenario 3: "I want to see test examples"
```
START
  └─→ Read: writing-tests/SKILL.md
      └─ Step 1 mentions examples
          └─→ Go to: references/code-patterns.md
              ├─ Example 1: Testing models
              ├─ Example 2: Testing services
              └─ Example 3: Testing API endpoints
```

---

## Validation Checklist (Visual)

### Before Implementation
- [ ] Core workflow identified (what stays in SKILL.md)
- [ ] Examples identified (what moves to references)
- [ ] Extraction boundaries confirmed (clean cuts)
- [ ] Cross-reference points identified (where callouts go)

### During Implementation
- [ ] Reference directories created
- [ ] Content extracted to new files
- [ ] Extracted content removed from main files
- [ ] Cross-reference callouts added
- [ ] File headers/navigation added

### After Implementation
- [ ] Main SKILL.md reads standalone
- [ ] Main SKILL.md is ~160 lines
- [ ] Each reference file is ~50-65 lines
- [ ] Each reference file reads standalone
- [ ] Cross-references use relative paths
- [ ] No content duplicated
- [ ] Line numbers updated in any mentions

---

## Summary: Before vs After

| Aspect | Before | After |
|--------|--------|-------|
| **Main SKILL.md lines** | 215–230 | ~160 |
| **Scanning time** | 8–10 min | 4–5 min |
| **Examples location** | Embedded in SKILL.md | Organized by type |
| **Quick lookup** | "Find in file" | Navigate to reference |
| **Learning path** | Linear (start to finish) | Procedural + examples as needed |
| **Reference quality** | Shallow (1 example per scenario) | Deep (3–5 examples per pattern) |

---

## What Doesn't Change

✅ The skill itself (what it does)
✅ The workflow (5 steps for impl, 7 for tests)
✅ The philosophy (minimal code, testable code)
✅ The output format (what "done" looks like)
✅ The integration with other skills

**What improves:**
- Scannability of core workflow
- Organization of patterns and examples
- Navigation by learning need (patterns / edge cases / troubleshooting)
- Modularity for future updates
