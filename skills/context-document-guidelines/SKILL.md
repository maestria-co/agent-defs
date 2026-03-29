---
name: context-document-guidelines
description: |
  Use when creating or updating .context/ documentation to ensure it meets quality
  standards. Triggers on "how should I document this", "create a context doc for X",
  "update the context docs", or when reviewing .context/ files for quality.
---

# Skill: Context Document Guidelines

## Purpose

Ensure `.context/` documentation is specific, accurate, and actually useful to agents —
not generic advice that adds noise without reducing uncertainty.

## Quality Principles

1. **Document what's non-obvious** — Skip language basics and framework docs that any developer knows. Document THIS project's choices.
2. **Always include real examples** — Real file paths, real function names, real code patterns from THIS codebase — not hypothetical examples.
3. **Explain "why", not just "what"** — "We use repository pattern because our domain logic must be testable without a database" beats "We use repository pattern."
4. **Keep atomic** — One facet per file. Don't mix auth patterns with error handling in the same doc.
5. **Stay current** — Outdated docs are worse than no docs — they actively mislead agents.

## Quality Checklist

**Good context doc (all must be true):**
- [ ] Specific to this project (not generic advice applicable to any codebase)
- [ ] Contains real file paths and function names from the actual codebase
- [ ] Explains rationale behind patterns, not just the pattern itself
- [ ] Has concrete examples showing the pattern in use
- [ ] Identifies common mistakes or pitfalls specific to this codebase

**Bad context doc (rewrite or delete):**
- Generic advice applicable to any project
- No examples or references to actual code
- Only describes "what" without "why"
- Not reviewed in more than 3 months
- Duplicate of what's already in `.github/copilot-instructions.md`

## Document Template

```markdown
# [Topic]

## Purpose
[What does this document help agents do? 1 sentence.]

## Key Concepts
[2-5 core concepts with THIS project's terminology]

## Patterns
[How things are done in this project — with real file path examples]

## Examples
[Actual code patterns from the codebase with file:line references]

## Pitfalls
[Common mistakes in THIS codebase and how to avoid them]
```

## File Placement

| Directory | Content |
|---|---|
| `domains/` | Business and technical domain knowledge |
| `standards/` | Coding conventions and project-specific patterns |
| `testing/` | Test strategies, mock patterns, test data setup |
| `architecture/` | System design, ADRs, structural patterns |
| `workflows/` | CI/CD, branching, deployment, release process |

## Maintenance Triggers

- **Create** after completing a task in a new area of the codebase
- **Update** when discovering a pattern violation or learning something new about a domain
- **Review** when a context doc is older than 3 months

## Constraints

- Never write a context doc that applies to every project equally — if it could be copy-pasted into any codebase unchanged, it doesn't belong here.
- Every doc must have at least one real file path or code reference from the actual codebase.
- Do not duplicate content from `.github/copilot-instructions.md` or README.
