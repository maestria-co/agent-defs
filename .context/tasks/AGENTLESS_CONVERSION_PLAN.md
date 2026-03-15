# Agentless Conversion Plan

## Overview

Convert the current **multi-agent system** (6 specialized agents with routing logic, handoff protocols, and state management) to **agentless patterns** following Anthropic's principle of simplicity and composability.

**Key Shift:**
- **From:** Complex agent roles with handoff protocols, routing logic, and workflow state
- **To:** Simple, composable prompt patterns that are reusable, maintainable, and directly effective

**Core Principle:** "The most successful implementations weren't using complex frameworks. They were building with simple, composable patterns."

---

## Conversion Strategy

This conversion is broken into **7 phases** to allow incremental adoption and testing. Each phase:
1. Introduces agentless equivalents alongside the old agent system
2. Validates they produce equivalent or better results
3. Retires old agent files only after validation
4. Updates documentation to guide users to the new patterns

**Timeline Philosophy:** No time estimates. Each phase is a discrete logical unit. Work through them sequentially with human checkpoint verification after each phase.

---

## Phase 1: Analysis & Assessment

**Goal:** Document the current system, map current behaviors to agentless equivalents, and validate conversion assumptions.

**Tasks:**
1. Document all 6 agent roles and their responsibilities
2. Catalog existing `_skills/` directory: `context-review` and `evaluate-skill` skills (note their format and structure for consistency)
3. Extract the core "patterns" each agent represents (planning, research, architecture, coding, testing, coordination)
4. Analyze handoff protocols — which are essential, which add complexity
5. Map current workflows (Manager → Specialists) to direct prompt patterns
6. Identify state/context that flows between agents — move it to `.context/` files
7. Create a conversion mapping document showing old agent → new pattern equivalents
8. **Fix broken `CLAUDE.md` references** (pre-existing bug):
   - `agents/manager.md` → `agents/manager.agent.md`
   - `agents/architect.md` → `agents/architect.agent.md`
   - `agents/planner.md` → `agents/planner.agent.md`
   - `agents/researcher.md` → `agents/researcher.agent.md`
   - `agents/coder.md` → `agents/coder.agent.md`
   - `agents/tester.md` → `agents/tester.agent.md`
   - Remove reference to `agents/README.md` (does not exist; use `agents/_shared/README.md`)

**Deliverables:**
- `.context/tasks/CURRENT_SYSTEM_ANALYSIS.md` — Complete documentation of 6-agent system + existing `_skills/` inventory
- `.context/tasks/AGENTLESS_MAPPING.md` — Old agent role → new pattern equivalents
- `.context/tasks/HANDOFF_ANALYSIS.md` — Which handoff logic adds value vs. adds complexity
- Updated `CLAUDE.md` — Fixed file references (corrective only, no content changes)

**Completion Criteria:**
- All agent files analyzed
- Existing `_skills/` skills catalogued
- All workflows documented
- Clear mapping exists between old agents and new patterns
- `CLAUDE.md` references are corrected and verified
- Team confirms mapping accuracy

---

## Phase 2: Extract Core Patterns (Documentation Refactor)

**Goal:** Rewrite agent documentation as reusable, composable SKILL.md patterns following Anthropic's
Agent Skills format. Patterns live in `.context/patterns/` with gerund naming and YAML frontmatter.

**Pattern Format (every pattern must follow):**
- File: `.context/patterns/<gerund-name>/SKILL.md`
- YAML frontmatter: `name`, `description` (trigger-oriented, includes "Use when…")
- Sections: Purpose, Pre-flight Checks, Execution Steps (numbered, imperative), Constraints
- Max 500 lines per SKILL.md (move heavy reference material to `references/` subdirectory)
- Degree of freedom declared: high / medium / low

