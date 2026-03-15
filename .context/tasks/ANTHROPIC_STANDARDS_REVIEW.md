# Agentless Conversion Plan: Review Against Anthropic Standards

## Executive Summary

**Status:** ✅ Plan aligns well with Anthropic's latest standards

The agentless conversion plan follows Anthropic's core principles and direction. However, there are **3 important areas for enhancement** to fully align with Anthropic 2026 standards:

1. **Skills standardization** — Current agent system should evolve toward Anthropic's Skills architecture
2. **Prompt engineering best practices** — Patterns need explicit prompt engineering guidance
3. **Agent SDK integration** — Consider modernizing to use Anthropic's Agent SDK where applicable

---

## Anthropic Standards Review (March 2026)

### A. Agent Skills Architecture

**Anthropic's Latest Guidance:**
- Agent Skills are the **primary way** to extend Claude with specialized capabilities
- Skills use progressive disclosure: metadata loaded always (~100 tokens), full instructions loaded when needed, resources loaded on-demand
- Skills must be **concise, testable, and filesystem-based**
- Skills benefit from gerund naming (e.g., `planning`, `researching`, `testing`)

**Current Plan Assessment:** ✅ **Mostly aligned, with opportunities**

The plan proposes converting agents to patterns, which is conceptually correct. However:

**Recommendation 1:** Evolve patterns toward Agent Skills architecture
- Instead of just markdown patterns, structure them as **SKILL.md files**
- Follow Anthropic's three-level loading: metadata (always) → instructions (on-trigger) → resources (on-demand)
- This makes patterns discoverable, composable, and efficient

**Actionable Change:**
- Phase 2 should create `patterns/` as an Agent Skills directory
- Each pattern becomes a proper SKILL.md with frontmatter, instructions, and optional resources
- Naming: `planning-tasks` (gerund), `researching-options`, `testing-code`, `implementing-features`, `deciding-architecture`

### B. Prompt Engineering Best Practices

**Anthropic's Latest Guidance (Claude Prompting Best Practices):**
1. **Be clear and direct** — Claude is a new employee; explicitly state what you want
2. **Add context to improve performance** — Explain the "why" behind instructions
3. **Use examples effectively** — 3–5 well-crafted examples dramatically improve accuracy
4. **XML tags for structure** — Use XML (`<instructions>`, `<context>`, `<examples>`, `<output>`) for clarity
5. **Long context at the top** — When using large documents/context, place data before queries
6. **Give Claude a role** — Set a role in system prompt to focus behavior
7. **Concise self-knowledge** — Clara's communication style is now more direct, less verbose

**Current Plan Assessment:** ✅ **Aligned, but needs strengthening**

The plan assumes simplicity but doesn't explicitly guide on prompt engineering. Patterns need:

**Recommendation 2:** Add explicit prompt engineering guidance to each pattern
- Each pattern (SKILL.md) should include:
  - **Clear role definition** — What is this pattern trying to accomplish?
  - **XML-structured instructions** — Clear, unambiguous guidelines
  - **3–5 real examples** — Concrete inputs/outputs from actual use
  - **Conciseness principle** — Only context Claude doesn't already have
  - **Degrees of freedom** — Specify when to give flexibility vs. exact instructions

**Actionable Change:**
- Phase 2 deliverables should include a **"Prompt Engineering Guide for Patterns"**
- Each pattern file should have a template structure:
  ```
  # Pattern: [Name]
  
  [Role & purpose]
  
  ## Instructions (XML-structured)
  <instructions>
    [Clear steps]
  </instructions>
  
  ## Examples
  <examples>
    <example>
      <input>[Real input]</input>
      <output>[Real output]</output>
    </example>
  </examples>
  
  ## Degrees of Freedom
  [Guidance on when to be flexible vs. specific]
  ```

### C. Agent SDK Integration

