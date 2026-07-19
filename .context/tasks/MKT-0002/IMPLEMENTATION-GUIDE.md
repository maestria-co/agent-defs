# Implementation Guide: Ecosystem Roadmap

**Start Date:** 2026-07-02  
**Estimated Duration:** 3-4 weeks  
**Current Phase:** Phase 1 (Ready to Start)

---

## Quick Start for Tomorrow

All Phase 1 tasks are **ready to start** (no dependencies). Pick any task and begin!

### Phase 1: Quick Wins (Week 1) — 6 Tasks

**Estimated total:** 15-20 hours

| Priority | Task ID | Task | Effort | Files to Modify |
|----------|---------|------|--------|-----------------|
| P0 | `p1-sidecar-poc` | Create sidecar references POC | 5-6h | `skills/implementing-features/`, `skills/writing-tests/` |
| P0 | `p1-content-aware` | Content-aware reading strategies | 2-3h | `skills/context-loader/SKILL.md`, `skills/implementing-features/SKILL.md` |
| P1 | `p1-task-templates` | Enhanced task tracking templates | 2h | `skills/task-plan/SKILL.md`, `agents/manager.agent.md` |
| P1 | `p1-output-control` | Output verbosity control | 2h | `agents/manager.agent.md`, `agents/coder.agent.md`, `agents/tester.agent.md` |
| P2 | `p1-cache-structure` | Cache-friendly structure docs | 3-4h | `agents/_shared/conventions.md` |
| P2 | `p1-lazy-guidance` | Lazy skill loading guidance | 1h | `skills/using-skills/SKILL.md` |

**Recommendation:** Start with `p1-sidecar-poc` or `p1-content-aware` (highest value).

---

## Detailed Task Breakdowns

### P0: p1-sidecar-poc — Create Sidecar References POC

**Goal:** Prove the sidecar pattern works by refactoring 2 skills.

**Steps:**

1. **Choose skills to refactor:**
   - `skills/implementing-features/SKILL.md` (currently ~700+ lines)
   - `skills/writing-tests/SKILL.md` (currently ~500+ lines)

2. **For each skill:**
   
   a. **Create references directory:**
   ```bash
   mkdir -p skills/implementing-features/references
   mkdir -p skills/writing-tests/references
   ```
   
   b. **Identify content to extract:**
   - Code patterns/examples → `references/code-patterns.md`
   - Edge cases → `references/edge-cases.md`
   - Troubleshooting → `references/troubleshooting.md`
   - Integration guides → `references/testing-integration.md`
   
   c. **Refactor SKILL.md:**
   - Keep: Intent, When to Use, Core Workflow (decision tree)
   - Move: Detailed examples, edge cases, troubleshooting
   - Target: ~150-200 lines for SKILL.md
   - Add: "When You Need More Detail" section with links to references
   
   d. **Extract content:**
   - Copy detailed content to references/ files
   - Keep references focused (each ~100-200 lines)
   - Add clear headings and examples

3. **Test the refactor:**
   ```bash
   # Ask an agent to implement a feature using the refactored skill
   # Verify it:
   # - Reads SKILL.md first
   # - Loads references/ only when needed
   # - Completes task successfully
   ```

4. **Document the pattern:**
   - Add comment at top of SKILL.md explaining references/
   - Update skills/README.md with sidecar pattern explanation

**Example refactored structure:**

```
skills/implementing-features/
├── SKILL.md                    # 150 lines - core workflow
└── references/
    ├── code-patterns.md        # Common implementation patterns
    ├── testing-integration.md  # How to integrate with tests
    ├── edge-cases.md           # Unusual scenarios
    └── troubleshooting.md      # Common issues
```

**Success criteria:**
- [ ] SKILL.md files are ~150-200 lines (down from 500-700)
- [ ] References are well-organized and discoverable
- [ ] Agent can complete tasks using refactored skills
- [ ] Agent loads references only when encountering specific scenarios

