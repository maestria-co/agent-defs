# Anthropic Standards: Enhancement Recommendations

## Quick Summary

Your agentless conversion plan is **fundamentally aligned** with Anthropic's latest standards and direction. Three key areas can be enhanced to maximize alignment:

---

## 1. Formalize Patterns as Agent Skills (SKILL.md)

### What Anthropic Says
Agent Skills are the standard way to extend Claude with specialized capabilities. They use:
- **YAML frontmatter** with name and description (always loaded, ~100 tokens)
- **Instructions body** with procedural knowledge (loaded when triggered)
- **Optional resources** like scripts/templates (loaded on-demand)

### Current Plan
Patterns are planned as markdown files without formal Skills structure.

### Recommendation
Update **Phase 2 (Extract Core Patterns)** to:
1. Create patterns as proper **SKILL.md files** with YAML frontmatter
2. Use gerund naming: `planning-tasks`, `researching-options`, `testing-code`, etc.
3. Structure instructions with XML tags: `<instructions>`, `<examples>`, `<context>`, `<output>`
4. Keep patterns concise (challenge: "Does Claude need this?")
5. Bundle optional resources (templates, example scripts)

**Impact:** Patterns become discoverable, composable, and follow Anthropic's standard architecture.

**Effort:** Minimal — just adds frontmatter and XML structure to existing patterns

---

## 2. Add Prompt Engineering Best Practices to Patterns

### What Anthropic Says
Effective prompts follow:
- **Clear role definition** (what is this pattern trying to do?)
- **XML-structured instructions** (unambiguous parsing)
- **3–5 real, diverse examples** (dramatically improves accuracy)
- **Degrees of freedom** (specify flexibility vs. exactness)
- **Conciseness** (only context Claude doesn't already have)

### Current Plan
Patterns promise guidance but don't specify structure or examples.

### Recommendation
Create a **Pattern Template** for Phase 2 that includes:

```yaml
---
name: pattern-name              # gerund form: planning-tasks
description: What and when to use this pattern
---

## Instructions
<instructions>
[Clear steps. Assume Claude is smart.]
</instructions>

## Role & Context
[Set role, add only context Claude wouldn't know]

## Examples (3–5, diverse)
<examples>
<example>
<input>Real input</input>
<output>Expected output</output>
</example>
</examples>

## Degrees of Freedom
[High/Medium/Low: flexibility guidance]
```

**Impact:** Patterns become more consistent, examples improve accuracy, output is more predictable

**Effort:** Moderate — requires gathering 3–5 real examples per pattern, but pays off in quality

---

## 3. Test Patterns Across Models (Haiku, Sonnet, Opus)

### What Anthropic Says
Skills must work across Claude Haiku (needs more detail), Sonnet (balanced), and Opus (avoid over-explaining). If they don't, refine for the weakest model.

### Current Plan
Phase 6 validation doesn't specify cross-model testing.

### Recommendation
Update **Phase 6 (Validation)** to test each pattern with:
- **Claude Haiku** (3.5-sonnet equivalent: Does pattern provide enough guidance?)
- **Claude Sonnet** (balanced: Is pattern clear and efficient?)
- **Claude Opus** (most capable: Does pattern avoid over-explaining?)

**Success criteria:** Pattern works well with all three; if not, refine for Haiku compatibility.

**Impact:** Patterns work reliably across user's tool choices, future-proof for model changes

**Effort:** Low — just run same test prompt with three model configs

---

## Recommended Phasing for Enhancements

| Enhancement | Phase | Effort | Impact |
|---|---|---|---|
| **Formalize as SKILL.md** | 2 | Low | High (foundational) |
| **Gerund naming** | 2 | Low | Medium (better UX) |
| **Add prompt engineering template** | 2 | Medium | High (better outputs) |
| **Gather 3–5 real examples** | 4 | Medium | High (proof of concept) |
| **Add conciseness validation** | 6 | Low | Medium (future quality) |
| **Test across models** | 6 | Low | High (reliability) |

**Total effort:** ~1–2 additional days across phases 2, 4, and 6

---

## Files to Create/Update

### New Files
- `.context/tasks/PATTERN_TEMPLATE.md` — Template for all patterns (SKILL.md format)
- `.context/tasks/PATTERN_NAMING.md` — Naming convention (gerund form)
- `.context/tasks/PROMPT_ENGINEERING_GUIDE.md` — Pattern-specific guidance

### Updated Files
- `AGENTLESS_CONVERSION_PLAN.md` — Add Phase 2 and Phase 6 enhancements
- `VISUAL_ROADMAP.md` — Show SKILL.md structure in Phase 2 output

---

## Alignment Summary

| Standard | Status | Change |
|---|---|---|
| Conciseness-first | ✅ Aligned | No change |
| Simplicity over complexity | ✅ Aligned | No change |
| Progressive disclosure | ⚠️ Partial | Formalize as SKILL.md |
| Prompt engineering best practices | ⚠️ General | Add template & examples |
| Skills architecture | ⚠️ Partial | Use official format |
| Model cross-testing | ❌ Missing | Add to Phase 6 |
| Gerund naming | ❌ Missing | Rename patterns |
| Real examples (3–5) | ⚠️ Promised | Strengthen Phase 4 |

---

## Why These Enhancements Matter

1. **Aligns with Anthropic's direction:** Skills architecture is how Anthropic is building agents
2. **Improves discoverability:** Proper SKILL.md format works with Anthropic's skill discovery
3. **Future-proofs:** If agent-defs becomes an agent system later, patterns are already Skills-ready
4. **Improves outputs:** Prompt engineering best practices (examples, XML, degrees of freedom) directly improve pattern quality
5. **Builds confidence:** Testing across models proves patterns work reliably
6. **No timeline impact:** All enhancements fit within existing phases

---

## Decision: Adopt Enhancements?

### Recommend: YES

**Why:**
- Minimal effort (1–2 days total)
- High impact (foundation for Skills ecosystem)
- No timeline changes
- Directly aligns with Anthropic's published standards
- Makes patterns future-compatible with Agent SDK and Skills architecture

### How to Proceed

1. **Approve enhancements** — This document
2. **Update Phase 2** — Add SKILL.md structure, gerund naming, prompt engineering template
3. **Create supporting docs** — PATTERN_TEMPLATE.md, PATTERN_NAMING.md
4. **Proceed with Phase 1** — Using enhanced plan
5. **Gather examples in Phase 4** — Ensure 3–5 real examples per pattern
6. **Validate cross-model in Phase 6** — Test with Haiku, Sonnet, Opus

---

## Questions?

See **ANTHROPIC_STANDARDS_REVIEW.md** for detailed analysis with examples and citations.
