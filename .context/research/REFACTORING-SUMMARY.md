# Quick Reference: Skill Refactoring Summary

## Files Analyzed
- ✅ `skills/implementing-features/SKILL.md` (215 lines)
- ✅ `skills/writing-tests/SKILL.md` (230 lines)

**Full detailed analysis**: `skill-refactoring-sidecar-references.md` (530 lines)

---

## At a Glance: What Can Be Extracted

### Implementing Features

| Current | Target | Extract | Files to Create |
|---------|--------|---------|-----------------|
| 215 lines | 160 lines | 55 lines | 1 reference file |
| 3 examples + core workflow | Core workflow only | All examples + patterns | `references/code-patterns.md` |

**Extract 83 lines of Examples (lines 117–202) to:**
- **`references/code-patterns.md`** (~65 lines)
  - Example 1: Model + migration pattern
  - Example 2: Bug fixing pattern  
  - Example 3: Spec clarification pattern

**Keep in SKILL.md:**
- Purpose + Pre-flight Checks (48 lines)
- 5 Execution Steps (54 lines)
- Output Format (18 lines)
- Constraints (9 lines)

---

### Writing Tests

| Current | Target | Extract | Files to Create |
|---------|--------|---------|-----------------|
| 230 lines | 160 lines | 70 lines | 3 reference files |
| 3 examples + core workflow | Core workflow only | Examples distributed by type | `references/` × 3 |

**Extract 67 lines of Examples (lines 148–216) to:**

1. **`references/code-patterns.md`** (~60 lines)
   - Example 1: Testing models with Sequelize + Jest
   - Coverage benchmarks (90% for new code, etc.)

2. **`references/edge-cases.md`** (~50 lines)
   - Example 3: Untestable code (global singletons)
   - 5 patterns that block testing
   - How to unblock (link to implementing-features)

3. **`references/troubleshooting.md`** (~45 lines)
   - Example 2: Regression testing (bug + test verification)
   - Common test failures + diagnostic steps
   - Output format reference

**Keep in SKILL.md:**
- Purpose (10 lines)
- Pre-flight Checks (22 lines)
- 7 Execution Steps (53 lines)
- 3 Output Formats (28 lines)
- Constraints (9 lines)

---

## Extraction Boundaries

### Implementing Features
```
Lines 1–10     | Frontmatter        | KEEP
Lines 14–47    | Purpose + Pre-flight| KEEP
Lines 50–113   | Steps + Output     | KEEP
Lines 117–202  | Examples           | EXTRACT → code-patterns.md
Lines 207–215  | Constraints        | KEEP
```

**Natural break**: Line 113 (Output Format ends) → Line 117 (Examples start)
**Result**: Clean extraction with no content disruption

---

### Writing Tests
```
Lines 1–10     | Frontmatter        | KEEP
Lines 14–46    | Purpose + Pre-flight| KEEP
Lines 49–144   | Steps + Outputs    | KEEP
Lines 148–216  | Examples (3)       | EXTRACT to 3 files:
               |   - Example 1      |   → code-patterns.md
               |   - Example 2      |   → troubleshooting.md
               |   - Example 3      |   → edge-cases.md
Lines 222–230  | Constraints        | KEEP
```

**Natural breaks**: Each example is clearly separated
**Result**: Examples can be extracted independently without damaging coherence

---

## What Makes This Refactoring Safe

✅ **Core workflow stays intact**: All procedural steps remain in main SKILL.md  
✅ **Examples are illustrative, not required**: Examples teach patterns; steps teach procedures  
✅ **Clean extraction boundaries**: Examples section has natural delimiters  
✅ **Main file remains actionable**: Can follow either skill using only SKILL.md  
✅ **Reference files are independent**: Each is readable without returning to main  

### Validation Tests
- Read implementing-features main SKILL.md (no examples) → Can implement a feature? ✓ Yes
- Read writing-tests main SKILL.md (no examples) → Can write tests? ✓ Yes
- Read code-patterns.md standalone → Does it make sense? ✓ Yes (with context header)
- Read edge-cases.md standalone → Does it make sense? ✓ Yes (with context header)

---

## Post-Refactoring Line Counts

| File | Current | After | Reduction | Status |
|------|---------|-------|-----------|--------|
| implementing-features/SKILL.md | 215 | 160 | -55 (26%) | ✓ Focused |
| implementing-features/references/code-patterns.md | — | 65 | +65 | New |
| writing-tests/SKILL.md | 230 | 160 | -70 (30%) | ✓ Focused |
| writing-tests/references/code-patterns.md | — | 60 | +60 | New |
| writing-tests/references/edge-cases.md | — | 50 | +50 | New |
| writing-tests/references/troubleshooting.md | — | 45 | +45 | New |
| **TOTAL** | 445 | 580 | +135 | Better organized |

---

## Cross-Reference Map

### Links FROM main SKILL.md TO references

**implementing-features/SKILL.md** →
- Step 3 (Implement Minimally): Link to `references/code-patterns.md` for patterns
- Pre-flight Check 2: Link to `references/code-patterns.md` for examples

**writing-tests/SKILL.md** →
- Step 1 (List test cases): Link to `references/code-patterns.md` for examples
- Step 6 (Run suite): Link to `references/troubleshooting.md` for failures
- Constraints: Link to `references/edge-cases.md` for untestable code

### Links BETWEEN skills

**writing-tests/references/edge-cases.md** →
- Links to `implementing-features` skill: "Refactor for testability"

**implementing-features/SKILL.md** (Output Format) →
- Suggests: "Next: writing-tests" (already exists, no change needed)

---

## Reference File Templates

### Header for Each Reference File
```markdown
# [Skill Name] — [Type: Patterns | Edge Cases | Troubleshooting]

**See also**: [Link to main SKILL.md]
**Related skills**: [Any skills that depend on this]

**In this guide:**
- [Pattern/Case 1]: [description]
- [Pattern/Case 2]: [description]
- ...

---

## [Pattern/Case 1]

[Content here]

---

## [Pattern/Case 2]

[Content here]
```

---

## Implementation Checklist

- [ ] Phase 1: Create reference file directories
  - [ ] `skills/implementing-features/references/`
  - [ ] `skills/writing-tests/references/`

- [ ] Phase 2: Extract content to new files
  - [ ] Copy examples to code-patterns.md files
  - [ ] Create edge-cases.md for writing-tests
  - [ ] Create troubleshooting.md for writing-tests

- [ ] Phase 3: Remove extracted content from main SKILL.md
  - [ ] Delete Examples section
  - [ ] Update line numbers in any comments

- [ ] Phase 4: Add cross-references
  - [ ] Update all KEEP sections with "See references/" callouts
  - [ ] Verify links use relative paths

- [ ] Phase 5: Validate
  - [ ] Main SKILL.md reads standalone ✓
  - [ ] Reference files read standalone ✓
  - [ ] No content duplicated ✓
  - [ ] All links work ✓

---

## Expected Outcome

**Before**: Two large monolithic skill files (445 lines total)
**After**: Two focused skill files (320 lines) + 4 organized reference files (220 lines)

**Benefits**:
- Skill core is scannable (160 lines each → quick overview)
- Patterns are accessible but not overwhelming
- Learners navigate by use case (code-patterns / edge-cases / troubleshooting)
- Main SKILL.md remains the "how to" guide
- References are the "what" and "when" guides

---

## Questions?

Refer to full analysis: `.context/research/skill-refactoring-sidecar-references.md`

Detailed sections:
- Line count analysis with character counts
- Content categorization rationale
- Extraction boundaries with examples
- Validation criteria checklist
- Risks and mitigations
- Implementation notes for each phase
