---
name: ecological-impact
description: >
  Assess the compute and carbon cost of a code change or architecture decision. Use
  whenever someone asks "is this efficient?", "what's the environmental impact of this?",
  "how expensive is this at scale?", "will this blow up our infra costs?", or when
  reviewing a PR that adds new queries, background jobs, scheduled tasks, or any feature
  likely to grow with load. Surface the numbers early so teams can make informed tradeoffs
  before the pattern is entrenched.
---

# Skill: Ecological Impact

## Purpose

Quantify the computational and carbon footprint of code changes to inform decisions about 
efficiency, infrastructure sizing, and sustainability. This skill helps teams understand the 
resource implications of their technical choices and identify optimization opportunities before 
they become expensive at scale.

---

## Assessment Framework

Evaluate across five dimensions:

### 1. Compute Intensity
How much CPU/memory does this add?
- Count operations per request, note algorithmic complexity
- **Red flags:** O(n²) or worse, CPU-heavy ops in the request path, unbounded memory growth

### 2. I/O Impact
New queries, API calls, or cache misses?
- Count new DB queries per request, external calls, N+1 patterns
- **Red flags:** N+1 queries, uncached repeated reads, sequential calls that could be parallel

### 3. Storage Impact
Does this generate more data?
- Estimate growth rate (bytes per user/request/day), check retention policy
- **Red flags:** Unbounded growth with no archival, hot storage for cold data, DEBUG logs in prod

### 4. Scaling Behavior
How does this perform at 10×, 100×, 1000× load?
- Calculate at current load, project forward
- **Red flags:** Superlinear growth, vertical-only scaling, global locks

### 5. Idle Cost
Always-on infrastructure? Scheduled jobs?
- Identify if infra can scale to zero; check job frequency
- **Red flags:** <20% utilization on always-on infra, polling that could be event-driven

---

## Output Format

```markdown
## Ecological Impact Assessment: [Change Description]

### Operations Added Per Request
- [list each new query, API call, heavy computation with count]
- Algorithmic complexity: [O(n), O(n²), etc.]

### Load Estimates
- Current requests/day: [N] (source: [metrics / estimate])

### Scaling Projection
| Load | Ops/Day | Assessment |
|------|---------|------------|
| Current (1×) | [N] | [OK / concerning] |
| 10× | [N×10] | [assessment] |
| 100× | [N×100] | [assessment] |

**Classification:** [Linear / Superlinear / Exponential]

### Top Optimization Opportunities
1. [Pattern] — estimated [N]% reduction in [metric], effort [XS/S/M/L]
2. ...

### Overall Assessment
**Impact level:** Negligible | Moderate | Significant | Critical

[One paragraph: key concerns, whether to optimize now or at higher scale]

### Recommendations
- [ ] [Action item]
- [ ] Consider revisiting when load reaches [threshold]
```

---

## Constraints

- Label all estimates clearly — avoid false precision
- Do not block changes for ecological reasons alone; surface data for human tradeoffs
- Flag O(n²) or worse as a scaling concern regardless of current scale
- Document all traffic/cost assumptions so they can be updated with real data

