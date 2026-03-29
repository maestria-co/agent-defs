---
name: code-identifier
description: >
  Find where specific code lives in a large or unfamiliar codebase. Use whenever
  someone asks "where is X implemented?", "which file handles Y?", "find the code
  that does Z", "where does the auth logic live?", "I need to locate the payment
  processing code", or any time navigation through an unknown codebase is needed.
  Also use when an agent needs to locate an entry point before making changes.
---

# Skill: Code Identifier

## Purpose

Systematically locate code patterns and entry points in large codebases without reading every file.

---

## Process

### 1. Clarify what to find

Is this a function? A class? A behavior? An API route? A config value?

### 2. Start with the most specific search term

Exact function name, error message text, API path

```bash
grep -r "functionName" src/
```

Or use IDE search.

### 3. If the specific term doesn't match, broaden

- Search for related terms (synonyms, abbreviated forms, camelCase and snake_case variants)
- Search for the HTTP verb + path for API routes
- Search for the entity name for data model code

### 4. Use file structure

Framework conventions suggest where code lives (e.g., `routes/`, `controllers/`, `services/`, `handlers/`)

### 5. Trace from entry point

Once you find a related file, read its imports and exports to navigate to the target

### 6. Cross-reference with tests

Test file names often mirror the source file names

---

## Search Patterns by Code Type

| Looking for     | Search strategy                                  |
|-----------------|--------------------------------------------------|
| API route       | Search for HTTP verb + path string: `"POST /users"` |
| Event handler   | Search for event name: `"user.created"`          |
| Config value    | Search for config key in quotes                  |
| Error message   | Search for the exact error text                  |
| Data model      | Search for the entity name in model/schema directories |

---

## Output

Report the file path, function/class name, and a 1-line description of what you found. Note any related files discovered during the search.

---

## Constraints

- Do not read full file contents unless necessary — use targeted searches
- Report confidence: "found" vs "likely" vs "uncertain"
- If pattern not found after 3 search strategies, report what was tried
