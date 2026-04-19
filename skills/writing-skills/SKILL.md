---
name: writing-skills
description: Use when creating a new skill, editing an existing skill, or helping a user author a skill for this system. Covers structure, discoverability, quality, and discipline hardening.
user-invocable: true
---

# Writing Skills

## Overview

**Writing skills is TDD applied to process documentation.** You identify failure modes (what agents get wrong without guidance), write the skill to address those specific failures, and verify agents now comply.

**Core principle:** If you haven't seen an agent fail without the skill, you don't know what the skill needs to teach.

## When to Create a Skill

**Create when:**
- A technique wasn't intuitively obvious — you or an agent got it wrong first
- You'd reference this again across projects
- The pattern applies broadly (not project-specific)
- Others would benefit from the encoded process

**Don't create for:**
- One-off solutions to a specific problem
- Standard practices well-documented elsewhere
- Project-specific conventions (put in `.context/standards/` instead)
- Mechanical constraints enforceable with linting/validation — automate those, save skills for judgment calls

## Skill Types

| Type | Description | Examples |
|------|-------------|---------|
| **Technique** | Concrete method with steps | `systematic-debugging`, `initialize-repo` |
| **Discipline** | Rules that prevent known failure modes | `testing-discipline`, `verification-checklist` |
| **Process** | Workflow with decision points | `task-retrospective`, `design-first` |
| **Format** | Output templates with structure guidance | `jira-story`, `asana-story` |

## Directory Structure

```
skills/
  skill-name/
    SKILL.md              # Main reference (required)
    supporting-file.*     # Only if needed (heavy reference, reusable tools)
```

**Keep inline:** Principles, concepts, code patterns under 50 lines, examples.
**Separate files for:** Heavy reference (100+ lines), reusable scripts/templates.

## SKILL.md Structure

### Frontmatter (YAML)

```yaml
---
name: skill-name-with-hyphens
description: Use when [specific triggering conditions and symptoms]
---
```

- **`name`**: Letters, numbers, hyphens only. Verb-first gerunds work well (`writing-skills`, `executing-plans`).
- **`description`**: Third-person. Starts with "Use when..." Describes ONLY triggering conditions — NOT what the skill does or its workflow.

**Why description must not summarize workflow:** If a description says "dispatches subagent per task with code review between tasks," agents may follow that summary instead of reading the full skill. Descriptions that summarize workflow create shortcuts that bypass the actual process. Describe the PROBLEM or TRIGGER, not the SOLUTION.

```yaml
# ❌ BAD: Summarizes workflow — agent may follow this instead of reading skill
description: Use for TDD - write test first, watch it fail, write minimal code, refactor

# ✅ GOOD: Triggering conditions only — agent must read skill for process
description: Use when writing tests, reviewing test quality, or deciding what to mock
```

### Body Structure

```markdown
# Skill Name

## Overview
Core principle in 1-2 sentences. What is this and why does it matter?

## When to Use
Bullet list of symptoms and situations.
When NOT to use.

## The Process (or Core Pattern)
The actual technique, steps, or rules.
Before/after comparisons for techniques.

## Common Mistakes
What goes wrong and how to fix it.

## Rationalization Prevention (for discipline skills)
Table of excuses agents make and why they're wrong.
```

Not every skill needs every section. Scale to complexity — a simple technique skill might be 40 lines; a discipline skill might be 150.

**Step and Phase heading format** — When a skill defines a numbered process, prefix every step or phase heading with the skill name:

```markdown
## skill-name: Step 1: Do Something       ← correct
## skill-name: Phase 2: Verify            ← correct
## Step 1: Do Something                   ← wrong — agent cannot tell which skill this belongs to
```

When a skill has sub-processes (stages that contain steps), include both the stage and step identifiers in every heading:

```markdown
## skill-name: Stage 1: Prepare
### skill-name: Stage 1: Step 1: Do X     ← correct — full path preserved
### skill-name: Stage 1: Step 2: Do Y     ← correct
## skill-name: Stage 2: Execute
### skill-name: Stage 2: Step 1: Do Z     ← correct

### Stage 1: Step 1: Do X                 ← wrong — missing skill name
### skill-name: Step 1: Do X              ← wrong — ambiguous which stage
```

