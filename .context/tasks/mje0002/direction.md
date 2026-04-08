# Context Graph Linker — Direction & Reasoning

**Task:** mje0002  
**Branch:** mje0002/graphing  
**Status:** Complete — ready for review and merge

---

## Why We Did This

The `context-graph-linker` concept originated in a prior session (see `conversation.md`) as a way to help agents navigate `.context/` folders without opening every file. The original implementation was a heavy skill — a 260-line instruction set telling agents to do bulk file mutations, directory creation, and index writes. Three problems were identified:

1. **Wrong form factor** — A skill that creates directories and rewrites files isn't composable. It belongs in a script, not an agent instruction set.
2. **No sync strategy** — The graph could go stale after any task that touched `.context/`. Nothing ensured it stayed current.
3. **INDEX lacked descriptions** — The original index only showed titles. Agents need a one-line description per node to make relevance decisions without opening files.

---

## Decisions Made

### 1. Script-first, thin skill stub

**Decision:** Move core logic to `scripts/graph-link.sh`. Keep `skills/context-graph-linker/SKILL.md` as a thin stub (~100 lines) that explains *when* to invoke the script, not *how* to run it step by step.

**Reasoning:**
- Skills are instructions for agents. Deterministic file mutations (inventory, link scan, INDEX write) are better expressed as a script — auditable, testable, version-controlled, and runnable by both agents and humans.
- The thin stub preserves discoverability in the skills table without duplicating procedural logic that lives in the script.
- `context-maintenance/SKILL.md` is the canonical home for incremental context upkeep; the graph sync step belongs there, not in a separate skill.

### 2. Two-layer sync strategy

**Decision:** (a) Add a "Graph Sync" step to `context-maintenance/SKILL.md`. (b) Add a git pre-commit hook via `scripts/hooks/sync-context-graph.sh`.

**Reasoning:**
- Agents need explicit direction; without a step in `context-maintenance`, they will forget to re-run the graph after modifying `.context/`. Adding it to the skill makes graph sync part of the normal upkeep loop.
- The pre-commit hook provides an automated safety net for human developers who commit `.context/` changes directly. It only triggers when `.context/` files are staged, and is a no-op if the graph hasn't been initialized — so it can't break repos that haven't adopted the pattern.
- Hook is registered via `setup-hooks.sh` / `setup-hooks.ps1` alongside existing hooks (task-state evaluation).

### 3. One-line descriptions in INDEX

**Decision:** Add a `description:` frontmatter field to each `.context/` file. The graph script extracts it (or falls back to the first real prose line) and renders it in `graph/INDEX.md` as:
```
- [[slug]] — one-sentence description of what this file covers
```

**Reasoning:**
- Agents that need to load context have to decide which files are relevant. A title alone (`[[adr-001]] — Auth Design`) is not enough. A one-liner (`[[adr-001]] — Chose JWT over sessions for stateless API auth`) gives the agent enough signal to make a skip/load decision without reading the file.
- Extracting from frontmatter keeps it machine-readable and consistent. The prose fallback (first non-heading line) means existing files without frontmatter still get a reasonable description on first run.

### 4. Output file is `graph/INDEX.md`, not `overview.md`

**Decision:** The script writes to `.context/graph/INDEX.md`, fully overwriting it on each run. It does not inject content into `overview.md`.

**Reasoning:**
- `overview.md` is hand-authored narrative — mixing auto-generated graph content into it breaks the human/machine contract. Sentinel-block injection was considered and rejected.
- `graph/INDEX.md` is entirely machine-generated. Overwriting it on each run is correct and clean. Git diffs show exactly what changed.

### 5. Edge detection: link scanning only, no directory inference

**Decision:** Edges in the graph are derived from actual `@mentions` and markdown links (`[text](path.md)`) found in file content. Directory-as-sibling inference (treating all files in the same directory as linked) was explicitly excluded.

**Reasoning:**
- Directory inference creates noise. Just because two decisions live in `.context/decisions/` doesn't mean they reference each other. False edges undermine the graph's utility for agents.
- Scanning actual links is conservative and accurate. Missing an edge is less harmful than fabricating one.

### 6. Type taxonomy aligned to actual `context_template`

