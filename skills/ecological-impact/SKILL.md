---
name: ecological-impact
description: >
  Assess the environmental and compute cost impact of code changes. Use when evaluating 
  "what's the environmental impact", "how compute-intensive is this", "is this efficient 
  enough", or when reviewing architecture choices with significant infrastructure footprint. 
  Quantifies computational and carbon footprint to inform efficiency and sustainability decisions.
---

# Skill: Ecological Impact

## Purpose

Quantify the computational and carbon footprint of code changes to inform decisions about 
efficiency, infrastructure sizing, and sustainability. This skill helps teams understand the 
resource implications of their technical choices and identify optimization opportunities before 
they become expensive at scale.

---

## Assessment Framework

Evaluate code changes across five dimensions:

### 1. Compute Intensity

**Question:** How much CPU/memory does this add?

- Count the number of operations per request/job
- Identify algorithmic complexity (O(n), O(n²), etc.)
- Check if compute is proportional to data size or worse

**Red flags:**
- O(n²) or worse algorithmic complexity
- CPU-intensive operations in the request path (encryption, image processing, etc.)
- Memory allocations that grow with data size without bounds

### 2. I/O Impact

**Question:** Does this add database queries? Network calls? Cache misses?

- Count new database queries per user request
- Count new external API calls
- Identify cache misses (reads without caching)
- Check for N+1 query patterns

**Red flags:**
- N+1 queries (fetching related records in a loop)
- Uncached repeated queries
- Sequential API calls that could be parallelized
- Large payloads fetched but only partially used

### 3. Storage Impact

**Question:** Does this generate/store more data?

- Estimate data growth rate (bytes per user/request/day)
- Check retention requirements (how long is data kept?)
- Identify log volume changes

**Red flags:**
- Unbounded data growth (no cleanup/archival strategy)
- Large objects stored in expensive storage (hot storage for cold data)
- Logs at DEBUG level in production

### 4. Scaling Behavior

**Question:** How does this perform at 10×, 100×, 1000× current load?

- Calculate resource usage at current load
- Project resource usage at 10×, 100×, 1000× load
- Identify whether additional infrastructure is needed per user or fixed cost

**Red flags:**
- Resource usage grows faster than linearly with load
- Requires vertical scaling (bigger machines) instead of horizontal scaling
- Single points of contention (global locks, single-threaded bottlenecks)

### 5. Idle Cost

**Question:** Does this run on a schedule? Does it require always-on infrastructure?

- Identify scheduled jobs and their frequency
- Check if infrastructure must run 24/7 or can scale to zero
- Calculate idle time (time infrastructure is running but not doing useful work)

**Red flags:**
- Always-on infrastructure with low utilization (<20%)
- Scheduled jobs that could be event-driven
- Redundant infrastructure that duplicates cloud provider capabilities

---

## Estimation Process

### Step 1: Count Operations

For the code change, count:

- New database queries per request: [N]
- New external API calls per request: [N]
- New cache reads/writes per request: [N]
- New heavy computations per request: [description]

### Step 2: Estimate Current Volume

Determine current load:

- Requests per day: [N]
- Jobs per day: [N]
- Active users: [N]

If metrics aren't available, use conservative estimates based on similar systems or ask for 
analytics data.

### Step 3: Calculate Daily Overhead

```
New operations per day = operations per request × requests per day
```

Example:
- 3 new queries per request
- 100,000 requests per day
- = 300,000 additional queries per day

### Step 4: Convert to Infrastructure Units

Use cloud provider metrics or benchmarks:

- Database queries: [N] queries = [X] vCPU-minutes
- API calls: [N] calls = [X] MB transferred = [X] vCPU-minutes
- Storage: [N] GB per day = [X] GB per year

### Step 5: Assess Scaling Behavior

Project impact at future scale:

| Load Multiplier | Operations/Day | Infrastructure Needed | Cost Impact |
|-----------------|----------------|----------------------|-------------|
| Current (1×) | [N] | [current setup] | Baseline |
| 10× | [N × 10] | [projection] | [estimate] |
| 100× | [N × 100] | [projection] | [estimate] |