**Tasks:**
1. Create `.context/patterns/` directory
2. Create `PATTERN_TEMPLATE.md` — canonical SKILL.md template with all required sections
3. Create `PATTERN_NAMING.md` — naming conventions (gerund form, kebab-case, examples)
4. For each agent role, extract its core "pattern" as a `SKILL.md`:
   - **`planning-tasks/`** (from Planner) — How to break goals into tasks
   - **`researching-options/`** (from Researcher) — How to evaluate options and fill knowledge gaps
   - **`designing-systems/`** (from Architect) — How to make design decisions and write ADRs
   - **`implementing-features/`** (from Coder) — How to write code from specifications
   - **`writing-tests/`** (from Tester) — How to write tests and validate quality
   - **`coordinating-work/`** (from Manager) — How to orchestrate simpler workflows when needed
5. Each `SKILL.md` must include 3–5 real, diverse examples with XML structure tags
6. Extract shared prompt conventions into `.context/patterns/_shared/conventions.md`
7. Create `.context/patterns/GUIDE.md` — when to use each pattern and how to compose them

**Deliverables:**
- `.context/tasks/PATTERN_TEMPLATE.md` — Canonical SKILL.md template
- `.context/tasks/PATTERN_NAMING.md` — Naming conventions reference
- `.context/patterns/planning-tasks/SKILL.md` — Planning pattern (replaces Planner agent)
- `.context/patterns/researching-options/SKILL.md` — Research pattern (replaces Researcher agent)
- `.context/patterns/designing-systems/SKILL.md` — Architecture pattern (replaces Architect agent)
- `.context/patterns/implementing-features/SKILL.md` — Implementation pattern (replaces Coder agent)
- `.context/patterns/writing-tests/SKILL.md` — Testing pattern (replaces Tester agent)
- `.context/patterns/coordinating-work/SKILL.md` — Light coordination pattern (replaces Manager agent)
- `.context/patterns/_shared/conventions.md` — Shared principles drawn from `agents/_shared/conventions.md`
- `.context/patterns/GUIDE.md` — When to use which patterns, how to compose them
- `.context/tasks/PATTERN_EXAMPLES.md` — Real examples of each pattern in use

**Completion Criteria:**
- All 6 patterns are valid SKILL.md files (pass structural requirements: YAML frontmatter, name, description)
- Each pattern has 3–5 real examples with XML tag structure
- Pattern naming follows gerund + kebab-case convention
- Shared conventions extracted from `agents/_shared/conventions.md`
- Pattern composition guide is clear and complete
- Patterns work standalone (no agent routing required)

---

## Phase 3: Update Context System and `context_template/` for Agentless Patterns

**Goal:** Ensure `.context/` structure fully supports agentless workflows (no runtime state needed),
and update `context_template/` so new projects start with agentless patterns by default.

**Tasks:**

### 3a — Context System Update
1. Review current `.context/` structure for any agent-specific assumptions
2. Add/clarify sections needed by agentless patterns:
   - Decision registry (for `designing-systems/` pattern reference)
   - Task examples (for `planning-tasks/` pattern reference)
   - Tech evaluation notes (for `researching-options/` pattern reference)
   - Code standards (for `implementing-features/` pattern reference)
   - Testing standards (for `writing-tests/` pattern reference)
3. Document how context flows in agentless workflows (no handoff state needed)
4. Ensure `project-overview.md` is complete and pattern-friendly

### 3b — `context_template/` Update
5. Review all files in `context_template/` for agent-specific language or assumptions
6. Update `context_template/` to reference `.context/patterns/` instead of agent files
7. Add pattern quick-reference to `context_template/` (which pattern to use for common tasks)
8. Remove or neutralize any routing/handoff protocol references from templates

**Deliverables:**
- Updated `.context/README.md` — Agentless-focused context structure
- `.context/tasks/CONTEXT_STRUCTURE.md` — How context flows in agentless workflows
- Updated `context_template/` files — Agent references replaced with pattern references

**Completion Criteria:**
- Context structure fully supports agentless patterns
- No agent-specific state in context files
- All patterns can reference context independently
- Project overview is complete
- `context_template/` reflects agentless-first approach for new projects

