# Skill Refactoring Analysis — Complete Package

## 📋 Analysis Overview

This package contains a comprehensive analysis of refactoring two skill files (`implementing-features` and `writing-tests`) into a **sidecar references pattern**. The goal is to reduce main SKILL.md files from 215–230 lines to ~160 lines while organizing supporting content into focused reference files.

**Status**: Analysis complete ✅  
**Total analysis**: 1,114 lines across 3 documents  
**Date**: 2026-07-06

---

## 📚 Documents in This Package

### 1. **REFACTORING-SUMMARY.md** (232 lines)
**Best for**: Quick overview and implementation planning

- At-a-glance extraction targets (what gets moved where)
- Post-refactoring line counts and targets
- Extraction boundaries with line ranges
- Cross-reference map
- Implementation checklist (5 phases)
- Expected outcomes

**Read this first** if you're implementing the refactoring.

---

### 2. **REFACTORING-VISUAL-GUIDE.md** (352 lines)
**Best for**: Understanding structure and navigation

- Visual diagrams (before/after folder structures)
- Content flow maps (how users navigate)
- Cross-reference callout examples
- Line count visualizations
- User scenarios and pathways
- Validation checklists
- Before/after comparison

**Read this** to understand the user experience and structure.

---

### 3. **skill-refactoring-sidecar-references.md** (530 lines)
**Best for**: Deep dive and rationale documentation

- Detailed file statistics (lines, characters, section breakdown)
- Content categorization with rationale
- Section-by-section analysis (what stays, what goes, why)
- Proposed sidecar structure for each skill
- Validation criteria checklists
- Cross-file reference map (detailed)
- Line count targets with detailed breakdown
- Extraction boundaries and natural break points
- Content integrity checklist
- Implementation notes for each phase
- Risks and mitigations
- Recommendations for file structure

**Read this** for detailed rationale and complete reference.

---

## 🎯 Quick Start: What You Need to Know

### Executive Summary
- **Files to refactor**: 2 SKILL.md files (445 lines total)
- **Main file reduction**: 215 → 160 lines (impl) and 230 → 160 lines (tests)
- **New reference files**: 4 files (code-patterns × 2, edge-cases, troubleshooting)
- **Why**: Improve scannability, organize patterns by use case, maintain workflow coherence
- **Safe?**: Yes — core workflow stays in main files; examples are supporting material

### What Gets Extracted

**implementing-features/SKILL.md:**
```
Lines 117–202 (83 lines of Examples)
    ↓
Move to: references/code-patterns.md
```

**writing-tests/SKILL.md:**
```
Lines 148–216 (67 lines of Examples)
    ↓ Split into 3 files:
    ├─ Example 1 → references/code-patterns.md
    ├─ Example 2 → references/troubleshooting.md
    └─ Example 3 → references/edge-cases.md
```

### What Stays in Main Files

**Both SKILL.md files retain:**
- Purpose (why to use this skill)
- Pre-flight Checks (gates for starting)
- Execution Steps (the workflow)
- Output Format (what "done" looks like)
- Constraints (non-negotiables)

---

## 📊 Key Metrics

| Metric | Value |
|--------|-------|
| Current main files | 445 lines |
| After refactoring | 320 lines (main) + 220 lines (references) |
| Main file reduction | 27% (110 lines) |
| Reference files created | 4 |
| Examples extracted | 6 total (3 per skill) |
| Natural break points | 4 (clean extraction boundaries) |

---

## 🔄 Implementation Phases (5 Total)

### Phase 1: Create Reference File Directories
- Create `skills/implementing-features/references/`
- Create `skills/writing-tests/references/`

### Phase 2: Extract Content to New Files
- Copy examples to `code-patterns.md` files
- Create `edge-cases.md` for writing-tests
- Create `troubleshooting.md` for writing-tests

### Phase 3: Remove Extracted Content from Main SKILL.md
- Delete Examples section from both main files
- Update any line number references

### Phase 4: Add Cross-References
- Add callouts in main SKILL.md pointing to references
- Add headers/navigation to reference files
- Verify all links use relative paths

