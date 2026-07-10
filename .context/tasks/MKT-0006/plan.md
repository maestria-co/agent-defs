# MKT-0006: Lazy Skill Loading Guidance

## Branch

`feature/MKT-0006-lazy-skill-loading`

## Objective

Add "Efficient Skill Loading" guidance to `skills/using-skills/SKILL.md` to teach agents when and how to load skill reference files on-demand, preventing unnecessary context expansion while ensuring references are available when needed.

## Acceptance Criteria

- [x] Given the `skills/using-skills/SKILL.md`, when I read the new "Efficient Skill Loading" section, then it describes a 2-phase workflow: Discovery Phase (identify skill, read SKILL.md, start working) and Deep Dive Phase (load references only when needed). **Evidence:** Lines 192-206 describe both phases with clear steps.
- [x] Given the section's "What NOT to Do" guidance, when I read it, then it explicitly discourages pre-loading all references, reading multiple full skills, and re-reading skills. **Evidence:** Lines 210-215 list 4 anti-patterns including all required ones.
- [x] Given the section's "What TO Do" guidance, when I read it, then it explicitly encourages reading skills on-demand, loading references only for specific scenarios, and trusting memory within a session. **Evidence:** Lines 219-224 list 4 best practices including all required ones.
- [x] Given a step-by-step example (e.g., "Implementing a Feature"), when I follow it, then I see the workflow: identify skill → read core → start work → hit edge case → load reference → continue work. **Evidence:** Lines 228-245 show 5-step workflow with phase annotations.
- [x] Given the guidance, when an agent follows it, then it loads skills/references minimally and completes tasks without unnecessarily expanding context. **Evidence:** Section structure and decision-point language ("Can I continue without this reference?") enforce minimal loading.

## Key Files

- `skills/using-skills/SKILL.md` — Skill selection and usage guidance; will contain the new efficient loading section

## Task Breakdown

1. [x] Review existing `using-skills/SKILL.md` structure
2. [x] Design 2-phase workflow (Discovery + Deep Dive)
3. [x] Write "What NOT to Do" anti-patterns
4. [x] Write "What TO Do" best practices
5. [x] Create concrete example workflow (e.g., feature implementation)
6. [x] Verify all acceptance criteria met ← COMPLETE

## Decisions

*No decisions recorded yet.*

## Progress Log

- **2026-07-10 (12:05):** Added "Efficient Skill Loading" section to using-skills/SKILL.md (73 lines). Covers 2-phase workflow, anti-patterns, best practices, example workflow, and scenario-to-reference mapping table. All implementation steps complete.
- **2026-07-10 (11:54):** Task MKT-0006 created from Trello. Depends on MKT-0001 (sidecar pattern).

## Blockers

*No blockers currently identified.*
