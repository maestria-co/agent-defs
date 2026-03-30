# Standards

> **AI Instruction:** Read this before writing any code in this project. These are the established patterns — follow them, don't reinvent them.

## Code Style

<!-- How are files organized? What are the import conventions? What do comments look like? -->
<!-- Infer from reading 3+ source files. Example: -->

- **File structure:** [e.g., one class per file / feature-folder pattern / barrel exports]
- **Imports:** [e.g., external → internal → relative, no wildcard imports]
- **Comments:** [e.g., JSDoc for public APIs only, inline comments for non-obvious logic]
- **Formatting:** [e.g., Prettier with config at `.prettierrc`, 2-space indent]

## Naming Conventions

<!-- Use real file/variable names from this codebase as examples -->

| Thing | Convention | Example |
|-------|-----------|---------|
| Files | | |
| Variables | | |
| Functions | | |
| Classes | | |
| Tests | | |

## Error Handling

<!-- Document the actual pattern found in this codebase, not a generic one -->

- **Error types:** [e.g., custom Error subclasses / Result type / thrown exceptions]
- **Logging:** [e.g., structured JSON via `logger.error(msg, { context })` ]
- **Validation:** [e.g., Zod schemas at API boundary, no runtime validation inside services]

## Structural Patterns

<!-- 1-2 recurring patterns an AI should replicate, with real file paths as examples -->

<!-- Example:
**Service pattern:** Services live in `src/services/`, accept injected dependencies, never import from `src/routes/`. See `src/services/user.service.ts` for the canonical example.
-->
