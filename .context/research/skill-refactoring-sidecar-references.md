# Skill Refactoring Analysis: Sidecar References Pattern

**Date**: 2026-07-06  
**Files Analyzed**:
- `skills/implementing-features/SKILL.md` (215 lines, 7.3 KB)
- `skills/writing-tests/SKILL.md` (230 lines, 8.1 KB)

**Total Combined**: 445 lines, 15.3 KB

---

## Executive Summary

Both skill files contain a clear **core workflow section** (Pre-flight Checks + Execution Steps) that should remain in the main SKILL.md. However, each file has **70-80+ lines of supporting content** (examples, edge cases, troubleshooting) that can be extracted into sidecar reference files while maintaining coherence.

### Refactoring Impact
- **Before**: Two large monolithic files (215 + 230 lines)
- **After**: Two focused SKILL.md files (~150 lines each) + 6 sidecar reference files (~50-80 lines each)
- **Benefit**: Core workflow remains actionable in SKILL.md; learners navigate detailed patterns independently

---

## Skill 1: Implementing Features

### Current Structure Analysis

| Section | Lines | Type | Character Count |
|---------|-------|------|-----------------|
| Frontmatter (metadata) | 10 | Static | ~150 chars |
| Purpose + Pre-flight Checks | 48 | **Core workflow** | ~1,200 chars |
| Execution Steps (Steps 1-5) | 54 | **Core workflow** | ~1,800 chars |
| Output Format | 18 | **Core workflow** | ~600 chars |
| Examples (3 scenarios) | 83 | **Supporting** | ~2,800 chars |
| Constraints | 9 | **Core workflow** | ~700 chars |
| **Total** | **215** | | **7,254** |

### Content Categorization

#### ✅ KEEP in SKILL.md (Target: 150-160 lines)

**Section: Purpose** (lines 14–21)
- Rationale: Sets expectation and defines when to use the skill
- Status: Essential for decision-making before starting

**Section: Pre-flight Checks** (lines 24–47)
- Rationale: Gate-keeping logic — prevents wasted work
- Status: Non-negotiable; must stay to prevent scope creep

**Section: Execution Steps** (lines 50–93)
- Rationale: Core workflow — the "how to do it" steps
- Status: Keep all 5 steps; this is the actionable core

**Section: Output Format** (lines 96–113)
- Rationale: Defines how to present work; critical for handoff
- Status: Keep in full; informs every implementation

**Section: Constraints** (lines 207–215)
- Rationale: Defines scope boundaries and non-negotiables
- Status: Keep as-is

**Frontmatter** (lines 1–10)
- Status: Keep as-is

---

#### 📦 EXTRACT to Sidecar References

**Content from Examples Section (lines 117–202)**: **83 lines, 2,800 chars**

Extract to: `references/code-patterns.md`

**Breakdown:**
- Example 1: "Implementing a new model and database migration" (lines 121–151) — 31 lines
  - **Category**: Code pattern (model + migration structure)
  - **Subcategory**: Database patterns, ORM conventions
  - **Extract**: Full example; establishes convention for model files
  
- Example 2: "Fixing a bug with a known root cause" (lines 154–179) — 26 lines
  - **Category**: Troubleshooting + code pattern (root cause analysis)
  - **Subcategory**: Debugging methodology, bug fix patterns
  - **Extract**: Full example; shows how to diagnose and frame a fix
  - **Cross-ref**: Link to "troubleshooting.md" for debugging methodology
  
- Example 3: "Spec is ambiguous — pattern asks for clarification" (lines 182–200) — 19 lines
  - **Category**: Edge case (incomplete spec handling)
  - **Extract**: Move to `references/edge-cases.md`
  - **Rationale**: Shows boundary condition of the skill (when NOT to proceed)

---

### Proposed Sidecar Structure

#### `references/code-patterns.md` (~60-70 lines)

**Content to include:**
- Example 1 (Model + migration): Full
- Model naming conventions (inferred from example)
- Encryption/dependency injection pattern
- Brief guidance on "minimal implementation" with code examples