---

### P0: p1-content-aware — Content-Aware Reading Strategies

**Goal:** Teach agents to detect content type before reading.

**Steps:**

1. **Update context-loader skill:**
   
   Add section: "Content-Aware Reading Strategy"
   
   ```markdown
   ## Content-Aware Reading Strategy
   
   Before reading content, identify its type and use the appropriate strategy:
   
   ### JSON/Structured Data
   - Use jq for targeted queries: `jq '.errors[] | select(.severity=="critical")'`
   - Read structure first: `jq 'keys'` before diving into values
   - Filter before reading: don't load 10MB JSON, query what you need
   
   ### Code Files
   - Read exports/public API first (top 20 lines usually sufficient)
   - Use grep to find specific functions: `grep -n "function authenticate"`
   - Use view_range for targeted sections: `view(path, view_range=[145, 200])`
   
   ### Log Files
   - Filter for errors first: `grep -E "(ERROR|WARN|FATAL)" app.log`
   - Use tail for recent entries: `tail -100 app.log`
   - Request log summaries when tools support it
   
   ### Documentation
   - Read headers/ToC first to understand structure
   - Use grep to find relevant sections: `grep -n "## Authentication"`
   - Load full doc only if entire context needed
   
   ### Test Output
   - Request minimal formats: `npm test -- --reporter=minimal`
   - Filter for failures only: `npm test 2>&1 | grep -A5 FAIL`
   - Show summary first, details on request
   ```

2. **Update implementing-features skill:**
   
   Add to "Understand the Spec" section:
   
   ```markdown
   ## Understand the Spec
   
   1. **Read acceptance criteria**
   2. **Identify affected files** (use grep/glob for discovery)
   3. **Apply content-aware reading:**
      - If spec references config → read as JSON (use jq)
      - If spec references code → find functions first (grep), then read targeted
      - If spec references logs → filter for relevant entries
   ```

3. **Add examples to both skills:**
   
   Show before/after patterns:
   
   ```markdown
   ## Example: Reading a Large Config File
   
   ❌ **Don't:**
   ```bash
   view(/config/app.config.json)  # Loads entire 5000-line file
   ```
   
   ✅ **Do:**
   ```bash
   # First, understand structure
   jq 'keys' /config/app.config.json
   
   # Then, read relevant section
   jq '.database' /config/app.config.json
   ```
   ```

**Success criteria:**
- [ ] Both skills have content-aware reading sections
- [ ] Examples show before/after patterns
- [ ] Covers 4+ content types (JSON, code, logs, docs)
- [ ] Clear, actionable guidance

---

### P1: p1-task-templates — Enhanced Task Tracking Templates

**Goal:** Structured plan.md templates that reduce context loading.

**Steps:**

1. **Update task-plan skill:**
   
   Add template section:
   
   ```markdown
   ## Plan.md Template Structure
   
   Use this structure to keep task context lean:
   
   ```markdown
   # Task Plan: [Task Name]
   
   ## 🎯 Active Task
   **Currently working on:** [current subtask]
   
   **Status:** [in progress / blocked / waiting]
   
   **Acceptance criteria:**
   - [ ] Criterion 1
   - [ ] Criterion 2
   
   ## 📋 Next Up (Priority Order)
   
   1. **[Next task name]**
      - Dependencies: [any blockers]
      - Acceptance criteria: [brief list]
   
   2. **[Following task]**
      - Dependencies: [any blockers]
      - Acceptance criteria: [brief list]
   
   ## ⏸️ Blocked/Waiting
   
   - **[Blocked task]** - Waiting for: [reason]
   
   ## ✅ Completed Tasks
   
   <details>
   <summary>View completed (5 tasks)</summary>
   
   - [x] Task 1 - Completed 2026-07-01
     - Outcome: [what was delivered]
   - [x] Task 2 - Completed 2026-07-01
     - Outcome: [what was delivered]
   
   </details>
   ```
   ```

