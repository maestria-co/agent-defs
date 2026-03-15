# Agentless Conversion: Visual Roadmap

## Current vs. Target Architecture

### Current System (Agent-Based)

```
┌─────────────────────────────────────────────────┐
│                    USER REQUEST                  │
└────────────────────┬────────────────────────────┘
                     │
                     ▼
┌─────────────────────────────────────────────────┐
│          MANAGER AGENT (Routing Logic)           │
│  - Reads request                                │
│  - Decides which agents to route to              │
│  - Manages handoff state                         │
│  - Synthesizes results                           │
└─┬─────────────┬─────────────┬──────────┬────────┘
  │             │             │          │
  ▼             ▼             ▼          ▼
┌─────────┐ ┌────────────┐ ┌────────────┐ ┌────────┐
│ PLANNER │ │ RESEARCHER │ │ ARCHITECT  │ │ CODER  │
│ Agent   │ │ Agent      │ │ Agent      │ │ Agent  │
└────┬────┘ └────────────┘ └────────────┘ └───┬────┘
     │                                         │
     └─────────────┬──────────────────────────┘
                   │
                   ▼
            ┌──────────────┐
            │ TESTER AGENT │
            └──────────────┘
                   │
                   ▼
        (Complex handoff state flow)
                   │
                   ▼
       ┌──────────────────────┐
       │   Result synthesized  │
       │   by Manager          │
       └──────────────────────┘
                   │
                   ▼
            ┌────────────────┐
            │  USER RESPONSE │
            └────────────────┘
```

**Complexity:**
- 6 agents with distinct responsibilities
- Manager handles routing and state
- Complex handoff protocol between agents
- State accumulates through handoff chain

---

### Target System (Agentless Patterns)

```
┌─────────────────────────────────────────────────┐
│                    USER REQUEST                  │
└────────────────────┬────────────────────────────┘
                     │
        Identify which pattern(s) apply
                     │
        ┌───────────┬┴────────────┬──────────┐
        │           │             │          │
        ▼           ▼             ▼          ▼
    ┌────────┐ ┌────────┐ ┌────────┐ ┌────────┐
    │Planning│ │Research│ │Architecture│ │Implementation│
    │Pattern │ │Pattern │ │Pattern │ │Pattern │
    └────────┘ └────────┘ └────────┘ └────────┘
        │           │             │          │
        └───────────┼─────────────┼──────────┘
                    │
              Compose if needed
                    │
                    ▼
            ┌──────────────┐
            │Testing       │
            │Pattern       │
            └──────────────┘
                    │
                    ▼
        ┌──────────────────────┐
        │   Results from direct │
        │   pattern application │
        └──────────────────────┘
                    │
                    ▼
            ┌────────────────┐
            │  USER RESPONSE │
            └────────────────┘
```

**Simplicity:**
- 5 patterns (planning, research, architecture, implementation, testing)
- Direct pattern selection based on task type
- No routing agent or handoff state
- Context flows from `.context/` files, not agent-to-agent
- Users compose patterns as needed

---

## Transformation by Phase

```
Phase 1: ANALYSIS
┌──────────────────────────────────┐
│ Current system documented        │
│ Patterns identified in agents    │
│ Mapping created                  │
└──────────────────────────────────┘
            │
            ▼
Phase 2: PATTERNS EXTRACTED
┌──────────────────────────────────┐
│ .context/patterns/ created        │
│ 6 SKILL.md files written          │
│ Gerund naming (planning-tasks/)   │
│ Shared conventions extracted      │
└──────────────────────────────────┘
            │
            ▼
Phase 3: CONTEXT + TEMPLATE ALIGNED
┌──────────────────────────────────┐
│ .context/ updated for patterns    │
│ No agent state in context         │
│ Pattern-specific knowledge added  │
│ context_template/ updated         │
└──────────────────────────────────┘
            │
            ▼
Phase 4: USER GUIDES
┌──────────────────────────────────┐
│ Quick-start guide created         │
│ Workflow recipes written          │
│ Troubleshooting docs added        │
└──────────────────────────────────┘
            │
            ▼
Phase 5: SOFT DEPRECATION
┌──────────────────────────────────┐
│ Agent files marked legacy         │
│ Agents refactored as wrappers     │
│ Migration guide provided          │
│ Parallel system active            │
└──────────────────────────────────┘
            │
            ▼
Phase 6: VALIDATION
┌──────────────────────────────────┐
│ Patterns tested at scale          │
│ Metrics collected                 │
│ Patterns refined                  │
│ ✓ Passes validation               │
└──────────────────────────────────┘
            │
            ▼
Phase 7: MIGRATION COMPLETE
┌──────────────────────────────────┐
│ Old agents archived (_archive/)   │
│ README: hybrid (patterns primary) │
│ CLAUDE.md points to patterns      │
│ Teams have migration checklist    │
│ ✓ Agentless system live           │
└──────────────────────────────────┘
```

---

## Pattern Overview

### Planning Pattern
**When:** Need to break a goal into concrete, ordered tasks  
**Input:** A goal or requirement  
**Output:** Ordered task list with dependencies  
**Replaces:** Planner agent  

### Research Pattern
**When:** Need to evaluate options, fill knowledge gaps, or compare approaches  
**Input:** A decision or question  
**Output:** Analysis with recommendation  
**Replaces:** Researcher agent  

### Architecture Pattern
**When:** Making system design decisions, tech choices, or writing ADRs  
**Input:** A design question or decision  
**Output:** Design document or ADR  
**Replaces:** Architect agent  

### Implementation Pattern
**When:** Writing or modifying code from specifications  
**Input:** Detailed specification or requirement  
**Output:** Code with minimal explanation  
**Replaces:** Coder agent  

