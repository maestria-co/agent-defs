# Phase 2 Enhanced: Extract Core Patterns (Anthropic Standards)

## Updated Phase 2 Overview

**Goal:** Extract patterns as Agent Skills, following Anthropic's latest standards for conciseness, prompt engineering, and skill architecture.

**Key Changes from Original:**
1. Patterns become proper **SKILL.md files** (not just markdown)
2. Use **gerund naming** (`planning-tasks`, not `planner`)
3. Structure with **XML tags** (`<instructions>`, `<examples>`, `<context>`)
4. Include **degrees of freedom** specification
5. Plan for **3–5 real examples** (to be gathered in Phase 4)

---

## New Phase 2 Structure

### Task 2.1: Set Up Skills Directory

Create `.context/patterns/` as an Agent Skills directory:

```
.context/patterns/
├── README.md                    (How to use these patterns/skills)
├── _shared/
│   ├── CONVENTIONS.md           (Shared rules for all patterns)
│   └── TEMPLATE.md              (Pattern/SKILL template)
├── planning-tasks/
│   ├── SKILL.md                 (Skill definition + instructions)
│   ├── examples.md              (3–5 real examples, loaded on-demand)
│   └── templates/
│       └── task-breakdown.md    (Optional resource)
├── researching-options/
├── deciding-architecture/
├── implementing-features/
├── testing-code/
└── coordinating-workflows/      (Lightweight, optional)
```

**Key Insight:** Skills can have multiple files. Only SKILL.md and metadata are loaded by default. Examples and templates load on-demand.

---

## New Phase 2 Tasks

### Task 2.1: Create Skills Directory Structure ✓

**What:** Set up proper directory structure for Agent Skills

**Output:**
- `.context/patterns/README.md` — Explains the patterns/skills, how to use them
- `.context/patterns/_shared/TEMPLATE.md` — Template for all pattern SKILL.md files
- `.context/patterns/_shared/CONVENTIONS.md` — Shared rules (conciseness, XML, degrees of freedom)

**Skill.md Template:**

```yaml
---
name: pattern-name
description: One sentence: what this pattern does and when to use it. Max 1024 chars.
---

# [Pattern Title]

## What This Pattern Does

[1–2 sentences explaining the pattern and when Claude should use it]

## Instructions

<instructions>
1. [Clear step]
2. [Clear step]
3. [Clear step]

[Assumption: Claude is very smart. Only add context Claude doesn't already have.]
</instructions>

## Context

<context>
[Background knowledge only if Claude wouldn't know it. Challenge each piece:
- "Does Claude really need this?"
- "Can I assume Claude knows this?"]
</context>

## Examples

<examples>
<example>
<input>
[Real input/request using this pattern]
</input>
<output>
[Expected output/result]
</output>
</example>
</examples>

## Degrees of Freedom

[Specify: High / Medium / Low]

- **High:** [Many valid approaches; Claude has flexibility]
- **Medium:** [A pattern exists, but some variation is ok]
- **Low:** [Specific sequence required; less flexibility]

## Optional Resources

- `examples.md` — Additional real-world examples
- `templates/` — Reusable templates (loaded on-demand)
- `scripts/` — Executable utilities (loaded on-demand)
```

---

### Task 2.2: Extract & Write Planning-Tasks Skill

**From:** Planner agent  
**To:** `patterns/planning-tasks/SKILL.md`

**Template (Filled):**