2. **Update manager agent:**
   
   Add reading guidance:
   
   ```markdown
   ## Reading Task Plans
   
   When reading plan.md:
   1. Read "Active Task" section first (this is current work)
   2. Read "Next Up" to understand what's coming
   3. Skip "Completed Tasks" unless you need historical context
   4. Only expand Completed if debugging or understanding decisions
   
   This keeps context focused on current and upcoming work.
   ```

3. **Create example plan.md:**
   
   Create `.context/tasks/MKT-0002/example-plan.md` showing the template in use.

**Success criteria:**
- [ ] Template is clear and easy to use
- [ ] Manager agent knows to read Active + Next first
- [ ] Example demonstrates the pattern
- [ ] Completed section uses collapsible details tag

---

### P1: p1-output-control — Output Verbosity Control

**Goal:** Reduce verbose agent responses for routine operations.

**Steps:**

1. **Update manager agent:**
   
   Add section: "Output Efficiency Guidelines"
   
   ```markdown
   ## Output Efficiency Guidelines
   
   ### For Routine Operations
   (Reading files, running passing tests, standard tasks)
   
   - Skip preambles: "Great, let me...", "I'll now..."
   - Don't restate the task or previous context
   - Provide only essential observation or next action
   
   ### For Complex Operations
   (Debugging, architecture decisions, research)
   
   - Provide reasoning (users want to understand thinking)
   - Show evidence for conclusions
   - Explain non-obvious choices
   
   ### For Error Scenarios
   (Always verbose - never skip context)
   
   - Provide full context and reasoning
   - Show stack traces, error messages verbatim
   - Explain diagnosis process step-by-step
   ```

2. **Update coder agent:**
   
   Add to code change guidelines:
   
   ```markdown
   ## Code Output Efficiency
   
   **For routine changes:**
   - Show only changed sections with minimal context
   - Use edit tool's targeted approach
   - Don't echo back unchanged code
   
   **For complex refactors:**
   - Explain the reasoning
   - Show before/after structure if helpful
   - Highlight key changes
   ```

3. **Update tester agent:**
   
   Add test output guidance:
   
   ```markdown
   ## Test Output
   
   **When tests pass:**
   - Brief summary: "All 247 tests passed in 3.2s"
   - No need to show passing test names
   
   **When tests fail:**
   - Show full failure output
   - Include stack traces
   - Show relevant passing tests if they provide context
   ```

**Success criteria:**
- [ ] Guidelines in 3+ agents
- [ ] Clear distinction: routine vs. complex vs. error
- [ ] Examples show both verbose and concise styles

---

### P2: p1-cache-structure — Cache-Friendly Structure

**Goal:** Document patterns that help provider KV caching.

**Steps:**

1. **Update agents/_shared/conventions.md:**
   
   Add section: "Cache-Friendly File Structure"
   
   ```markdown
   ## Cache-Friendly File Structure
   
   Structure agent and skill files to maximize provider KV cache hits.
   
   ### Pattern: Static Top, Dynamic Bottom
   
   **Top 70% - Static Content (likely cached):**
   1. Role & Identity
   2. Core Capabilities
   3. Standard Workflows
   4. Example Patterns
   5. Reference Documentation
   
   **Bottom 30% - Dynamic Content (expect cache miss):**
   6. Current Task Context
   7. Session-Specific State
   8. Recent Learnings
   9. Task-Specific Overrides
   
   ### Why This Helps
   
   LLM providers cache prompt prefixes. When static content stays at top,
   the cache remains valid even when dynamic state changes.
   
   ### Example Agent Structure
   
   ```markdown
   # Agent: Coder
   
   ## Role (Static - rarely changes)
   You are a senior software developer...
   
   ## Core Skills (Static)
   - Implementing features from specs
   - Writing tests
   - Code review
   
   ## Standard Workflow (Static)
   1. Read spec
   2. Identify files
   3. Implement
   4. Test
   5. Verify
   
   ## Examples (Static)
   [example code patterns]
   
   ---
   
   ## Current Task (Dynamic - inject at runtime)
   [task-specific context]
   
   ## Session State (Dynamic)
   [active plan, current phase]
   ```
   ```

