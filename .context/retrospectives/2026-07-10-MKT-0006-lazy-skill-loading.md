# 2026-07-10 — MKT-0006: Lazy Skill Loading Guidance

## What Went Well

- **Single focused addition**: Task required one well-scoped section (73 lines) in one file. Clear requirements meant fast execution (< 15 minutes from start to verification).
- **Concrete example with phase annotations**: The implementing-features workflow example uses inline `← Discovery Phase` / `← Deep Dive Phase` labels that make the decision point visible without extra prose. Agents can pattern-match this structure.
- **Anti-patterns paired with best practices**: "What NOT to Do" and "What TO Do" as sibling subsections create scannable contrast. Matching the existing tone (direct, imperative) kept it consistent with the rest of using-skills/SKILL.md.

## What Could Be Improved

- **No research phase**: Assumed skill structure from MKT-0001 context without verifying how many skills actually use `references/` folders. Quick `find skills/ -type d -name references` would have confirmed the pattern is established (5 skills found post-commit). → Always validate assumptions with one grep/find before designing guidance.
- **Example uses non-existent reference**: Workflow mentions `commit-discipline/references/` which doesn't exist yet. Should have checked actual reference file paths before using them in examples. → Verify example file paths exist before committing.

## Lessons Learned

- **Small documentation tasks benefit from tight scope**: MKT-0006 had clear acceptance criteria and a single-file change. No planning phase needed — straight to implementation. Contrast with MKT-0005 where scope expanded 3x through user questions.
- **Phase annotations in code blocks**: Inline `← Phase Name` comments in example workflows make the decision point explicit without requiring agents to infer it from context. Reusable pattern for other procedural guidance.
- **Decision-point questions**: "Can I continue without this reference?" embedded in the example workflow is an executable heuristic. Agents can literally ask themselves this question. More effective than abstract guidance like "load references judiciously."

## Promotion Items

- [ ] "Phase annotations in code blocks" pattern → promote to `.context/standards.md` under documentation examples
- [ ] "Decision-point questions" technique → promote to `skills/writing-skills/` as a best practice for procedural guidance
- [ ] Cross-reference validation → promote to `.context/standards.md`: "verify example file paths exist before using them in documentation"
