#!/usr/bin/env python3
"""
Structural validator for agent-defs repo.

Checks:
- All agents have required frontmatter keys (description, name, model)
- All agents are on claude-sonnet-4.6
- All specialist agents have Behavior Tiers, Anti-Rationalization, Scope Guard, Constraints
- All skill references in agents resolve to real directories on disk
- No stale agent references (workspace-manager, monorepo-manager)
- Manager does not have 'codebase' in tools list
- GUIDE.md mentions all custom skills

Usage:
  python3 scripts/validate.py
  python3 scripts/validate.py --strict   # treat warnings as errors
"""

import os
import re
import sys

REPO = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
SKILLS_DIR = os.path.join(REPO, "skills")
AGENTS_DIR = os.path.join(REPO, "agents")

# Skills installed from the skill kit — not owned by this repo, don't require GUIDE.md coverage
SKILLKIT_SKILLS = {
    "agentic-evaluation", "asana-story", "code-identifier", "commit-discipline",
    "dependency-management", "design-first", "initialize-monorepo", "initialize-repo",
    "initialize-workspace", "jira-story", "knowledge-graduation", "linear-story",
    "planning-tasks", "post-meeting", "researching-options", "start-worktree",
    "using-skills", "context-review",
}

REQUIRED_FRONTMATTER = ["description", "name", "model"]
REQUIRED_SECTIONS_SPECIALIST = [
    "## Behavior Tiers",
    "## Anti-Rationalization",
    "## Scope Guard",
    "## Constraints",
]
STALE_AGENT_REFS = ["workspace-manager", "monorepo-manager"]

STRICT = "--strict" in sys.argv


def collect_skills():
    skills = set()
    for entry in os.listdir(SKILLS_DIR):
        if os.path.isfile(os.path.join(SKILLS_DIR, entry, "SKILL.md")):
            skills.add(entry)
    return skills


def validate():
    errors = []
    warnings = []

    real_skills = collect_skills()
    agent_files = sorted(f for f in os.listdir(AGENTS_DIR) if f.endswith(".agent.md"))

    for fname in agent_files:
        path = os.path.join(AGENTS_DIR, fname)
        content = open(path).read()
        is_manager = fname == "manager.agent.md"

        # Frontmatter
        for key in REQUIRED_FRONTMATTER:
            if not re.search(rf"^{key}:", content, re.MULTILINE):
                errors.append(f"[{fname}] Missing frontmatter key: {key}")

        # Model version
        m = re.search(r"^model:\s*(.+)", content, re.MULTILINE)
        if m and "claude-sonnet-4.6" not in m.group(1):
            warnings.append(f"[{fname}] Model not claude-sonnet-4.6: {m.group(1).strip()}")

        # Required sections (all agents except manager)
        if not is_manager:
            for section in REQUIRED_SECTIONS_SPECIALIST:
                if section not in content:
                    errors.append(f"[{fname}] Missing required section: {section}")

        # Skill references
        for ref in re.findall(r"skills/([^/\s]+)/SKILL\.md", content):
            if ref not in real_skills:
                errors.append(f"[{fname}] Broken skill ref: skills/{ref}/SKILL.md (not on disk)")

        # Stale agent references
        for stale in STALE_AGENT_REFS:
            if stale in content:
                errors.append(f"[{fname}] Stale agent reference found: '{stale}'")

        # Manager-specific checks
        if is_manager:
            if '"codebase"' in content:
                errors.append(f"[{fname}] 'codebase' tool in tools list contradicts no-raw-source rule")

    # GUIDE.md coverage for custom skills
    guide_path = os.path.join(SKILLS_DIR, "GUIDE.md")
    if os.path.isfile(guide_path):
        guide_content = open(guide_path).read()
        for skill in real_skills:
            if skill.startswith("_") or skill in SKILLKIT_SKILLS:
                continue
            if skill not in guide_content:
                warnings.append(f"[GUIDE.md] Custom skill not mentioned: {skill}")
    else:
        errors.append("[GUIDE.md] File not found")

    return errors, warnings


def main():
    errors, warnings = validate()

    if errors:
        print(f"❌ {len(errors)} error(s) found:\n")
        for e in errors:
            print(f"  {e}")
    else:
        print("✅ No errors")

    if warnings:
        print(f"\n⚠️  {len(warnings)} warning(s):\n")
        for w in warnings:
            print(f"  {w}")
    else:
        print("✅ No warnings")

    if errors or (STRICT and warnings):
        sys.exit(1)
    sys.exit(0)


if __name__ == "__main__":
    main()
