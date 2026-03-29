---
name: categorizer
description: >
  Apply consistent categorization to issues, tickets, or work items by type, domain, and 
  priority. Use when categorizing issues, tagging tickets, organizing backlogs, or when asked 
  "how should I classify this work". Prevents backlogs from becoming unnavigable noise by 
  establishing consistent, filterable categories.
---

# Skill: Categorizer

## Purpose

Apply consistent categorization to issues and tickets so they can be filtered, prioritized, and 
routed correctly. This skill prevents backlogs from becoming unnavigable noise by ensuring every 
work item has clear, consistent metadata that enables filtering, prioritization, and sprint planning.

---

## Categorization Dimensions

Every work item should be evaluated across these five dimensions:

### 1. Type

| Type | Definition | Example |
|------|------------|---------|
| Bug | Something is broken or behaving incorrectly | Login fails with valid credentials |
| Feature | New capability being added | Add two-factor authentication |
| Improvement | Enhancement to existing functionality | Reduce API response time |
| Technical Debt | Code quality, architecture, or infrastructure work | Refactor auth module to reduce duplication |
| Security | Security vulnerability or hardening | Fix SQL injection in search endpoint |
| Documentation | User or developer documentation | Document API authentication flow |
| Question | Needs clarification or discussion | Should we support OAuth 2.0? |
| Spike | Time-boxed research or investigation | Research best state management library |

### 2. Domain

Infer from project `.context/domains/` or common system areas:

- Auth (authentication, authorization)
- Payments (billing, transactions)
- User Management (profiles, accounts)
- API (backend services)
- UI (frontend, design)
- Infrastructure (deployment, monitoring)
- Data (database, ETL, analytics)

If `.context/domains/` exists, use those domain names exactly. If not, infer domains from 
the codebase structure.

### 3. Priority

| Priority | Definition | Response Time |
|----------|------------|---------------|
| P0 | Critical — system down or data loss | Immediately |
| P1 | High — blocking major functionality | This sprint |
| P2 | Medium — important but not blocking | Next 1-2 sprints |
| P3 | Low — nice to have | Someday/backlog |

**Priority criteria:**
- P0: Production is broken, users are blocked, data is being lost
- P1: Core functionality is broken or significantly degraded
- P2: Important feature or improvement, but workarounds exist
- P3: Polish, minor features, "would be nice"

### 4. Effort

| Size | Time Estimate | Confidence |
|------|---------------|------------|
| XS | < 1 hour | Can complete in one sitting |
| S | Half day | Straightforward, well-understood |
| M | 1-2 days | Some complexity or unknowns |
| L | 3-5 days | Significant complexity |
| XL | > 1 week | Needs breakdown before starting |

**If estimating XL, note "needs breakdown"** — work items should be broken down before 
they enter a sprint.

### 5. Status

| Status | Meaning |
|--------|---------|
| Needs info | Missing information required to categorize or start work |
| Ready | Fully specified and ready to be worked on |
| Blocked | Cannot proceed due to external dependency |
| In progress | Currently being worked on |
| Done | Completed and verified |

---

## Process

### For Single Items

1. **Read fully** — Read the issue title and description completely before categorizing
2. **Assign type** — What kind of work is this? (Bug vs. Feature vs. Improvement, etc.)
3. **Identify domain** — Which area of the system does this touch?
4. **Assess priority** — Who is affected and how urgently?
   - Consider: How many users? What's the impact if we don't fix it? Are there workarounds?
5. **Estimate effort** — How complex is this? What's the size?
   - Consider: Is the approach clear? How many files will be touched? Are there unknowns?
6. **Check for missing information** — Can this be worked on as written?
   - If not, mark "Needs info" and list what's missing

### For Batch Categorization

When categorizing multiple items at once:

1. **Group by similarity** — Cluster similar issues to categorize in batches
2. **Start with easy classifications** — Knock out obvious bugs and features first
3. **Use consistent domain names** — Don't create new domains mid-batch; reuse existing ones
4. **Flag ambiguous cases** — Mark unclear items as "Needs info" rather than guessing
5. **Output as table** — Use the format below for easy review

---

## Output Format

### Single Item

```markdown
## Categorization: [Issue Title]

**Type:** [Bug/Feature/Improvement/etc.]
**Domain:** [Auth/Payments/etc.]
**Priority:** [P0/P1/P2/P3]
**Effort:** [XS/S/M/L/XL]
**Status:** [Needs info/Ready/Blocked]

**Rationale:**
- Type: [Why this type?]
- Priority: [Who is affected? What's the impact?]
- Effort: [What makes this the estimated size?]

**Missing information (if Status = Needs info):**
- [What additional details are needed?]
```

### Batch Categorization

```markdown
## Batch Categorization Results

| # | Title | Type | Domain | Priority | Effort | Status | Notes |
|---|-------|------|--------|----------|--------|--------|-------|
| 1 | Login fails on mobile | Bug | Auth | P1 | M | Ready | Affects all mobile users |
| 2 | Add password reset | Feature | Auth | P2 | L | Ready | Requested by 50+ users |
| 3 | Optimize search | Improvement | API | P2 | S | Needs info | Missing perf requirements |
| 4 | Update docs | Documentation | — | P3 | XS | Ready | Quick win |

### Summary
- Total items: 4
- Ready to work: 3
- Needs info: 1
- P0/P1 items: 1
- Effort breakdown: 1 XS, 1 S, 1 M, 1 L

### Recommended Next Steps
1. Request missing perf requirements for #3
2. Prioritize #1 (P1 bug affecting mobile users)
3. Break down #2 if starting this sprint (L effort)
```

---

## Special Cases

### Ambiguous Items

If the issue description is unclear or too vague to categorize:

```markdown
**Status:** Needs info

**Missing information:**
- Is this a bug (something is broken) or a feature request (new capability)?
- Which part of the system is affected?
- What is the current behavior vs. expected behavior?
- How does this impact users?
```

### Duplicate Detection

If an issue appears to be a duplicate:

```markdown
**Status:** Needs info

**Note:** Possible duplicate of issue #[number]. Please confirm:
- Are these describing the same problem?
- If duplicate, which should be kept?
```

### Multi-Domain Items

If an issue spans multiple domains:

```markdown
**Domain:** Auth + Payments

**Note:** This issue touches multiple domains. Consider:
- Can this be split into separate issues per domain?
- Which domain owns the majority of the work?
- Should this be an Epic with sub-tasks?
```

---

## Quality Checks

Before finalizing categorization:

- [ ] Type accurately reflects the nature of the work (not just what the reporter called it)
- [ ] Domain matches existing domain names (check `.context/domains/` for consistency)
- [ ] Priority is based on impact, not just urgency (loud customer ≠ high priority)
- [ ] Effort estimate includes testing and review time, not just implementation
- [ ] "Needs info" status is used when truly missing information (not as a guess)
- [ ] Notes explain non-obvious categorization decisions

---

## Constraints

- **Do not guess priority without understanding impact** — "Needs info" is a valid and preferred 
  category over a wrong guess
- **Do not create new category values outside the defined sets** without documenting why and 
  getting team agreement
- **Do not categorize based solely on the reporter's urgency** — assess actual impact
- **Do not estimate effort without understanding the technical approach** — if approach is 
  unclear, mark "Needs info" or estimate conservatively
- **Do not skip the rationale** — explain why you chose each category, especially for priority 
  and effort
- **Use existing domain names from `.context/domains/`** — do not invent new domains without 
  checking existing ones first
- **When in doubt, ask** — unclear categorization leads to misprioritized work