### Phase 5: Validate
- Main SKILL.md reads standalone ✓
- Reference files read standalone ✓
- No content duplicated ✓
- All links work ✓

---

## ✅ Validation Criteria

**Main SKILL.md files must:**
- [ ] Be 155–165 lines
- [ ] Include all core workflow steps (unchanged)
- [ ] Include Pre-flight Checks that gate bad starts
- [ ] Include Output Format with success criteria
- [ ] Include Constraints
- [ ] Read as a complete, standalone guide
- [ ] Have explicit callouts to reference files at relevant steps

**Reference files must:**
- [ ] Be 45–65 lines each
- [ ] Be readable without returning to main SKILL.md
- [ ] Have clear navigation headers
- [ ] Include concrete code examples
- [ ] Link back to main SKILL.md for procedural context
- [ ] Never duplicate content from main files

---

## 🗺️ Navigation for Implementation

**If you want to...**

| Goal | Read This | Then | Then |
|------|-----------|------|------|
| Understand what to extract | REFACTORING-SUMMARY.md | Section: "At a Glance" | — |
| See folder structure post-refactor | REFACTORING-VISUAL-GUIDE.md | Section: "After Refactoring" | — |
| Understand user navigation | REFACTORING-VISUAL-GUIDE.md | Section: "Content Flow Map" | — |
| Get detailed rationale | skill-refactoring-sidecar-references.md | Skill 1 or Skill 2 section | — |
| Get extraction boundaries | REFACTORING-SUMMARY.md | Section: "Extraction Boundaries" | Or VISUAL-GUIDE |
| See cross-references | REFACTORING-SUMMARY.md | Section: "Cross-Reference Map" | — |
| Implement the refactoring | REFACTORING-SUMMARY.md | Section: "Implementation Checklist" | Use line ranges |
| Validate after refactoring | skill-refactoring-sidecar-references.md | Section: "Validation After Refactoring" | — |

---

## 🔍 File-by-File Breakdown

### implementing-features/SKILL.md

**Current**: 215 lines, 7.3 KB
**After**: 160 lines

**Sections:**
```
✓ KEEP  Lines 1–10     Frontmatter (metadata)
✓ KEEP  Lines 14–21    Purpose
✓ KEEP  Lines 24–47    Pre-flight Checks
✓ KEEP  Lines 50–113   Execution Steps (5) + Output Format
✗ MOVE  Lines 117–202  Examples (83 lines)
✓ KEEP  Lines 207–215  Constraints
```

**Extract to**: `references/code-patterns.md` (65 lines)
- Example 1: Model + migration pattern (31 lines)
- Example 2: Bug fixing pattern (26 lines)
- Example 3: Spec clarification pattern (19 lines)

---

### writing-tests/SKILL.md

**Current**: 230 lines, 8.1 KB
**After**: 160 lines

**Sections:**
```
✓ KEEP  Lines 1–10     Frontmatter
✓ KEEP  Lines 14–22    Purpose
✓ KEEP  Lines 25–46    Pre-flight Checks
✓ KEEP  Lines 49–144   Execution Steps (7) + Output Formats
✗ MOVE  Lines 148–216  Examples (67 lines) → 3 files
✓ KEEP  Lines 222–230  Constraints
```

**Extract to three files:**
1. `references/code-patterns.md` (60 lines)
   - Example 1: Testing models with Sequelize + Jest (22 lines)

2. `references/edge-cases.md` (50 lines)
   - Example 3: Untestable code patterns (18 lines)
   - 5 patterns that block testing
   - How to refactor

3. `references/troubleshooting.md` (45 lines)
   - Example 2: Regression testing (20 lines)
   - Common failures + diagnosis

---

## 🎓 Why This Refactoring Works

