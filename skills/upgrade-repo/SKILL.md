---
name: upgrade-repo
description: >
  Use when upgrading a language version, framework, or major dependency in a
  repository. Triggers on "upgrade Node to v22", "migrate to React 19",
  "upgrade this framework", or "we need to update to the latest version of X".
---

# Skill: Upgrade Repo

## Purpose

Upgrade language versions, frameworks, and major dependencies safely with a
structured pre/during/post process and a clear rollback plan. This skill prevents
the most common upgrade failures: skipping migration guides, introducing breaking
changes without testing, and losing the ability to roll back.

---

## Pre-Upgrade

**Goal:** Understand the scope and prepare for safe execution.

### Step 1: Research

Before changing any code:

1. **Read official release notes**
   - What's new in this version?
   - What's deprecated?
   - What's removed?

2. **Read migration guide**
   - Every major version has a migration guide — find it
   - List all breaking changes
   - Note recommended migration steps

3. **Read CHANGELOG**
   - Scan for unexpected behavior changes
   - Look for performance implications
   - Check for security fixes (might be why you're upgrading)

### Step 2: Check Dependency Compatibility

Verify the ecosystem supports the new version:

```bash
# Node.js ecosystem
npm outdated

# Python
pip list --outdated

# .NET
dotnet list package --outdated
```

**Check each dependency:**
- [ ] Does it support the new version?
- [ ] Does it require updating too?
- [ ] Are there known compatibility issues?

### Step 3: Assess Scope

Search the codebase for impacted patterns:

```bash
# Search for deprecated API usage
git grep "oldAPIName"

# Search for version-specific imports
git grep "from 'framework/old-module'"

# Count affected files
git grep "deprecatedPattern" | wc -l
```

**Document:**
- How many files use deprecated APIs?
- Which files will need changes?
- Estimated effort (hours/days)?

### Step 4: Create Upgrade Branch

Prepare version control:

```bash
# Create a dedicated branch
git checkout -b upgrade/[name]-[old-version]-to-[new-version]

# Tag the current state for easy rollback
git tag pre-upgrade-[name]-$(date +%Y%m%d)

# Push the tag
git push origin pre-upgrade-[name]-$(date +%Y%m%d)
```

### Step 5: Document Rollback Plan

Write down the exact steps to revert:

```markdown
## Rollback Plan

If upgrade fails:

1. Revert to tagged state:
   ```
   git checkout pre-upgrade-[name]-[date] -- .
   ```

2. Or reset the branch:
   ```
   git reset --hard pre-upgrade-[name]-[date]
   ```

3. Or revert the merge:
   ```
   git revert -m 1 [merge-commit]
   ```

4. Restore dependencies:
   ```
   npm install  # or equivalent
   ```

5. Rebuild and verify tests pass.
```

---

## Upgrade Process

**Goal:** Incrementally upgrade with verification at each step.

### Rule: One Major Version at a Time

**Never jump multiple major versions in one step.**

Example: Upgrading Node 16 → 22

```bash
# Wrong: Direct jump
nvm install 22  # ❌ Too big a leap

# Right: Incremental
nvm install 18  # ✅ 16 → 18
# Fix issues, verify tests
nvm install 20  # ✅ 18 → 20
# Fix issues, verify tests
nvm install 22  # ✅ 20 → 22
# Fix issues, verify tests
```

### Step 1: Update Version in Manifest Files

Update version declarations:

- `package.json` (Node.js)
- `requirements.txt` / `pyproject.toml` (Python)
- `.csproj` / `global.json` (.NET)
- `build.gradle` / `pom.xml` (Java)
- `Cargo.toml` (Rust)
- `go.mod` (Go)

**Commit this change before installing:**

```bash
git add package.json
git commit -m "chore: bump [package] from [old] to [new]"
```

### Step 2: Install Dependencies

```bash
# Node.js
npm install

# Python
pip install -r requirements.txt

# .NET
dotnet restore
```

**Check for dependency conflicts in the output.**

### Step 3: Fix Compilation/Import Errors

Run the build **before** running tests:

```bash
# Node.js
npm run build

# Python
python -m compileall .

# .NET
dotnet build
```

**Fix errors in this order:**

1. Import/module errors (missing or renamed modules)
2. Syntax errors (deprecated syntax)
3. Type errors (stricter type checking in new version)
4. API errors (removed or renamed functions)

**Commit after each category of fixes:**

```bash
git add .
git commit -m "fix: update imports for [package] [new-version]"
```

### Step 4: Run Test Suite

After build succeeds:

```bash
npm test  # or equivalent
```

**Fix test failures one at a time:**

- [ ] Read the failure message carefully
- [ ] Is the test broken or is the code broken?
- [ ] Fix the root cause
- [ ] Re-run tests
- [ ] Commit the fix

```bash
git add .
git commit -m "fix: update [test-name] for [package] [new-version]"
```

### Step 5: Address Deprecation Warnings

Scan build and test output for warnings:

```
⚠️  DeprecationWarning: oldAPI is deprecated. Use newAPI instead.
```

**Address each warning:**

1. Search for usage: `git grep "oldAPI"`
2. Replace with recommended alternative
3. Verify tests still pass
4. Commit the change

```bash
git add .
git commit -m "refactor: replace deprecated oldAPI with newAPI"
```

### Step 6: Commit Working State

Before moving to the next major version:

```bash
# Verify everything works
npm run build && npm test

# Commit if all green
git add .
git commit -m "chore: [package] upgrade to [version] complete"
```

---

## Post-Upgrade

**Goal:** Verify the upgrade is complete and stable.

### Step 1: Full Test Suite

Run the **complete** test suite:

```bash
# Unit tests
npm run test:unit

# Integration tests
npm run test:integration

# End-to-end tests
npm run test:e2e
```

**All tests must be green before proceeding.**

### Step 2: Manual Testing of Critical Paths

Test the features users rely on most:

- [ ] Authentication (login, logout, token refresh)
- [ ] Payments (if applicable)
- [ ] Key user workflows (top 3-5 features)
- [ ] Admin functions (if applicable)

**Document any behavioral changes observed.**

### Step 3: Performance Testing

For major upgrades, verify performance hasn't regressed:

```bash
# Memory usage
npm run benchmark:memory

# Startup time
time npm start

# Request latency (if applicable)
npm run benchmark:api
```

**Compare to pre-upgrade baseline.**

### Step 4: Update Context Documentation

Document the upgrade decision:

**`.context/decisions/upgrade-[package]-[date].md`:**

```markdown
# Upgrade [Package] to [New Version]

## Decision
Upgraded from [old] to [new] on [date].

## Rationale
- [Why we upgraded: security fix, new features, dependency requirement]

## Breaking Changes
- [List breaking changes from migration guide]
- [How we addressed each one]

## Migration Notes
- [Patterns that changed]
- [New best practices with this version]
- [Things to watch for]

## Rollback
Tag: `pre-upgrade-[name]-[date]`
```

**Update `.context/architecture/` if patterns changed:**

```markdown
## Post-[Package]-[Version] Patterns

With [package] [version], we now:
- [new pattern replacing old pattern]
- [new API replacing deprecated API]
```

### Step 5: Write Release Notes

Add an entry for the upgrade:

```markdown
## [Version] - [Date]

### Changed
- Upgraded [package] from [old] to [new]
- [Breaking changes that affect users, if any]
- [New capabilities now available]

### Migration
- [Steps users must take, if any]
- [Deprecated patterns to replace]
```

---

## Upgrade Verification Checklist

Before merging the upgrade:

- [ ] All tests pass (unit, integration, e2e)
- [ ] Build succeeds with no errors
- [ ] No unaddressed deprecation warnings
- [ ] Critical paths tested manually
- [ ] Performance hasn't regressed
- [ ] `.context/decisions.md` updated with upgrade rationale
- [ ] `.context/architecture/` updated if patterns changed
- [ ] Release notes written
- [ ] Rollback plan documented and tested
- [ ] Dependencies are compatible with new version

---

## Rollback Procedure

If the upgrade causes production issues:

### Immediate Rollback

```bash
# Revert to the tagged pre-upgrade state
git checkout pre-upgrade-[name]-[date]

# Create a rollback branch
git checkout -b rollback/[package]-[date]

# Restore dependencies
npm install  # or equivalent

# Verify tests pass
npm test

# Deploy
```

### Long-Term Rollback

If the upgrade must be abandoned:

```bash
# Close the upgrade branch
git checkout main
git branch -D upgrade/[name]-[old]-to-[new]

# Document why in .context/decisions/
```

---

## Special Cases

### Security-Driven Upgrades

When upgrading due to a CVE:

1. **Upgrade to the minimum safe version** — Don't take unnecessary changes
2. **Test specifically for the vulnerability** — Verify the fix works
3. **Expedite deployment** — Security fixes can't wait for the next release
4. **Document the CVE** — Link to the security advisory in commit message

### Breaking Change Mitigation

If a breaking change affects many files:

1. **Create a compatibility shim** — Adapter layer for old code
2. **Migrate incrementally** — Update files over time
3. **Deprecate the shim** — Set a deadline to remove it
4. **Track progress** — Keep a checklist of files to migrate

---

## Constraints

- **Never skip the migration guide** — Breaking changes are always documented
- **Never upgrade multiple major-version dependencies in one commit** — Upgrade one at a time
- **Never merge an upgrade with failing tests** — All tests must be green
- **Never upgrade in a production hotfix** — Upgrades need dedicated branches and full testing
- **Never delete deprecation warnings without addressing them** — They indicate future breaking changes
- **Always tag before upgrading** — You must be able to roll back
- **Always document the rationale** — Future maintainers need to know why
