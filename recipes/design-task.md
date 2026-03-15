# Recipe: Design Task

> **When to use:** Architecture decision needed before implementing — library selection, system design, service boundary decisions.
> **Patterns:** `researching-options` (if needed) → `designing-systems` → then `complex-task` recipe.
> **Total time:** A few hours for the design; implementation varies.

---

## Example: Choose a caching strategy for user profile endpoint

**Situation:** Profile endpoint hitting 500 req/s. Need caching, but unsure whether Redis or in-memory is right.

### Step 0 — Create brief

```markdown
# Brief: Caching Strategy — User Profile Endpoint

## Goal
Reduce database load on GET /users/:id — currently 500 req/s, 80% cache-hit potential.

## Decision Needed
Redis (distributed cache) vs. in-memory LRU cache.

## Constraints
- Deployment is currently single-instance but plans for multi-instance in 6 months
- Cannot add operational complexity that the team can't support
- Cache must be invalidated when profile is updated

## Out of Scope
- Frontend caching (HTTP headers)
- Database query optimization
```

### Step 1 — researching-options (if external knowledge needed)

Skip this step if the team already knows the options well.

```
Use the researching-options skill.

<task>What are the tradeoffs between Redis and in-memory caching for a Node.js API that plans to scale to multi-instance in 6 months?</task>
<context>
Stack: Node.js/Express
Scale: 500 req/s now, multi-instance planned in 6 months
Cache invalidation: on profile update (write-through pattern)
Operational constraint: small team, prefer managed services
</context>
```

Expected output: recommendation with rationale.
Saved to: `.context/tasks/caching-strategy/research.md`

### Step 2 — designing-systems

```
Use the designing-systems skill.

<task>Decide the caching strategy for the user profile endpoint.</task>
<context>
Brief: .context/tasks/caching-strategy/brief.md
Research: .context/tasks/caching-strategy/research.md
Existing ADRs: .context/decisions/ (check for relevant prior decisions)
Reversibility: medium — Redis adds infrastructure dependency; not easily reversed
</context>
```

Expected output: ADR documenting the decision, rationale, rejected alternatives, and implementation constraints.
Saved to: `.context/decisions/ADR-007-caching-strategy.md`

Typical ADR shape:
```markdown
# ADR-007: Redis for User Profile Caching

## Status: Accepted

## Decision
Use Redis with ioredis for user profile caching.

## Rationale
In-memory cache would not survive multi-instance deployment planned in 6 months.
Accepting Redis operational complexity now avoids a forced migration later.

## Consequences
- Adds Redis as infrastructure dependency
- Cache invalidation via write-through on PATCH /users/:id
- 60-second TTL as safety net

## Rejected Alternatives
- In-memory LRU: works today, fails at multi-instance
- No cache: database cannot sustain projected growth
```

### Step 3 — Continue with complex-task recipe

Once the ADR is written, the design is done. Hand off to `complex-task`:
- The ADR becomes the spec for the implementation
- Pass ADR path as `decisions/` context in implementing-features prompts

---

## When This Recipe Applies

- ✅ You have a real architectural choice to make (not a trivial preference)
- ✅ Wrong choice has meaningful cost to reverse
- ✅ The team needs a documented rationale for the decision

## When to Skip designing-systems

Use `implementing-features` directly when:
- The decision is clearly two-way door (easy to reverse)
- There's an existing pattern that obviously applies
- The choice is a preference, not an architectural constraint

## Quick Heuristic

> "Will we regret this in 6 months if we pick wrong?" → Yes → write an ADR.

If it's a folder structure or variable naming question, skip it. If it's a database engine, authentication strategy, or service boundary — write an ADR.
