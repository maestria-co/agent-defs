# MKT-0002 — Content-Aware Reading Strategies

**Status:** Pending
**Branch:** feature/MKT-0002-content-aware-reading
**Effort:** 2-3h | **Priority:** P0
**Complexity:** S (Small)

## Overview

Add content-aware reading strategies to skills so agents use efficient query patterns based on file type (JSON → jq, code → grep, logs → filter first) instead of loading entire files unnecessarily.

## Acceptance Criteria

- [ ] 1. `skills/context-loader/SKILL.md` has new "Content-Aware Reading Strategy" section describing patterns for: JSON/Structured Data, Code Files, Log Files, Documentation, and Test Output.

- [ ] 2. Given a JSON file, when following content-aware pattern, use jq to query specific fields instead of loading entire file.

- [ ] 3. Given a code file, when following content-aware pattern, use grep to find functions/exports first, then view_range for relevant sections only.

- [ ] 4. Given a log file, when following content-aware pattern, filter for errors/warnings first with grep before requesting full logs.

- [ ] 5. `skills/implementing-features/SKILL.md` "Understand the Spec" section includes guidance to apply content-aware reading based on spec content type.

- [ ] 6. Both updated skills include before/after examples showing ❌ inefficient patterns (loading full files) vs. ✅ efficient patterns (targeted queries).

## Affected Components

- `skills/context-loader/SKILL.md`
- `skills/implementing-features/SKILL.md`

## Steps

1. **[DONE]** Analyze current context-loader and implementing-features skills to understand structure and where to integrate content-aware reading patterns.
   - context-loader has "Reading Strategies" section (lines 54-79)
   - implementing-features has Pre-flight Check 2 (lines 38-48)

2. **[DONE]** Design content-aware reading section: define patterns for each file type (JSON, code, logs, documentation, test output) with before/after examples.
   - 5 patterns designed with ❌ inefficient vs ✅ efficient examples
   - Decision flow diagram for quick reference

3. **[DONE]** Add "Content-Aware Reading Strategy" section to `context-loader/SKILL.md` with all 5 file type patterns and examples.
   - Added 127-line section (lines 82-206)
   - Commit: 91322b3

4. **[DONE]** Update `implementing-features/SKILL.md` "Understand the Spec" section to reference content-aware reading patterns.
   - Updated Pre-flight Check 2 with 4-bullet guidance
   - Cross-reference to context-loader skill
   - Commit: 91322b3

5. **[DONE]** Add before/after examples to both skills showing inefficient vs. efficient reading patterns.
   - All 5 patterns include ❌/✅ examples
   - Examples are realistic and copy-pasteable

6. **[DONE]** Test updated skills: verify guidance is clear and actionable for agents.
   - All 6 acceptance criteria verified
   - Quality checks passed: content preservation, markdown formatting, examples quality, cross-references

7. **[DONE]** Verify acceptance criteria are met; commit and push branch.
   - All AC verified
   - 1 commit on feature/MKT-0002-content-aware-reading

## Verification Summary

✅ **All Acceptance Criteria Met:**
- AC1: context-loader has Content-Aware Reading Strategy section with all 5 file types ✓
- AC2: JSON pattern uses jq instead of loading entire files ✓
- AC3: Code pattern uses grep + view_range ✓
- AC4: Log pattern filters errors/warnings first ✓
- AC5: implementing-features references content-aware reading ✓
- AC6: Both skills show ❌ inefficient vs ✅ efficient examples ✓

✅ **Quality Gates:**
- Content preservation: +133 lines, 0 deletions
- Markdown formatting: Valid and consistent
- Examples quality: Realistic, copy-pasteable
- Cross-references: Working correctly
- Guidance clarity: Clear and actionable

✅ **Ready for Merge**

## Trello Card

- **Title:** MKT-0002 — Content-Aware Reading Strategies
- **ID:** 6a47d60da6a4ed039616c031
- **URL:** https://trello.com/c/oFhfnhdj
- **List:** To do
- **Board:** Work Center

## Progress Log

- **Created:** 2026-07-09 — Task infrastructure initialized from Trello card
