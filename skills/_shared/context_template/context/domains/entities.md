# Domain Entities

> **Purpose:** Document the core domain entities, their business rules, and how they relate to each other. This is not a database schema dump — it's the business logic that isn't obvious from reading the code.

---

## How to Use This File

Add or update an entity entry when:
- A new model is added to the codebase
- A relationship between entities changes
- A non-obvious business rule about an entity is discovered (especially after a bug)

Do not duplicate things that are obvious from the code. Document the *why* and the *gotchas*.

---

## Entity Entry Format

```
### [EntityName]

**Represents:** [What real-world thing is this?]

**Key fields:**
- `fieldName` — [what it means, any non-obvious behavior]

**Business rules:**
- [Non-obvious invariant — the kind that causes bugs if you don't know it]

**Relationships:**
- `has many [Entity]` — [when/why this relationship exists]
- `belongs to [Entity]` — [any constraints?]

**Where defined:** `src/[path/to/model-or-schema.ts]`
```

---

## Entities

### User

**Represents:** A registered account in the system. May be a human or a service account.

**Key fields:**
- `id` — UUID, generated at creation, never changes
- `email` — unique, lowercase-normalized on write. The login identifier.
- `passwordHash` — bcrypt hash, nullable (null when user logged in via OAuth only)
- `role` — enum: `admin | member | viewer`. Default: `member`
- `status` — enum: `active | suspended | pending_verification`. New users start as `pending_verification`

**Business rules:**
- Users can have **at most 3 active sessions** simultaneously. Creating a 4th session silently invalidates the oldest. This is not enforced at the DB level — it's enforced in `src/features/auth/session.ts`.
- `email` is stored lowercase. Comparison must always use `.toLowerCase()` — the DB collation does NOT handle this.
- Suspended users can still log in but receive a `403` on all data endpoints. Auth and suspension are separate concerns.
- Service accounts have `role: admin` and `passwordHash: null`. They authenticate via API key, not password.

**Relationships:**
- `has many Session` — active sessions, max 3 (see business rule above)
- `has many AuditLog` — all actions taken by or on behalf of this user

**Where defined:** `src/lib/db/schema.ts` (Drizzle schema), `src/repositories/user.ts` (queries)

---

### [PLACEHOLDER — Add Next Entity Here]

**Represents:** [What real-world thing is this?]

**Key fields:**
- `fieldName` — [description]

**Business rules:**
- [Non-obvious rule]

**Relationships:**
- [Relationship]

**Where defined:** `src/[path/to/definition.ts]`

---

<!-- Document entities as they're added. Focus on business rules that aren't in the code. -->