```yaml
---
name: planning-tasks
description: Break a goal into ordered tasks with clear dependencies and success criteria.
---

# Planning Tasks Pattern

## What This Pattern Does

Takes a goal or requirement and produces a structured task list with dependencies, sequencing, and completion criteria. Use when you need to break complex work into manageable pieces.

## Instructions

<instructions>
1. **Understand the goal** — What's the end state? What problem does it solve?
2. **Identify discrete tasks** — What are the concrete, independent units of work?
3. **Order them logically** — Which must come first? What has dependencies?
4. **Add success criteria** — How will you know each task is done?
5. **Note blockers** — Are there any unknowns or dependencies on external work?
6. **Output as ordered list** — One task per line with dependencies and criteria.

[Assumption: You understand task management. Only tell Claude what's specific to this goal.]
</instructions>

## Context

<context>
A task is a unit of work that:
- Can be completed independently (or with clear dependencies)
- Has a clear acceptance criterion
- Should take 1–3 work units (hours, days, phases)

Larger items are epics; smaller items are subtasks. Find the right granularity.
</context>

## Examples

<examples>
<example>
<input>
Goal: "Convert agent-defs from agents to patterns"
</input>
<output>
1. Analyze current system (depends on: none)
   - Success: All 6 agents documented, workflows mapped
2. Extract patterns (depends on: 1)
   - Success: 5 pattern SKILL.md files created
3. Update context (depends on: 2)
   - Success: .context/ structure updated
4. Create guides (depends on: 3)
   - Success: Quick-start and recipes written
5. Soft deprecation (depends on: 4)
   - Success: Agents marked legacy, migration guide created
6. Validate patterns (depends on: 5)
   - Success: Patterns tested, metrics collected
7. Complete migration (depends on: 6)
   - Success: Old system archived, docs reorganized
</output>
</example>

<example>
<input>
Goal: "Implement JWT authentication in Express.js backend"
</input>
<output>
1. Design auth flow (depends on: none)
   - Success: Auth sequence documented, endpoints defined
2. Create user model (depends on: 1)
   - Success: Schema in place, password hashing implemented
3. Implement login endpoint (depends on: 2)
   - Success: Login works, JWT issued, tests pass
4. Implement token refresh (depends on: 3)
   - Success: Refresh endpoint works, tests pass
5. Add middleware (depends on: 4)
   - Success: Protected routes require valid token
6. Write integration tests (depends on: 5)
   - Success: Full auth flow tested end-to-end
</output>
</example>
</examples>

## Degrees of Freedom

**High**

Many valid task orderings exist depending on project context. This pattern provides structure (dependencies, success criteria) but leaves the specific tasks and ordering to Claude's understanding of the goal.

## Optional Resources

See `examples.md` for additional real-world task breakdowns.
```

---

### Tasks 2.3–2.7: Extract Remaining Patterns

**Similar structure for:**
- `researching-options` — From Researcher agent
- `deciding-architecture` — From Architect agent
- `implementing-features` — From Coder agent
- `testing-code` — From Tester agent

**Each includes:**
- SKILL.md with name, description, instructions, context, examples, degrees of freedom
- Proper XML structure
- Real, diverse examples (to be gathered in Phase 4)

---

### Task 2.8: Extract Shared Conventions

**To:** `.context/patterns/_shared/CONVENTIONS.md`

Content (updated for Anthropic standards):

```markdown
# Patterns: Shared Conventions

All patterns follow these principles:

## Conciseness (Core)

The context window is shared with conversation history, system prompt, and other patterns.

- Assume Claude is very smart
- Only add context Claude doesn't already have
- Challenge each paragraph: "Does Claude need this?"
- Once loaded, every token competes with conversation history

## Clarity & Direction

- Be direct, not preamble-heavy
- State what you want explicitly
- Use XML tags for unambiguous parsing
- Show, don't tell (examples > explanations)

## XML Structure

All patterns use consistent tags:
- `<instructions>` — Clear, ordered steps
- `<context>` — Only necessary background
- `<examples>` — 3–5 diverse, real examples
- `<output>` — Expected result format

## Testing

Patterns must work across models:
- Claude Haiku (needs more guidance)
- Claude Sonnet (balanced)
- Claude Opus (avoid over-explaining)

If a pattern doesn't work with Haiku, refine it. The weakest model drives clarity.

## Examples

Each pattern includes 3–5 real, diverse examples showing:
- Varied input complexity
- Edge cases where appropriate
- Expected output format
- How the pattern handles ambiguity

## Degrees of Freedom

Specify for each pattern:
- **High:** Many valid approaches; flexibility ok
- **Medium:** Pattern exists, but variation acceptable
- **Low:** Specific sequence required; precision critical

Match to the task's fragility and variability.

## When to Use Patterns

Each pattern is independent. For complex work, combine patterns:
- Planning first (break goal into tasks)
- Researching (if evaluating options)
- Deciding (if making architecture choices)
- Implementing (write code)
- Testing (validate)

No routing agent needed. Just ask for the patterns you need.
```

