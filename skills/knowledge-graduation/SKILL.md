---
name: knowledge-graduation
description: >
  Graduate validated patterns from `.context/` to reusable local skills. Use this
  skill when reviewing `.context/` files and noticing patterns that keep recurring
  across tasks, when retrospectives show the same lessons being re-learned, or
  during periodic context review cycles. Also use after completing 10+ tasks when
  patterns should be mature enough to evaluate for promotion.
user-invocable: false
---

# Skill: Knowledge Graduation

## Purpose

Knowledge in `.context/` starts as project-specific documentation. When a pattern
proves stable, broadly applicable, and non-obvious, it should graduate to a local
skill — making it reusable across tasks and discoverable by agents.

This skill defines the graduation criteria, process, and quality checks.

---

## The Knowledge Lifecycle

```
L3: Ad-hoc (chat, comments, tribal knowledge)
  ↓  capture
L2: Documented (.context/ files — project-specific)
  ↓  graduate
L1: Local skill (skills/ — reusable, discoverable)
  ↓  generalize (future)
L0: Shared skill (published — cross-project)
```

This skill handles the L2 → L1 transition.

---

## Graduation Criteria

A pattern is ready to graduate when it meets **all four** criteria:

### 1. Stability

The pattern has been used successfully at least 3 times without modification.

**How to check:** Search retrospectives and task history for references to the pattern.
If it keeps changing each time it's applied, it's not stable yet.

### 2. Breadth

The pattern applies to more than one specific context.

**How to check:** Could another team member use this pattern for a different task?
If it only works for one specific module or flow, it stays in `.context/`.

### 3. Non-Obvious

The pattern isn't something an experienced developer would naturally do.

**How to check:** Would an agent or developer new to the project make mistakes without
this knowledge? If yes, it's worth graduating. If it's standard practice, it stays
as documentation.

### 4. Conciseness

The pattern can be expressed in a single SKILL.md file (< 200 lines).

**How to check:** If it requires multiple files or extensive examples, it might be
better as a documentation section rather than a skill.

---

## Graduation Process

### Step 1: Identify Candidates

Review these sources for graduation candidates:

- `.context/retrospectives.md` — recurring lessons that keep coming up
- `.context/standards/` — patterns that go beyond formatting conventions
- `.context/architecture/` — patterns that are reusable beyond this project
- `.context/decisions/` — decisions with implementation patterns that recur

### Step 2: Evaluate Against Criteria

For each candidate, check all four criteria:

```markdown
| Criterion   | Met? | Evidence                                          |
| ----------- | ---- | ------------------------------------------------- |
| Stability   | ✅   | Used in TASK-12, TASK-18, TASK-25 without changes |
| Breadth     | ✅   | Applies to all API endpoints, not just one        |
| Non-obvious | ✅   | New developers consistently miss the retry logic  |
| Conciseness | ✅   | Can fit in ~80 lines                              |
```

All four must be met. If any criterion fails, the pattern stays in `.context/`.

### Step 3: Create the Skill

1. Create `skills/[skill-name]/SKILL.md`
2. Follow the standard SKILL.md format (see existing skills for reference):
   - YAML frontmatter with `name`, `description`
   - Purpose section
   - Clear execution steps
   - Examples
   - Constraints
3. Reference the original `.context/` source in the skill for traceability

### Step 4: Update References

1. Update `skills/GUIDE.md` — add the new skill to the selection table
2. Update `.context/` source — add a note that this pattern graduated:
   ```markdown
   > **Graduated to skill:** See `skills/[skill-name]/SKILL.md` for the
   > canonical version of this pattern.
   ```
3. Don't delete the `.context/` entry — it provides project-specific context
   that the skill may not include

### Step 5: Verify

- [ ] Skill follows the standard SKILL.md format
- [ ] Frontmatter is parseable (name, description present)
- [ ] Triggering conditions are clear in the description
- [ ] Skill is discoverable via `skills/GUIDE.md`
- [ ] Original `.context/` entry references the graduated skill

---

## What NOT to Graduate

| Pattern                     | Why it stays in .context/            |
| --------------------------- | ------------------------------------ |
| Project-specific API quirks | Not broadly applicable               |
| One-time setup instructions | Single use, not recurring            |
| Business rules              | Domain-specific, not process-related |
| Tool configuration          | Changes with tool versions           |
| Style preferences           | Already covered by linter config     |

---

## Graduation Frequency

Don't graduate continuously. Review for candidates:

- After every 10 completed tasks
- During quarterly planning
- When onboarding a new team member (their questions reveal what knowledge is missing)
- When `retrospectives.md` has more than 15 entries

---

## Examples

### Good Graduation Candidate

**Pattern:** "API error responses always include a `code`, `message`, and `details` field"

- Stability: ✅ Used in all 12 API endpoints without modification
- Breadth: ✅ Applies to every endpoint, not just one
- Non-obvious: ✅ New agents create inconsistent error shapes without this
- Conciseness: ✅ ~50 lines as a skill

→ Graduate to `skills/api-error-format/SKILL.md`

### Not Ready to Graduate

**Pattern:** "The payment service requires a 500ms delay between retry attempts"

- Stability: ✅ Been consistent for 6 months
- Breadth: ❌ Only applies to the payment service
- Non-obvious: ✅ Not documented in the payment API
- Conciseness: ✅ One paragraph

→ Stays in `.context/domains/` — too narrow for a skill

---

## Constraints

- All four graduation criteria must be met — no exceptions
- Don't create skills preemptively — wait for evidence of repeated use
- Graduated skills must follow the standard SKILL.md format
- Don't delete `.context/` entries after graduation — annotate them instead
- Review graduation candidates periodically, not continuously
