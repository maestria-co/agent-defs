# MKT-0005 Validation Plan

**Purpose:** Define how to measure cache effectiveness improvements after implementing the cache-friendly structure pattern.

**Status:** Ready for production validation  
**When to run:** After restructuring agents and deploying to production

---

## Limitation

We cannot measure cache benefits from the development environment because:
- Cache metrics (`cache_read_input_tokens`, `cached_tokens`) only appear in API responses
- We need actual agent invocations through Anthropic/OpenAI APIs
- Requires production or staging deployment with API access

---

## Validation Approach

### Phase 1: Baseline Measurement (Pre-Restructure)

**If agents are already deployed and haven't been restructured yet:**

1. Select a high-frequency agent (e.g., Coder, Manager)
2. Log API responses for 20 invocations
3. Extract metrics:
   - Anthropic: `cache_read_input_tokens`, `cache_creation_input_tokens`
   - OpenAI: `cached_tokens`, `cache_write_tokens`
4. Calculate baseline:
   - Cache hit rate: `(calls with cache_read > 0) / total_calls`
   - Average cached tokens per call
   - Cost per invocation (with 10% discount on cached tokens)

**If agents haven't been deployed yet:**
- Skip baseline — compare against theoretical maximum (90% cache hit rate after first call)

### Phase 2: Apply Pattern

Our survey shows agents are already 80-95% static, so restructuring is minimal:

**Agents that already follow pattern (no changes needed):**
- `agents/coder.agent.md` (90-95% static already)
- `agents/tester.agent.md` (90% static already)
- `agents/researcher.agent.md` (likely similar structure)

**Agent that may benefit from reordering:**
- `agents/manager.agent.md` — has Session Start/Turn Start sections that inject dynamic content early (lines 20-177)

**Recommendation:** Move Manager's dynamic orchestration to bottom if not already done.

### Phase 3: Post-Restructure Measurement

After deploying restructured agents:

1. Run the same agent 20 times with **identical static content** and **varying tasks**
2. Log API responses
3. Extract metrics (same fields as Phase 1)
4. Calculate improved metrics:
   - Cache hit rate (expect 90-95% on calls 2-20)
   - Average cached tokens per call
   - Cost per invocation
5. Compare to baseline

**Expected improvements:**
- Cache hit rate: increase from baseline to 90-95%
- Cost per invocation: decrease by ~63-85% (90% savings on static tokens which are 70-95% of prompt)
- Latency: decrease by 2-5× on cached calls (not measured via metrics, but observable)

---

## Measurement Script Template

```python
# cache_validation.py
# Run this script against deployed agents to measure cache effectiveness

import anthropic
import json
from datetime import datetime

client = anthropic.Anthropic(api_key="YOUR_API_KEY")

def measure_cache_effectiveness(agent_prompt_static, num_calls=20):
    """
    Invoke an agent multiple times with varying dynamic content.
    Log cache metrics to validate the pattern.
    """
    results = []
    
    for i in range(num_calls):
        # Dynamic content changes each call
        task_dynamic = f"Task {i+1}: Implement feature X with variation {i}"
        
        # Full prompt: static (unchanging) + dynamic (changes each call)
        full_prompt = agent_prompt_static + "\n\n# Current Task\n" + task_dynamic
        
        response = client.messages.create(
            model="claude-sonnet-4.6",
            max_tokens=1024,
            system=full_prompt,
            messages=[{"role": "user", "content": "Begin"}]
        )
        
        # Extract cache metrics
        usage = response.usage
        cache_read = getattr(usage, 'cache_read_input_tokens', 0)
        cache_creation = getattr(usage, 'cache_creation_input_tokens', 0)
        input_tokens = usage.input_tokens
        
        result = {
            "call": i + 1,
            "cache_read": cache_read,
            "cache_creation": cache_creation,
            "input_tokens": input_tokens,
            "cache_hit": cache_read > 0
        }
        results.append(result)
        
        print(f"Call {i+1}: read={cache_read}, creation={cache_creation}, hit={cache_read > 0}")
    
    # Calculate summary
    warm_calls = results[1:]  # Skip first call (cold)
    hit_rate = sum(1 for r in warm_calls if r['cache_hit']) / len(warm_calls)
    avg_cached = sum(r['cache_read'] for r in warm_calls) / len(warm_calls)
    
    print(f"\n=== Summary ===")
    print(f"Cache hit rate (calls 2-20): {hit_rate:.1%}")
    print(f"Average cached tokens: {avg_cached:.0f}")
    print(f"Expected savings: {avg_cached * 0.9:.0f} tokens/call @ 90% discount")
    
    return results

# Example usage:
# static_content = open('agents/coder.agent.md').read()  # up to cache breakpoint
# results = measure_cache_effectiveness(static_content, num_calls=20)
```

---

## Success Criteria

✅ **Pattern is working if:**
- Calls 2-20 show `cache_read > 0` and `cache_creation = 0` (hit rate ≥ 90%)
- Average cached tokens ≈ 70-95% of total input tokens
- Cost per invocation drops by ~63-85% compared to baseline

❌ **Pattern is NOT working if:**
- `cache_read = 0` on all calls → dynamic content in static zone
- Both metrics = 0 → prompt below minimum threshold (512-4096 tokens)
- `cache_creation > 0` on every call → breakpoint on dynamic content

---

## Next Steps After Validation

If validation shows improvements:
1. Document actual metrics in `.context/retrospectives/MKT-0005-validation-results.md`
2. Apply pattern to remaining agents
3. Add cache monitoring to production dashboards

If validation shows no improvement:
1. Review restructured agents for hidden dynamic content in static zone
2. Check token counts (may be below caching threshold)
3. Verify cache breakpoint placement
4. Consult `agents/_shared/conventions.md` § Measuring Cache Effectiveness § Warning Signs
