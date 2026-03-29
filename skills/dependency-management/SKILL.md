---
name: dependency-management
description: >
  Update, audit, and manage project dependencies safely. Use whenever someone says
  "update dependencies", "we have a security vulnerability", "this package is outdated",
  "fix the npm audit warnings", "upgrade [library] to latest", "check for outdated
  packages", or when a dependency audit reveals CVEs. Works across all package
  ecosystems (npm, pip, Maven, NuGet, Cargo, Go modules).
---

# Skill: Dependency Management

## Purpose

Update and manage project dependencies safely, one at a time, with testing at each step.

---

## Process

### 1. Identify outdated or vulnerable dependencies

- **npm**: `npm outdated` and `npm audit`
- **Python**: `pip list --outdated` and `pip-audit`
- **Maven**: `mvn versions:display-dependency-updates`
- **.NET**: `dotnet outdated`

### 2. Categorize updates

- **Security patch (CVE)**: do immediately, highest priority
- **Minor version bump (x.Y.z)**: low risk, batch if same library family
- **Major version bump (X.y.z)**: breaking changes possible, treat individually

### 3. Update strategy — one at a time

a. Update the dependency in manifest (package.json, pom.xml, etc.)  
b. Update the lock file  
c. Run the full test suite  
d. Check for deprecation warnings in output  
e. If tests pass → commit that single update  
f. If tests fail → diagnose before moving to the next dependency

### 4. For major version bumps

- Read the migration guide / CHANGELOG
- Search codebase for deprecated API usage
- Update all call sites before running tests

### 5. Verify compatibility matrix

Check all direct dependencies are mutually compatible

### 6. Final verification

Full test suite + build + lint clean

---

## Risk Levels

| Type                   | Risk     | Action                           |
|------------------------|----------|----------------------------------|
| CVE security patch     | Critical | Fix immediately                  |
| Minor patch (z)        | Low      | Batch updates OK                 |
| Minor feature (y)      | Medium   | Test individually                |
| Major (x)              | High     | Read migration guide; test thoroughly |

---

## Rollback Plan

Before updating, commit the current lock file to a branch. To revert to the pre-update state:

```bash
# Restore the lock file and reinstall
git checkout [branch] -- [lock-file]
[install command]   # npm ci / pip install / dotnet restore / etc.
```

Replace `[lock-file]` with the appropriate file: `package-lock.json`, `yarn.lock`, `Pipfile.lock`, `poetry.lock`, `packages.lock.json`, `go.sum`, etc.

---

## Constraints

- Never update multiple major-version dependencies in a single commit
- Always run the full test suite after each update
- Do not skip lock file updates
