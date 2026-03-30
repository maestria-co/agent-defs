# Architecture Patterns

> **Purpose:** Document the non-obvious structural patterns that every agent and developer must follow. Code that doesn't follow these patterns creates inconsistencies that become painful to untangle later.

---

## How to Use This File

Add a pattern here when:
- A pattern is explicitly established in code review ("going forward, we always do X")
- A pattern is derived from an ADR in `decisions.md`
- A painful refactor revealed a pattern that should have been followed from the start

Do not add patterns here just because they're in a tutorial. Only add them when this codebase has committed to them.

---

## Pattern Entry Format

```
### [Pattern Name]

**Context:** When does this pattern apply?
**Pattern:** What must you do?
**Example:** Real file path and code snippet from this codebase.
**Anti-pattern:** What does incorrect code look like?
```

---

## Patterns

### Repository Pattern

**Context:** Any time code needs to read from or write to the database.

**Pattern:** Service layer never accesses the database directly. All database operations go through a repository class in `src/repositories/`. Repositories are the only place that knows about the ORM or query builder.

**Example:**
```ts
// ✅ src/features/auth/login.ts — service calls repository
import { UserRepository } from '@/repositories/user';

const userRepo = new UserRepository();
const user = await userRepo.findByEmail(email);

// src/repositories/user.ts — only file that touches the db directly
export class UserRepository {
  async findByEmail(email: string): Promise<User | null> {
    return db.query.users.findFirst({ where: eq(users.email, email) });
  }
}
```

**Anti-pattern:**
```ts
// ❌ src/features/auth/login.ts — service accessing db directly
import { db } from '@/lib/db';
const user = await db.query.users.findFirst({ where: eq(users.email, email) });
```

---

### [PLACEHOLDER — Add Next Pattern Here]

**Context:** [When does this apply?]

**Pattern:** [What must you do?]

**Example:**
```ts
// [src/path/to/example.ts]
```

**Anti-pattern:**
```ts
// [What not to do]
```

---

<!-- 
Common patterns to document as the project evolves:
- How adapters wrap external services
- How middleware is applied and ordered
- How feature flags are checked
- How background jobs are structured
- How caching is applied
-->
