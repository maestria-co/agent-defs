---
name: jira-story
user-invocable: true
description: >
  Write a well-structured Jira user story or ticket. Use whenever someone says "write
  a Jira ticket", "create a story for this feature", "draft acceptance criteria",
  "format this as a Jira issue", "turn this into a story", or provides a feature idea
  that needs to be formalized into a backlog item. Prevents under-specified stories
  that force developers to hunt for missing information or make incorrect assumptions.
---

# Skill: Jira Story

## Purpose

Format user stories and tickets for Jira with consistent structure, complete acceptance
criteria, and technical context. Prevents under-specified stories that force developers
to hunt for missing information or make incorrect assumptions.

---

## Process

### 1. Gather Information

Before writing, collect:

- **Who** is the user/persona?
- **What** action do they want to take?
- **What benefit** does it deliver?
- **What technical components** are affected?
- **What are the edge cases** or error scenarios?

### 2. Write the Story Statement

Use the standard format:

```
As a [persona],
I want [goal],
So that [benefit]
```

**Rules:**
- Persona must be specific (not "user" — e.g., "logged-in customer," "admin user")
- Goal is the action or capability being added
- Benefit explains the value — why this matters

### 3. Write Acceptance Criteria

Write **3-8 acceptance criteria** using Given/When/Then format:

```
Given [context/precondition],
When [action/trigger],
Then [expected result]
```

**Each AC must:**
- Be testable (can be verified as pass/fail)
- Cover a different scenario (happy path, edge cases, error cases)
- Be specific enough to test without asking questions

### 4. Add Technical Notes

Include a **Technical Notes** section with:

| Element           | What to Include                                        |
| ----------------- | ------------------------------------------------------ |
| Affected Components | Services, modules, or files that will change          |
| API Changes       | New endpoints, modified requests/responses             |
| Data Model Changes | New tables, columns, migrations required              |
| Key Files         | Specific files developers should start with            |
| Performance Notes | Expected load, caching needs, query optimization       |

### 5. Add Dependencies

List anything blocking or required:

- **Blocking Tickets:** Story IDs that must be done first
- **Required Resources:** Access, credentials, test data needed
- **Team Approvals:** Security review, design sign-off, etc.

### 6. Self-Check

Before finalizing, verify:

- [ ] Story follows As a/I want/So that format
- [ ] At least 3 acceptance criteria, all testable
- [ ] Technical notes include affected components
- [ ] Dependencies are explicit (or "None" if truly independent)
- [ ] A developer can start this story without asking clarifying questions
- [ ] No implementation details leaked into the story statement

---

## Templates

### Story Template

```
**Story:**
As a [persona],
I want [goal],
So that [benefit]

**Acceptance Criteria:**

1. Given [context], when [action], then [result]
2. Given [context], when [action], then [result]
3. Given [context], when [action], then [result]

**Technical Notes:**
- Affected Components: [list]
- API Changes: [list or "None"]
- Data Model Changes: [list or "None"]
- Key Files: [list]

**Dependencies:**
- Blocking Tickets: [ticket IDs or "None"]
- Required Resources: [list or "None"]
- Approvals Needed: [list or "None"]
```

---

## Examples

### ✅ Good Story

```
**Story:**
As a logged-in customer,
I want to filter my order history by date range,
So that I can find specific past orders quickly without scrolling.

**Acceptance Criteria:**

1. Given I am on the Order History page, when I select a start date and end date,
   then only orders placed within that range are displayed
2. Given I select an end date before the start date, when I click Apply,
   then I see an error message "End date must be after start date"
3. Given I have no orders in the selected date range, when I apply the filter,
   then I see "No orders found for this date range"
4. Given I apply a date filter, when I click "Clear Filters",
   then all orders are displayed again

**Technical Notes:**
- Affected Components: OrderHistory service, Orders API, OrderHistory UI component
- API Changes: Add optional `startDate` and `endDate` query params to GET /api/orders
- Data Model Changes: None (orders.created_at already indexed)
- Key Files: `services/order-history/index.js`, `api/routes/orders.js`, `ui/OrderHistory.jsx`

**Dependencies:**
- Blocking Tickets: None
- Required Resources: Access to staging environment for testing
- Approvals Needed: None
```

### ❌ Bad Story

```
**Story:**
As a user, I want better order history, so that it's more useful.

**Acceptance Criteria:**
- Orders should be filterable
- The UI should be intuitive
- Performance should be good

**Technical Notes:**
Update the order history page.
```

**Why this is bad:**
- Persona is vague ("user" — what kind of user?)
- Goal is unclear ("better" is subjective)
- Benefit is meaningless ("more useful" — how?)
- AC are not testable (what does "intuitive" mean? What is "good" performance?)
- No technical details — which components? Which files?
- A developer cannot start this without a clarification meeting

---

## Constraints

- **Do not write implementation details in the story body** — those belong in Technical Notes or subtasks
- **AC must be testable** — if you can't write a test that verifies it, rewrite the AC
- **Avoid technical jargon in the story statement** — personas and goals should be user-focused
- **No vague acceptance criteria** — "should work," "looks good," "is fast" are not testable
- **Do not invent persona details** — if the persona is unclear, ask before proceeding
- **Do not combine multiple features** — one story per feature; split large stories into smaller ones
