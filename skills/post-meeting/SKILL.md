---
name: post-meeting
description: >
  Use after any meeting to capture decisions, action items, and context. Triggers on
  "write up the meeting", "capture meeting notes", "document what we decided", or
  immediately after a meeting conversation. Converts meeting discussions into durable,
  actionable records to prevent decisions from being lost and action items from falling
  through the cracks.
---

# Skill: Post-Meeting

## Purpose

Convert meeting discussions into durable, actionable records. Prevents decisions from
being lost, action items from falling through the cracks, and participants from having
different understandings of what was agreed.

---

## Process

### 1. Summary

**Goal:** Provide context in 2-3 sentences for someone who wasn't there.

Answer:
- What was the meeting about?
- What was the key outcome?

**Example:**
```
Sprint planning meeting for Sprint 42. Team committed to 38 points focused on real-time
order tracking. Identified dependency on Partner API key, due by Day 3.
```

### 2. Attendees

**Goal:** Record who was present and their role for context.

**Format:**
```
**Attendees:**
- Alice Chen (Engineering Lead)
- Bob Smith (Product Manager)
- Carol Davis (Designer)
```

**Why include roles:**
- Provides context for who made decisions
- Helps future readers understand perspective
- Clarifies who to follow up with

### 3. Decisions Made

**Goal:** Separate decisions from discussion and action items.

**Format:**
```
**Decision:** [Statement of fact about what was decided]
**Rationale:** [Why this decision was made]
**Decided by:** [Who made the call, if applicable]
```

**Rules:**
- Each decision as a declarative statement ("We decided to X")
- Include the "why" — future readers need context
- If decision has an owner, note it
- Separate from action items (a decision is not an action)

**Example:**
```
**Decision:** Use offset-based pagination instead of cursor-based for orders API
**Rationale:** Our use case (customers viewing recent orders) doesn't need arbitrary page jumps, and offset is simpler to implement
**Decided by:** Engineering Lead (Alice)
```

### 4. Action Items

**Goal:** Ensure every action has an owner and a deadline.

**Format:**
```
[Owner] — [Action verb] — [Deliverable] — by [Date]
```

**Rules:**
- Every action item must have an owner (name, not role)
- Every action item must have a deadline
- Use action verbs (draft, send, review, deploy, test, schedule)
- Be specific about deliverable (not "look into X" — what is the output?)

**No owner = no action item** — if it has no owner, it's a suggestion or future work, not an action.

**Example:**
```
**Action Items:**

1. Alice — Draft RFC for orders API pagination — by Jan 20
2. Bob — Send Partner API key request to Partner team — by Jan 17
3. Carol — Review and approve status icon designs — by Jan 19
4. Alice — Schedule follow-up review meeting — by Jan 22
```

### 5. Discussion Notes

**Goal:** Capture key points raised, concerns, and rationale that informed decisions.

**Include:**
- Important concerns raised
- Options discussed (even if not chosen)
- Constraints identified
- Assumptions made

**Don't include:**
- Verbatim transcripts
- Tangential discussions
- Every comment made

**Example:**
```
**Discussion Notes:**

- Concern raised: Cursor-based pagination would require client changes
- Alternative discussed: Infinite scroll, rejected due to API latency remaining for other clients
- Assumption: 80% of customers view only the first 2 pages of orders
- Constraint: Must maintain backward compatibility for 6 months to allow client migration
```

### 6. Open Questions

**Goal:** Track items discussed but not decided — and who is responsible for resolving them.

**Format:**
```
**Question:** [The unresolved question]
**Owner:** [Who will resolve it]
**Due:** [When a decision is needed]
```

**Rules:**
- If it was decided, it's not an open question (move to Decisions)
- If there's no owner or deadline, it's a risk, not an open question
- Open questions block progress — highlight them

**Example:**
```
**Open Questions:**

1. **Question:** Should we support page sizes >100 for admin users?
   **Owner:** Bob (Product)
   **Due:** Jan 22 (before implementation starts)

2. **Question:** Do we need to support sorting by order date in first release?
   **Owner:** Alice (Engineering)
   **Due:** Jan 20 (as part of RFC review)
```

---

## Templates

### Meeting Notes Template

