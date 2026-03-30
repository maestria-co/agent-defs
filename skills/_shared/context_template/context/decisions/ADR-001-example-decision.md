# ADR-001: Example Decision Title

**Date:** YYYY-MM-DD
**Status:** Accepted

## Context

What situation forced this decision? What were the constraints? What options were evaluated?

*Example: The project has a frontend app, a shared component library, and backend API logic. We needed to decide whether to maintain these as separate repositories or a single repository.*

## Decision

What was decided and why? Why did alternatives lose?

*Example: Use a monorepo managed with [e.g., Turborepo / npm workspaces / Nx]. The frontend app, shared packages, and API code all live under one repository root. Separate repos were rejected because: (1) cross-cutting changes require coordinated releases, (2) the team is small enough that the overhead of managing multiple repos isn't justified, (3) shared types between frontend and backend are a first-class concern.*

## Consequences

- ✅ What becomes easier
- ⚠️ What becomes harder or requires discipline
- 🔒 What must always / never be done going forward

*Example:*
- ✅ A single PR can change frontend + shared types + backend atomically
- ⚠️ Developers must use workspace commands rather than top-level commands
- 🔒 Always: new packages go under `packages/`, apps go under `apps/`. Never add source files to root.

---

> Replace this example with the first real decision for your project.
> See [index.md](index.md) for all decisions.
