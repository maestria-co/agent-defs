# Task Workflow

> **Purpose:** How to execute tasks using the agentless pattern system. Pick the right pattern for your task, follow its steps, and write results back to `.context/`. Artifacts from each task are stored in `.context/tasks/[TASK-ID]/`.

---

## Decision Tree — Which Workflow to Use

Before starting, classify the task:

```
Is this a single-file change or quick bug fix?
  └─ YES → Simple path: use implementing-features directly

Is this multi-file but using established patterns?
  └─ YES → Medium path: planning-tasks → implementing-features → writing-tests

Does this introduce new patterns, new architecture, or touch >5 files?
  └─ YES → Full workflow: research? → designing-systems → planning-tasks → implement → test
```

When in doubt, use the medium path. Upgrade to full if blockers are encountered.

---

## Pattern Quick-Reference

| Task type | Pattern |
|---|---|
| Break a goal into ordered tasks | `planning-tasks` |
| Evaluate libraries, approaches, options | `researching-options` |
| Make an architecture decision (ADR) | `designing-systems` |
| Write or modify code | `implementing-features` |
| Write or run tests | `writing-tests` |
| Orchestrate 3+ patterns | `coordinating-work` |

See `.context/patterns/GUIDE.md` for the full selection guide and composition patterns.

---

## Task Artifact Structure

```
.context/tasks/[TASK-ID]/
├── brief.md          # What needs to be done (created at start)
├── plan.md           # planning-tasks output — ordered task breakdown
├── research.md       # researching-options output — if external knowledge needed
├── decisions.md      # designing-systems output — ADRs for this task
└── retrospective.md  # Post-task lessons
```

Create the `[TASK-ID]/` directory at the start of any medium or complex task.

---

## The Workflow Phases

### Phase 1 — Context Discovery
**When:** Start of every task.
**Pattern:** (manual pre-flight — no pattern needed)
**Actions:**
1. Read `overview.md` — understand project shape
2. Read relevant `standards/`, `architecture/`, `domains/` files
3. Run `git log --oneline -10` — see recent changes
4. Create `.context/tasks/[TASK-ID]/brief.md` — document the task goal and acceptance criteria
**Artifact:** `brief.md`

---

### Phase 2 — Research (if needed)
**When:** Task involves an external library, API, or technology that may have changed.
**Pattern:** `researching-options`
**Actions:**
1. Run the `researching-options` pattern
2. Output: recommendation with rationale, tradeoffs, confidence level
**Artifact:** `research.md`
**Skip when:** Task uses only well-understood internal patterns.

---

### Phase 3 — Planning
**When:** Medium or complex tasks.
**Pattern:** `planning-tasks`
**Actions:**
1. Run `planning-tasks` with the brief and any research as input
2. Output: ordered task list, dependencies, complexity estimates, flagged unknowns
**Artifact:** `plan.md`

---

### Phase 4 — Architecture Review (if needed)
**When:** Task introduces new patterns, new services, or changes existing architecture.
**Pattern:** `designing-systems`
**Actions:**
1. Run `designing-systems` with plan and context as input
2. Assess reversibility — one-way door decisions require explicit ADR
3. Output: ADR(s) and implementation constraints
**Artifact:** `decisions.md`
**Skip when:** Task follows fully established patterns with no structural decisions.

---

### Phase 5 — Implementation
**When:** After planning (and architecture review if needed).
**Pattern:** `implementing-features`
**Actions:**
1. Run `implementing-features` for each task from `plan.md`
2. Follow all patterns in `standards/` and `architecture/`
3. Commit after each logical unit of work
4. Update `overview.md` or `domains/` if new facts are discovered
**Checkpoint:** After 3-5 major actions, verify against `brief.md` acceptance criteria.

---

### Phase 6 — Testing
**When:** After implementation of each unit.
**Pattern:** `writing-tests`
**Actions:**
1. Run `writing-tests` — write unit tests (≥90% coverage target)
2. Write or update integration tests if API surface changed
3. Run the full test suite — all tests must pass
4. For bug fixes: verify the reproducing test fails on original, passes on fix
**Reference:** `testing/unit-testing.md`, `testing/integration-testing.md`

---

### Phase 7 — Review
**When:** After testing passes.
**Pattern:** (human review)
**Actions:**
1. Verify all acceptance criteria from `brief.md` are met
2. Check that new code follows `standards/` conventions
3. Check that no new patterns were introduced without architecture review
4. Approve or return with feedback

---

### Phase 8 — Retrospective
**When:** After task is merged/complete.
**Pattern:** (manual — write directly to retrospectives)
**Three questions:**
1. What went well that should be repeated?
2. What slowed us down that should be improved?
3. What did we learn that should be promoted to `.context/`?

**Actions:**
1. Add entry to `retrospectives.md`
2. Identify promotion candidates (checkbox items)
3. If any item is immediately obvious to promote, do it now

**Artifact:** Entry in `retrospectives.md`, optional updates to `standards/` or `architecture/`

---

## Human Checkpoints

Stop and check in with the human when:
- 3-5 major actions have been completed (progress update)
- Before any irreversible change (dropping tables, external API calls that can't be undone)
- When a blocker is encountered that requires a decision
- Before Phase 7 Review (human should approve before merge)