**Decision:** The type field uses: `overview`, `architecture`, `standards`, `testing`, `decision`, `retrospective`, `domain`, `workflow`.

**Reasoning:**
- The original skill used `epic/story/decision/research/constraint` — none of which match the actual directory structure in `skills/_shared/context_template/context/`. This mismatch would have caused the type-based grouping in INDEX.md to misclassify every file.
- The new taxonomy was derived directly from inspecting the template directories.

### 7. Bash 3 compatibility (macOS)

**Decision:** The script avoids `mapfile`, `declare -A`, and `realpath --relative-to`. Associative arrays are replaced with named temp files or per-key variables. Path resolution uses a pure `awk` normalizer.

**Reasoning:**
- macOS ships with bash 3.2 (GPLv2 license constraint). Any script that requires bash 4+ breaks on stock macOS without Homebrew. Since `graph-link.sh` will run via a git pre-commit hook on developer machines, it must work without configuration.

---

## What Was Built

| File | Change | Purpose |
|------|--------|---------|
| `scripts/graph-link.sh` | Created (full rewrite) | Core graph logic: inventory, frontmatter, link scan, INDEX write, validation |
| `scripts/hooks/sync-context-graph.sh` | Created | Git pre-commit hook; runs graph rebuild when `.context/` files are staged |
| `skills/context-graph-linker/SKILL.md` | Created (thin stub) | Discoverability pointer; explains when to use the script |
| `skills/context-maintenance/SKILL.md` | Updated | Added "Graph Sync" section directing agents to run script after `.context/` changes |
| `setup-hooks.sh` | Updated | Installs `sync-context-graph.sh` as pre-commit hook |
| `setup-hooks.ps1` | Updated | Same for PowerShell/Windows |

---

## Decisions Deferred

### DRIFT Detection

**Question:** Should `graph-link.sh` add DRIFT detection logic to identify nodes marked as `status: active` that should actually be `status: superseded` based on `supersedes:` relationships in other nodes?

**Decision:** Defer for now.

**Reasoning:**
1. The script already correctly **filters** out superseded nodes (line 246: `[[ "$node_status" == "superseded" ]] && continue`) — they don't appear in the INDEX.
2. DRIFT detection would be about **reporting** inconsistencies — flagging files that claim to be `active` but are referenced in another file's `supersedes:` field as outdated.
3. This adds complexity without clear evidence of need:
   - It requires parsing YAML `related:` frontmatter to find `supersedes` relationships
   - It would generate a `.context/graph/DRIFT.md` report that someone has to act on
   - False positives are likely if a file is "superseded for one use case but still active for another"
4. Simpler solution exists: `context-maintenance` skill already directs agents to audit `.context/` files. If DRIFT becomes a real problem, agents can grep for `supersedes:` manually.
5. The current implementation is already a large improvement over no graph at all. Adding DRIFT detection would delay completion without solving a validated problem.

**Path forward:** If DRIFT reports become a requested feature (users complain about stale nodes staying active), revisit this as a separate task after the core system is proven.

---

## What Remains

- [x] Commit all changes on `mje0002/graphing` branch
- [x] Update `context-loader/SKILL.md` to reference `graph/INDEX.md` at Level 1 discovery (after `overview.md`)
- [x] Update `CLAUDE.md` template in `skills/_shared/context_template/` to mention `graph/INDEX.md`
- [x] Decide if DRIFT detection (superseded-but-active nodes) should be added to `graph-link.sh` — **Decision: Defer** (see Decisions Deferred section)

**Status:** Complete. Ready for review and merge.

---

## Reference: Script Behaviour

```
scripts/graph-link.sh [--validate-only] [--rebuild] [context-dir]
```

- Default context dir: `.context/` relative to git root
- `--validate-only`: checks for orphans and broken links; exits non-zero if found
- `--rebuild`: forces full rebuild even if INDEX is up to date
- Output: `.context/graph/INDEX.md` (overwritten on each run)
- Changelog: appended inside INDEX.md at the bottom

### Index format

```markdown
## overview
- [[project-overview]] — Single-sentence description of what this file covers

## decision
- [[adr-001]] — Chose JWT for stateless API auth
- [[adr-002]] — Selected Postgres as primary datastore
```
