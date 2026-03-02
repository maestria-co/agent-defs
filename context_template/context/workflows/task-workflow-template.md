# Task Workflow

> **Purpose:** The 8-phase workflow for executing tasks with the multi-agent system. Use this as a reference for how work should flow through the agent roster. Artifacts from each task are stored in `.context/tasks/[TASK-ID]/`.

---

## Decision Tree — Which Workflow to Use

Before starting, classify the task:

```
Is this a single-file change or quick bug fix?
  └─ YES → Simple path: skip phases 2-4, go directly to Implementation (phase 5)

Is this multi-file but using established patterns?
  └─ YES → Medium path: Planning → Implementation → Testing (phases 3, 5, 6)

Does this introduce new patterns, new architecture, or touch >5 files?
  └─ YES → Full 8-phase workflow
```

When in doubt, use the medium path. Upgrade to full if blockers are encountered.

---

## Task Artifact Structure

```
.context/tasks/[TASK-ID]/
├── brief.md          # What needs to be done (created at start of phase 1)
├── plan.md           # Planner output — ordered task breakdown (phase 3)
├── research.md       # Researcher output — if external knowledge needed (phase 2)
├── decisions.md      # ADRs generated during this task (phase 4)
└── retrospective.md  # Post-task lessons (phase 8)
```

Create the `[TASK-ID]/` directory at the start of any medium or complex task.

---

## The 8 Phases

### Phase 1 — Context Discovery
**When:** Start of every task.
**Who:** Manager agent.
**Actions:**
1. Read `overview.md` — understand project shape
2. Read relevant `standards/`, `architecture/`, `domains/` files
3. Run `git log --oneline -10` — see recent changes
4. Create `.context/tasks/[TASK-ID]/brief.md` — document the task goal and acceptance criteria
**Artifact:** `brief.md`

---

### Phase 2 — Research (if needed)
**When:** Task involves an external library, API, or technology that may have changed since training.
**Who:** Researcher agent.
**Actions:**
1. Fetch current documentation for the relevant library/API
2. Identify breaking changes, deprecated APIs, or new patterns
3. Document findings and recommended approach
**Artifact:** `research.md`
**Skip when:** Task uses only well-understood internal patterns.

---

### Phase 3 — Planning
**When:** Medium or complex tasks.
**Who:** Planner agent.
**Actions:**
1. Read `brief.md` and `research.md` (if exists)
2. Break the work into ordered, atomic tasks
3. Identify dependencies between tasks
4. Estimate complexity per task (S/M/L)
**Artifact:** `plan.md`

---

### Phase 4 — Architecture Review (if needed)
**When:** Task introduces new patterns, new services, or changes existing architecture.
**Who:** Architect agent.
**Actions:**
1. Evaluate the plan against existing `architecture/patterns-template.md`
2. Identify if new ADRs are needed
3. Approve or revise the plan
**Artifact:** `decisions.md` (any new ADRs for this task)
**Skip when:** Task follows fully established patterns with no structural decisions.

---

### Phase 5 — Implementation
**When:** After planning (and architecture review if needed).
**Who:** Coder agent.
**Actions:**
1. Implement each task from `plan.md` in order
2. Follow all patterns in `standards/` and `architecture/`
3. Create a git commit after each logical unit of work
4. Update `overview.md` or `domains/` if new facts are discovered
**Checkpoint:** After 3-5 major actions, verify against `brief.md` acceptance criteria.

---

### Phase 6 — Testing
**When:** After implementation of each unit (not just at the end).
**Who:** Tester agent.
**Actions:**
1. Write unit tests for new code (≥90% coverage)
2. Write or update integration tests if API surface changed
3. Run the full test suite — all tests must pass
4. For bug fixes: verify the reproducing test fails on the original code, passes on the fix
**Reference:** `testing/unit-testing.md`, `testing/integration-testing.md`

---

### Phase 7 — Review
**When:** After testing passes.
**Who:** Reviewer (human or review agent).
**Actions:**
1. Verify all acceptance criteria from `brief.md` are met
2. Check that new code follows `standards/` conventions
3. Check that no new patterns were introduced without architecture review
4. Approve or return with feedback

---

### Phase 8 — Retrospective
**When:** After task is merged/complete.
**Who:** Manager agent.
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
