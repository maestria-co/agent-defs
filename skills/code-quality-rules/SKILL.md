---
name: code-quality-rules
description: Use when conducting a code review and evaluating whether a change meets project quality standards.
user-invocable: false
---

# Code Quality Rules

## Overview

Defines the evaluation criteria, severity levels, and multi-pass methodology for code reviews. Apply these rules when reviewing any code change.

## Checklist

**Code Quality**: No commented-out code. No debug statements. Proper error handling (no swallowed exceptions). No hardcoded secrets. Clear naming. No magic numbers. DRY principle followed.

**Security**: No sensitive data in logs or error messages. User input validated/sanitized at trust boundaries. No SQL injection (use parameterized queries). No XSS (output encoding applied). No eval() or dynamic code execution. Auth/authz properly checked — verify that authorization is enforced at the service layer, not just the UI. Secrets not hardcoded or committed. New endpoints or data access paths have appropriate access controls. Changes to auth/authz logic get extra scrutiny — verify the change doesn't widen access unintentionally.

**Performance**: No N+1 query patterns. Resources properly cleaned up (connections, files, streams). Expensive operations not in hot paths.

**Testing**: Tests exist for new functionality. Assertions are meaningful (test real behavior, not mock existence). Edge cases covered. No test-only methods added to production classes. For changed decision points, check whether the standardized **Coverage Evidence Block** from `testing-discipline` is present and reasonably complete. Treat this as process guidance: note gaps as coaching feedback, not as an automatic blocker.

**Verification**: Build and test commands were actually run, not just assumed to pass. Output evidence is included or reproducible.

**Maintainability**: Methods not excessively long. Reasonable cyclomatic complexity. Clear separation of concerns. No circular dependencies.

## Severity Levels

**Critical**: Security vulnerabilities, data loss risk, crashes, breaking public API changes, incorrect business logic.

**Moderate**: Performance issues, missing error handling, missing tests for important paths, deviation from established patterns.

**Minor**: Style inconsistencies not caught by linters, documentation improvements, optional refactoring opportunities.

## Review Passes

For thorough reviews, evaluate changes through multiple focused passes rather than trying to catch everything in a single read. Each pass has a narrow focus that prevents important issues from being overlooked.

### Pass 1: Correctness & Logic
- Does the code do what the specification requires?
- Are there off-by-one errors, null/undefined paths, or race conditions?
- Are error states handled, not just happy paths?
- Does the control flow match the intended behavior?

### Pass 2: Security & Trust Boundaries
- Is user input validated before use?
- Are authorization checks present at the service layer (not just UI)?
- Are secrets, tokens, or PII handled safely (not logged, not exposed)?
- Do new endpoints or data paths have appropriate access controls?
- Are SQL queries parameterized? Is output encoded to prevent XSS?

### Pass 3: Integration & Side Effects
- How do these changes interact with existing code?
- Are there unintended side effects on callers or consumers?
- Do changes to shared utilities affect other modules?
- Are database migrations backward-compatible?
- Are API contract changes backward-compatible?

### Pass 4: Maintainability & Clarity
- Would a new team member understand this code without the PR description?
- Are names descriptive and consistent with project conventions?
- Is complexity justified, or could the same result be achieved more simply?
- Are there magic numbers, unclear abbreviations, or misleading names?

### Pass 5: Evidence & Completeness
- Did the implementer run the build and include output?
- Do tests exist for new behavior, and do test assertions verify real outcomes?
- Are all requirements from the task specification addressed?
- Is there scope creep — changes beyond what was specified?

### When to Use All Passes

**Full multi-pass review**: New features, cross-module changes, security-sensitive code, public API changes.

**Abbreviated review (Passes 1, 4, 5 only)**: Single-file bug fixes, documentation changes, configuration changes, test additions.

The review output format should still use the standard Findings structure (Critical / Moderate / Minor), but consider which pass uncovered each finding — this helps the author understand the nature of the issue.