2. **Create agent template showing pattern:**
   
   Update `agents/_shared/agent-template.md` to demonstrate structure.

3. **Add guidance on when to apply:**
   
   ```markdown
   ## When to Apply This Pattern
   
   **Apply for:**
   - Agent definitions
   - Skill definitions
   - Project conventions documents
   
   **Don't apply for:**
   - Task-specific plan.md (mostly dynamic)
   - Session logs (all dynamic)
   - One-off prompts
   ```

**Success criteria:**
- [ ] Clear pattern documented
- [ ] Rationale explained (KV caching)
- [ ] Template demonstrates structure
- [ ] Guidance on when to apply/skip

---

### P2: p1-lazy-guidance — Lazy Skill Loading

**Goal:** Teach agents to load skills on-demand.

**Steps:**

1. **Update skills/using-skills/SKILL.md:**
   
   Add section: "Efficient Skill Loading"
   
   ```markdown
   ## Efficient Skill Loading
   
   ### Discovery Phase
   
   1. Read `GUIDE.md` to identify which skill matches your task
   2. Read that `SKILL.md` (concise, ~150-200 lines)
   3. Start working with the core workflow
   
   ### Deep Dive (Only When Needed)
   
   4. Hit an edge case? → Read `references/edge-cases.md`
   5. Implementation pattern unclear? → Read `references/code-patterns.md`
   6. Something failed? → Read `references/troubleshooting.md`
   
   ### What NOT to Do
   
   ❌ Read all reference files upfront "just in case"
   ❌ Read multiple full skills when you only need one
   ❌ Re-read skills you've already used this session
   
   ### What TO Do
   
   ✅ Read skills on-demand as you need them
   ✅ Load reference files only for specific scenarios
   ✅ Trust your memory - once read this session, you know it
   
   ### Example: Implementing a Feature
   
   ```
   # Step 1: Identify skill
   Read: skills/GUIDE.md → "implementing features" maps to implementing-features
   
   # Step 2: Read core skill
   Read: skills/implementing-features/SKILL.md
   [Now you know the workflow]
   
   # Step 3: Start implementation
   [Working on code...]
   
   # Step 4: Hit edge case (error handling pattern unclear)
   Read: skills/implementing-features/references/error-patterns.md
   [Now you know how to handle errors in this project]
   
   # Step 5: Continue implementation
   [Finish the work]
   ```
   ```

**Success criteria:**
- [ ] Clear do/don't examples
- [ ] Step-by-step workflow shown
- [ ] Explains when to load references
- [ ] Discourages pre-loading

---

## Phase 2: Discovery & Learning (Week 2)

**Not ready yet** - depends on Phase 1 completion. Will unlock after:
- ✅ `p1-sidecar-poc` is done
- ✅ `p1-cache-structure` is done

**Tasks:**
1. `p2-learning-skill` — Create learning-from-failures skill (3-4h)
2. `p2-context-graph` — Build context graph generator (5-6h)
3. `p2-graph-integration` — Integrate graph with context-loader (2h)

---

## Phase 3: Sidecar Migration (Week 3)

**Not ready yet** - depends on Phase 1 POC success.

**Tasks:**
1. `p3-sidecar-full` — Refactor remaining 5+ skills (6-8h)
2. `p3-guide-update` — Update GUIDE.md (1h)
3. `p3-validation` — Test refactored skills (1h)

---

## Phase 4: Validation (Week 4)

**Not ready yet** - depends on Phases 2 & 3.

**Tasks:**
1. `p4-real-world-test` — Use on 10 real tasks (varies)
2. `p4-findings` — Document findings and decisions (2-3h)

---

