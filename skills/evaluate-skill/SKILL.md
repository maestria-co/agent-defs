---
name: evaluate-skill
description: >
  Evaluates a SKILL.md file against the open AgentSkills specification and
  industry best practices. Produces a structured fix specification that can be
  passed directly to an agent for remediation. Use this when asked to review,
  audit, validate, or fix a skill file.
metadata:
  author: copilot-cli
  version: "1.0"
compatibility: Requires internet access when industry standards cache is stale (older than 5 days).
---

# Skill: Evaluate Skill

## Purpose

Evaluate any `SKILL.md` file against the open [AgentSkills specification](https://agentskills.io/specification), GitHub Copilot CLI requirements, and industry best practices for AI agent design. Produce a structured fix specification ready for an agent to execute.

---

## Pre-flight Checks

Run these checks before evaluating. If either fails, abort and notify the user.

**Check 1 — Identify the target skill**

The user must provide the path to the `SKILL.md` file (or skill directory) to evaluate.

- If no path is provided → ask: "Which SKILL.md should I evaluate? Provide the full path."
- If the path does not exist → **Abort.** Report: "File not found: `<path>`"
- If the file is not named `SKILL.md` → **Abort.** Report: "Target must be a file named `SKILL.md`."

**Check 2 — Load industry standards from cache**

Read `~/.copilot/.context/cache/skill-evaluation.md`.

1. Parse the `last_fetched` field from the YAML frontmatter.
2. If the file does not exist OR `last_fetched` is older than **5 days**:
   - Fetch updated standards from the following sources using the `fetch` tool:
     - `https://agentskills.io/specification`
     - `https://docs.github.com/api/article/body?pathname=/en/copilot/how-tos/copilot-cli/customize-copilot/create-skills`
     - `https://docs.github.com/api/article/body?pathname=/en/copilot/concepts/agents/copilot-cli/comparing-cli-features`
   - Rewrite `~/.copilot/.context/cache/skill-evaluation.md` with the updated content and a new `last_fetched` timestamp (ISO 8601).
   - Notify the user: "Standards refreshed from official sources."
3. If the file exists and `last_fetched` is within 5 days → use cached standards. Do not fetch.

---

## Evaluation Steps

Load the target `SKILL.md` and evaluate it against each criterion below. For every criterion, record the result as PASS, FAIL, or N/A.

### Category 1: Structural Requirements (Critical)

These failures prevent correct skill discovery and auto-invocation.

| # | Check | Severity |
|---|---|---|
| S1 | File is named exactly `SKILL.md` | CRITICAL |
| S2 | YAML frontmatter is present (file starts with `---`) | CRITICAL |
| S3 | `name` field is present | CRITICAL |
| S4 | `name` is lowercase alphanumeric + hyphens only (`a-z`, `0-9`, `-`) | CRITICAL |
| S5 | `name` is 1–64 characters | CRITICAL |
| S6 | `name` does not start or end with a hyphen | CRITICAL |
| S7 | `name` contains no consecutive hyphens (`--`) | CRITICAL |
| S8 | `name` matches the parent directory name | CRITICAL |
| S9 | `description` field is present | CRITICAL |
| S10 | `description` is 1–1024 characters | CRITICAL |
| S11 | Frontmatter closes properly (`---` after fields, before body) | CRITICAL |

### Category 2: Description Quality (High Impact)

These affect whether Copilot auto-invokes the skill correctly.

| # | Check | Severity |
|---|---|---|
| D1 | Description states **what** the skill does (not just a noun phrase) | WARNING |
| D2 | Description states **when** to use it (trigger conditions or "Use when...") | WARNING |
| D3 | Description includes domain-specific keywords (not generic language like "helps with") | WARNING |
| D4 | Description is specific enough to distinguish from other skills | WARNING |
| D5 | Optional `compatibility` field present if skill requires external tools or network | SUGGESTION |
| D6 | Optional `metadata.version` present for shared or team skills | SUGGESTION |

### Category 3: Body Content Quality

| # | Check | Severity |
|---|---|---|
| B1 | Body contains step-by-step instructions (numbered, ordered) | WARNING |
| B2 | Steps use imperative verbs ("Read", "Check", "Write") not passive/vague language | WARNING |
| B3 | Pre-flight checks defined if the skill has preconditions or can fail | WARNING |
| B4 | Every conditional branch has a defined outcome (no "handle as appropriate") | WARNING |
| B5 | Constraints section exists — explicit list of what the skill must NOT do | SUGGESTION |
| B6 | Output format is described if skill produces structured output | SUGGESTION |
| B7 | Edge cases are addressed | SUGGESTION |

### Category 4: Context Management

| # | Check | Severity |
|---|---|---|
| C1 | `SKILL.md` body is under 500 lines | WARNING |
| C2 | Heavy reference material is in `references/` not inline in the body | WARNING |
| C3 | Scripts are in `scripts/` not embedded as inline code blocks | SUGGESTION |
| C4 | File references use relative paths from the skill root | WARNING |
| C5 | If skill fetches external data, a cache mechanism (file + TTL) is defined | WARNING |

### Category 5: Security and Scope

| # | Check | Severity |
|---|---|---|
| SC1 | Skill does not embed secrets, tokens, or credentials | CRITICAL |
| SC2 | File-path scope is defined (which directories the skill may read/write) | SUGGESTION |
| SC3 | Side effects are declared (files written, network calls, tools invoked) | SUGGESTION |

---

## Output Format

Produce the evaluation output in three sections. This output is designed to be passed directly to an agent for remediation.

---

### SECTION 1: Evaluation Summary

```
## Skill Evaluation Report
Target: <full path to SKILL.md>
Evaluated against: ~/.copilot/.context/cache/skill-evaluation.md (last_fetched: <timestamp>)

### Results by Severity
- CRITICAL failures: <count>  ← must fix before skill will work
- WARNINGs: <count>            ← should fix; affects quality and invocation
- SUGGESTIONs: <count>         ← optional improvements

### Overall Assessment
<one of: INVALID | NEEDS WORK | ACCEPTABLE | GOOD | EXCELLENT>
<one sentence summary of the dominant issue(s)>
```

---

### SECTION 2: Issue Register

For every FAIL, produce an entry:

```
#### [SEVERITY] Check <ID>: <Check Name>

**Problem:** <clear description of what is wrong>
**Current value:** <the actual value or "missing">
**Expected:** <what it should be, including exact format/value if applicable>
**Fix:** <exact instructions for what to change — specific enough for an agent to execute without clarification>
```

Group by severity: CRITICAL first, then WARNING, then SUGGESTION.

---

### SECTION 3: Agent Fix Specification

Produce a ready-to-execute fix specification as a Markdown code block. This section must be self-contained so it can be pasted directly into an agent prompt.

````
## Agent Task: Fix SKILL.md

Apply the following changes to `<full path to SKILL.md>`:

### Required Changes (CRITICAL)
1. <specific change — e.g., "Add YAML frontmatter at the top of the file with the following content:">
   ```yaml
   ---
   name: <correct-value>
   description: <corrected description>
   ---
   ```

2. <next change>

### Recommended Changes (WARNING)
1. <specific change>

### Optional Improvements (SUGGESTION)
1. <specific change>

### Validation
After applying changes, verify:
- [ ] `name` field matches directory: `<directory-name>`
- [ ] `description` triggers auto-invocation: contains "<keyword1>", "<keyword2>"
- [ ] SKILL.md body is under 500 lines (currently: <count> lines)
- [ ] All pre-flight check branches have defined outcomes
````

---

## Constraints

- Only read files during evaluation — never write to the target skill unless explicitly asked to apply fixes
- Do not rewrite sections that are clearly intentional design choices (e.g., a deliberately broad constraint section)
- If the target is a shared/published skill (not authored by the user), flag issues but note the external origin
- Do not hallucinate spec rules — if uncertain whether something violates the standard, cite "not in spec" and mark as SUGGESTION only
- Always write an updated cache file timestamp after refreshing standards, even if the content did not change
