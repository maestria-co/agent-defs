# MKT-0001 — Create Sidecar References POC

**Status:** Pending
**Branch:** feature/MKT-0001-sidecar-references
**Effort:** 5-6h | **Priority:** P0
**Complexity:** M

## Overview

Refactor skills to use a sidecar references pattern so skills remain concise (~150-200 lines) while detailed content (examples, edge cases, troubleshooting) stays accessible in organized reference files.

## Acceptance Criteria

- [ ] 1. Create `references/` subdirectories for `implementing-features/SKILL.md` and `writing-tests/SKILL.md`, each containing: `code-patterns.md`, `edge-cases.md`, `troubleshooting.md`, and integration guides.

- [ ] 2. Refactored main `SKILL.md` files are ~150-200 lines (down from 500-700 lines).

- [ ] 3. When an agent follows the core workflow and encounters an edge case, it loads the appropriate reference file (e.g., `references/edge-cases.md`) on demand.

- [ ] 4. Both refactored skills allow agents to complete tasks successfully using the refactored structure (e.g., implementing a feature).

- [ ] 5. The `skills/README.md` clearly documents the sidecar pattern with examples showing the structure.

## Affected Components

- `skills/implementing-features/SKILL.md`
- `skills/implementing-features/references/` (new)
- `skills/writing-tests/SKILL.md`
- `skills/writing-tests/references/` (new)
- `skills/README.md`

## Steps

1. **[DONE]** Analyze current `implementing-features` and `writing-tests` skill files to understand structure and identify content for refactoring.
   - **Findings**: Extracted 83 lines (implementing-features) and 67 lines (writing-tests) that can move to references
   - **Research**: `.context/research/REFACTORING-SUMMARY.md` with extraction boundaries and validation
   
2. **[DONE]** Design sidecar references structure: define what goes in each reference file.
   - **Implementing-features**: 1 reference file (`code-patterns.md` with 3 code examples)
   - **Writing-tests**: 3 reference files (`code-patterns.md`, `edge-cases.md`, `troubleshooting.md` distributed by use case)

3. **[DONE]** Create `references/` directories and extract content into appropriate reference files for both skills.
   - Extract and place examples into reference files: ✅ 4 files created
   - Add cross-reference links in main SKILL.md files (5 decision points per skill): ✅ complete
   - **Lines**: implementing-features 215→129 (40% reduction), writing-tests 230→159 (31% reduction)
   - **Commit**: 64d2e95

4. **[DONE]** Refactor main `SKILL.md` files to be concise (~150-200 lines) with clear pointers to reference files.
   - **Result**: Both files fully refactored and actionable in isolation
   - **Commit**: 64d2e95

5. **[DONE]** Update `skills/README.md` to document the sidecar pattern with examples.
   - Added "Skill Structure: Sidecar References Pattern" section with examples
   - **Commit**: 6d3992a

6. **[IN PROGRESS]** Test the refactored skills: verify agents can successfully use them with reference file loading.
   - @Tester validating all 6 acceptance criteria
   - Checking actionability, readability, cross-references, content preservation, line counts, markdown formatting

7. **[PENDING]** Verify acceptance criteria are met; commit and push branch.

## Trello Card

- **Title:** MKT-0001 — Create Sidecar References POC
- **ID:** 6a47d60ad5a033b4847f651e
- **URL:** https://trello.com/c/ciK6kLBa
- **List:** To do
- **Board:** Work Center

## Progress Log

- **Created:** 2026-07-05 — Task infrastructure initialized from Trello card
