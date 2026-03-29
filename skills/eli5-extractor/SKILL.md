---
name: eli5-extractor
description: >
  Use when a technical concept needs to be explained simply to a non-technical
  audience, or when documentation needs to be made accessible. Triggers on
  "explain this simply", "ELI5", "how do I explain X to a stakeholder", "make
  this accessible", or when bridging technical and non-technical communication.
---

# Skill: ELI5 Extractor

## Purpose

Translate complex technical concepts into clear, concrete explanations that non-technical
audiences can understand and act on. Prevents communication breakdowns between engineers
and stakeholders.

---

## Process

### 1. Identify the Core Idea

**What is the single most important thing to convey?**

- Strip away implementation details
- Focus on what it does, not how it does it
- Identify what decision or action depends on understanding this concept

### 2. Find an Analogy

**Choose something from everyday life that shares the same structural relationship.**

Guidelines for analogies:

- Use concrete, physical objects or experiences
- Prefer universal experiences (cooking, driving, shopping) over specialized ones
- Test the analogy — does it break down in ways that would mislead?
- Be ready to adjust or abandon an analogy if it doesn't fit

See the Analogy Patterns table below for common technical concepts.

### 3. Eliminate Jargon

**Replace every technical term with a plain-English equivalent.**

Rules:

- If a term **must** be used, define it immediately in simple terms
- Use verbs instead of abstract nouns ("the system checks" not "validation occurs")
- Break compound terms into parts ("database query" → "looking up information in storage")
- Avoid acronyms — always expand them on first use

### 4. Use Concrete Examples

**Show a specific scenario, not an abstract description.**

Good:

- "When you click Login, the system checks if your password matches what's stored"
- "If the server crashes, the load balancer redirects traffic to a backup server"

Bad:

- "The authentication module processes credentials"
- "Failover mechanisms provide high availability"

### 5. Explain the "So What"

**Why does this matter to the listener?**

- What decision does understanding this enable?
- What problem does it solve for them?
- What happens if this fails or doesn't exist?

### 6. Simplicity Check

**Would a smart 12-year-old understand this?**

- If not, simplify further
- Read it aloud — does it flow naturally?
- Remove sentences that don't add value

---

## Analogy Patterns

| Technical Concept      | Analogy                                                                 |
| ---------------------- | ----------------------------------------------------------------------- |
| **API**                | A restaurant menu — you pick from options, the kitchen does the work    |
| **Database**           | A filing cabinet with very fast search                                  |
| **Cache**              | A sticky note on your monitor for things you look up constantly         |
| **Async/await**        | Ordering coffee and waiting for your name to be called instead of standing at the counter |
| **Deployment**         | Publishing a book — writing is done in private, publishing makes it public |
| **Version control**    | Track Changes in Word, but for code and with time-travel                |
| **Load balancer**      | A restaurant host directing customers to available tables               |
| **Microservices**      | Specialized food trucks instead of one giant restaurant kitchen         |
| **Docker container**   | A lunchbox with everything needed for a meal, works anywhere            |
| **Encryption**         | A locked box that only opens with the right key                         |
| **API rate limit**     | "You can only ask me 100 questions per hour"                            |
| **Retry logic**        | Knocking on a door again if no one answers the first time               |

---

## Output Format

Write the explanation at the target complexity level. Follow with metadata:

```
## Explanation: [concept name]

[The actual explanation in simple terms — use paragraphs, analogies, and concrete examples]

---

**Metadata:**
- Analogy used: [analogy and what it maps to]
- Jargon replaced:
  - [technical term] → [plain English version]
  - [technical term] → [plain English version]
- Target audience: [who this is for: exec, customer, junior dev, etc.]
```

---

## Example

**Concept:** "What is a REST API?"

**Explanation:**

A REST API is like a restaurant menu. The menu lists dishes you can order (the API lists actions
you can request). You don't need to know how the kitchen makes the food — you just pick from the
menu, and the kitchen handles the details.

When you make a request (order food), you get back what you asked for (your meal) or an error if
something went wrong (sorry, we're out of that dish).

This matters because it lets different programs talk to each other without needing to understand
each other's internal workings. Your phone's weather app doesn't need to know how the weather
service's servers work — it just asks "what's the weather in New York?" and gets an answer.

---

**Metadata:**
- Analogy used: Restaurant menu (API) → ordering food (making requests) → receiving meals (responses)
- Jargon replaced:
  - REST API → a menu of actions you can request from a program
  - endpoint → item on the menu
  - request → order
  - response → what you get back
- Target audience: non-technical stakeholder

---

## Constraints

- **Never use acronyms without expansion** — always spell out on first use
- **Never sacrifice accuracy for simplicity** — if the analogy misleads, choose a different one
- **Write for the specific audience** — an exec needs different details than a junior developer
- Do not oversimplify to the point of being condescending — respect the audience's intelligence
- If a concept has no good analogy, use a concrete example instead
- Avoid nested analogies ("it's like X, which is like Y") — use one clear analogy
