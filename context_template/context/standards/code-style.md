# Code Style

> **Purpose:** Document the project-specific style decisions that go beyond what the linter enforces. Read this before writing any new file. Update when a new convention is established in code review.

---

## File Organization

[PLACEHOLDER — describe whether the project uses feature-based or layer-based structure, and where new files go]

**Convention in this project:** Feature-based. Each feature is a self-contained directory.

```
src/features/auth/
├── login.ts          # Business logic
├── login.test.ts     # Co-located tests
├── login.schema.ts   # Zod schemas for this feature
├── login.types.ts    # TypeScript types (if non-trivial)
└── index.ts          # Public exports only — never import internals from outside
```

New files go inside their feature directory. Utilities used by 3+ features move to `src/lib/`.

---

## Import Ordering

[PLACEHOLDER — document the project's import ordering rules]

**Convention in this project:** stdlib → third-party → internal (absolute) → relative. Blank line between each group.

```ts
// src/features/auth/login.ts
import { hash, compare } from 'bcrypt';           // third-party

import { db } from '@/lib/db';                     // internal absolute
import { UserRepository } from '@/repositories/user';

import { loginSchema } from './login.schema';       // relative
import type { LoginResult } from './login.types';
```

The linter enforces group order. The blank lines between groups are convention, not enforced.

---

## Comment Style

[PLACEHOLDER — document when to comment, what comments should say, and any JSDoc/docstring rules]

**Convention in this project:**

- **Do comment:** non-obvious business rules, workarounds for external library bugs, performance-sensitive sections
- **Don't comment:** what the code does (that's what the code is for), obvious type annotations
- **JSDoc:** required on all exported functions in `src/lib/` and `src/repositories/`. Not required on internal/private functions.

```ts
// ✅ Good — explains the why
// Bcrypt's compare is intentionally slow; do not await in a hot loop
const valid = await compare(password, user.passwordHash);

// ❌ Bad — explains the what (obvious from the code)
// Compare the password with the stored hash
const valid = await compare(password, user.passwordHash);
```

---

## Formatting Rules Beyond the Linter

[PLACEHOLDER — document line length preferences, blank line conventions, or anything else the linter doesn't catch]

**Convention in this project:**

- Max line length: 100 characters (Prettier enforces 80, but we allow 100 for long import paths)
- One blank line between logical sections within a function; two blank lines between top-level declarations
- Ternaries: only for simple single-line expressions. If either branch needs a variable, use `if/else`
- Object destructuring at function signature when more than 2 parameters

```ts
// ✅ Two blank lines between top-level declarations
export async function login(email: string, password: string): Promise<LoginResult> {
  // ...
}


export async function logout(sessionId: string): Promise<void> {
  // ...
}
```