---: Create Quick-Start Guides for Agentless Workflows

**Goal:** Show users how to use patterns directly without learning the old agent system.

**Tasks:**
1. Create **Quick-Start Guide** (`QUICK_START.md`):
   - Common task types (plan a feature, evaluate options, implement, write tests)
   - Which pattern(s) to use for each
   - Template prompt for each
   - Examples of expected outputs
2. Create **Workflow Recipes** (`recipes/`):
   - Simple task (no routing needed)
   - Complex task (multiple patterns, but no manager)
   - Design decision task (research + architecture)
   - Full feature implementation (planning + research + implementation + testing)
3. Create **Troubleshooting Guide**:
   - Common mistakes using patterns
   - When patterns fall short
   - How to debug pattern outputs
   - When to add external tools/agents

**Deliverables:**
- `QUICK_START.md` — Direct patterns for common tasks
- `recipes/simple-task.md` — Single pattern workflow
- `recipes/complex-task.md` — Multiple patterns, no routing
- `recipes/design-task.md` — Research + Architecture pattern workflow
- `recipes/feature-workflow.md` — Full development workflow
- `TROUBLESHOOTING.md` — Common issues and solutions

**Completion Criteria:**
- Users can complete common tasks with just pattern prompts
- No routing logic or agent coordination needed
- Examples are real and reproducible
- Workflows produce high-quality outputs

---

## Phase 5: Migrate Existing Agent Files (Soft Deprecation)

**Goal:** Keep agent files working but mark them as legacy and provide agentless equivalents.

**Tasks:**
1. Add deprecation notices to all agent files (`.agent.md`):
   - Link to equivalent pattern(s)
   - Explain why agentless is preferred
   - Show migration path
2. Refactor each agent file as a **wrapper** around composable patterns:
   - Manager becomes a simple decision tree (use pattern X? use pattern Y? combine patterns A+B?)
   - Specialized agents become pattern invocations (Coder → just use Implementation pattern)
3. Update `CLAUDE.md` to prefer patterns but still reference agents
4. Create migration guide for users currently using agent system:
   - How to replace Manager with pattern-based workflow
   - How to replace specialized agents with pattern prompts

**Deliverables:**
- Deprecation notices in all agent files
- Refactored agent files (simpler, wrapper-based)
- `MIGRATION_GUIDE.md` — How to move from agents to patterns
- Updated `CLAUDE.md` — Patterns as primary, agents as legacy
- `.context/tasks/DEPRECATION_TIMELINE.md` — When to fully retire agent files

**Completion Criteria:**
- All agents have deprecation notices
- Agent files still work but use patterns internally
- Migration guide is clear and step-by-step
- Users understand why patterns are preferred

---

## Phase 6: Validate Agentless Patterns at Scale

**Goal:** Test patterns on real-world tasks, gather feedback, and refine until they're production-ready.

**Tasks:**
1. Create validation test suite (`.context/tasks/VALIDATION_TESTS.md`):
   - Common task categories (planning, research, code, tests)
   - Success criteria for each
   - Baseline: current agent system performance
   - Target: agentless pattern performance
2. Run validation tests:
   - Each pattern independently
   - Patterns in combination (no coordination agent)
   - Against both simple and complex tasks
3. Collect metrics:
   - Output quality (accuracy, completeness)
   - Token efficiency (fewer prompts?)
   - User satisfaction (easier to use?)
   - Context usage (does `.context/` flow better?)
4. Refine patterns based on results:
   - Update prompts if weak areas identified
   - Add examples if confusion found
   - Simplify if overly complex
5. Document findings in `.context/retrospectives/`

**Deliverables:**
- `.context/tasks/VALIDATION_TESTS.md` — Test plan and baselines
- `.context/tasks/VALIDATION_RESULTS.md` — Test results and metrics
- Updated pattern files (refined based on validation)
- `.context/retrospectives/AGENTLESS_VALIDATION.md` — Lessons learned

