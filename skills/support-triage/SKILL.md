---
name: support-triage
description: >
  Use when triaging incoming support tickets or user requests. Triggers on
  "triage this ticket", "categorize this support request", "what's the priority
  of this issue", or when processing a batch of support requests.
---

# Skill: Support Triage

## Purpose

Quickly classify, prioritize, and route support tickets so each gets the right
response at the right speed. Prevents high-priority issues from being buried and
low-priority requests from consuming disproportionate attention. Ensures every
request is properly categorized, deduplicated, and routed to the right team.

---

## Classification Framework

### Type Categories

| Type | Definition | Example |
|------|------------|---------|
| **Bug** | Unexpected behavior in existing functionality | "Login button doesn't work on mobile Safari" |
| **Feature Request** | Request for new capability | "Add dark mode support" |
| **Question** | User needs education or clarification | "How do I export my data?" |
| **Incident** | Production issue requiring immediate action | "API returns 500 for all requests" |
| **Configuration** | Setup or environment issue | "Can't connect to database after upgrade" |

---

## Priority Matrix

Use impact and urgency to determine priority:

| Impact | Urgency | Priority | SLA |
|--------|---------|----------|-----|
| Many users blocked | Now | **P0 — Incident** | Immediate escalation |
| Core feature broken | Today | **P1 — Critical** | 4 hours |
| Feature partially broken | This week | **P2 — High** | 2 days |
| Minor issue, workaround exists | This sprint | **P3 — Medium** | 1 week |
| Cosmetic / enhancement | Backlog | **P4 — Low** | Best effort |

### Priority Guidance

**P0 (Incident)**
- Production system down
- Data loss or corruption
- Security breach
- Payment processing broken

**P1 (Critical)**
- Core feature completely broken
- Many users affected
- No workaround available
- Blocking business operations

**P2 (High)**
- Important feature partially broken
- Moderate number of users affected
- Workaround exists but painful
- Affects key workflows

**P3 (Medium)**
- Minor feature broken
- Small number of users affected
- Easy workaround available
- Quality-of-life improvement

**P4 (Low)**
- Cosmetic issue
- Feature enhancement
- Nice-to-have improvement
- Affects very few users

---

## Triage Process

### Step 1: Parse the Request

Extract key information:

- **What happened?** (observed behavior)
- **What was expected?** (desired outcome)
- **Who is affected?** (one user? many? specific customer?)
- **What's the environment?** (version, browser, OS, deployment)
- **When did this start?** (regression or always been this way?)
- **Impact level?** (blocking work? annoying? cosmetic?)

### Step 2: Classify Type

Match the request to one of the 5 types (Bug, Feature Request, Question, Incident, Configuration).

### Step 3: Determine Priority

Apply the priority matrix based on impact and urgency.

### Step 4: Search for Duplicates

Before creating a new ticket:

1. Search existing tickets for similar keywords
2. Check closed tickets (might be known regression)
3. Search documentation/FAQ (might already be answered)
4. Search changelog (might be fixed in newer version)

If duplicate found:

- **Link to existing ticket** — Do not create a new ticket
- **Add reporter's context** — Their use case might add valuable information
- **Update priority if needed** — More affected users = higher priority

### Step 5: Identify Affected Area

Map the request to system components:

- Which service/feature is involved?
- Which team owns this area?
- What domain knowledge is required?
- Are there related known issues?

### Step 6: Route

| Priority | Action |
|----------|--------|
| **P0** | Immediate escalation to on-call team. Create incident ticket. Page if necessary. |
| **P1** | Create high-priority ticket. Notify team lead. Track for same-day response. |
| **P2** | Create ticket in team backlog. Tag with area. Schedule for next planning. |
| **P3** | Create ticket in backlog. Will be prioritized in normal workflow. |
| **P4** | Add to enhancement backlog. May be combined with related requests. |

---

## Triage Output Template

```markdown
# Ticket: [Concise descriptive title]

## Classification
- **Type:** [Bug | Feature Request | Question | Incident | Configuration]
- **Priority:** P[0-4] — [Incident | Critical | High | Medium | Low]
- **Affected Area:** [service/feature/component]

## Original Report
[Reporter's description verbatim — do not paraphrase]

## Environment
- Version: [X.Y.Z]
- Platform: [browser/OS/device]
- Deployment: [prod/staging/self-hosted]
- Started: [date or "unknown"]

## Duplicate Check
- **Duplicate of:** [ticket ID | none]
- **Related to:** [ticket IDs if any]
- **Similar closed:** [ticket IDs if relevant]

## Routing
- **Route to:** [team/person/backlog]
- **Requires:** [domain expertise needed]
- **SLA:** [response time based on priority]

## Recommended Action
[Brief description of next steps]
```

---

## Special Cases

### Questions (User Education)

For questions that don't require code changes:

1. Check if documentation exists
2. If yes: link to docs and close ticket
3. If no: answer the question AND update docs with the answer
4. Consider: Is this a common question? Should it be in FAQ?

### Feature Requests

For new capability requests:

1. Understand the underlying need (not just the proposed solution)
2. Check if existing features can solve the need
3. Assess complexity and value
4. Route to product team for prioritization
5. Set expectation: feature requests may not be implemented immediately

### Configuration Issues

For setup/environment problems:

1. Check if version is supported
2. Verify configuration against documentation
3. Check for known compatibility issues
4. Often resolvable without code changes
5. Update docs if configuration is unclear

---

## Batch Triage

When processing multiple tickets:

### Workflow

1. **First pass: Quick scan**
   - Mark P0 issues for immediate escalation
   - Flag obvious duplicates
   - Set aside questions for batch answering

2. **Second pass: Deep triage**
   - Classify and prioritize each unique issue
   - Search for duplicates thoroughly
   - Route to appropriate teams

3. **Third pass: Documentation**
   - Create tickets with full context
   - Update any affected documentation
   - Send batch update to reporters

### Batch Output

```markdown
# Triage Summary: [Date]

## Processed: [N] requests

### P0 (Incidents): [N]
- [ID] — [brief description] — escalated to [team]

### P1 (Critical): [N]
- [ID] — [brief description] — assigned to [team]

### P2 (High): [N]
- [ID] — [brief description] — in backlog

### P3 (Medium): [N]
- [ID] — [brief description] — in backlog

### P4 (Low): [N]
- [ID] — [brief description] — in backlog

### Duplicates: [N]
- Linked to existing tickets

### Questions Answered: [N]
- Resolved with documentation

## Actions Required
- [ ] P0 issues escalated
- [ ] P1 issues notified to team leads
- [ ] Documentation updated for [N] questions
- [ ] Batch notification sent to reporters
```

---

## Constraints

- **Never dismiss without documenting** — Every request must be recorded, even if it's a duplicate
- **P0 issues must be escalated immediately** — Do not batch P0 issues
- **Include original description verbatim** — Do not paraphrase the reporter's words in the ticket body
- **Do not change priority without justification** — Document why priority differs from standard matrix
- **Do not route without confidence** — If unsure which team owns an area, ask
- **Do not promise timelines** — SLA is for internal tracking only
- **Always close the loop** — Reporter must receive a response, even if it's "added to backlog"