**Anthropic's Latest Guidance:**
- The **Agent SDK** (newly renamed from Claude Code SDK) is Anthropic's standard for building autonomous agents
- Supports Python and TypeScript
- Has built-in tools: file reading, command execution, code editing, web search
- Supports Skills, slash commands, memory (CLAUDE.md), and plugins
- Progressive disclosure and context management built-in
- Agentic loop: evaluate → tool call → result → repeat

**Current Plan Assessment:** ⚠️ **Not explicitly addressed**

The plan doesn't mention the Agent SDK, which is now central to Anthropic's agent architecture.

**Recommendation 3:** Consider Agent SDK as Phase 8 (optional) or Phase 7 extension
- Don't force it into the agentless conversion
- But document how patterns could be **wrapped as Agent SDK agents** for users who want autonomous execution
- Recognize that some workflows (feature implementation, testing) are better served by Agent SDK than static patterns

**Actionable Change:**
- Add a **Phase 8 (Optional): Agent SDK Integration** that documents:
  - How each pattern can become an Agent SDK skill
  - Which patterns benefit from autonomous execution
  - When to stay "agentless" (human-interactive) vs. agentic (autonomous)
  - Example: Implementation pattern could be agentless (guide user) or agentic (actually write code)

---

## Detailed Standards Alignment

### 1. Conciseness (Core Principle)

**Anthropic Says:** "The context window is a public good. Only add context Claude doesn't already have."

**Current Plan:** ✅ Aligns — Promises simpler patterns over complex agents
**Enhancement Needed:** Verify patterns follow the "conciseness test" in Phase 6 validation

**Action:** Add to Phase 6 validation: Test each pattern with conciseness checklist
- Does each pattern include only necessary context?
- Can any paragraph be cut without losing meaning?
- Does the pattern assume Claude's general knowledge appropriately?

### 2. Testing with Multiple Models

**Anthropic Says:** Skills must work with Haiku, Sonnet, and Opus — each has different needs.

**Current Plan:** ⚠️ Not explicitly addressed
**Enhancement Needed:** Ensure Phase 6 tests patterns across models

**Action:** Update Phase 6 validation:
- Test each pattern with Claude Haiku (needs more guidance), Sonnet (balanced), Opus (avoid over-explaining)
- Patterns should work with all three; if they don't, refine for the weakest model

### 3. XML Structuring

**Anthropic Says:** Use XML tags (`<instructions>`, `<context>`, `<examples>`, `<output>`) for unambiguous parsing.

**Current Plan:** ⚠️ Agents use XML in handoff protocol, but patterns don't explicitly mandate it
**Enhancement Needed:** Patterns should use XML structure

**Action:** Add to Phase 2:
- Create pattern template with XML structure
- `<instructions>` for steps
- `<examples>` for input/output pairs
- `<context>` for background knowledge
- `<output>` for expected results

### 4. Progressive Disclosure (Skills Architecture)

**Anthropic Says:** Load metadata first (~100 tokens), instructions on-demand, resources as-needed.

**Current Plan:** Partially aligned (patterns are lightweight), but doesn't explicitly use Skills structure
**Enhancement Needed:** Formalize as Agent Skills

**Action:** Phase 2 should create Skills directory with SKILL.md files for each pattern

### 5. Gerund Naming

**Anthropic Says:** Use gerund form (verb + -ing) for skill names: `processing-pdfs`, `analyzing-spreadsheets`

**Current Plan:** Uses agent role names (Planner, Researcher), not gerunds
**Enhancement Needed:** Rename patterns to gerund form

**Action:** Update phase 2 deliverables:
- `planner-agent` → `planning-tasks`
- `researcher-agent` → `researching-options`
- `architect-agent` → `deciding-architecture`
- `coder-agent` → `implementing-features`
- `tester-agent` → `testing-code`
- `manager-agent` → `coordinating-workflows` (lightweight, optional)

### 6. Degrees of Freedom

**Anthropic Says:** Match specificity to task fragility:
- High freedom (text guidance) when multiple approaches valid
- Medium freedom (pseudocode) when pattern exists but variation ok
- Low freedom (exact scripts) when fragile/critical

