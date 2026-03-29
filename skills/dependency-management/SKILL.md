---
name: dependency-management
description: >
  Use when updating, auditing, or managing project dependencies. Triggers on
  "update dependencies", "fix security vulnerability", "check for outdated packages",
  "upgrade [library]", or when a dependency audit is needed.
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

Keep the pre-update lock file committed to a branch. To revert:

```bash
git checkout [branch] -- package-lock.json && npm ci
```

---

## Constraints

- Never update multiple major-version dependencies in a single commit
- Always run the full test suite after each update
- Do not skip lock file updates
