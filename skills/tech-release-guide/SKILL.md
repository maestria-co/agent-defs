---
name: tech-release-guide
description: >
  Use when executing a technical release process. Triggers on "release this version",
  "how do I cut a release", "walk me through the release process", or when preparing
  the actual mechanics of shipping a version.
---

# Skill: Tech Release Guide

## Purpose

Guide the end-to-end technical mechanics of creating and deploying a release: tagging, building, deploying, and monitoring.

---

## Pre-Release (1 hour before)

1. Confirm all intended changes are merged to release branch
2. Run full test suite — must be green
3. Confirm staging deployment is successful and verified
4. Check on-call rotation — someone must be available during deployment window
5. Notify stakeholders of deployment window

---

## Release Execution

### 1. Create release branch from main

```bash
git checkout -b release/X.Y.Z
```

### 2. Bump version numbers in manifest files

### 3. Update CHANGELOG or generate release notes

Use `deployment-release-notes` skill

### 4. Commit and push

```bash
git commit -m "chore: release vX.Y.Z"
```

### 5. Create git tag

```bash
git tag -a vX.Y.Z -m "Release vX.Y.Z"
git push origin vX.Y.Z
```

### 6. Trigger CI/CD deployment pipeline

### 7. Monitor deployment progress

Logs, health checks, error rates

---

## Post-Release (first 30 minutes)

1. Verify key user flows in production
2. Check error rates and latency dashboards (compare to pre-release baseline)
3. Confirm deployment complete in all regions/instances
4. Update release in issue tracker (close tickets, update version fields)
5. Send release communication to stakeholders

---

## Rollback Trigger

If error rate increases >2× baseline OR any P0/P1 incident within 30 minutes → initiate rollback without waiting.

---

## Constraints

- Never skip the staging verification step
- Never release without an on-call person available
- Tag before deploying, not after
- Rollback must be executable in under 5 minutes — verify this before every release