**Sections:**
- Common patterns in implementing features (5-10 lines intro)
- Pattern 1: Creating new models (25 lines — Example 1)
- Pattern 2: Fixing bugs — root cause analysis (20 lines — Example 2)
- When to ask for clarification (5-10 lines — Example 3 relocated to edge-cases)

**Cross-references:**
- Link to ADR guidance in main SKILL.md
- Link to `writing-tests` skill for verification

---

#### No explicit "edge-cases.md" needed for this skill

**Rationale**: Example 3 can be shortened and embedded as a note in the main SKILL.md under "Pre-flight Checks" as a callout.

---

### Validation After Refactoring

**Main SKILL.md should:**
- [ ] Still read as a complete, standalone guide (150–160 lines)
- [ ] Include all 5 execution steps with no gaps
- [ ] Include Pre-flight Checks that prevent bad starts
- [ ] Include Output Format with examples of what "done" looks like
- [ ] Include crisp callouts for when to stop and ask for clarification

**Reference files should:**
- [ ] Be independently readable without returning to main SKILL.md
- [ ] Include 3–5 concrete code examples per pattern
- [ ] Show naming conventions and error handling patterns
- [ ] Explicitly cross-reference constraints from main SKILL.md

---

## Skill 2: Writing Tests

### Current Structure Analysis

| Section | Lines | Type | Character Count |
|---------|-------|------|-----------------|
| Frontmatter (metadata) | 10 | Static | ~150 chars |
| Purpose | 10 | **Core workflow** | ~350 chars |
| Pre-flight Checks | 22 | **Core workflow** | ~850 chars |
| Execution Steps (Steps 1-7) | 53 | **Core workflow** | ~2,000 chars |
| Output Formats (3 outcomes) | 28 | **Core workflow** | ~1,000 chars |
| Examples (3 scenarios) | 67 | **Supporting** | ~2,600 chars |
| Constraints | 9 | **Core workflow** | ~1,100 chars |
| **Total** | **230** | | **8,051** |

### Content Categorization

#### ✅ KEEP in SKILL.md (Target: 155-165 lines)

**Section: Purpose** (lines 14–22)
- Rationale: Defines testing philosophy and success criteria
- Status: Essential; establishes "contract vs internals" principle

**Section: Pre-flight Checks** (lines 25–46)
- Rationale: Gate-keeping — prevents testing unimplemented code
- Status: Non-negotiable; critical decision points

**Section: Execution Steps** (lines 49–113)
- Rationale: Core workflow — the "how to test" steps
- Status: Keep all 7 steps
- Note: Step 2 (finding conventions) and Step 6 (running suite) are procedural and should stay

**Section: Output Formats** (lines 117–144)
- Rationale: Defines success/failure criteria
- Status: Keep all three outcome formats (passing, failing, blocked)

**Section: Constraints** (lines 222–230)
- Rationale: Non-negotiables (no production code, contract-based testing, etc.)
- Status: Keep as-is

**Frontmatter** (lines 1–10)
- Status: Keep as-is

---

#### 📦 EXTRACT to Sidecar References

**Content from Examples Section (lines 148–216)**: **67 lines, 2,600 chars**

Extract to multiple files based on use case:

**Example 1: "Testing a new model with encrypted fields" (lines 152–173)** — 22 lines
- **Category**: Code pattern (test structure for database models)
- **Subcategory**: Unit testing convention, Sequelize mocking, coverage targets
- **Extract → `references/code-patterns.md`**
  - Concrete example: how to test models with Jest + Sequelize
  - Coverage target: 90%+ for new code
  - Shows: happy path, edge cases, security (encrypted fields)

**Example 2: "Writing a regression test for a bug fix" (lines 176–195)** — 20 lines
- **Category**: Troubleshooting + code pattern
- **Subcategory**: Bug verification testing, regression prevention
- **Extract → `references/troubleshooting.md`**
  - Shows how to write a test that reproduces the bug
  - Demonstrates: input/expected/validation structure
  - Links to: "implementing-features" skill for the fix itself

