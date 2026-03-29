---
name: log-query
description: >
  Query and analyze application logs to debug issues, investigate incidents, or understand 
  system behavior. Use when asked to "look at the logs", "find errors in logs", "what do the 
  logs show", "investigate this from logs", or during any production incident investigation. 
  Prevents wasted time from unfocused log reading by applying structured query patterns.
---

# Skill: Log Query

## Purpose

Extract meaningful signal from application logs to diagnose issues, trace request flows, and 
understand system behavior. This skill prevents wasted time from unfocused log reading by 
applying structured query patterns and asking the right questions before diving into log data.

---

## Pre-Query: Define the Question

**Never read logs without a defined question.** Unfocused log reading wastes time and misses signal.

### Good Questions

| Question | Why It's Answerable |
|----------|---------------------|
| Why did requests fail between 14:00-14:30? | Specific time window and failure condition |
| What errors occurred for user ID 12345? | Specific entity and condition |
| Which endpoints had response times > 5 seconds today? | Specific metric and threshold |
| What happened to request ID abc-123? | Specific request trace |

### Bad Questions

| Question | Why It's Not Answerable |
|----------|-------------------------|
| Show me all errors | Too broad — could be thousands of unrelated errors |
| Are there any problems? | Undefined — what counts as a problem? |
| What's wrong with the app? | Requires knowing what "wrong" means first |

### Question Template

```markdown
## Investigation Question

**What am I trying to learn?**
[Specific question with defined success criteria]

**Time window:**
[Start time] to [End time] (narrowest window that covers the incident)

**Entity filter (if applicable):**
[User ID / Session ID / Request ID / IP address / etc.]

**Success criteria:**
[What would a satisfying answer look like?]
```

---

## Query Strategy Selection

Choose the right query pattern based on your investigation goal:

### 1. Error Investigation

**Goal:** Understand why errors are occurring

**Strategy:**
1. Filter by log level (ERROR or FATAL)
2. Group by error message or error code
3. Count occurrences
4. Examine most frequent error first
5. Find first occurrence to identify when it started

### 2. Request Tracing

**Goal:** Follow a specific request through the system

**Strategy:**
1. Filter by correlation ID / request ID / trace ID
2. Sort chronologically
3. Follow the request through each service/component
4. Identify where the request failed or slowed down

### 3. Performance Investigation

**Goal:** Find slow requests or operations

**Strategy:**
1. Filter by response time / duration above threshold
2. Group by endpoint or operation
3. Identify patterns (time of day, specific users, data size)
4. Examine slowest requests for common factors

### 4. User-Specific Investigation

**Goal:** Understand what happened for a specific user

**Strategy:**
1. Filter by user ID or session ID
2. Sort chronologically
3. Trace the user's journey through the system
4. Identify errors or unexpected behavior in their flow

### 5. Pattern Detection

**Goal:** Identify systemic issues vs. one-off errors

**Strategy:**
1. Start with error query
2. Count occurrences per error type
3. Plot over time (if possible) to see if errors are clustered
4. Check if errors affect one user or many
5. Check if errors affect one endpoint or many

---

## Common Query Patterns

### Command-Line (grep/awk/sed)

**Always disable pagers** to avoid interactive tools interfering with output.

```bash
# Find all errors in a time window
grep "ERROR" app.log | grep "2024-01-15 14:"

# Find errors for a specific user
grep 'user_id":"12345"' app.log | grep "ERROR"

# Find slow requests (>5000ms in JSON logs)
grep '"duration_ms":[5-9][0-9][0-9][0-9]' app.log  # Matches 5000+

# Count errors by type
grep "ERROR" app.log | grep -oP '"code":\K[^,}]+' | sort | uniq -c | sort -rn

# Find first occurrence of an error
grep "ERROR" app.log | grep "NullPointerException" | head -n 1

# Extract request trace by correlation ID
grep "correlation_id\":\"abc-123" app.log | sort

# Find errors that occurred after a deployment (timestamp)
awk '$1 >= "2024-01-15T14:30:00"' app.log | grep "ERROR"
```

### Structured Log Platforms (Datadog, Splunk, CloudWatch)

**Always filter by time window first** to reduce cost and noise.

#### Datadog

```
# Error investigation
status:error @timestamp:[2024-01-15T14:00 TO 2024-01-15T14:30]

# Request tracing
@correlation_id:abc-123

# Performance
@duration:>5000 @timestamp:[now-1h TO now]

# User-specific
@user_id:12345 status:error

# Count errors by type
status:error @timestamp:[now-1d TO now] | count by @error.code
```

