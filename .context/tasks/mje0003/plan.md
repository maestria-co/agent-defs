# Task MJE0003: Graph Effectiveness Eval Skill

## Problem

After running `context-graph-linker` on a repository there is no way to verify
the graph actually improves AI context-loading efficiency. Structural checks
(do the files exist?) don't prove the graph reduces tokens loaded or retrieves
the right nodes for a given task.

## Goal

Build a `graph-effectiveness-eval` skill that runs a before/after A/B
measurement to quantify the improvement the graph provides.

## Approach

### Before snapshot (no graph)
- List all `.context/` markdown files
- Sum total character count → divide by 4 for token estimate
- Record file count and total tokens as the "worst-case load" baseline

### After snapshot (graph exists)
- Given a task description, an evaluator agent:
  1. Reads `INDEX.md` only as the entry point
  2. Follows edges relevant to the task
  3. Records which nodes it visited and why
  4. Sums token sizes of only those files

### Comparison report
- Token reduction: before tokens vs after tokens (e.g. 12,000 → 2,400 = 80% savings)
- Noise reduction: files loaded but not relevant to the task
- Coverage: did traversal still find all expected files? (no missed critical nodes)
- Orphan risk: nodes in `ORPHANS.md` are context the graph can never navigate to

## Acceptance Criteria

- [ ] Skill measures before-state token count from `.context/` without modifying anything
- [ ] Skill accepts a task description and simulates graph traversal from `INDEX.md`
- [ ] Skill produces a comparison report with token delta, noise count, and coverage verdict
- [ ] Skill flags orphaned nodes as a coverage risk
- [ ] Works on any repo with a `.context/` directory (graph present or absent)

## Notes

- "Before" baseline = all `.context/` files loaded (no navigation aid available)
- "After" traversal must be done by an LLM evaluator since it requires semantic understanding
- The eval should be reusable as a regression check after future graph updates
- Related: MJE0002 (context-graph-linker skill), the graph this eval validates

## Status

Pending — scheduled for next session
