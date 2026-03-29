---
name: impact-assessor
description: >
  Use when evaluating the impact of a proposed change before implementing it.
  Triggers on "what's the impact of changing X", "assess this change", "what
  breaks if we modify Y", "how risky is this refactor", or before any
  non-trivial code change.
---

# Skill: Impact Assessor

## Purpose

Systematically assess the scope, risk, and dependencies of a proposed change before
coding begins. Prevents surprises mid-implementation and surfaces hidden coupling.

---

## Process

### 1. Scope Analysis

**Direct impact:**

- Which files and modules are being modified?
- What functions/classes/exports are being changed?

**Indirect impact:**

- What depends on the modified code? (search for imports/usages)
- Are there upstream callers that will be affected?
- Are there downstream consumers of this API?

**Data impact:**

- Does this change database schemas, migrations, or data flow?
- Does this affect stored data formats or serialization?
- Are there data migrations required?

### 2. Risk Analysis

Use this checklist to evaluate risk categories:

- [ ] **Breaking changes** — Does this modify a public API, exported function signature, or contract?
- [ ] **Performance impact** — Does this add new queries, loops, or resource usage?
- [ ] **Security impact** — Does this touch authentication, authorization, input handling, or data exposure?
- [ ] **Operational impact** — Does this require config changes, env vars, or deployment coordination?
- [ ] **Compatibility** — Does this affect backward compatibility or integrations?

### 3. Dependency Analysis

**Upstream dependencies:**

- What does this change depend on that might not be ready?
- Are there feature flags, config, or infrastructure prerequisites?

**Downstream consumers:**

- Who consumes this code?
  - Internal callers (search codebase)
  - External API consumers (check API documentation, contracts)
  - Third-party integrations

**External systems:**

- Are third-party integrations affected?
- Do webhook payloads, API contracts, or data formats change?

### 4. Testing Requirements

Identify what must be tested:

**Unit tests:**

- [ ] What new tests are needed for the changed code?
- [ ] Do existing tests need updates?

**Integration tests:**

- [ ] What cross-component flows need verification?
- [ ] Are there end-to-end scenarios that could break?

**Manual testing:**

- [ ] What user-facing scenarios must be verified?
- [ ] Are there edge cases that require manual validation?

### 5. Effort Estimate

| Size | Description                        | Example                            |
| ---- | ---------------------------------- | ---------------------------------- |
| S    | < 2 hours, isolated change         | Fix typo, update config            |
| M    | Half day, single component         | Add validation, refactor one class |
| L    | 1-2 days, multiple components      | New feature, API change            |
| XL   | Multiple days, cross-cutting       | Architecture change, major refactor|

### 6. Go/No-Go Recommendation

Based on the analysis above:

- **Proceed** — Low risk, clear scope, no blockers
- **Proceed with caution** — Medium risk, needs monitoring or staged rollout
- **Needs design** — High complexity or risk, requires architectural review
- **Do not proceed** — Critical risk, dependencies not ready, or fundamentally flawed

---

## Output Format

```
## Impact Assessment: [change description]

Risk level: [Low | Medium | High | Critical]
Effort: [S | M | L | XL]

### Scope
- Direct: [files/modules being modified]
- Indirect: [consumers/dependents that will be affected]
- Data: [migrations/schema changes, or "none"]

### Risks
- [risk description] — Severity: [Low/Medium/High/Critical] — Mitigation: [how to address]
- [risk description] — Severity: [Low/Medium/High/Critical] — Mitigation: [how to address]

### Dependencies
- Upstream: [what this change needs to function]
- Downstream: [who/what consumes this code]
- External: [third-party integrations affected, or "none"]

### Testing Required
- [ ] [specific test scenario or suite]
- [ ] [specific test scenario or suite]
- [ ] [manual testing steps if needed]

### Recommendation
[Proceed | Proceed with caution | Needs design | Do not proceed]

Reason: [1-2 sentences explaining the recommendation]
```

---

## Constraints

- **Never skip the downstream dependency check** — that's where hidden breakage hides
- If risk level is **High** or **Critical**, recommend `@architect` review before proceeding
- Effort estimates are **not deadlines** — they are risk signals for planning
- Differentiate between "this is hard" (effort) and "this is dangerous" (risk)
- If you cannot assess impact without making the change, recommend a spike or prototype first
- Do not proceed with implementation if recommendation is "Needs design" or "Do not proceed"