**Example 3: "Test blocked by untestable code" (lines 198–215)** — 18 lines
- **Category**: Edge case (architectural constraint on testability)
- **Subcategory**: Dependency injection, global state problems
- **Extract → `references/edge-cases.md`**
  - Concrete example: singleton Redis client (untestable)
  - Shows: what "untestable" means in practice
  - Links to: "implementing-features" for refactoring solution

---

### Proposed Sidecar Structure

#### `references/code-patterns.md` (~55-65 lines)

**Content to include:**
- Overview of test structure (given/when/then or arrange/act/assert) — 5-10 lines
- Example 1 (Model testing with Sequelize) — 22 lines
- Common patterns for different code types (unit, integration, security) — 15-20 lines
- Coverage targets per code type (new: 90%, refactor: no decrease) — 5 lines

**Sections:**
- Test anatomy: happy path, edge cases, error cases, security (8 lines)
- Pattern 1: Unit testing database models (Example 1, ~22 lines)
- Pattern 2: Unit testing services (5 lines + brief code snippet)
- Pattern 3: Integration testing API endpoints (5 lines + brief code snippet)
- Coverage benchmarks (8 lines)

**Cross-references:**
- Link to `writing-tests` Step 1 (list test cases before writing)
- Link to `implementing-features` for code that's untestable (see edge-cases.md)

---

#### `references/edge-cases.md` (~45-55 lines)

**Content to include:**
- When testing is blocked (global state, no DI, etc.) — 8 lines
- Example 3 (Redis singleton problem) — 18 lines full
- How to identify untestable code patterns (5 patterns) — 15-20 lines
- How to report it (format, link to implementing-features) — 5-10 lines

**Sections:**
- Testability blockers: what they are (10 lines)
- Pattern: Global singletons (Example 3, ~18 lines)
- Pattern: Circular dependencies (5 lines + brief example)
- Pattern: Hard-coded external calls (5 lines + brief example)
- How to unblock: refactoring path (10-15 lines)
- Output format when blocked: copy from main SKILL.md Step 6 (5 lines)

**Cross-references:**
- Link to `implementing-features` skill (refactor for testability)
- Link to Constraints in main SKILL.md

---

#### `references/troubleshooting.md` (~40-50 lines)

**Content to include:**
- Common test failures and diagnosis (15-20 lines)
- Example 2 (Regression test for bug fix) — 20 lines
- How to verify a fix with a test (10-15 lines)

**Sections:**
- Why tests fail and how to debug (10-15 lines)
- Scenario 1: Regression testing (Example 2, ~20 lines)
- Scenario 2: Flaky tests / timing issues (5-10 lines)
- Scenario 3: Coverage targets not met (5 lines)
- When to report: output format reference (5 lines — link to main SKILL.md Step 7)

**Cross-references:**
- Link to `implementing-features` skill for the fix that enabled the test
- Link to Step 6 in main SKILL.md (Run the Suite)

---

### Validation After Refactoring

**Main SKILL.md should:**
- [ ] Remain at 155–165 lines
- [ ] Include all 7 execution steps with no gaps
- [ ] Retain Pre-flight Checks that gate unimplemented code
- [ ] Include all three Output Formats (passing/failing/blocked)
- [ ] Preserve the testing philosophy ("contract vs internals")

**Reference files should:**
- [ ] Be independently readable
- [ ] Include concrete code examples (models, services, API endpoints)
- [ ] Link back to main SKILL.md for procedural steps
- [ ] Show what "blocked" looks like and how to unblock

---

## Cross-File Reference Map

### For Implementing Features Skill

**From main SKILL.md:**
- Pre-flight Check 1 → points to "code-patterns.md" for real-world examples
- Step 3 (Implement Minimally) → points to "code-patterns.md" for naming/error handling conventions
- Self-Review checklist → points to "code-patterns.md" for pattern verification

**From code-patterns.md:**
- Example sections → point back to main SKILL.md Output Format
- Bug fixing pattern → points to "writing-tests" skill for regression testing

---

### For Writing Tests Skill