**Completion Criteria:**
- Minimum 10 representative tasks tested (Standard rigor)
- All 6 patterns tested independently and in combination
- Metrics show agentless patterns match or exceed agent performance
- Patterns refined based on real-world feedback
- Team confidence high enough to proceed with deprecation

---

## Phase 7: Complete Migration & Cleanup

**Goal:** Full transition to agentless patterns, retire old agent system, finalize documentation.

**Tasks:**
1. Archive old agent files:
   - Move to `agents/_archive/` directory
   - Keep for reference only
   - Add archive notice explaining they're superseded by patterns
2. Reorganize main `README.md` as **hybrid** (patterns-first, agents as legacy):
   - Lead with patterns section: what they are, how to use them directly
   - Secondary section: legacy agents (kept for backward compatibility, point to archive)
   - Include link to migration guide for users still on agents
3. Update all examples and quick-start guides to use patterns by default
4. Clean up documentation:
   - Update `agents/_shared/handoff-protocol.md` — mark as legacy/archive, patterns replace it
   - Simplify `agents/_shared/conventions.md` reference — note canonical version is in `.context/patterns/_shared/conventions.md`
   - Consolidate to one source of truth (`.context/patterns/`)
5. Final documentation pass:
   - Ensure all paths and references work
   - Remove dead links
   - Validate all examples run
6. Update `CLAUDE.md` — patterns as primary, agents section points to archive
7. Create final migration checklist for teams converting their projects

**Deliverables:**
- `agents/_archive/` — Old agent files archived
- Updated `README.md` — Patterns-first structure
- `FINAL_MIGRATION_CHECKLIST.md` — For teams converting
- Updated `CLAUDE.md` — Points to patterns
- `.context/tasks/MIGRATION_COMPLETE.md` — Signed off, ready for projects

**Completion Criteria:**
- Old agent system fully archived (available in `agents/_archive/`, not deleted)
- README is hybrid: patterns lead, agents acknowledged as legacy alternative
- `CLAUDE.md` references patterns as primary system
- Migration path is clear for existing users
- All paths and references in docs are valid

---

## Rollback Strategy

If issues are discovered at any phase:
1. **Phase 1–3 issues:** No breaking changes yet. Refine analysis/patterns and continue.
2. **Phase 4–5 issues:** Keep patterns and agent system in parallel. Mark as "experimental" and continue refining.
3. **Phase 6 validation failures:** Refine patterns and re-test. **Stay agentless** — do not revert to agents as primary. The issue is almost always that a pattern needs to be *simpler*, not more complex.
4. **Phase 7 rollback:** If issues found after archive, restore agent files from `agents/_archive/`. Patterns remain in `.context/patterns/` for future use.

**Key Point:** If a pattern doesn't work, simplify it. Complexity is never the solution.

---

## Success Criteria (All Phases Complete)

✅ Users can accomplish all current workflows with patterns alone  
✅ Patterns are simpler than agents (fewer files, less routing logic)  
✅ Patterns produce equal or better quality outputs  
✅ Documentation clearly explains when/how to use each pattern  
✅ Old agent system archived and clearly marked as legacy  
✅ No runtime handoff state or orchestration needed  
✅ Context flows directly from `.context/` files (no agent intermediary)  
✅ Teams can migrate their projects easily with provided guides  

---

## Notes for Phase Implementation

- **Start with Phase 1–2:** These are documentation/analysis only. Low risk, high clarity.
- **Validate before retiring agents:** Don't deprecate until Phase 6 proves patterns work.
- **Keep examples real:** Use actual repo tasks to validate, not hypothetical ones.
- **Simplicity is the goal:** If a pattern gets complex, split it or simplify the task instead.
- **User feedback loop:** Gather feedback on patterns from actual use before full migration.
- **Context is key:** Invest in `.context/` structure — it replaces agent handoff state.