---

### Task 2.9: Create Pattern Composition Guide

**To:** `.context/patterns/GUIDE.md`

Example content:

```markdown
# Pattern Composition Guide

## Single-Pattern Tasks

### Use Planning-Tasks
- "Break this project into tasks"
- "What should I work on first?"
- "Scope this feature"

### Use Researching-Options
- "Compare X, Y, Z approaches"
- "Should we use A or B?"
- "What are the tradeoffs?"

### Use Deciding-Architecture
- "Design the auth system"
- "Should this be microservices?"
- "Write an ADR for this decision"

### Use Implementing-Features
- "Write a function that..."
- "Implement the login endpoint"
- "Refactor this code"

### Use Testing-Code
- "Write tests for this"
- "Is this implementation solid?"
- "What edge cases am I missing?"

## Multi-Pattern Workflows

### Feature Implementation
1. Planning-Tasks: "Break this feature into tasks"
2. Researching-Options (if needed): "Compare approaches"
3. Deciding-Architecture: "Design any new components"
4. Implementing-Features: "Code the feature"
5. Testing-Code: "Test it thoroughly"

### Architecture Decision
1. Researching-Options: "Compare approaches"
2. Deciding-Architecture: "Design the solution, write ADR"
3. Planning-Tasks: "Plan the rollout/implementation"
4. Implementing-Features: "Code the changes"
5. Testing-Code: "Validate"

### Debugging/Investigation
1. Planning-Tasks: "What do I need to check?"
2. Implementing-Features: "Instrument/inspect code"
3. Testing-Code: "Write tests to validate fix"
```

---

### Task 2.10: Create Examples Document

**To:** `.context/patterns/EXAMPLES.md`

Content: Real examples from agent-defs conversions

Each pattern includes 3–5 real, diverse examples showing actual input/output.

---

## Phase 2 Deliverables (Updated)

✓ `.context/patterns/README.md` — Pattern system overview  
✓ `.context/patterns/_shared/TEMPLATE.md` — Pattern SKILL.md template  
✓ `.context/patterns/_shared/CONVENTIONS.md` — Shared rules (Anthropic-aligned)  
✓ `.context/patterns/planning-tasks/SKILL.md` — Pattern 1  
✓ `.context/patterns/researching-options/SKILL.md` — Pattern 2  
✓ `.context/patterns/deciding-architecture/SKILL.md` — Pattern 3  
✓ `.context/patterns/implementing-features/SKILL.md` — Pattern 4  
✓ `.context/patterns/testing-code/SKILL.md` — Pattern 5  
✓ `.context/patterns/coordinating-workflows/SKILL.md` — Optional light pattern  
✓ `.context/patterns/GUIDE.md` — When to use each pattern, composition guide  
✓ `.context/patterns/EXAMPLES.md` — Real examples for each pattern  

## Success Criteria (Updated)

✓ All 5 core patterns defined as proper SKILL.md files  
✓ Each pattern uses gerund naming (`planning-tasks`, not `planner`)  
✓ Each pattern includes XML-structured instructions, context, examples  
✓ Each pattern specifies degrees of freedom (high/medium/low)  
✓ Patterns are concise (~1–2k tokens per SKILL.md instruction body)  
✓ Examples are real and diverse (ready for Phase 4 expansion)  
✓ Shared conventions documented and Anthropic-aligned  
✓ Pattern composition guide shows single & multi-pattern workflows  

---

## Why These Changes

1. **Aligns with Anthropic Skills architecture** — SKILL.md format is how Anthropic builds skills
2. **Improves conciseness** — Progressive disclosure: only load what's needed
3. **Improves clarity** — XML structure, examples, degrees of freedom reduce ambiguity
4. **Future-compatible** — If patterns become Agent SDK agents later, they're ready
5. **Professional standard** — Gerund naming and proper structure signal quality

---

## Timeline Impact

**No additional time needed.** This is how Phase 2 was always planned — just with clearer structure and Anthropic-aligned standards.

The work is the same; the format is professional and future-proof.
