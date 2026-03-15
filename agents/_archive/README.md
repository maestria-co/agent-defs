# agents/_archive

> **This directory contains the legacy multi-agent system.** It has been superseded by the agentless pattern system in `.context/patterns/`.

These files are kept for reference and backward compatibility. They still work — they are not broken or invalid. But the recommended approach is to use patterns directly.

---

## Why Archived

The agent system required routing all requests through a Manager, which then handed off to specialists. The agentless pattern system eliminates this overhead — you select the right pattern directly and run it.

The valuable parts of the agent system (XML tag conventions, self-verify discipline, stopping conditions, handoff examples) were extracted into the patterns and shared conventions. Nothing of substance was lost.

---

## Archived Files

| File | Was | Pattern equivalent |
|---|---|---|
| `manager.agent.md` | Workflow orchestrator | `.context/patterns/coordinating-work/SKILL.md` + direct pattern selection |
| `architect.agent.md` | System designer | `.context/patterns/designing-systems/SKILL.md` |
| `planner.agent.md` | Task decomposer | `.context/patterns/planning-tasks/SKILL.md` |
| `researcher.agent.md` | Technical investigator | `.context/patterns/researching-options/SKILL.md` |
| `coder.agent.md` | Senior developer | `.context/patterns/implementing-features/SKILL.md` |
| `tester.agent.md` | QA engineer | `.context/patterns/writing-tests/SKILL.md` |

---

## If You Need These

Invoke them as you always did — they still work. But see `MIGRATION_GUIDE.md` to switch to patterns, which produce equivalent results with less overhead.

**To restore to active use:** Move any file back to `agents/` and update `CLAUDE.md`. That's the entire rollback.
