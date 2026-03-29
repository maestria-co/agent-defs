---
name: deployment-release-research
description: >
  Use when preparing for a deployment to research requirements, risks, and
  rollback criteria before executing the release. Triggers on "is it safe to
  deploy", "what do I need to check before releasing", "pre-deployment checklist",
  or when planning a release with unknowns.
---

# Skill: Deployment Release Research

## Purpose

Systematic pre-deployment research to surface risks before they become production incidents.

---

## Process

1. **Identify the scope**
   - What is being deployed?
   - Which environments?
   - Which services are affected?

2. **Check for database migrations**
   - Are there pending migrations?
   - Are they backward-compatible?
   - Can they be rolled back?

3. **Check for config/env changes**
   - New environment variables?
   - Changed defaults?
   - Config changes that must be deployed before or after code?

4. **Review feature flags**
   - Are new features gated?
   - Is the flag defaulting correctly for each environment?

5. **Check downstream impact**
   - Are there API contract changes?
   - Are consumers aware?
   - Have they been tested?

6. **Define rollback criteria**
   - Under what conditions do we roll back?
   - Who has authority to call it?
   - How long is the observation window?

7. **Confirm deployment checklist**
   - All tests green?
   - Staging verified?
   - On-call aware?
   - Monitoring dashboards ready?

---

## Output Template

```
## Pre-Deployment Research: [version/ticket]

Scope: [what's being deployed]

Risks identified:
- [risk] — [severity: low/med/high] — [mitigation]

Migration required: [Yes/No — details]
Config changes: [Yes/No — details]
Rollback criteria: [specific conditions]
Rollback procedure: [steps or link]

Go/No-Go: [Go | No-Go | Conditional — conditions]
```

---

## Constraints

- Never skip rollback criteria — if you can't define rollback, the deployment is not ready
- Highlight any "No-Go" conditions prominently