**Current Plan:** ⚠️ Doesn't explicitly discuss this
**Enhancement Needed:** Each pattern should specify degrees of freedom

**Action:** Add to Phase 2 pattern template:
- Specify degree of freedom (high/medium/low) for each pattern
- Example: Planning pattern = high freedom (many valid approaches)
- Example: Testing pattern = medium freedom (structure exists, but tests vary)
- Example: Architecture pattern = low-medium (should follow org standards)

### 7. Real Examples

**Anthropic Says:** 3–5 well-crafted examples improve accuracy dramatically; make them diverse and relevant.

**Current Plan:** Phase 4 promises "examples of each pattern," but doesn't commit to 3–5 per pattern
**Enhancement Needed:** Ensure each pattern has minimum 3–5 real, diverse examples

**Action:** Strengthen Phase 4 (Quick-Start Guides):
- Each pattern should include 3–5 real examples
- Examples should cover edge cases and variety
- Examples should be actual tasks from agent-defs repo history

---

## Summary of Enhancements

### High Priority (Core Anthropic Standards)

| Area | Current | Enhancement | Phase |
|---|---|---|---|
| **Skills Architecture** | Markdown patterns | Formalize as SKILL.md with progressive disclosure | Phase 2 |
| **Prompt Engineering** | General guidance only | Add XML structure, examples, degrees of freedom template | Phase 2 |
| **Naming Convention** | Agent role names | Switch to gerund form (e.g., `planning-tasks`) | Phase 2 |
| **Examples** | Promised but not detailed | Commit to 3–5 diverse, real examples per pattern | Phase 4 |
| **Model Testing** | Not mentioned | Test patterns with Haiku, Sonnet, Opus | Phase 6 |

### Medium Priority (Modernization)

| Area | Current | Enhancement | Phase |
|---|---|---|---|
| **Conciseness Validation** | Assumed | Add explicit conciseness checklist to validation | Phase 6 |
| **Degrees of Freedom** | Not discussed | Specify for each pattern (high/medium/low) | Phase 2 |
| **XML Structuring** | Used in handoffs | Standardize in all patterns | Phase 2 |
| **Context Window Efficiency** | Assumed | Document progressive disclosure strategy | Phase 3 |

### Low Priority (Optional Future)

| Area | Current | Enhancement | Phase |
|---|---|---|---|
| **Agent SDK Integration** | Not mentioned | Consider Phase 8 (optional): Show how patterns wrap as Agent SDK skills | Phase 7+ |
| **Autonomous Execution** | Not discussed | Document when patterns should be agentic vs. agentless | Phase 8 |
| **Composable Skills** | Mentioned generally | Deep dive on skill composition patterns | Phase 4 |

---

## Specific Updates to Plan Documents

### 1. Update AGENTLESS_CONVERSION_PLAN.md

**Phase 2 (Extract Core Patterns):**

Add new task:
```
- Formalize patterns as Agent Skills (SKILL.md)
  Each pattern becomes a proper SKILL.md with:
  • YAML frontmatter (name, description)
  • Concise instructions body (<1000 tokens)
  • XML-structured guidance (<instructions>, <examples>, <context>)
  • 3–5 real, diverse examples
  • Degrees of freedom specification (high/medium/low)
  • Optional resource files (templates, scripts)
```

**Phase 6 (Validation):**

Add validation criteria:
```
- Test patterns across models: Haiku, Sonnet, Opus
- Validate conciseness: Does each pattern pass the "unnecessary context" test?
- Check prompt engineering: Are examples diverse? Are XML tags clear?
- Verify naming: Are patterns using gerund form?
- Test degrees of freedom: Is flexibility appropriate for each pattern?
```

**Phase 7 (Migration):**

Add note:
```
- Optional Phase 8: Document how patterns wrap as Agent SDK skills
  (for teams wanting autonomous execution in addition to agentless patterns)
```

### 2. Add New Phase 2 Template: Pattern Structure

Create `.context/tasks/PATTERN_TEMPLATE.md`:

