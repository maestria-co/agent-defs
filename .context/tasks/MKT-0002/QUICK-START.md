# Quick Start Card — Tomorrow Morning

## ✅ You're Ready to Start!

**All Phase 1 tasks are available** (no dependencies). Pick one and go!

---

## 🎯 Recommended Starting Point

### Option A: High Impact (5-6 hours)
```
Task: p1-sidecar-poc
Goal: Refactor 2 skills to use references/ pattern
Why: Proves the pattern, unlocks Phase 2, high value
```

**Quick steps:**
1. Create `skills/implementing-features/references/` directory
2. Move detailed content from SKILL.md to references/
3. Keep SKILL.md to ~150 lines (core workflow only)
4. Test that agents still work
5. Repeat for `skills/writing-tests/`

---

### Option B: Quick Win (2-3 hours)
```
Task: p1-content-aware
Goal: Teach agents to detect content type before reading
Why: Fast, immediate value, improves efficiency
```

**Quick steps:**
1. Add "Content-Aware Reading Strategy" section to `skills/context-loader/SKILL.md`
2. Add section to `skills/implementing-features/SKILL.md`
3. Include examples for JSON, code, logs, docs
4. Show before/after patterns

---

### Option C: Multiple Quick Wins (5 hours)
```
Tasks: p1-task-templates + p1-output-control + p1-lazy-guidance
Goal: Knock out 3 smaller improvements
Why: Fast progress, builds momentum
```

**Quick steps:**
1. Update `skills/task-plan/SKILL.md` with template (2h)
2. Add output control to 3 agents (2h)
3. Add lazy-loading guidance to `skills/using-skills/SKILL.md` (1h)

---

## 📋 All Phase 1 Tasks

| Priority | Task | Time | Value |
|----------|------|------|-------|
| **P0** | `p1-sidecar-poc` | 5-6h | HIGH |
| **P0** | `p1-content-aware` | 2-3h | HIGH |
| P1 | `p1-task-templates` | 2h | MED-HIGH |
| P1 | `p1-output-control` | 2h | MEDIUM |
| P2 | `p1-cache-structure` | 3-4h | MEDIUM |
| P2 | `p1-lazy-guidance` | 1h | MEDIUM |

**Total Phase 1:** 15-20 hours (1 week at ~3h/day)

---

## 🔄 Daily Workflow

**Each morning:**
```sql
-- See what's ready to work on
SELECT t.id, t.title FROM todos t
WHERE t.status = 'pending'
AND NOT EXISTS (
    SELECT 1 FROM todo_deps td
    JOIN todos dep ON td.depends_on = dep.id
    WHERE td.todo_id = t.id AND dep.status != 'done'
)
ORDER BY t.id;
```

**When starting a task:**
```sql
UPDATE todos SET status = 'in_progress' WHERE id = 'p1-sidecar-poc';
```

**When completing a task:**
```sql
UPDATE todos SET status = 'done' WHERE id = 'p1-sidecar-poc';
```

---

## 📚 Detailed Instructions

See: `.context/tasks/MKT-0002/IMPLEMENTATION-GUIDE.md`

Each task has:
- Goal
- Step-by-step instructions
- Files to modify
- Success criteria
- Examples

---

## 🎉 After Phase 1

**Phase 2 unlocks:**
- `p2-learning-skill` — Extract lessons from failures
- `p2-context-graph` — Build relationship maps
- `p2-graph-integration` — Query-based discovery

**Phase 3 unlocks:**
- `p3-sidecar-full` — Refactor remaining skills
- `p3-guide-update` — Update documentation
- `p3-validation` — Test everything

---

## 💡 Remember

- **Start anywhere** — All Phase 1 tasks are independent
- **Test as you go** — Verify each change works
- **Commit often** — Save progress after each task
- **Document blockers** — If stuck, move to another task
- **Have fun!** — You're building something cool 🚀

---

**Tomorrow: Pick one task, mark it in-progress, and start building!**
