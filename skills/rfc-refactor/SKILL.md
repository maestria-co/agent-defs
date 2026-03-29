---
name: rfc-refactor
description: >
  Refactor or improve an existing RFC document for clarity, completeness, and actionability. 
  Use when improving an RFC, when an RFC needs work, when making an RFC ready for review, or 
  when an RFC exists but is unclear, incomplete, or has received confusing feedback. Transforms 
  rough drafts into clear, complete documents that can reach a decision.
---

# Skill: RFC Refactor

## Purpose

Transform a rough or incomplete RFC into a clear, complete document that can receive productive 
feedback and reach a decision. This skill prevents RFCs from dying in perpetual "draft" status 
by identifying and fixing common problems that block progress: vague problem statements, missing 
alternatives, conflated goals, and unanswerable questions.

---

## Common RFC Problems

| Problem | Symptom | Fix |
|---------|---------|-----|
| Vague problem statement | Reviewers ask "why is this needed?" | Rewrite with specific examples of current pain |
| Missing alternatives | Reviewers suggest alternatives the author already considered | Add "Alternatives considered" with rejection rationale |
| No rollout plan | Approved but nobody knows how to ship it | Add phased rollout with rollback criteria |
| Conflated goals | RFC tries to solve 3 problems at once | Split into separate RFCs or narrow scope explicitly |
| Assumed context | Only the author can understand it | Add background section explaining current state |
| Unanswerable open questions | Questions that could be resolved by the author | Research and answer them; keep only true unknowns |
| Missing success criteria | No way to evaluate if proposal worked | Add measurable outcomes and acceptance criteria |
| Unclear scope | Boundaries of the proposal are fuzzy | Define explicitly what is in-scope and out-of-scope |
| No trade-off analysis | Looks like a one-sided pitch | Document what you're giving up to gain the benefit |

---

## Refactor Process

### Step 1: Read Completely First

**Do not start editing until you understand the intent.**

- Read the entire RFC from start to finish
- Identify the core proposal in one sentence
  - If you can't summarize it in one sentence, the RFC needs scoping work
- Note what's missing or unclear
- Understand what the author is trying to achieve

### Step 2: Evaluate Against Quality Checklist

Use the checklist below to identify gaps. Mark which items are missing or weak.

### Step 3: Fix Issues Section by Section

**Start with the problem statement** — everything flows from a clear problem definition.

1. Problem statement
2. Background / current state
3. Proposal
4. Alternatives considered
5. Rollout / migration plan
6. Success criteria
7. Open questions

**Important:** Fix issues in this order. A vague problem statement will make every other 
section weak.

### Step 4: Verify Alternatives Are Comprehensive

Reviewers will suggest alternatives. Save time by addressing them preemptively:

- List at least 2 alternatives (ideally 3-4)
- Include the "do nothing" option
- For each alternative, explain why it was rejected
- Be fair — don't strawman alternatives

Common alternatives to consider:
- Do nothing (live with current state)
- Incremental improvement (smaller change)
- Buy vs. build (use existing solution)
- Alternative technologies (different tool/framework)
- Different scope (broader or narrower)

### Step 5: Ensure Rollout Is Specific Enough

A good rollout plan can be executed by someone who wasn't involved in writing the RFC.

