# MKT-0006: Lazy Skill Loading Guidance

## Branch

`feature/MKT-0006-lazy-skill-loading`

## Objective

Add "Efficient Skill Loading" guidance to `skills/using-skills/SKILL.md` to teach agents when and how to load skill reference files on-demand, preventing unnecessary context expansion while ensuring references are available when needed.

## Acceptance Criteria

- [ ] Given the `skills/using-skills/SKILL.md`, when I read the new "Efficient Skill Loading" section, then it describes a 2-phase workflow: Discovery Phase (identify skill, read SKILL.md, start working) and Deep Dive Phase (load references only when needed).
- [ ] Given the section's "What NOT to Do" guidance, when I read it, then it explicitly discourages pre-loading all references, reading multiple full skills, and re-reading skills.
- [ ] Given the section's "What TO Do" guidance, when I read it, then it explicitly encourages reading skills on-demand, loading references only for specific scenarios, and trusting memory within a session.
- [ ] Given a step-by-step example (e.g., "Implementing a Feature"), when I follow it, then I see the workflow: identify skill → read core → start work → hit edge case → load reference → continue work.
- [ ] Given the guidance, when an agent follows it, then it loads skills/references minimally and completes tasks without unnecessarily expanding context.

## Key Files

- `skills/using-skills/SKILL.md` — Skill selection and usage guidance; will contain the new efficient loading section

## Task Breakdown

1. [ ] Review existing `using-skills/SKILL.md` structure ← CURRENT
2. [ ] Design 2-phase workflow (Discovery + Deep Dive)
3. [ ] Write "What NOT to Do" anti-patterns
4. [ ] Write "What TO Do" best practices
5. [ ] Create concrete example workflow (e.g., feature implementation)
6. [ ] Verify all acceptance criteria met

## Decisions

*No decisions recorded yet.*

## Progress Log

- **2026-07-10 (11:54):** Task MKT-0006 created from Trello. Depends on MKT-0001 (sidecar pattern).

## Blockers

*No blockers currently identified.*
