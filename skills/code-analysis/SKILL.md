# Skill: Code Analysis Templates

Use the appropriate template below based on your research type. Fill in every field. Do not omit sections — missing fields degrade usefulness for the next agent.

---

## Code Path Trace

Use when tracing how a feature works end-to-end through the codebase.

```markdown
## Code Path: [Description]

Entry point: `path/to/file.ts:functionName()`

1. `file-a.ts:functionA()` → calls `file-b.ts:functionB()`
   - Transforms: [what data changes]
2. `file-b.ts:functionB()` → calls `file-c.ts:functionC()`
   - Side effects: [DB write, event emit, etc.]
3. `file-c.ts:functionC()` → returns [result]
   - Error handling: [how errors propagate]

Key observations:
- [Observation about the path]
```

---

## Pattern Analysis

Use when detecting how a concept is implemented consistently (or inconsistently) across the codebase.

```markdown
## Pattern: [Name]

Found in N files. Consistent: [yes/mostly/no]

Examples:
1. `path/to/example-1.ts` — [brief description]
2. `path/to/example-2.ts` — [brief description]
3. `path/to/example-3.ts` — [brief description]

Common pattern:
- [Step 1 that all examples share]
- [Step 2]

Deviations:
- `path/to/deviation.ts` — [how and why it differs]
```

---

## Usage Analysis

Use when finding all callers of a function, type, or module before refactoring.

```markdown
## Usage: `targetFunction()`

Defined in: `path/to/definition.ts`
Total usage sites: N

By category:
- Direct calls: N — [file list]
- Indirect (via wrapper): N — [file list]
- Tests: N — [file list]

Impact of changing signature: [assessment]
```
