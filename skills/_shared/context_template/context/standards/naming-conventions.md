# Naming Conventions

> **Purpose:** Consistent naming reduces the cognitive load of reading unfamiliar code. Follow these conventions everywhere. When in doubt, match the pattern of the nearest existing file.

---

## File Naming

[PLACEHOLDER — document the file naming pattern for the project]

**Convention in this project:**

| File type | Pattern | Example |
|---|---|---|
| TypeScript modules | `kebab-case.ts` | `user-repository.ts` |
| React components | `PascalCase.tsx` | `LoginForm.tsx` |
| Test files | `*.test.ts` / `*.test.tsx` | `login.test.ts` |
| Schema files | `*.schema.ts` | `login.schema.ts` |
| Type definition files | `*.types.ts` | `auth.types.ts` |

## Variable Naming

[PLACEHOLDER] **Convention:** `camelCase`. Booleans must start with `is`, `has`, or `can`.
```ts
const isAuthenticated = !!session;   // ✅
const hasPermission = roles.includes('admin');  // ✅
const authenticated = !!session;     // ❌ booleans need is/has/can prefix
```

## Function / Method Naming

[PLACEHOLDER] **Convention:** `verb + noun`. No `Async` suffix — the return type makes it clear.
```ts
async function getUser(id: string): Promise<User> {}      // ✅
async function getUserAsync(id: string): Promise<User> {} // ❌ redundant suffix
function user(id: string): User {}                        // ❌ no verb
```

## Class Naming

[PLACEHOLDER] **Convention:** `PascalCase`. Repository classes end in `Repository`. Service classes end in `Service`.
```ts
class UserRepository {}  // ✅ database access
class AuthService {}     // ✅ business logic
class Users {}           // ❌ no role suffix, ambiguous
```

## Test Naming

[PLACEHOLDER] **Convention:** Co-located as `*.test.ts`. `describe` uses module name. `it` starts with `should`.
```ts
// src/features/auth/login.test.ts
describe('login', () => {
  it('should return a session token on valid credentials', async () => {});
  it('should throw UnauthorizedError on invalid password', async () => {});
});
```

## Constants

[PLACEHOLDER] **Convention:** `SCREAMING_SNAKE_CASE` for module-level. `camelCase` for function-local.
```ts
const MAX_SESSION_DURATION_MS = 7 * 24 * 60 * 60 * 1000; // module-level
const maxRetries = 3; // function-local — camelCase is fine
```

## Database / API Naming

[PLACEHOLDER] **Convention:** DB columns `snake_case`, JSON keys `camelCase`. Repositories map at the boundary.
```ts
// src/repositories/user.ts — repository handles the mapping
return { ...user, createdAt: user.created_at };
```
