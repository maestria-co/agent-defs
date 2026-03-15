# Final Migration Checklist

> For teams converting their projects from the legacy agent system to agentless patterns.
> Work through this in order. Each section has a gate — don't move forward until it's clear.

---

## 1. Setup (15 minutes)

- [ ] Clone or pull latest `agent-defs` — confirm `.context/patterns/` exists
- [ ] Read `QUICK_START.md` — understand the 6 patterns and prompt templates
- [ ] Read `.context/patterns/GUIDE.md` — understand pattern selection
- [ ] Verify `.context/project-overview.md` is current in your project

**Gate:** You can name which pattern to use for: a new feature, a library question, a bug fix.

---

## 2. First Pattern Run (1 hour)

Pick a real task from your backlog. Use the appropriate pattern.

- [ ] Create `.context/tasks/[TASK-ID]/brief.md` with goal + acceptance criteria
- [ ] Run the pattern using a prompt from `QUICK_START.md`
- [ ] Verify output matches success criteria
- [ ] Write back to `.context/` (ADR, plan, or research as appropriate)
- [ ] Commit the output

**Gate:** Pattern produced useful output. You did NOT need to invoke a Manager or use the agent system.

---

## 3. Chain Patterns (half day)

Run a 2-3 pattern workflow using a recipe from `recipes/`.

- [ ] Choose recipe: `simple-task`, `complex-task`, `design-task`, or `feature-workflow`
- [ ] Follow the recipe step-by-step
- [ ] Verify each pattern output before starting the next
- [ ] Confirm `.context/` files are being written after each pattern

**Gate:** Completed a multi-step workflow without the Manager agent. Context flowed via `.context/` files.

---

## 4. Update Project Configuration (30 minutes)

Update your project's AI configuration to prefer patterns:

- [ ] Update `CLAUDE.md` — add patterns section (see `agent-defs/CLAUDE.md` for template)
- [ ] Update `.github/copilot-instructions.md` — add `.context/patterns/` reference
- [ ] Remove or deprioritize any `Use the manager agent` instructions in project docs

**Gate:** Your AI tools load pattern context automatically at session start.

---

## 5. Team Onboarding (if applicable)

- [ ] Share `QUICK_START.md` with team
- [ ] Share relevant recipe(s) for your team's common workflows
- [ ] Share `TROUBLESHOOTING.md` — especially "Pattern Selection" section
- [ ] Answer first-time questions using `MIGRATION_GUIDE.md` as reference

**Gate:** Every team member has run at least one pattern independently.

---

## 6. Retire Agent References (when comfortable)

After your team is comfortable with patterns:

- [ ] Remove `agents/` from your project (if you copied them in)
- [ ] Remove any "Use the [agent] agent" instructions from your project docs
- [ ] Update retrospectives in `.context/retrospectives/` with lessons from migration

**Gate:** Team has used patterns on 5+ real tasks. No agent fallback needed.

---

## Rollback (if needed)

The agent files are in `agents/_archive/` in this repo and still work. To roll back any specific task:

1. Copy the relevant agent file from `agents/_archive/` to `agents/`
2. Invoke it as you did before
3. File a note in `.context/retrospectives/` about what the pattern failed to do — this becomes a pattern improvement

We do not recommend reverting your whole project to agent-based workflows. If a pattern is failing, it almost always means the prompt needs more context, not that patterns don't work.

---

## Done

When all sections above are complete:

- [ ] Add a retrospective entry: what changed, what you learned
- [ ] Promote any lessons to `.context/standards/` or `.context/architecture/`
- [ ] Consider contributing pattern improvements back to `agent-defs`
