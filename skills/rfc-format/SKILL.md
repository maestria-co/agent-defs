---
name: rfc-format
description: >
  Use when writing a Request for Comments (RFC) document for a technical proposal,
  architecture change, or significant decision. Triggers on "write an RFC", "draft a
  proposal", "create an RFC for", or when a decision needs structured community input
  before proceeding. Structures technical proposals so reviewers have everything needed
  to evaluate, critique, and approve or reject them.
---

# Skill: RFC Format

## Purpose

Structure technical proposals so reviewers have everything needed to evaluate, critique,
and approve or reject them. Prevents half-baked proposals that waste review time and
decisions made without considering alternatives or tradeoffs.

---

## Process

### 1. Problem Statement

**Goal:** Define what is broken, missing, or suboptimal.

Answer:
- What is the current situation?
- What is the pain or limitation?
- Why does this need solving **now**? (urgency, impact, cost of delay)
- Who is affected? (users, developers, operations, other teams)

**Be specific:**
- ❌ "The API is slow"
- ✅ "The `/orders` API takes 8 seconds at p95 for customers with >100 orders, causing checkout abandonment"

### 2. Goals and Non-Goals

**Goal:** Be explicit about what this RFC will and won't address.

**Goals:** The problems this proposal solves or capabilities it adds
**Non-Goals:** Related problems that are explicitly out of scope

**Why this matters:**
- Focuses review on what's being proposed
- Prevents scope creep
- Sets expectations

**Example:**
```
**Goals:**
- Reduce `/orders` API p95 latency to <1 second
- Support pagination for order lists

**Non-Goals:**
- Optimizing other API endpoints
- Redesigning the order data model
- Adding real-time order updates
```

### 3. Proposal

**Goal:** Present the recommended solution with sufficient detail to evaluate it.

Include:
- **High-level approach** — what is the core idea?
- **Architecture changes** — components added, modified, or removed
- **API contracts** — new endpoints, modified requests/responses
- **Data model changes** — schema changes, migrations required
- **Key tradeoffs** — what are you optimizing for? What are you sacrificing?

**Balance detail with readability:**
- Enough detail to evaluate feasibility
- Not so much detail that reviewers lose the big picture
- Use diagrams for complex flows

### 4. Alternatives Considered

**Goal:** Show that you evaluated other options and explain why they were rejected.

**Minimum: 2 alternatives** (in addition to the proposal)

For each alternative:
1. **Brief description** — what is this approach?
2. **Pros** — what would be good about it?
3. **Cons** — what are the downsides?
4. **Why rejected** — what made you choose the proposal over this?

**Anti-pattern:**
- Listing obviously bad alternatives to make the proposal look good
- "Do nothing" doesn't count unless it's a real option

### 5. Design Details

**Goal:** Provide implementation details for engineers to evaluate and build.

Include:
- **Implementation plan** — what are the steps to build this?
- **API contracts** — full request/response schemas
- **Data model changes** — schema, indexes, migrations
- **Migration strategy** — how do we move from current state to new state?
- **Testing strategy** — how will we verify this works?
- **Monitoring and observability** — how will we know if it's working in production?

**Use tables, code blocks, or diagrams:**

```
GET /api/orders?page=1&limit=20

Response:
{
  "orders": [...],
  "pagination": {
    "page": 1,
    "limit": 20,
    "total": 150,
    "hasMore": true
  }
}
```

### 6. Rollout Plan

**Goal:** Define how this will be deployed and how to roll back if needed.

Include:
- **Phases** — what gets deployed when?
- **Feature flags** — what toggles control the new behavior?
- **Backward compatibility** — does this break existing clients?
- **Rollback trigger** — what metrics or errors trigger a rollback?
- **Timeline** — estimated dates for each phase

**Example:**
```
**Phase 1 (Week 1):** Deploy pagination to staging, test with synthetic data
**Phase 2 (Week 2):** Deploy to production behind feature flag, enabled for 5% of users
**Phase 3 (Week 3):** Ramp to 50% if p95 latency <1s and error rate <0.1%
**Phase 4 (Week 4):** Ramp to 100%, remove feature flag after 1 week of stability

**Rollback trigger:** If error rate >0.5% or p95 latency >2s, disable feature flag immediately
```

### 7. Open Questions

**Goal:** Highlight what needs feedback or a decision from reviewers.

List questions that:
- Require a decision between multiple valid options
- Need input from domain experts
- Have unclear requirements

**Do not:**
- Put known answers as questions
- Use this section to avoid making decisions