```markdown
# Pattern Template (Follows Anthropic Standards)

## SKILL.md Structure

\`\`\`yaml
---
name: pattern-name           # gerund form, lowercase, hyphens only
description: One sentence describing what and when to use
---
\`\`\`

## Instructions (XML-Structured)

<instructions>
[Clear, concise steps. Assume Claude is very smart.]
</instructions>

## Context (if needed)

<context>
[Background that Claude wouldn't know. Challenge each piece.]
</context>

## Examples (3–5 real, diverse examples)

<examples>
<example>
<input>
[Actual input/request]
</input>
<output>
[Expected output]
</output>
</example>
</examples>

## Degrees of Freedom

[High/Medium/Low: specify how much flexibility Claude has in approach]

## Resources (optional)

[Scripts, templates, reference materials loaded on-demand]
```

### 3. Create Naming Convention Document

Create `.context/tasks/PATTERN_NAMING.md`:

```markdown
# Pattern Naming (Follows Anthropic Standards)

Use gerund form (verb + -ing) for pattern names:

- planning-tasks (from Planner agent)
- researching-options (from Researcher agent)
- deciding-architecture (from Architect agent)
- implementing-features (from Coder agent)
- testing-code (from Tester agent)
- coordinating-workflows (from Manager agent, optional/lightweight)

Rationale: Gerunds describe the activity/capability clearly
```

---

## Alignment Matrix: Current Plan vs. Anthropic Standards

| Anthropic Standard | Plan Status | Gap | Phase to Fix |
|---|---|---|---|
| **Concise skill definitions** | ✅ Promised | Needs validation criteria | Phase 6 |
| **Progressive disclosure** | ⚠️ Partial | Formalize as SKILL.md structure | Phase 2 |
| **Skills architecture** | ⚠️ Partial | Use official SKILL.md format | Phase 2 |
| **Prompt engineering (XML, examples, role)** | ⚠️ General | Add pattern template with guidance | Phase 2 |
| **Testing across models (Haiku/Sonnet/Opus)** | ❌ Missing | Add to validation | Phase 6 |
| **Gerund naming** | ❌ Missing | Update pattern names | Phase 2 |
| **Degrees of freedom specification** | ⚠️ Partial | Formalize in pattern template | Phase 2 |
| **Real, diverse examples (3–5 per skill)** | ⚠️ Promised | Strengthen Phase 4 commitment | Phase 4 |
| **Context efficiency** | ✅ Aligned | No change needed | — |
| **Simplicity first principle** | ✅ Aligned | No change needed | — |
| **Human checkpoints** | ✅ Aligned | No change needed | — |

---

## Key Takeaways

### What's Good (No Changes Needed)
✅ Simplicity-first philosophy aligns with Anthropic's "simpler is better"  
✅ Agentless approach aligns with Anthropic's move toward composable patterns  
✅ Phased, validated approach aligns with Anthropic's "test with real usage"  
✅ Context management strategy aligns with Anthropic's progressive disclosure  

### What Needs Attention (Enhancements)

1. **Formalize patterns as Agent Skills** (SKILL.md format)
2. **Add prompt engineering guidance** (XML structure, examples, degrees of freedom)
3. **Switch to gerund naming** (e.g., `planning-tasks` not `planner`)
4. **Test across all models** (Haiku, Sonnet, Opus)
5. **Commit to 3–5 real examples per pattern** (not just 1–2)
6. **Validate conciseness** (use Anthropic's "unnecessary context" test)

### Timeline
All enhancements fit within existing phases (mostly Phase 2 & 4). No timeline changes needed.

---

## Next Steps

1. **Review this assessment** with team
2. **Decide on enhancement adoption:**
   - High priority (Skills, prompt engineering, naming): Strongly recommend
   - Medium priority (Model testing, conciseness validation): Recommended
   - Low priority (Agent SDK integration): Optional future work
3. **Update plan documents** with enhancements before Phase 1
4. **Proceed with Phase 1** using enhanced plan

The plan is fundamentally sound and aligns with Anthropic's direction. These enhancements make it even more aligned and production-ready.