### Testing Pattern
**When:** Writing tests or validating implementations  
**Input:** Code to test or validation requirements  
**Output:** Tests and quality assessment  
**Replaces:** Tester agent  

### Coordination Pattern (Lightweight)
**When:** Orchestrating multiple patterns for complex tasks (optional)  
**Input:** Complex task requiring multiple patterns  
**Output:** Composed results  
**Note:** Use sparingly — most tasks use 1–2 patterns directly  

---

## Key Metric: Simplification

| Aspect | Current | Target | Reduction |
|---|---|---|---|
| Agent files | 6 | 0 (archived, not deleted) | 100% active |
| Pattern SKILL.md files | 0 | 6 | — |
| Routing logic lines | ~300 | ~0 | 100% |
| Handoff protocol doc | Yes | Archived | 100% active |
| Context files | ~10 | ~15 (richer, not agent state) | — |
| Entry point complexity | "Which agent?" | "Which pattern?" | Simpler |
| Learning time for new user | 30+ min | 10–15 min | 50% reduction |

**Result:** Fewer, simpler files with more direct utility.

---

## Risk Profile by Phase

```
Phase 1 (Analysis)      ████░░░░░░ MINIMAL   (docs only, no changes)
Phase 2 (Patterns)      ████░░░░░░ MINIMAL   (new docs, existing agents stay)
Phase 3 (Context)       █████░░░░░ LOW       (additive changes)
Phase 4 (Guides)        █████░░░░░ LOW       (reference docs)
Phase 5 (Deprecation)   ██████░░░░ LOW-MED   (agents still work, marked legacy)
Phase 6 (Validation)    ███████░░░ MEDIUM    (real testing required)
Phase 7 (Cleanup)       █████░░░░░ LOW       (only if phase 6 passes)
```

**Mitigation:**
- Phases 1–4 are safe (no breaking changes)
- Phase 5 keeps both systems working in parallel
- Phase 6 validates before any retirement
- Phase 7 is cleanup only after validation

---

## Timeline Approach

**No estimates given.** Each phase is a logical unit.

- **1–2 days:** Phases 1–3 (analysis and foundation)
- **1–2 days:** Phase 4 (guides and examples)
- **1 day:** Phase 5 (mark legacy, add guides)
- **2–3 days:** Phase 6 (validation and refinement)
- **1 day:** Phase 7 (archive and cleanup)

**Actual timeline:** Depends on team size, validation rigor, and whether issues emerge.

---

## Go/No-Go Decision Points

| Checkpoint | Criteria | Go If | No-Go Action |
|---|---|---|---|
| After Phase 3 | Context structure ready for patterns? | Patterns have required context access | Refine .context/ more |
| After Phase 6 | Do patterns pass validation (10+ tasks)? | Quality ≥ agents, simpler to use | Refine patterns and re-test (stay agentless) |

**Key Philosophy:** If patterns don't work better, the issue is that they need to be *simpler*, not more complex. Simplify rather than add features. Never revert to agent routing as the primary system.

---

## File Structure After Conversion

```
agent-defs/
├── .context/
│   ├── patterns/                    ← NEW: Agentless patterns (primary system)
│   │   ├── _shared/
│   │   │   └── conventions.md       (drawn from agents/_shared/conventions.md)
│   │   ├── planning-tasks/
│   │   │   └── SKILL.md             ← Replaces planner.agent.md
│   │   ├── researching-options/
│   │   │   └── SKILL.md             ← Replaces researcher.agent.md
│   │   ├── designing-systems/
│   │   │   └── SKILL.md             ← Replaces architect.agent.md
│   │   ├── implementing-features/
│   │   │   └── SKILL.md             ← Replaces coder.agent.md
│   │   ├── writing-tests/
│   │   │   └── SKILL.md             ← Replaces tester.agent.md
│   │   ├── coordinating-work/
│   │   │   └── SKILL.md             ← Replaces manager.agent.md (lightweight)
│   │   └── GUIDE.md                 (when to use each pattern, how to compose)
│   │
│   ├── tasks/                       (this plan and phase outputs)
│   ├── decisions/
│   ├── retrospectives/
│   └── project-overview.md
│
├── _skills/                         ← EXISTING: Utility skills (unchanged)
│   ├── context-review/
│   │   └── SKILL.md
│   └── evaluate-skill/
│       └── SKILL.md
│
├── agents/
│   └── _archive/                    ← OLD: Legacy agents (never deleted)
│       ├── manager.agent.md
│       ├── planner.agent.md
│       ├── researcher.agent.md
│       ├── architect.agent.md
│       ├── coder.agent.md
│       ├── tester.agent.md
│       ├── _shared/
│       └── README.md                (archive notice)
│
├── recipes/                         ← NEW: Workflow examples
│   ├── simple-task.md
│   ├── complex-task.md
│   ├── design-task.md
│   └── feature-workflow.md
│
├── context_template/                ← UPDATED: References patterns, not agents
│
├── QUICK_START.md                   ← NEW: Direct path to patterns
├── MIGRATION_GUIDE.md               ← NEW: For teams converting
├── TROUBLESHOOTING.md               ← NEW: Common issues
├── README.md                        (hybrid: patterns primary, agents as legacy)
├── CLAUDE.md                        (updated: patterns as primary, agents in archive)
└── ...

```

---

## Summary

This plan converts a **6-agent system** with complex routing into a **5-pattern system** with direct composition. It's designed to be:

- **Safe:** 7 phased steps, validation before retirement
- **Clear:** Explicit deliverables and success criteria for each phase
- **Maintainable:** Simpler patterns replace complex agents
- **User-friendly:** Quick-start guides and recipes show how to use directly

**Let's proceed to Phase 1 when you're ready.**