**Key question:** Does this scale linearly, or does it require disproportionate resources at scale?

---

## Optimization Recommendations

Common patterns and their fixes:

| Pattern | Impact | Recommendation | Estimated Improvement |
|---------|--------|----------------|----------------------|
| N+1 queries | High | Batch or eager-load | [N]× fewer queries |
| Uncached repeated computation | Medium | Add caching layer | [N]% CPU reduction |
| Synchronous heavy computation in request path | High | Move to background job | [N]ms latency improvement |
| Large payload with partial usage | Medium | Paginate or project fields | [N]% bandwidth reduction |
| Scheduled job that could be event-driven | Medium | Convert to event trigger | [N]% idle cost reduction |
| Sequential API calls | Medium | Parallelize calls | [N]% latency improvement |
| Global lock | High | Use fine-grained locking or optimistic concurrency | [N]× throughput improvement |

### Prioritization

Focus optimization efforts on:

1. **O(n²) or worse algorithms** — these become critical at scale
2. **Operations in the hot path** — user-facing request handlers
3. **N+1 queries** — easy to fix, high impact
4. **Always-on infrastructure with low utilization** — constant cost drain

---

## Output Format

```markdown
## Ecological Impact Assessment: [Change Description]

### Compute Added
- Operations per request: [list with counts]
- Algorithmic complexity: [O(n), O(n²), etc.]
- Heavy computations: [description]

### Current Load Estimate
- Requests/day: [N] (source: [metrics/estimate])
- Current volume: [additional context]

### Projected Daily Overhead
- Additional queries/day: [N]
- Additional API calls/day: [N]
- Additional compute: [X] vCPU-hours/day
- Additional storage: [X] GB/day

### Scaling Behavior
| Load | Operations/Day | Assessment |
|------|----------------|------------|
| Current | [N] | [OK / concerning / critical] |
| 10× | [N × 10] | [assessment] |
| 100× | [N × 100] | [assessment] |

**Scaling classification:** [Linear / Polynomial / Exponential]

### Top Optimization Opportunities
1. [Description] — estimated [N]% reduction in [metric]
   - Current: [before state]
   - Proposed: [after state]
   - Effort: [XS/S/M/L]

2. [Description] — estimated [N]% reduction in [metric]
   - Current: [before state]
   - Proposed: [after state]
   - Effort: [XS/S/M/L]

### Overall Assessment
**Impact level:** [Negligible | Moderate | Significant | Critical]

**Summary:** [One paragraph explaining the overall ecological impact, key concerns, and whether 
optimizations are recommended now or can wait until scale increases]

### Recommendations
- [ ] [Action item 1]
- [ ] [Action item 2]
- [ ] Consider revisiting when load reaches [threshold]
```

---

## Benchmarking and Validation

When possible, validate estimates with actual measurements:

### Load Testing

```bash
# Example: Measure query count before and after
# Before
ab -n 100 -c 10 https://api.example.com/endpoint
# Check database query logs

# After
ab -n 100 -c 10 https://api.example.com/endpoint
# Compare query count
```

### Profiling

```bash
# Example: Profile CPU usage
# Node.js
node --prof app.js
node --prof-process isolate-*.log

# Python
python -m cProfile -o output.prof app.py
python -m pstats output.prof
```

### Monitoring

If the change is already deployed, use observability tools:

- Database query count: Check slow query logs or APM tools
- API latency: Check response time metrics
- Error rate: Check for timeouts or failures under load

---

## Constraints

- **All estimates must be labeled as estimates** — avoid false precision
- **Do not block changes for ecological reasons alone** — surface the data and let humans decide 
  the tradeoff
- **Flag anything O(n²) or worse as a scaling concern** regardless of current scale — these 
  become critical as data grows
- **Always provide at least one optimization recommendation** — even if impact is negligible, 
  identify what could be improved
- **Do not optimize prematurely** — if current scale is low and scaling behavior is linear, 
  note it but don't require optimization now
- **Compare against cloud provider capabilities** — don't reinvent caching, load balancing, or 
  auto-scaling if the provider offers it
- **Document all assumptions** — traffic estimates, query costs, storage costs — so they can be 
  updated as real data becomes available