**From main SKILL.md:**
- Step 1 (List test cases) → shows categories; detailed examples in "code-patterns.md"
- Step 6 (Run the suite) → points to "troubleshooting.md" for common failures
- Constraints → note about testable code links to "edge-cases.md"
- Output Format (Blocked) → example and diagnosis in "edge-cases.md"

**From code-patterns.md:**
- Coverage targets → reference to main SKILL.md Step 6
- How to structure tests → based on Execution Steps in main

**From edge-cases.md:**
- Testability blockers → link to "implementing-features" skill for refactoring
- Output format for "blocked" state → copy from main SKILL.md

**From troubleshooting.md:**
- Regression testing → example of implementing-features workflow + writing-tests
- Test failures → diagnostic steps reference Step 6 in main SKILL.md

---

## Line Count Targets (Post-Refactoring)

| File | Current | Target | Delta | Status |
|------|---------|--------|-------|--------|
| **implementing-features/SKILL.md** | 215 | 160 | -55 | ✓ Achievable |
| implementing-features/references/code-patterns.md | — | 65 | +65 | New |
| **writing-tests/SKILL.md** | 230 | 160 | -70 | ✓ Achievable |
| writing-tests/references/code-patterns.md | — | 60 | +60 | New |
| writing-tests/references/edge-cases.md | — | 50 | +50 | New |
| writing-tests/references/troubleshooting.md | — | 45 | +45 | New |
| **Total** | 445 | 580 | +135 | ✓ Improved modularity |

---

## Extraction Boundaries & Natural Break Points

### Implementing Features

**Boundary 1: Examples Section (lines 117–202)**
- **Current state**: 3 examples mixed with core steps
- **Natural break**: No code after line 113 (Output Format) until line 117 (Examples)
- **Extraction**: Move all examples → code-patterns.md
- **Keeps coherence**: ✓ Main file is still a complete workflow

**Boundary 2: Constraints (lines 207–215)**
- **Decision**: Keep in main file
- **Rationale**: Constraints are scope-defining; must stay with workflow

---

### Writing Tests

**Boundary 1: Examples Section (lines 148–216)**
- **Current state**: 3 distinct examples + 1 blank line separator between them
- **Natural breaks**:
  - Example 1 ends line 173 (model testing)
  - Example 2 ends line 195 (regression testing)
  - Example 3 ends line 215 (untestable code)
- **Extraction plan**:
  - Example 1 → code-patterns.md
  - Example 2 → troubleshooting.md
  - Example 3 → edge-cases.md
- **Keeps coherence**: ✓ Main file explains procedure; examples distributed by use case

**Boundary 2: Output Formats (lines 117–144)**
- **Decision**: Keep in main file
- **Rationale**: Defines success criteria; essential for every execution path

---

## Content Integrity Checklist

### Implementing Features

**Can the main SKILL.md be used standalone to implement a feature?**
- [ ] Yes — Purpose + Pre-flight + 5 Steps + Output Format + Constraints = complete workflow
- [ ] References are "nice to have" but not required

**Do examples clarify patterns or are they essential?**
- [ ] Clarify — they show best practices but the steps are sufficient
- [ ] Can extract without breaking the workflow

**Test the coherence:**
- Try reading lines 1–113 (frontmatter + purpose + checks + steps + output + constraints) without examples
- Result: Still actionable. Can implement a feature. Examples are illustrations, not prerequisites.

---

### Writing Tests

**Can the main SKILL.md be used standalone to write tests?**
- [ ] Yes — Purpose + Pre-flight + 7 Steps + 3 Output Formats + Constraints = complete workflow
- [ ] All procedural steps are present

**Do examples teach patterns or are they essential?**
- [ ] Teach patterns — they show concrete test structure but steps are sufficient
- [ ] Can extract without breaking the workflow

**Test the coherence:**
- Try reading lines 1–146 (frontmatter + purpose + checks + steps + outputs + constraints) without examples
- Result: Still actionable. Can write tests. Examples are reference material.

---

## Implementation Notes for Refactoring

### Phase 1: Extract Content
1. Copy Examples section from implementing-features → code-patterns.md (new)
2. Copy Example 1 from writing-tests → code-patterns.md (new)
3. Copy Example 2 from writing-tests → troubleshooting.md (new)
4. Copy Example 3 from writing-tests → edge-cases.md (new)