```
# [Meeting Title]

**Date:** [YYYY-MM-DD]
**Time:** [HH:MM - HH:MM]
**Attendees:**
- [Name] ([Role])
- [Name] ([Role])

---

## Summary

[2-3 sentences: what was the meeting about and what was the key outcome?]

---

## Decisions Made

1. **Decision:** [Statement]
   **Rationale:** [Why]
   **Decided by:** [Who]

2. **Decision:** [Statement]
   **Rationale:** [Why]
   **Decided by:** [Who]

---

## Action Items

1. [Owner] — [Action] — [Deliverable] — by [Date]
2. [Owner] — [Action] — [Deliverable] — by [Date]

---

## Discussion Notes

- [Key point raised]
- [Alternative discussed]
- [Constraint identified]
- [Assumption made]

---

## Open Questions

1. **Question:** [Unresolved question]
   **Owner:** [Who will resolve]
   **Due:** [When decision needed]

2. **Question:** [Unresolved question]
   **Owner:** [Who will resolve]
   **Due:** [When decision needed]
```

---

## Examples

### ✅ Good Meeting Notes

```
# Sprint 42 Planning Meeting

**Date:** 2025-01-15
**Time:** 10:00 - 11:30
**Attendees:**
- Alice Chen (Engineering Lead)
- Bob Smith (Product Manager)
- Carol Davis (Designer)
- Dan Lee (QA Engineer)

---

## Summary

Sprint planning for Sprint 42, focused on real-time order tracking. Team committed to
38 points across 2 sprint goals. Identified dependency on Partner API key, needed by
Day 3 of the sprint.

---

## Decisions Made

1. **Decision:** Commit to 38 story points across 8 stories for Sprint 42
   **Rationale:** Team velocity is 40 points; 38 provides buffer for Partner API integration unknowns
   **Decided by:** Team consensus

2. **Decision:** Mark email notifications for order status as out of scope for this sprint
   **Rationale:** Requires separate infrastructure for email sending; focus sprint on core tracking feature
   **Decided by:** Product Manager (Bob)

---

## Action Items

1. Alice — Draft RFC for orders API pagination — by Jan 20
2. Bob — Send Partner API key request to Partner team — by Jan 17 (blocking)
3. Carol — Finalize status icon designs and share in Slack — by Jan 18
4. Dan — Set up test data in staging for order tracking scenarios — by Jan 19
5. Alice — Schedule mid-sprint check-in for Day 5 — by Jan 16

---

## Discussion Notes

- Concern raised: Partner API integration is untested; could be a sprint risk
  - Mitigation: Bob to request API key by Jan 17; Alice to spike integration on Day 1-2
- Alternative discussed: Build email notifications in parallel
  - Rejected: Would split focus and risk not completing core tracking feature
- Assumption: Real-time tracking will reduce "Where is my order?" tickets by 30%
  - Plan: Track ticket volume pre- and post-release to validate
- Constraint: Must support both old and new order status formats during migration period

---

## Open Questions

1. **Question:** Should manual status updates be admin-only or available to customer support agents?
   **Owner:** Bob (Product)
   **Due:** Jan 18 (needed for AC review)

2. **Question:** Do we need to support status history (view all past status changes) in first release?
   **Owner:** Carol (Design)
   **Due:** Jan 19 (impacts UI design)
```

### ❌ Bad Meeting Notes

```
# Meeting Notes

We talked about the sprint. Alice is doing some stuff with the API. Bob is going to
email someone about something. We need to decide about the icons.

**Action Items:**
- Alice: API stuff
- Bob: Email
- Someone: Icons

**Next Steps:**
- Follow up later
```

**Why this is bad:**
- No attendees list (who was there?)
- No summary (what was the meeting about?)
- Decisions mixed with actions (what was decided vs. what needs doing?)
- Action items have no deadlines or specific deliverables
- "Someone" is not an owner
- No discussion notes (what was the context?)
- "Follow up later" is not an action (no owner, no deadline, no deliverable)

---

## Constraints

- **Every action item must have an owner and a date** — no exceptions
- **Never mix decisions and action items in the same list** — they serve different purposes
- **If no decisions were made, state that explicitly** — do not invent decisions
- **Do not use roles as owners** — use names (roles change, people are accountable)
- **Do not capture verbatim discussion** — summarize key points and context
- **Vague actions are not action items** — "look into X" must become "draft analysis of X by [date]"
- **Open questions must have owners and deadlines** — unowned questions are not tracked
