---
name: upgrade-repo
description: >
  Safely upgrade a language version, framework, or major dependency. Use when someone
  says "upgrade Node to v22", "migrate to React 19", "we need to get off this old
  version", "update our framework", or "how do we upgrade X?". Also triggers when a
  security advisory requires a version bump. Prevents the most common upgrade pitfalls:
  skipping migration guides, multi-major jumps, and losing rollback options.
---

# Skill: Upgrade Repo

## Purpose

Upgrade language versions, frameworks, and major dependencies safely with a
structured pre/during/post process and a clear rollback plan. The goal is to stay
in control at every step: understand breaking changes before touching code, verify
the build after each fix, and keep commits granular enough that any problem can be
isolated and reverted.

---

## Pre-Upgrade

### 1. Research Before Touching Code

Read the official release notes, migration guide, and CHANGELOG for the new version:
- What is removed or renamed?
- What patterns are deprecated?
- Are there any required migration steps?

Skipping the migration guide is the #1 cause of upgrade pain — breaking changes are
always documented.

### 2. Check Dependency Compatibility

Verify your direct dependencies support the new version. Run your package manager's
outdated/audit command and check whether dependencies need to update alongside the upgrade.

### 3. Assess Scope

Search the codebase for deprecated API usage before starting. This turns vague fear
into a concrete list of files to update and helps you estimate the effort.

### 4. Create a Dedicated Branch and Tag

```bash
git checkout -b upgrade/[name]-[old-version]-to-[new-version]
git tag pre-upgrade-[name]-$(date +%Y%m%d)
git push origin pre-upgrade-[name]-$(date +%Y%m%d)
```

The tag is your rollback anchor — push it before making any changes.

---

## Upgrade Process

### Rule: One Major Version at a Time

Never jump multiple major versions in one step. If upgrading Node 16 → 22,
go 16 → 18 → 20 → 22. Verify tests pass after each step. This isolates which
version introduced each breakage and keeps PRs reviewable.

### Per-Version Steps

1. **Update version** in the manifest (`package.json`, `pyproject.toml`, `go.mod`, etc.)  
   Commit this change before installing so the diff is readable.

2. **Install dependencies** — check the output for conflicts

3. **Fix build errors first** — imports, syntax, renamed APIs — before running tests.  
   Fix in order: import errors → syntax → type errors → API changes.  
   Commit after each logical group of fixes.

4. **Run tests** — fix failures one at a time, commit each fix separately.

5. **Address deprecation warnings** — these become errors in the next major version,
   so clearing them now prevents the next upgrade from being painful.

6. **Commit the working state** before advancing to the next major version.

---

## Post-Upgrade

### Verification Checklist

- [ ] All tests pass (unit, integration, e2e)
- [ ] Build succeeds with no errors or unaddressed deprecation warnings
- [ ] Critical user paths tested manually
- [ ] Performance hasn't regressed (startup time, key latencies)
- [ ] Dependencies are compatible with the new version

### Document in `.context/`

Add a decision record at `.context/decisions/upgrade-[package]-[date].md`:

```markdown
# Upgrade [Package] to [New Version]

## Decision
Upgraded from [old] to [new] on [date].

## Rationale
[Why: security fix / new features / dependency requirement]

## Breaking Changes & Mitigations
- [Change]: [how we addressed it]

## Migration Notes
[Patterns that changed; new best practices to follow going forward]

## Rollback
Tag: `pre-upgrade-[name]-[date]`
```

---

## Rollback Procedure

```bash
# Revert to the pre-upgrade state
git checkout pre-upgrade-[name]-[date]
git checkout -b rollback/[package]-[date]

# Restore dependencies and verify
[install command]  # npm install / pip install / etc.
[test command]
```

If the upgrade must be abandoned entirely, delete the upgrade branch and document
the reason in `.context/decisions/`.

---

## Constraints

- Read the migration guide before writing any code
- One major version per upgrade branch — not multiple
- Merge only when all tests are green
- Never upgrade in a production hotfix branch — upgrades need dedicated branches and full testing
- Always tag before upgrading so you can roll back
- Document the rationale — future maintainers need to know why the version changed

