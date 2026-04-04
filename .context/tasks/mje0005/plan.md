# Task: Fix Manager Agent Task Classification Logic

**Task ID:** mje0005  
**Status:** Complete  
**Assigned to:** TBD  
**Created:** 2025-01-13  
**Completed:** 2025-01-13

## Problem

The Manager agent is not consistently creating task folders, branches, and plan.md files when it should. The current "simple vs complex" classification is too vague and leads to agents skipping critical task infrastructure.

## Specific Issues Observed

- Agent told to "initialize a repo" didn't create a task folder or branch
- No clear rule for when task tracking is required
- Classification based on "3+ steps, multi-file, unclear scope" is subjective

## Requirements

**Create task folder + branch + plan.md if ANY of these are true:**

1. Task will modify 2+ files in the system
2. Task requires handoff to another specialist (research, design, implementation phases)
3. Task involves research or findings that need to be tracked
4. Any code changes are planned (manager should have a plan before code changes)

**Key Principle:** Default to creating task infrastructure. It's better to have unnecessary tracking than to lose context mid-task.

## Acceptance Criteria

- [x] Manager agent instructions updated with explicit task classification rules
- [x] New rules replace vague "simple vs complex" language
- [x] Special cases documented (initialize-repo, architecture decisions, etc.)
- [x] Rule: 2+ file modifications = always create task folder
- [x] Rule: Any specialist handoff = always create task folder
- [x] Default behavior: create task infrastructure unless explicitly exempted
- [x] Exemption list is narrow and concrete (typo fixes, read-only operations, user says "no tracking")

## Files to Modify

- `agents/manager.agent.md` — "Turn Protocol → 3. Set Active Task" section

## Approach

1. Review current task classification logic in `agents/manager.agent.md`
2. Replace subjective "simple vs complex" language with explicit rules
3. Add the 4 trigger conditions for task infrastructure creation
4. Document narrow exemption list
5. Update examples to reflect new rules
6. Test with historical task scenarios to validate classification

## Notes

- This aligns with the principle of defaulting to more structure rather than less
- Prevents context loss during agent handoffs
- Makes task classification deterministic rather than subjective

## Completion Summary

**Completed:** 2025-01-13

All acceptance criteria met. The Manager agent instructions in `agents/manager.agent.md` have been updated with:

1. **Deterministic classification rules** — Replaced subjective "simple vs complex" language with explicit trigger conditions
2. **Four clear triggers** for task infrastructure creation:
   - 2+ file modifications
   - Specialist handoff required
   - Research/findings need tracking
   - Any code changes planned
3. **Default-to-tracking behavior** — Task infrastructure is now the default unless explicitly exempted
4. **Narrow exemption list** — Only typo fixes, documentation formatting, read-only operations, and user opt-out

**Evidence:** See `agents/manager.agent.md` "Turn Protocol → 3. Set Active Task" section with complete rewrite of task classification logic.