**Example:**
```
**Open Questions:**

1. Should pagination default to 20 or 50 items per page? (Trade: fewer requests vs. smaller response size)
2. Should we deprecate the unpaginated endpoint immediately or give clients 6 months to migrate?
3. Do we need cursor-based pagination for real-time data, or is offset-based sufficient?
```

---

## Templates

### RFC Document Template

```
# RFC [Number]: [Title]

**Author:** [Name]
**Status:** Draft | Review | Approved | Rejected | Implemented
**Created:** [Date]
**Updated:** [Date]

---

## Problem Statement

[What is broken, missing, or suboptimal? Why does it need solving now? Who is affected?]

## Goals and Non-Goals

**Goals:**
- [Goal 1]
- [Goal 2]

**Non-Goals:**
- [Non-goal 1]
- [Non-goal 2]

## Proposal

[High-level approach, architecture changes, API contracts, data model changes, key tradeoffs]

## Alternatives Considered

### Alternative 1: [Name]
- **Description:** [brief summary]
- **Pros:** [benefits]
- **Cons:** [drawbacks]
- **Why rejected:** [reason]

### Alternative 2: [Name]
- **Description:** [brief summary]
- **Pros:** [benefits]
- **Cons:** [drawbacks]
- **Why rejected:** [reason]

## Design Details

### Implementation Plan
[Steps to build this]

### API Contracts
[Request/response schemas]

### Data Model Changes
[Schema, indexes, migrations]

### Migration Strategy
[How to move from current state to new state]

### Testing Strategy
[How to verify this works]

### Monitoring and Observability
[How to know if it's working in production]

## Rollout Plan

**Phase 1:** [description and timeline]
**Phase 2:** [description and timeline]
**Phase 3:** [description and timeline]

**Rollback trigger:** [conditions that trigger rollback]

## Open Questions

1. [Question requiring decision or feedback]
2. [Another question]

---

## Appendix (Optional)

[Supporting materials: benchmarks, diagrams, research, references]
```

---

## Examples

### ✅ Good RFC

```
# RFC 042: Paginate Orders API

**Author:** Alice Chen
**Status:** Review
**Created:** 2025-01-15

## Problem Statement

The `/api/orders` endpoint returns all orders for a customer in a single response.
For customers with >100 orders, the response takes 8 seconds at p95, causing checkout
abandonment (measured at 12% for affected customers vs. 3% baseline). This affects
approximately 15,000 customers (8% of our active user base).

We need to solve this now because checkout abandonment directly impacts revenue, and
the problem worsens as customer tenure increases.

## Goals and Non-Goals

**Goals:**
- Reduce `/orders` API p95 latency to <1 second
- Support pagination for order lists

**Non-Goals:**
- Optimizing other API endpoints (separate effort)
- Redesigning the order data model (out of scope)

## Proposal

Add offset-based pagination to `/api/orders`:
- New query params: `page` (default 1) and `limit` (default 20, max 100)
- Response includes pagination metadata: `page`, `limit`, `total`, `hasMore`
- Maintain backward compatibility: if no pagination params, return all orders (deprecated)

**Tradeoff:** Offset pagination has performance issues at high offsets, but our use case
(customers viewing recent orders) stays within the first few pages.

[... rest of proposal ...]

## Alternatives Considered

### Alternative 1: Cursor-Based Pagination
- **Pros:** Better performance at high offsets, real-time data safe
- **Cons:** More complex to implement, clients can't jump to arbitrary pages
- **Why rejected:** Our use case doesn't need arbitrary page access; users view recent orders

### Alternative 2: Infinite Scroll with Lazy Loading
- **Pros:** Better UX for mobile
- **Cons:** Requires client changes, doesn't solve API latency for all clients
- **Why rejected:** Doesn't address the core API performance problem

[... rest of RFC ...]
```

### ❌ Bad RFC

```
# RFC: Make Orders Faster

## Problem

The orders API is slow.

## Proposal

We should optimize it.

## Implementation

Make the queries faster and cache things.
```

**Why this is bad:**
- Problem is vague (how slow? for whom? why does it matter?)
- No goals or non-goals
- Proposal has no details (what specific changes?)
- No alternatives considered
- No design details, rollout plan, or open questions
- A reviewer cannot evaluate or approve this

---

## Constraints

- **RFC must include at least 2 alternatives** — single-solution proposals suggest insufficient exploration
- **Rollout plan required for any user-facing or breaking change** — no rollout plan = no approval
- **Open questions must be answerable** — do not put known answers as questions to inflate the section
- **Problem statement must include urgency** — why now, not later?
- **Goals and non-goals must be explicit** — vague scope invites scope creep
- **Do not propose without data** — include measurements, benchmarks, or evidence for the problem
- **Do not mix proposal and implementation** — RFC approval is for approach, not every implementation detail
