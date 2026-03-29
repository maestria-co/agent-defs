---
name: tech-release-research
description: >
  Use when researching the requirements and feasibility of an upcoming release.
  Triggers on "what do we need to do to release X", "is X ready to release",
  "what are the blockers for this release", or when planning the release of a
  specific version.
---

# Skill: Tech Release Research

## Purpose

Systematically evaluate readiness for a release before committing to a deployment window.

---

## Process

### 1. Scope the release

List all tickets/PRs included in this release and confirm they are merged

### 2. Check test coverage

- Are all acceptance criteria tested?
- Any known failing tests?

### 3. Check feature flags

- Are incomplete features properly gated?
- Will any flags need to be updated post-deploy?

### 4. Identify configuration changes

- New env vars, changed defaults, secrets rotation needed?

### 5. Check for data migrations

- Pending migrations?
- Migration performance tested on production-scale data?

### 6. Identify service dependencies

- Any downstream services that need updating first?
- Coordinated deployments?

### 7. Assess risk level

- **Low**: bug fixes, internal changes
- **Medium**: new features, performance
- **High**: breaking changes, migrations, architecture changes

### 8. Recommend

Go / No-Go / Go with conditions

---

## Output Template

```
## Release Research: v[X.Y.Z]

Included changes: [N tickets/PRs]
Risk level: [Low | Medium | High]

Blockers (must resolve before release):
- [blocker description]

Watch items (monitor after deploy):
- [item to watch]

Configuration changes needed: [None | list]
Migration required: [No | Yes — details]

Recommendation: [Go | No-Go | Go with conditions]
Conditions (if any): [what must be true before proceeding]
```

---

## Constraints

- Any blocker is a hard No-Go
- Conditions must be binary and checkable
- Do not recommend Go with unresolvable unknowns
