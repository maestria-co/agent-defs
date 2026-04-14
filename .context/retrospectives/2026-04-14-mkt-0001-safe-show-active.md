# Task MKT-0001: Fix "Show Active" Command Security Issue

**Date:** 2026-04-14
**Type:** Bugfix
**Duration:** ~2 hours

## Problem
Manager agent generated unsafe shell code with heredoc + nested command substitution when executing "show active" command, triggering security blocks.

## Solution
Updated `agents/manager.agent.md` with explicit safe implementation guidance using jq with pre-assigned variables.

## Key Lessons

### Lesson 1: Agent definitions need explicit implementation examples, not just requirements
- Agents perform better when shown concrete, safe patterns rather than abstract requirements
- Providing code examples reduces ambiguity and prevents agents from generating unsafe alternatives

### Lesson 2: Security-sensitive operations require safe pattern documentation
- Operations involving shell execution, code generation, or data handling need documented safe patterns
- Security blocks are effective early-warning systems that catch issues before production

### Lesson 3: Runtime code generation needs safety guardrails
- When agents generate executable code, provide explicit safe patterns and constraints
- Pre-assignment and separation of data from code logic prevents injection vulnerabilities

## What Went Well
- **Clear root cause identification:** Quickly identified that manager agent was generating heredoc + nested substitution
- **Simple, elegant solution:** Using jq with pre-assigned variables avoided complex escaping logic
- **Fast performance:** Final implementation executed in ~17ms with consistent results
- **Minimal scope:** Fix required only documentation updates, no breaking changes

## What to Improve
- **Safe pattern library:** Create a centralized `.context/patterns/safe-shell-operations.md` documenting recommended patterns for JSON parsing, timestamp formatting, command execution
- **Agent definition audit:** Review other agent definitions (Coder, Architect, Product-Manager) for similar code generation risks
- **Security testing:** Add smoke tests that verify generated code passes security validation

## Artifacts
- **Updated:** `agents/manager.agent.md` (Step 0 section with safe jq implementation)
- **Created:** `.context/tasks/MKT-0001/plan.md` (task planning and exploration)
- **Created:** `.context/retrospectives/2026-04-14-mkt-0001-safe-show-active.md` (this file)

## Follow-up Actions
1. Create safe shell patterns documentation
2. Audit remaining agent definitions for code generation risks
3. Consider adding pre-execution validation step for generated shell commands
