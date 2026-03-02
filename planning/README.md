# Agent System Rebuild Guide

A step-by-step guide to rebuilding a multi-agent orchestration system for GitHub Copilot based on the patterns and lessons learned from the original system.

## Overview

This guide breaks down the rebuild process into 4 iterative phases. Total estimated time: 5-9 days.

The original system was built through research and iteration, achieving a 76% reduction in agent instruction length (v1.0 → v2.0) by following the "earn your place" principle.

## Phases

| Phase | Duration | Goal |
|-------|----------|------|
| [Phase 1: Research & Planning](phase-1-research-planning.md) | 1-2 days | Study sources, define roles, make design decisions |
| [Phase 2: Build Minimal Agents](phase-2-build-minimal-agents.md) | 2-3 days | Create 3 core agents (manager, coder, tester) |
| [Phase 3: Build Context Template](phase-3-build-context-template.md) | 1-2 days | Create .context/ directory structure and templates |
| [Phase 4: Test & Iterate](phase-4-test-iterate.md) | Ongoing | Test with real projects, refine based on results |

## Quick Start

1. **Read all phase files first** to understand the full scope
2. **Start with Phase 1** - don't skip the research
3. **Build incrementally** - resist the urge to build all 7 agents at once
4. **Test ruthlessly** - the testing phase is where real learning happens
5. **Embrace iteration** - your v1.0 will be verbose; that's expected

## Key Principles

From the original system's evolution:

### 1. Earn Your Place
Every line in an agent definition must prevent a concrete mistake. If it's not preventing errors or clarifying ambiguity, cut it.

### 2. File-Based Context
Use `.context/` directory for knowledge storage. Tool-agnostic, version-controlled, permanent.

### 3. Separation of Concerns
- `.github/copilot-instructions.md` → Big picture (tech stack, overview, key commands)
- `.context/` → Detailed knowledge (patterns, standards, domain docs)

### 4. Retrospective Learning
Lessons from completed tasks get promoted from `retrospectives.md` to permanent documentation in `.context/` subdirectories.

### 5. Concise Over Comprehensive
Better to have 50 lines of precise instructions than 200 lines of verbose guidance that gets ignored.

## What You'll Build

### 7 Agent Definitions
- **manager.agent.md** (~125 lines) - Orchestrator
- **planner.agent.md** (~60 lines) - Task breakdown
- **architect.agent.md** (~85 lines) - Structural decisions
- **coder.agent.md** (~50 lines) - Implementation
- **tester.agent.md** (~45 lines) - Test creation and execution
- **reviewer.agent.md** (~75 lines) - Code review
- **researcher.agent.md** (~100 lines) - Documentation research

### Context Template System
```
context_template/
├── README.md
├── SETUP_PROMPT.md
└── context/
    ├── META.md
    ├── retrospectives.md
    ├── standards/
    ├── architecture/
    ├── testing/
    ├── domains/
    └── workflows/
```

## Success Metrics

Track these as you build:

- **Line count reduction**: Target 50-75% from v1 to final version
- **Task success rate**: 80%+ of tasks completed correctly by appropriate agent
- **Context usage**: Agents reference `.context/` files regularly
- **No repeated mistakes**: Same error shouldn't occur 3+ times
- **Handoff clarity**: Agent-to-agent transitions should be smooth

## Alternative Approach: Single Mega-Prompt

If you prefer to generate everything at once instead of iteratively, see the mega-prompt in [phase-2-build-minimal-agents.md](phase-2-build-minimal-agents.md). However, the iterative approach is recommended as it mirrors how the original system was successfully built.

## Research Sources

The original system was informed by:
- Anthropic Claude Code best practices (code.claude.com)
- Anthropic agent harness patterns
- Analysis of 2,500+ GitHub repositories
- Multi-agent frameworks (AutoGen, LangChain, Azure AI)

## Next Steps

1. **Start with [Phase 1: Research & Planning](phase-1-research-planning.md)**
2. Work through each phase in order
3. Don't skip the testing/iteration phase
4. Document your own lessons learned
5. Share back what works (and what doesn't)

## Questions?

Each phase file includes:
- Detailed steps
- Generation prompts you can copy-paste
- Quality checklists
- Deliverables list

Work through them sequentially and you'll have a working multi-agent system.
