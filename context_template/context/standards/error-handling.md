# Error Handling

> **Purpose:** Inconsistent error handling is the most common source of confusing bugs and security leaks. This file defines the single way we handle errors in this codebase. Do not invent new patterns — extend these.

---

## Error Types

[PLACEHOLDER] **Convention:** Custom error classes extending `AppError`. Each carries an HTTP status and machine-readable `code`.

```ts
// src/lib/errors.ts
export class AppError extends Error {
  constructor(
    message: string,
    public code: string,
    public statusCode: number,
    public details?: Record<string, unknown>
  ) { super(message); this.name = 'AppError'; }
}
export class NotFoundError extends AppError {
  constructor(resource: string) { super(`${resource} not found`, 'NOT_FOUND', 404); }
}
export class UnauthorizedError extends AppError {
  constructor(reason = 'Unauthorized') { super(reason, 'UNAUTHORIZED', 401); }
}
```

## Logging Patterns

[PLACEHOLDER] **Convention:** Use `[pino / winston]`. All logs include `requestId` and `userId`. Never log PII.

```ts
logger.error('Failed to create session', {
  requestId: ctx.requestId,
  userId: ctx.userId,
  errorCode: err.code,
  // ❌ never: email, password, raw tokens
});
// error: unexpected failures | warn: expected failure paths | info: state changes | debug: disabled in prod
```

## User-Facing Error Messages

[PLACEHOLDER] **Convention:** All API errors return `{ error, code, details? }`. Never expose internal details.

```ts
// src/lib/api-handler.ts — central error handler
if (err instanceof AppError) {
  return res.status(err.statusCode).json({ error: err.message, code: err.code, details: err.details });
}
return res.status(500).json({ error: 'Internal server error', code: 'INTERNAL_ERROR' });
```

## Validation Patterns

[PLACEHOLDER] **Convention:** All input validated with Zod at the API boundary. Validate before any business logic.

```ts
// src/features/auth/login.ts
const result = loginSchema.safeParse(req.body);
if (!result.success) throw new ValidationError(result.error.flatten().fieldErrors);
```

Never validate in the repository layer. Never in the UI only.

## Never Do

- ❌ **Never silently swallow errors** — `catch (e) {}` with no logging is forbidden
- ❌ **Never log PII** — no email, passwords, tokens, or personal data in logs
- ❌ **Never expose stack traces to clients** — catch at the API boundary, return a safe message
- ❌ **Never throw plain `Error`** — use `AppError` subclasses so errors have codes and status
- ❌ **Never catch and re-throw without adding context** — handle it or let it propagate
