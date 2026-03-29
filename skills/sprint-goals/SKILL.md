---
name: sprint-goals
description: >
  Use when planning a sprint, defining sprint goals, or structuring sprint commitments.
  Triggers on sprint planning, sprint kick-off, "what should we commit to this sprint",
  or "define our sprint goals". Structures sprint planning so teams commit to achievable,
  measurable goals rather than vague themes.
---

# Skill: Sprint Goals

## Purpose

Structure sprint planning so teams commit to achievable, measurable goals rather than
vague themes or task lists. Prevents sprints that lack focus, overcommit on scope, or
fail to deliver coherent value.

---

## Process

### 1. Identify the Sprint Theme

**Goal:** Define the single outcome that drives this sprint's value.

Ask:
- What is the one thing this sprint needs to accomplish?
- What outcome would make this sprint a success?
- What problem are we solving or what value are we creating?

**The theme is not a task list** — it's a brief statement of intent (1-2 sentences).

Example:
- ✅ "Enable customers to track order status in real-time"
- ❌ "Work on order tracking features"

### 2. Define 1-3 Sprint Goals

**Goal:** Convert the theme into measurable outcomes.

**Format:**
```
By end of sprint, [stakeholder] can [do X], which [delivers value Y]
```

**Rules:**
- Maximum 3 goals (1 is often better)
- Each goal is an outcome, not a task
- Must be testable (can you demo it or measure it?)
- Must be achievable within the sprint

**Example:**
```
By end of sprint, customers can view real-time order status on the order details page,
which reduces "Where is my order?" support tickets by 30%.
```

### 3. List Committed Stories

For each goal, list the stories required to achieve it:

| Story ID | Description                          | Points | Assignee | Goal Link |
| -------- | ------------------------------------ | ------ | -------- | --------- |
| PROJ-123 | Display order status on details page | 5      | Alice    | Goal 1    |
| PROJ-124 | Add order tracking API endpoint      | 3      | Bob      | Goal 1    |
| PROJ-125 | Create status change webhook         | 8      | Carol    | Goal 1    |

**Commitment = sum of points must fit team velocity**

- If velocity is 40 and you've committed to 42 points, cut stories or reduce scope
- Stories not required for a goal should be marked "Stretch" or moved to backlog

### 4. Identify Dependencies and Risks

List anything that could block goal completion:

**Dependencies:**
- External teams (e.g., "Need API key from Partner team by Day 3")
- Infrastructure (e.g., "Production deploy requires SRE approval")
- Decisions (e.g., "Need design approval on status icons")

**Risks:**
- Technical unknowns (e.g., "Webhook integration not yet tested")
- Capacity constraints (e.g., "Alice out Days 8-10")
- External blockers (e.g., "Partner API still in beta")

**For each risk, identify mitigation:**
- Spike it early in the sprint
- Assign a backup owner
- Communicate dependency immediately

### 5. Define Definition of Done (DoD)

**Goal:** Set the quality bar for "done."

Example DoD checklist:
- [ ] Code reviewed and approved
- [ ] Unit tests pass
- [ ] Integration tests pass
- [ ] Deployed to staging and tested
- [ ] Documentation updated
- [ ] Acceptance criteria met and verified

**DoD must be agreed by the team before sprint starts.**

### 6. Mark Out of Scope

Explicitly state what is **not** included this sprint:

**Out of Scope:**
- Email notifications for order status changes
- Admin dashboard for tracking all orders
- Bulk order status updates

**Why this matters:**
- Prevents scope creep
- Sets expectations with stakeholders
- Protects the team from mid-sprint additions

---

## Templates

### Sprint Planning Template

```
## Sprint [Number]: [Theme]

**Sprint Dates:** [Start Date] - [End Date]

### Sprint Goals

1. By end of sprint, [stakeholder] can [do X], which [delivers value Y]
2. [Optional second goal]

### Committed Stories

| Story ID | Description | Points | Assignee | Goal |
| -------- | ----------- | ------ | -------- | ---- |
| PROJ-XXX | ...         | X      | Name     | 1    |

**Total Committed Points:** [sum] / Team Velocity: [avg velocity]

### Dependencies

- [Dependency 1] — Owner: [name], Due: [date]
- [Dependency 2] — Owner: [name], Due: [date]

### Risks

- [Risk 1] — Mitigation: [plan]
- [Risk 2] — Mitigation: [plan]

### Definition of Done

- [ ] [Criterion 1]
- [ ] [Criterion 2]
- [ ] [Criterion 3]

### Out of Scope

- [Feature/task explicitly excluded]
- [Another excluded item]
```

---

## Examples

### ✅ Good Sprint Goals

```
**Sprint 42: Real-Time Order Tracking**

**Sprint Goals:**

1. By end of sprint, customers can view real-time order status on the order details page,
   which reduces "Where is my order?" support tickets by 30%.

2. By end of sprint, customer support agents can manually update order status,
   which gives them a workaround when automated tracking fails.

**Why these are good:**
- Specific stakeholders (customers, support agents)
- Measurable outcomes (view status, manually update)
- Clear value (reduces support tickets, provides workaround)
- Testable (can demo and measure)
```

### ❌ Bad Sprint Goals

```
**Sprint 42: Orders**

**Sprint Goals:**

1. Improve order tracking
2. Work on customer support tools
3. Fix bugs
4. Refactor order service

**Why these are bad:**
- 4 goals (too many — no focus)
- Not measurable ("improve" by how much?)
- Task-focused ("work on," "fix," "refactor") instead of outcome-focused
- Not testable (how do you verify "improved"?)
- No stakeholder or value statement
```

---

## Constraints

- **Maximum 3 sprint goals** — more goals = no focus; 1 goal is often best
- **Goals must be testable** — if you can't demo or measure it, it's not a goal
- **Do not list individual tasks as goals** — tasks go in the committed stories table
- **Do not overcommit** — if committed points exceed velocity, cut scope before sprint starts
- **Every story must map to a goal** — if it doesn't, it's a stretch item or backlog candidate
- **Out of scope must be explicit** — vague boundaries invite scope creep
- **Dependencies must have owners and dates** — "we need X" without a plan is a risk, not a dependency
