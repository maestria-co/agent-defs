# Architectural Decision Records

> **AI Instruction:** Log decisions here the moment they're made. Future agents will make wrong assumptions without this. Every decision that isn't recorded here will be re-litigated in a future PR.

---

## Format

```
### ADR-[NNN]: [Decision Title]
**Date:** YYYY-MM-DD | **Status:** Proposed / Accepted / Deprecated / Superseded by ADR-NNN
**Context:** [What situation forced this decision? What were the constraints?]
**Decision:** [What was decided and why? Why did alternatives lose?]
**Consequences:** [What becomes easier? What becomes harder? What must always be done now?]
```

---

## Decision Log

### ADR-001: Monorepo over Multi-Repo Structure
**Date:** [YYYY-MM-DD] | **Status:** Accepted

**Context:** The project has a frontend app, a shared component library, and backend API logic. We needed to decide whether to maintain these as separate repositories or a single repository.

**Decision:** Use a monorepo managed with [e.g., Turborepo / npm workspaces / Nx]. The frontend app, shared packages, and API code all live under one repository root. Separate repos were rejected because: (1) cross-cutting changes require coordinated releases, (2) the team is small enough that the overhead of managing multiple repos isn't justified, (3) shared types between frontend and backend are a first-class concern.

**Consequences:**
- ✅ A single PR can change frontend + shared types + backend atomically
- ✅ CI runs from a single workflow with workspace-aware caching
- ⚠️ Developers must use workspace commands (`npm run build --workspace=packages/ui`) rather than top-level commands
- ⚠️ Bundle sizes must be monitored per package — a monorepo doesn't mean a monolith
- 🔒 Always: new packages go under `packages/`, apps go under `apps/`. Never add source files to the root.

---

<!-- Add new ADRs below. Number them sequentially. Never delete old ones — change status to Deprecated or Superseded. -->