**Required elements:**
- Phases (what ships in each phase?)
- Success criteria per phase (how do we know it's working?)
- Rollback plan (how do we undo this if it fails?)
- Timeline (when will each phase ship?)

**Red flag:** If the rollout section says "we'll implement this", it's not specific enough.

### Step 6: Resolve Answerable Open Questions

Open questions fall into two categories:

1. **True unknowns** — require experiment, user research, or future discovery
2. **Answerable now** — could be resolved with research, prototyping, or team discussion

**For answerable questions:**
- Do the research and answer them
- Move the answer into the main document
- Remove the question from "Open questions"

**For true unknowns:**
- Keep them in "Open questions"
- Explain why they're unknown (what would we need to resolve them?)
- Explain how we'll resolve them (experiment, pilot, metrics)

---

## Quality Checklist

Every RFC should pass this checklist after refactoring:

### Problem Statement
- [ ] Includes a real example of the current pain (not hypothetical)
- [ ] Explains who is affected and how
- [ ] Quantifies the problem if possible (how often, how many users, etc.)

### Background
- [ ] Explains the current state clearly
- [ ] Can be understood by someone not deeply familiar with the system
- [ ] Establishes necessary context without overwhelming detail

### Proposal
- [ ] Described concisely in 1 paragraph at the start
- [ ] Details follow the summary (don't bury the lede)
- [ ] Specific enough to implement (not just high-level vision)
- [ ] Trade-offs are acknowledged (what are we giving up?)

### Alternatives Considered
- [ ] At least 2 alternatives are listed
- [ ] "Do nothing" option is included
- [ ] Each alternative has a rejection rationale
- [ ] Rejection rationales are fair (not strawman arguments)

### Rollout / Migration Plan
- [ ] Broken into phases with clear boundaries
- [ ] Success criteria per phase (how do we know it's working?)
- [ ] Rollback plan (how do we undo this if it fails?)
- [ ] Timeline or sequencing (what happens when?)

### Success Criteria
- [ ] Measurable outcomes defined
- [ ] Acceptance criteria clear (how do we know when we're done?)
- [ ] Includes both technical and user-facing metrics if applicable

### Open Questions
- [ ] Only includes true unknowns (not questions the author could answer)
- [ ] Each question explains why it's unknown
- [ ] Each question explains how it will be resolved

### Scope
- [ ] In-scope items explicitly listed
- [ ] Out-of-scope items explicitly listed (prevents scope creep)
- [ ] Boundaries are clear

### Overall
- [ ] A non-expert can understand the proposal after reading it
- [ ] Reviewers have enough information to make a decision
- [ ] Implementation can proceed without needing to clarify intent

---

## Output Format

### Refactor Summary

```markdown
## RFC Refactor Summary: [RFC Title]

### Changes Made

**Problem Statement**
- [What was changed and why]

**Background**
- [What was changed and why]

**Proposal**
- [What was changed and why]

**Alternatives**
- [What was changed and why]

**Rollout Plan**
- [What was changed and why]

**Open Questions**
- [Resolved questions: list questions that were answered]
- [Remaining questions: list true unknowns]

### Quality Checklist Results

- [X] Problem statement includes real example
- [X] At least 2 alternatives listed
- [ ] Success criteria defined (still needs work)
- [X] Rollout has phases with success criteria
- [X] Open questions are truly unknown

### Core Proposal (one sentence)

[One sentence summarizing what this RFC proposes]

### Recommended Next Steps

1. [Action item 1, e.g., "Define success metrics for phase 1"]
2. [Action item 2, e.g., "Get feedback from security team"]
3. [Action item 3, e.g., "Ready for review"]
```

### Content Change Markers

When editing the RFC itself, mark your additions:

```markdown
## Problem Statement

[Original content]

**[Added for clarity]:** [Your addition explaining context or examples]

[More original content]
```

Mark substantial changes:

```markdown
## Alternatives Considered

**[Expanded section]:** This section was expanded to include alternatives that reviewers 
are likely to suggest.

### Alternative 1: Do Nothing
[Your addition]

### Alternative 2: Incremental Approach
[Your addition]
```

---

## Refactoring Strategies

### For Vague Problem Statements

**Before:**
```markdown
## Problem
Our API is slow.
```

**After:**
```markdown
## Problem

Our API's `/search` endpoint currently takes 3-5 seconds to return results for queries with 
more than 100 results. This affects approximately 40% of search queries based on last month's 
analytics. Users abandon searches after 2 seconds, leading to a 25% drop-off rate for large 
result sets.

**Example:** A search for "react components" returns 450 results and takes 4.2 seconds, causing 
users to abandon before seeing results.
```

### For Missing Alternatives

**Before:**
```markdown
## Proposal
We should rewrite the search service in Rust.
```

**After:**
```markdown
## Proposal
Rewrite the search service in Rust to achieve sub-500ms response times.

## Alternatives Considered

### 1. Do Nothing
**Pros:** No effort required
**Cons:** Search abandonment rate remains high, user satisfaction remains low
**Rejection reason:** The problem is significant enough to warrant action

### 2. Optimize Existing Python Code
**Pros:** Lower effort, no language change
**Cons:** Profiling showed Python's GIL is the bottleneck; optimizations would be marginal
**Rejection reason:** Tried this; achieved only 10% improvement

### 3. Add Caching Layer
**Pros:** Easier than rewrite, might help frequently searched terms
**Cons:** Cache hit rate is only 15% due to diverse queries; doesn't solve core performance
**Rejection reason:** Prototyped this; insufficient impact for high-effort investment

### 4. Rewrite in Rust
**Pros:** Rust's performance characteristics match our needs; no GIL; strong type safety
**Cons:** Team needs to learn Rust; rewrite effort is substantial
**Selected because:** Performance gains (10× improvement in benchmark) justify the effort
```

### For Missing Rollout Plans

**Before:**
```markdown
## Rollout
We'll implement this and deploy it.
```

**After:**
```markdown
## Rollout

### Phase 1: Prototype (Weeks 1-2)
- Build prototype search service in Rust
- Benchmark against current Python service
- **Success criteria:** <500ms response time on benchmark queries
- **Rollback:** Abandon if benchmarks don't show 3× improvement

### Phase 2: Shadow Mode (Weeks 3-4)
- Deploy Rust service alongside Python service
- Send 10% of traffic to Rust service (shadow; results not returned to users)
- Compare results and latency
- **Success criteria:** Results match Python service; latency <500ms on P95
- **Rollback:** Disable traffic routing if error rate > 0.1%

### Phase 3: Gradual Rollout (Weeks 5-8)
- Route 10% → 25% → 50% → 100% of traffic to Rust service
- Monitor error rate, latency, and user satisfaction metrics
- **Success criteria:** Error rate < 0.1%; latency < 500ms; search abandonment rate < 15%
- **Rollback:** Route traffic back to Python service if any success criterion fails

### Phase 4: Decommission Python Service (Week 9)
- Archive Python code
- Update documentation
- **Success criteria:** No rollbacks for 2 weeks; all metrics stable
```

---

## Constraints

- **Do not change the substance of the proposal** — only improve clarity and completeness. If 
  the proposal itself is flawed, note this separately rather than silently changing it.
- **Always mark where you added content** vs. edited existing content — use **[Added]** or 
  **[Expanded section]** markers
- **Do not remove the author's voice** — clarify and structure, but preserve their intent
- **Be fair to alternatives** — don't strawman options the author rejected; represent them fairly
- **Keep open questions honest** — don't remove questions just to make the RFC look more complete; 
  only remove questions you've actually answered
- **Verify claims** — if the RFC makes quantitative claims (performance, user impact), verify 
  they're accurate or mark them as estimates
- **Do not expand scope** — if the RFC tries to solve too many problems, note this but don't 
  add even more
- **Preserve existing structure** — if the RFC uses a different template, work within that 
  structure unless it's fundamentally broken

---

## When to Stop

An RFC is "refactor complete" when:

- [ ] The quality checklist passes (all items checked)
- [ ] A reviewer unfamiliar with the context can understand the proposal
- [ ] The proposal can be implemented without needing to clarify intent
- [ ] All answerable questions have been answered
- [ ] Alternatives are comprehensive enough that reviewers won't suggest obvious ones

**Note:** "Complete" doesn't mean "approved" — it means "ready for productive review."