#### Splunk

```
# Error investigation
level=ERROR earliest=-30m latest=now

# Request tracing
correlation_id="abc-123" | sort _time

# Performance
response_time>5000 earliest=-1h latest=now | stats count by endpoint

# User-specific
user_id="12345" level=ERROR

# Error rate over time
level=ERROR | timechart count by error_code
```

#### CloudWatch Logs Insights

```
# Error investigation
fields @timestamp, @message
| filter level = "ERROR"
| filter @timestamp >= "2024-01-15T14:00:00" and @timestamp <= "2024-01-15T14:30:00"

# Request tracing
fields @timestamp, @message
| filter correlation_id = "abc-123"
| sort @timestamp asc

# Performance
fields @timestamp, duration_ms, endpoint
| filter duration_ms > 5000
| stats count() by endpoint

# User-specific
fields @timestamp, @message
| filter user_id = "12345" and level = "ERROR"

# Count errors by type
fields @timestamp, error_code
| filter level = "ERROR"
| stats count() by error_code
```

---

## Query Workflow

### Step 1: Start Narrow

Begin with the most specific filter:

1. Time window (narrowest that covers the issue)
2. Entity filter (user, request, session)
3. Condition (error level, threshold)

### Step 2: Broaden Only If Needed

If the narrow query doesn't explain the issue, expand gradually:

- Widen the time window
- Remove entity filter
- Lower the threshold

### Step 3: Look for Patterns

Once you have relevant logs:

- **One error or many?** Count unique occurrences
- **One user or many?** Group by user/session
- **One endpoint or many?** Group by endpoint/operation
- **Clustered in time?** Plot timestamps to see if errors spike

### Step 4: Correlate Across Services

For distributed systems:

1. Find the correlation ID / trace ID in the initial service's logs
2. Search for the same correlation ID in downstream services
3. Follow the request through each service to find where it failed or slowed

### Step 5: Summarize Findings

Don't just dump logs — summarize:

- **What you found:** [error type, count, affected users]
- **When it occurred:** [time window, frequency]
- **Where it occurred:** [service, endpoint, component]
- **Apparent cause:** [hypothesis based on log evidence]
- **Recommended next step:** [what to investigate or fix next]

---

## Output Format

```markdown
## Log Query Results: [Investigation Question]

### Query Used
```
[Exact query run, so it can be repeated]
```

### Findings

**What:** [Description of what the logs show]
**When:** [Time window and frequency]
**Where:** [Service, endpoint, or component]
**How many:** [Count of occurrences, affected users, etc.]

### Evidence

```
[Relevant log excerpts — 5-10 lines max, not the full dump]
```

### Pattern Analysis

- [Pattern 1: e.g., "Errors only occur for requests > 10MB"]
- [Pattern 2: e.g., "All failures happened between 14:15-14:20"]
- [Pattern 3: e.g., "Only affects mobile clients"]

### Apparent Cause

[Hypothesis based on log evidence]

### Recommended Next Step

[What to investigate or fix based on these findings]
```

---

## Special Cases

### Intermittent Issues

If the issue doesn't reproduce consistently:

- Check for time-based patterns (time of day, day of week)
- Check for load-based patterns (high traffic periods)
- Check for user-based patterns (specific clients, mobile vs. web)
- Check for data-based patterns (large requests, specific input values)

### Missing Logs

If expected logs are missing:

- Verify log level is set correctly (DEBUG logs might be disabled in prod)
- Check if logs are being sampled (some platforms sample high-volume logs)
- Check if the code path is actually being executed (add temporary logging)
- Check log retention (old logs might be deleted)

### Too Many Logs

If queries return thousands of results:

- Add more specific filters (user, endpoint, error code)
- Sample randomly (e.g., `shuf -n 100`) to get a representative subset
- Group and count first, then drill into the most frequent issues

---

## Constraints

- **Never read logs without a defined question** — unfocused log reading wastes time and misses signal
- **Always include the query used in findings** — others need to be able to repeat your investigation
- **Redact PII and credentials** — never include sensitive data in reports or logs shared externally
- **Limit log excerpts** — include 5-10 relevant lines, not hundreds of lines of logs
- **Always disable pagers** (`git --no-pager`, `less -F`, or pipe to `| cat`) when querying 
  logs programmatically
- **Filter by time window first** when using cloud log platforms — reduces cost and noise
- **Use structured query syntax** over free-text search when available — faster and more accurate
- **Do not assume causation from correlation** — logs show what happened, not necessarily why