The full path (`skill-name: Stage N: Step N`) ensures an agent reading a heading in isolation can always determine which skill, which stage, and which step it is at — without needing to scroll back for context.

## Discoverability

Future agents find your skill through description matching. Optimize for discovery:

**1. Rich description field** — Include symptoms, error patterns, and contexts that would trigger use.

**2. Keyword coverage** — Use words agents would search for: error messages, symptoms ("flaky", "timeout", "race condition"), tool names, synonyms.

**3. Descriptive naming** — Verb-first, active voice:
- ✅ `commit-discipline` not `git-commit-guidelines`
- ✅ `design-first` not `pre-implementation-review`
- ✅ `context-maintenance` not `context-directory-updates`

**4. Register the skill** — After creating a skill, add it to the routing table in `skills/GUIDE.md` and the skills list in `README.md`. If the skill participates in multi-skill sequences, add it to the common workflows table in `skills/using-skills/SKILL.md`.

## Token Efficiency

Skills load into context on demand. Every word costs tokens.

**Targets:**
- Frequently-loaded skills: aim for < 200 words
- Standard skills: aim for < 500 words
- Complex discipline skills: can go longer, but earn every line

**Techniques:**
- Cross-reference other skills instead of repeating their content
- One excellent example beats three mediocre ones
- Compress examples — show the pattern, not the novel
- Eliminate redundancy — don't explain what's obvious from context

## Writing Discipline Skills

Discipline skills (rules that prevent failure modes) need extra hardening because agents rationalize away rules under pressure.

### 1. Close Every Loophole

Don't just state the rule — forbid specific workarounds:

```markdown
# ❌ Incomplete
Write code before test? Delete it.

# ✅ Bulletproof
Write code before test? Delete it. Start over.
**No exceptions:**
- Don't keep it as "reference"
- Don't "adapt" it while running tests
- Delete means delete
```

### 2. Build a Rationalization Table

Capture the excuses agents make and counter each one:

```markdown
| Excuse | Reality |
|--------|---------|
| "Too simple to test" | Simple code breaks. Test takes 30 seconds. |
| "I already know it works" | Show the evidence. |
| "I'll test after" | Tests-after prove nothing about intent. |
```

### 3. Create Red Flags

Self-check list for recognizing when you're about to violate the rule:

```markdown
## Red Flags — STOP
- "This is different because..."
- "I'll come back and do this later"
- "It's about the spirit, not the letter"
All of these mean: follow the process.
```

## Code Examples in Skills

**One excellent example beats many mediocre ones.** Choose the most relevant language for the technique. Don't implement in 5 languages.

**Good examples are:**
- Complete and runnable
- Commented explaining WHY (not what)
- From realistic scenarios
- Ready to adapt

**Avoid:**
- Fill-in-the-blank templates
- Contrived examples that don't match real use
- Multi-language dilution

## Quality Checklist

Before considering a skill complete:

- [ ] Name uses only letters, numbers, hyphens
- [ ] Description starts with "Use when..." and includes specific triggers
- [ ] Description does NOT summarize the skill's workflow
- [ ] Overview states core principle in 1-2 sentences
- [ ] Content addresses specific failure modes (not hypothetical ones)
- [ ] Discipline skills have rationalization prevention
- [ ] Examples are concrete, not generic
- [ ] Token-efficient — every line earns its place
- [ ] Added to `skills/GUIDE.md` routing table
- [ ] Added to `README.md` skills list
- [ ] Added to `using-skills` common workflows table if the skill participates in multi-skill sequences

## Anti-Patterns

| Anti-Pattern | Why It's Wrong |
|-------------|---------------|
| **Narrative storytelling** ("In session X, we found...") | Too specific, not reusable. State the technique. |
| **Multi-language examples** | Mediocre quality, maintenance burden. One great example. |
| **Generic labels** (step1, helper2) | Labels should have semantic meaning. |
| **Copying other skills' content** | Cross-reference instead. Save tokens. |
| **"Obviously clear" without testing** | Clear to you ≠ clear to agents. Verify. |