1. **Core workflow is self-contained**: All procedural steps stay in main files
2. **Examples are illustrative, not required**: Examples teach patterns; steps teach procedures
3. **Clean extraction boundaries**: No content duplication or context loss
4. **Natural folder structure**: "references/" folder groups all supporting material
5. **Main files remain actionable**: Can follow either skill using only main SKILL.md
6. **Reference files are independent**: Can read one without context from main file
7. **Cross-references are explicit**: Callouts in main files point to relevant references

---

## 🚀 Success Criteria

After refactoring, you can answer "yes" to:

- [ ] Can someone read `implementing-features/SKILL.md` and implement a feature without reading references?
- [ ] Can someone read `writing-tests/SKILL.md` and write tests without reading references?
- [ ] Can someone read `references/code-patterns.md` standalone and understand patterns?
- [ ] Can someone read `references/edge-cases.md` standalone and understand what makes code untestable?
- [ ] Is the main SKILL.md ~160 lines (from 215–230)?
- [ ] Are reference files ~50–65 lines each?
- [ ] Are cross-references using relative paths?
- [ ] Is no content duplicated across files?

---

## 📝 Reference File Templates

**Header template for all reference files:**

```markdown
# [Skill Name] — [Type]

**See also**: [Link to main SKILL.md]
**Related skills**: [Any dependent skills]

**In this guide:**
- [Topic 1]: [description]
- [Topic 2]: [description]

---

## [Topic 1]

[Content]

---

## [Topic 2]

[Content]
```

---

## 🔗 Interdependencies

### Links FROM main SKILL.md TO references

```
implementing-features/SKILL.md
  ├─ Pre-flight Check 2 → references/code-patterns.md
  └─ Step 3 → references/code-patterns.md

writing-tests/SKILL.md
  ├─ Step 1 → references/code-patterns.md
  ├─ Step 6 → references/troubleshooting.md
  └─ Constraints → references/edge-cases.md
```

### Links BETWEEN reference files

```
writing-tests/references/edge-cases.md
  └─ "How to unblock" → implementing-features (refactor for testability)
```

---

## 🛡️ Risks & Mitigations

| Risk | Mitigation |
|------|-----------|
| User misses examples in references | Add explicit "⚠️ See references/..." callouts at decision points |
| References become stale | Establish rule: references are examples only; procedures stay in main |
| Links break if files move | Use relative paths consistently; establish path convention |
| Developers skip references | Add "Before you start" note: read main SKILL.md + browse references |
| Line numbers drift | Update references when main SKILL.md changes |

---

## 📞 Questions?

- **"What exactly gets moved?"** → See REFACTORING-SUMMARY.md, section "At a Glance"
- **"Where do I put things?"** → See REFACTORING-VISUAL-GUIDE.md, section "After Refactoring"
- **"Why is this safe?"** → See skill-refactoring-sidecar-references.md, section "Content Integrity Checklist"
- **"How do I implement it?"** → See REFACTORING-SUMMARY.md, section "Implementation Checklist"
- **"What do I verify?"** → See skill-refactoring-sidecar-references.md, section "Validation After Refactoring"

---

## 📄 Document Metadata

| Document | Lines | Size | Purpose |
|----------|-------|------|---------|
| REFACTORING-SUMMARY.md | 232 | 7.2 KB | Quick reference, implementation guide |
| REFACTORING-VISUAL-GUIDE.md | 352 | 12 KB | Structure diagrams, user flows, navigation |
| skill-refactoring-sidecar-references.md | 530 | 20 KB | Deep analysis, detailed rationale |
| **TOTAL** | **1,114** | **39 KB** | Complete documentation package |

---

## ✨ Next Steps

1. **Read**: Start with REFACTORING-SUMMARY.md (10 min)
2. **Understand**: Review REFACTORING-VISUAL-GUIDE.md (10 min)
3. **Plan**: Create implementation checklist from REFACTORING-SUMMARY.md (5 min)
4. **Reference**: Use skill-refactoring-sidecar-references.md during implementation (as needed)
5. **Execute**: Follow the 5 implementation phases
6. **Validate**: Check against validation criteria from all documents

---

**Analysis completed**: 2026-07-06  
**Ready for implementation**: ✅ Yes