## Daily Workflow

### Tomorrow (Day 1)

**Pick ONE task to start:**

**Option A: High Impact (Recommended)**
```bash
# Start with sidecar POC
# This unlocks Phase 2 and proves the pattern works
Task: p1-sidecar-poc
Time: 5-6 hours
```

**Option B: Quick Win**
```bash
# Start with content-aware reading
# Fast, high value, immediate improvement
Task: p1-content-aware
Time: 2-3 hours
```

**Option C: Multiple Small Tasks**
```bash
# Knock out several quick ones
1. p1-task-templates (2h)
2. p1-output-control (2h)
3. p1-lazy-guidance (1h)
# Total: 5 hours
```

### Tracking Progress

Update todos as you work:

```sql
-- Mark task in progress
UPDATE todos SET status = 'in_progress' WHERE id = 'p1-sidecar-poc';

-- Mark task complete
UPDATE todos SET status = 'done' WHERE id = 'p1-sidecar-poc';

-- See what's ready next
SELECT t.id, t.title FROM todos t
WHERE t.status = 'pending'
AND NOT EXISTS (
    SELECT 1 FROM todo_deps td
    JOIN todos dep ON td.depends_on = dep.id
    WHERE td.todo_id = t.id AND dep.status != 'done'
)
ORDER BY t.id;
```

### Each Day

1. **Check ready tasks** (run query above)
2. **Pick one task** (start with P0, then P1, then P2)
3. **Mark in progress** (update todos)
4. **Complete the task** (follow detailed breakdown)
5. **Mark done** (update todos)
6. **Test the change** (verify it works)
7. **Commit** (save your progress)

---

## Success Metrics

Track these as you go:

### Qualitative
- [ ] Do refactored skills feel clearer?
- [ ] Are agents loading references appropriately?
- [ ] Do content-aware patterns feel natural?
- [ ] Is plan.md structure easier to read?

### Quantitative (if possible)
- [ ] Average SKILL.md length: ~150-200 lines (down from 500-700)
- [ ] Context files read per task (before/after)
- [ ] Time to complete similar tasks (before/after)

---

## Troubleshooting

**If a task feels blocked:**
1. Check dependencies (is it actually ready?)
2. Skip to another Phase 1 task (they're all independent)
3. Document the blocker
4. Move forward with other work

**If a pattern doesn't work:**
1. Document what failed
2. Try a simpler approach
3. Don't force it - some patterns may not fit ai-playbook

**If you need help:**
1. Read the ecosystem tool docs (Headroom, Graphify, CyberStrike)
2. Look at their implementations for inspiration
3. Adapt, don't copy verbatim

---

## Commit Strategy

**After each task:**
```bash
git add [modified files]
git commit -m "feat(MKT-0002): [task-title]

[What was changed]
[Why it helps]
[How to use it]

Part of ecosystem-inspired optimization roadmap.
Refs: [tool name] pattern adoption."
```

**Example:**
```bash
git commit -m "feat(MKT-0002): Add content-aware reading strategies

Added content-type detection patterns to context-loader and
implementing-features skills. Agents now use jq for JSON,
grep for discovery, tail for logs before reading full files.

Adopted from Headroom AI's ContentRouter pattern.
Refs: https://github.com/headroomlabs-ai/headroom"
```

---

## Next Steps

**Tonight:**
- [x] Review ecosystem roadmap (done)
- [x] Review implementation guide (this document)
- [ ] Decide which task to start tomorrow

**Tomorrow morning:**
- [ ] Pick one Phase 1 task (recommend: p1-sidecar-poc or p1-content-aware)
- [ ] Mark it in-progress
- [ ] Follow the detailed breakdown above
- [ ] Complete, test, commit
- [ ] Pick the next task

**End of Week 1:**
- [ ] All 6 Phase 1 tasks complete
- [ ] Pattern proven to work
- [ ] Ready for Phase 2

Let's build this! 🚀
