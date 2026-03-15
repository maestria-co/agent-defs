# Recipe: Complex Task

> **When to use:** Multi-file change with known design, no major unknowns.
> **Patterns:** `planning-tasks` → `implementing-features` × N → `writing-tests`.
> **Total time:** Half a day to multiple days.

---

## Example: Add user profile editing

**Situation:** Users need to update their display name and avatar. API + frontend.

### Step 0 — Create brief

Create `.context/tasks/user-profile-edit/brief.md`:

```markdown
# Brief: User Profile Editing

## Goal
Allow users to update their display name and avatar URL.

## Acceptance Criteria
- [ ] PATCH /users/:id endpoint accepts { displayName, avatarUrl }
- [ ] Validation: displayName 1-50 chars, avatarUrl valid URL or null
- [ ] Returns updated user object
- [ ] Frontend form submits and shows updated values
- [ ] Existing user data is not affected if field is omitted (partial update)

## Out of Scope
- Avatar file upload (URL only)
- Password change
- Email change
```

### Step 1 — planning-tasks

```
Use the planning-tasks skill.

<task>Plan the implementation of user profile editing.</task>
<context>
Brief: .context/tasks/user-profile-edit/brief.md
Stack: Node.js/Express, React, PostgreSQL/Sequelize
Relevant code: src/models/User.js, src/routes/users.js, src/components/ProfilePage.jsx
No unknowns — this follows established patterns.
</context>
```

Expected output: ordered task list saved to `.context/tasks/user-profile-edit/plan.md`.

Typical plan shape:
```
Task 1 (S): Add displayName and avatarUrl columns — migration
Task 2 (M): Implement PATCH /users/:id endpoint with validation
Task 3 (S): Write endpoint unit tests
Task 4 (M): Add ProfileEditForm component
Task 5 (S): Wire form to API, handle error states
Task 6 (S): Integration test — form → API → DB roundtrip
```

### Step 2 — implementing-features (per task)

Run once per task from the plan. Example for Task 2:

```
Use the implementing-features skill.

<task>Implement PATCH /users/:id endpoint with validation.</task>
<context>
Plan task: Task 2 from .context/tasks/user-profile-edit/plan.md
Spec:
- [ ] Accepts { displayName, avatarUrl } (both optional)
- [ ] displayName: 1-50 chars if provided
- [ ] avatarUrl: valid URL or null if provided
- [ ] Returns 200 with updated user on success
- [ ] Returns 422 with validation errors on bad input
Relevant files: src/routes/users.js, src/models/User.js
Pattern to follow: existing PATCH /users/:id/password for error format
</context>
```

Commit after each task: `git commit -m "feat: PATCH /users/:id — profile update endpoint"`

### Step 3 — writing-tests (after each logical unit)

Don't batch all tests at the end. Test each unit after implementing it:

```
Use the writing-tests skill.

<task>Write tests for PATCH /users/:id profile update endpoint.</task>
<context>
Implementation: src/routes/users.js (updateProfile handler)
Test file: tests/routes/users.test.js
Cases to cover: valid update, partial update (omitted fields), invalid displayName,
                invalid avatarUrl, unauthorized request, non-existent user
</context>
```

### Step 4 — verify acceptance criteria

After all tasks and tests pass, re-read `.context/tasks/user-profile-edit/brief.md` and check each criterion:

```
[ x ] PATCH /users/:id endpoint accepts { displayName, avatarUrl }
[ x ] Validation: displayName 1-50 chars, avatarUrl valid URL or null
[ x ] Returns updated user object
[ x ] Frontend form submits and shows updated values
[ x ] Existing user data is not affected if field is omitted
```

---

## When This Recipe Applies

- ✅ 4-15 files touched
- ✅ Tech choices are already made (no new architecture needed)
- ✅ Work can be broken into clear sequential steps
- ✅ Each step follows existing patterns in the codebase

## When to Upgrade

Upgrade to `design-task` recipe if:
- You're not sure which approach to use before planning
- The change introduces a new architectural pattern
- There are multiple valid implementation approaches with different tradeoffs

Upgrade to `feature-workflow` if:
- Unknown external dependencies (new library, new API)
- 5+ interconnected components with significant cross-cutting concerns
