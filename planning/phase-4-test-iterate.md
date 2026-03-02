# Phase 4: Test & Iterate (Ongoing)

## Set Up Test Project

Choose a real codebase to validate the agent system:

### Option A: Use an Existing Project
- Pick a small-to-medium project you're familiar with
- Should have multiple files, tests, and some complexity
- Avoid trivial "hello world" or massive enterprise codebases

### Option B: Create a Sample Project
- Build a simple CRUD app (todo list, blog, inventory system)
- Include: database models, business logic, API endpoints, tests
- Tech stack you're comfortable with

### Setup Steps

1. **Install the agents**
   ```bash
   # For global (Copilot CLI)
   cp -r /path/to/agent-files ~/.copilot/agents/
   
   # For project-specific (VS Code)
   cp -r /path/to/agent-files /path/to/project/.github/agents/
   ```

2. **Generate .context/ for the project**
   - Use the SETUP_PROMPT.md you created
   - Run it in the test project
   - Verify .context/ directory is created with project-specific content

3. **Verify agent availability**
   ```bash
   # In Copilot CLI
   /agents list
   
   # In VS Code
   # Type @ in chat and verify agents appear
   ```

## Test Scenarios

Run these tests in order, documenting results:

### Test 1: Simple Feature Request

**Task:** "Add a TODO comment to the main file"

**Expected workflow:**
1. @manager reads context
2. @manager delegates to @coder (simple task, no planning needed)
3. @coder adds comment
4. Done

**Check:**
- [ ] Manager correctly identified this as simple work
- [ ] No unnecessary agents invoked
- [ ] Change was made correctly
- [ ] No errors or confusion

### Test 2: Bug Fix with Test

**Task:** "Fix the validation bug in [specific function] and add a test"

**Expected workflow:**
1. @manager → @coder (fix bug)
2. @manager → @tester (add regression test)

**Check:**
- [ ] Coder fixed the bug correctly
- [ ] Tester wrote appropriate test
- [ ] Test runs and passes
- [ ] Both agents followed project patterns

### Test 3: New Feature (Medium Complexity)

**Task:** "Add user email validation to the registration form"

**Expected workflow:**
1. @manager → @planner (if you have planner, else skip)
2. @manager → @coder (implement validation)
3. @manager → @tester (write tests)
4. @manager → @reviewer (review changes)

**Check:**
- [ ] Agents were invoked in correct order
- [ ] Each agent had sufficient context
- [ ] Handoffs were smooth
- [ ] Feature works end-to-end

### Test 4: Architectural Decision

**Task:** "We need to add user authentication. What's the best approach for this codebase?"

**Expected workflow:**
1. @manager → @researcher (if available, check current auth libraries)
2. @manager → @architect (evaluate options)
3. Architect provides recommendation
4. (Don't implement, just get recommendation)

**Check:**
- [ ] Researcher found relevant docs (if invoked)
- [ ] Architect considered existing patterns
- [ ] Recommendation was project-specific
- [ ] No code written (stayed at design level)

## Document Issues

For each test, record:

### What Worked Well
- Which agent behaviors were helpful
- Good context usage
- Clean handoffs

### What Broke or Confused Agents
- Agent invoked incorrectly
- Missing context that caused errors
- Unclear instructions followed literally
- Infinite loops or redundant work

### Agent Instruction Problems
- Instructions that were ignored
- Instructions that were unclear
- Missing instructions that would prevent mistakes

## Iterate and Refine

After each test round:

### 1. Remove Unused Instructions

Track which instructions agents actually followed. After 5-10 tasks, remove:
- Instructions never referenced in agent outputs
- Redundant constraints
- Obvious advice (e.g., "write good code")

**Example refinement:**
```markdown
Before (verbose):
- Do not write code that is unclear or hard to maintain
- Do not create variables with non-descriptive names  
- Do not write functions that are overly complex
- Always write code that follows best practices
- Always ensure your code is well-structured

After ("earn your place"):
- Do not make architectural decisions — defer to @architect
- Always verify the build compiles after changes
```

### 2. Add Instructions for Repeated Mistakes

When agents make the same mistake 2-3 times, add specific guidance:

**Example additions:**
- Agent keeps writing tests without running them → Add "Always run tests after writing them"
- Agent invents file paths → Add "Always verify file paths exist before referencing them"
- Agent makes architectural changes unbidden → Add "Do not introduce new patterns without architect approval"

### 3. Refine Context Discovery

If agents repeatedly miss important context:
- Add explicit pointers in manager's "Context Discovery" section
- Update context file headers to be more descriptive
- Add cross-references between related context files

### 4. Improve Handoff Clarity

If agent-to-agent handoffs are unclear:
- Update "Delegation Protocol" in manager
- Add "Output Format" templates to specialists
- Clarify what artifacts should be created and where

## Track Progress

Use a simple log:

```markdown
## Test Round 1 - [Date]

**Test:** Simple feature request
**Result:** ✅ Worked / ⚠️ Partially worked / ❌ Failed
**Issues:**
- [Specific problem]
**Changes Made:**
- [Refinement to agent X]

**Instruction Count:**
- Manager: 125 lines
- Coder: 60 lines  
- Tester: 50 lines

---

## Test Round 2 - [Date]
...
```

## Goal: 76% Reduction

The original system went from 2,201 → 534 lines (76% reduction). Track your progress:

| Round | Total Lines | Notes |
|-------|-------------|-------|
| Initial | [count] | Baseline |
| Round 1 | [count] | Removed [what] |
| Round 2 | [count] | Removed [what] |
| Round 3 | [count] | Added [what] for [mistake] |
| ... | | |

## Graduation Criteria

You're ready to move on when:

- [ ] 5+ diverse tasks completed successfully
- [ ] Agents invoked correctly 80%+ of the time
- [ ] No repeated mistakes (same error happening 3+ times)
- [ ] Instructions are concise (under 100 lines per agent except manager)
- [ ] Context system is being used (agents reference .context/ files)
- [ ] Retrospective system works (lessons documented and promoted)

## Deliverables for Phase 4

- [ ] Test log with 5+ task results
- [ ] Refined agent definitions (shorter, more focused)
- [ ] Updated context templates based on real usage
- [ ] List of patterns that work vs patterns to avoid
- [ ] Documentation of common failure modes and fixes
- [ ] Line count reduction metrics
