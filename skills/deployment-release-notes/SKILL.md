---
name: deployment-release-notes
description: >
  Use when generating release notes for a deployment or version release.
  Triggers on "write release notes", "generate changelog", "what changed in
  this release", or preparing for a deployment.
---

# Skill: Deployment Release Notes

## Purpose

Generate structured, user-readable release notes from git history, merged PRs, and resolved tickets. Prevents vague or missing release communication.

---

## Process

1. **Gather changes since last release**
   - Run `git log [last-tag]..HEAD --oneline`
   - List merged PRs
   - List resolved tickets linked in commits

2. **Categorize each change**
   - Features (new functionality)
   - Bug Fixes
   - Performance
   - Breaking Changes
   - Dependencies updated
   - Internal/Dev-only

3. **Write a brief summary paragraph** for this release (1-3 sentences on the headline changes)

4. **Format the release notes** using the template below

5. **Flag any breaking changes prominently** at the top, not buried in sections

6. **Include deployment instructions** if the release requires migration steps or config changes

---

## Release Notes Template

```
## Version X.Y.Z — YYYY-MM-DD

> [1-sentence release summary]

### ⚠️ Breaking Changes
- [TICKET-ID] [Description of breaking change and migration action required]

### Features
- [TICKET-ID] [Description] (author if relevant)

### Bug Fixes
- [TICKET-ID] [Description]

### Performance
- [Description]

### Dependencies
- Updated [package] from X to Y — [reason]

### Internal
- [Changes that don't affect users but matter to developers]
```

---

## Constraints

- Breaking changes must appear at the top, not buried
- Every entry should link to a ticket or PR where one exists
- Internal changes are optional
- Do not include WIP commits or merge commits in user-facing notes
