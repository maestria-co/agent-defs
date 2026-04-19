---
name: agent-evaluation
description: Use when evaluating or auditing an agent system design, reviewing agent definitions for role overlap or responsibility leakage, or when orchestrator routing clarity, skill responsibility, or sub-agent job clarity is in question.
user-invocable: true
---

# Agent System Evaluation

## Overview

**Clean separation is the difference between a system that scales and one that decays.** Each problem has one owner; each skill does one thing; the orchestrator is the only routing intelligence.

## When to Use

- Designing a new agent system from scratch
- Reviewing existing agent definitions for overlap or creep
- Debugging unexpected agent behavior that may be a structural problem
- Before sharing or publishing an agent system

---

Evaluate the provided agent system against these 5 rules:

RULE 1 — PROMPT vs SKILL SEPARATION
- Decision logic, reasoning rules, and "when to do X" → must live in agent system prompts
- Output formatting, templates, API calls → must live in skill definitions
- Flag any rules or logic found inside skill definitions that should be in a prompt
- Flag any formatting or templates found in system prompts that should be in a skill

RULE 2 — SINGLE SOURCE OF TRUTH
- Each rule or constraint must exist in exactly ONE place
- Flag any rule, guideline, or constraint that appears in more than one place
- Flag any behaviour that could be governed by two different instructions simultaneously

RULE 3 — SUB-AGENT JOB CLARITY
- Each sub-agent must have ONE clearly defined job expressed as a question it answers
- Its output must directly serve the orchestrator before the skill is called
- Flag any sub-agent whose job overlaps with another sub-agent
- Flag any sub-agent whose output goes directly to a skill instead of back to the orchestrator
- Flag any sub-agent whose job is vague or could be interpreted multiple ways

RULE 4 — SKILL RESPONSIBILITY
- A skill must do ONE thing (format/call/return)
- A skill must not contain reasoning, decision logic, or conditional behaviour
- A skill must have a clear, structured return schema
- Flag any skill that is making decisions rather than executing them
- Flag any skill whose rules change depending on what the agent is trying to do

RULE 5 — ORCHESTRATOR CLARITY
- The orchestrator must own all routing decisions
- The orchestrator must be the only agent that calls the final skill
- The orchestrator must assemble all sub-agent outputs before calling the skill
- Flag any routing logic that lives outside the orchestrator
- Flag any case where a sub-agent could trigger the final skill directly

---

For each rule, respond in this format:

RULE [N] — [PASS / WARNING / FAIL]
Finding: [what you found]
Problem: [why it matters]
Fix: [specific change to make]

---

After evaluating all 5 rules, give:

OVERALL HEALTH: [CLEAN / NEEDS WORK / RESTRUCTURE REQUIRED]

PRIORITY FIXES: (ordered by what to fix first)
1. [most critical fix]
2. [next fix]
3. [etc.]

OPEN QUESTIONS: (things to clarify about the system before fixing it)
1. [question]
2. [etc.]
