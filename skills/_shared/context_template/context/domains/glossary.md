# Glossary

> **Purpose:** Project-specific terminology that has a meaning in this codebase that differs from general usage, or terms that are easy to confuse. Add terms when: a new domain concept is introduced, when a word has a project-specific meaning that differs from common usage, or when confusion about a term caused a bug.

---

## Terms

### Session
A period of authenticated access for a user. In this codebase, a Session is a database record in the `sessions` table — not an HTTP session cookie. The cookie contains a `sessionId` that references this record. Sessions expire after 7 days of inactivity. See `src/models/Session.ts` and `src/features/auth/session.ts`.

> ⚠️ Do not confuse with `req.session` (the HTTP layer) or `next-auth` session objects — those are adapters over our `Session` entity.

---

### [PLACEHOLDER — Term 2]
[Definition — what does this word mean in this specific project? How does it differ from general usage?]

See `src/[path/to/relevant/file.ts]`.

---

### [PLACEHOLDER — Term 3]
[Definition]

See `src/[path/to/relevant/file.ts]`.

---

### [PLACEHOLDER — Term 4]
[Definition]

See `src/[path/to/relevant/file.ts]`.

---

<!-- Keep this list alphabetical. A term belongs here if: (1) it means something specific in this codebase that a newcomer wouldn't guess, or (2) its misunderstanding has caused a bug before. -->