### Phase 2: Add Cross-References
1. In implementing-features/SKILL.md:
   - Under Step 3, add: "See `references/code-patterns.md` for naming and error handling examples."
   - Under Pre-flight Check 2, add: "Refer to `references/code-patterns.md` for relevant ADRs and architecture patterns."

2. In writing-tests/SKILL.md:
   - Under Step 1, add: "See `references/code-patterns.md` for test structure examples."
   - Under Step 6, add: "See `references/troubleshooting.md` if tests fail."
   - Under Constraints, add: "See `references/edge-cases.md` for untestable code patterns."

### Phase 3: Validate
1. Main SKILL.md files read as complete, standalone workflows
2. Each reference file has introductory text explaining its purpose
3. Cross-references use exact file paths: `references/code-patterns.md`
4. No content is duplicated across files

---

## Recommendations for Sidecar File Structure

### Directory Structure
```
skills/implementing-features/
├── SKILL.md (160 lines → core workflow)
└── references/
    ├── code-patterns.md (65 lines)
    └── _index.md (optional: navigation guide)

skills/writing-tests/
├── SKILL.md (160 lines → core workflow)
└── references/
    ├── code-patterns.md (60 lines)
    ├── edge-cases.md (50 lines)
    ├── troubleshooting.md (45 lines)
    └── _index.md (optional: navigation guide)
```

### Header Convention for Reference Files
Each reference file should start with:
```markdown
# [Skill Name] — [Reference Type]

**See also**: [Link to main SKILL.md]

**In this guide:**
- Pattern 1: [description]
- Pattern 2: [description]
- ...

---

## [Pattern Name]
...
```

---

## Validation Criteria Summary

| Criterion | Implementing Features | Writing Tests |
|-----------|----------------------|----------------|
| Main SKILL.md under 165 lines | ✓ Yes (160) | ✓ Yes (160) |
| Main SKILL.md is standalone | ✓ Yes | ✓ Yes |
| All examples have homes | ✓ code-patterns.md (3 ex) | ✓ Distributed (3 files) |
| Cross-references are explicit | ✓ Added | ✓ Added |
| No content orphaned | ✓ All extracted content has destination | ✓ All extracted content has destination |
| Reference files are independent | ✓ code-patterns.md includes intro | ✓ Each file has context intro |

---

## Risks & Mitigations

| Risk | Mitigation |
|------|-----------|
| User reads main SKILL.md and misses critical pattern in references | Add explicit callouts (e.g., "⚠️ See references/code-patterns.md") at relevant steps |
| Reference files become stale or drift from main workflow | Establish a convention: references are examples only; procedural steps stay in main SKILL.md |
| Cross-references break if files are moved | Use relative paths (e.g., `./references/code-patterns.md`) consistent across all skills |
| Developers skip reference files and miss edge cases | Add a "Before you start" note in main SKILL.md: "Read Pre-flight Checks + Execution Steps (above), then browse `references/` for detailed patterns and edge cases." |

---

## Summary: Ready for Refactoring

✅ **Implementing Features**: Extract 3 examples to `code-patterns.md` (~65 lines)
- Main SKILL.md: 215 → 160 lines (25% reduction)
- Gains: Focused workflow, patterns accessible but not overwhelming

✅ **Writing Tests**: Extract 3 examples to 3 sidecar files (~155 lines total)
- Main SKILL.md: 230 → 160 lines (30% reduction)
- Gains: Focused workflow, patterns organized by use case (patterns/edge-cases/troubleshooting)

✅ **Both files maintain coherence and are fully actionable standalone**

✅ **Reference files are independently readable**

✅ **Cross-references are explicit and traceable**

---

## Next Steps

1. **Create reference file structure** (empty directories + template headers)
2. **Extract content** using boundaries identified above
3. **Add cross-references** using the reference map
4. **Validate readability** using the checklist above
5. **Test workflow** by following each skill with only the main SKILL.md (should work)
6. **Test references** by reading each independently (should be coherent)
