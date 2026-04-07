#!/usr/bin/env bash
# graph-link.sh — Build and maintain the .context/ knowledge graph
#
# Usage:
#   bash scripts/graph-link.sh              # full build + validate
#   bash scripts/graph-link.sh --rebuild    # force full rebuild (same as default)
#   bash scripts/graph-link.sh --validate-only  # check for orphans/drift, no writes
#
# Prerequisites:
#   - Must be run from the repository root
#   - .context/ directory must exist
#   - Requires: bash 4+, awk, grep, find, date

set -euo pipefail

# ─── Configuration ──────────────────────────────────────────────────────────

CONTEXT_DIR=".context"
GRAPH_DIR="${CONTEXT_DIR}/graph"
INDEX_FILE="${GRAPH_DIR}/INDEX.md"
ORPHANS_FILE="${GRAPH_DIR}/ORPHANS.md"
BROKEN_FILE="${GRAPH_DIR}/BROKEN.md"
DRIFT_FILE="${GRAPH_DIR}/DRIFT.md"
CHANGELOG_FILE="${GRAPH_DIR}/CHANGELOG.md"

VALIDATE_ONLY=false

# ─── Argument parsing ────────────────────────────────────────────────────────

for arg in "$@"; do
  case "$arg" in
    --validate-only) VALIDATE_ONLY=true ;;
    --rebuild)       ;;  # default behavior, accepted for clarity
    *)               echo "Unknown argument: $arg" >&2; exit 1 ;;
  esac
done

# ─── Pre-flight checks ───────────────────────────────────────────────────────

if [[ ! -d ".git" ]]; then
  echo "❌ Not a git repository. Run from the repository root." >&2
  exit 1
fi

if [[ ! -d "${CONTEXT_DIR}" ]]; then
  echo "❌ .context/ directory not found. Run initialize-repo skill first." >&2
  exit 1
fi

context_files=()
while IFS= read -r f; do
  context_files+=("$f")
done < <(find "${CONTEXT_DIR}" -name "*.md" -not -path "*/graph/*" -not -path "*/tasks/*" | sort)

if [[ ${#context_files[@]} -eq 0 ]]; then
  echo "⚠️  No markdown files found in .context/ (excluding graph/ and tasks/)." >&2
  exit 0
fi

# ─── Helpers ─────────────────────────────────────────────────────────────────

# Extract a frontmatter field value from a file
# Usage: get_field <file> <field>
get_field() {
  local file="$1" field="$2"
  # Match "field: value" inside the opening --- block only
  awk "/^---/{found++; next} found==1 && /^${field}:/{sub(/^${field}:[[:space:]]*/,\"\"); print; exit}" "$file"
}

# Check if a file has a YAML frontmatter block
has_frontmatter() {
  head -1 "$1" | grep -q "^---"
}

# Infer node type from file path
infer_type() {
  local file="$1"
  case "$file" in
    */epics/*)       echo "epic" ;;
    */stories/*)     echo "story" ;;
    */decisions/*)   echo "decision" ;;
    */research/*)    echo "research" ;;
    */constraints/*) echo "constraint" ;;
    *)               echo "overview" ;;
  esac
}

# Slugify a string
slugify() {
  echo "$1" | tr '[:upper:]' '[:lower:]' | tr -cs 'a-z0-9' '-' | sed 's/^-//;s/-$//'
}

# ─── Step 1: Inventory — ensure every file has frontmatter ──────────────────

if [[ "$VALIDATE_ONLY" == false ]]; then
  echo "📋 Step 1: Inventorying .context/ files..."

  for file in "${context_files[@]}"; do
    if ! has_frontmatter "$file"; then
      # Infer values from filename/path
      basename_no_ext=$(basename "$file" .md)
      inferred_id=$(slugify "$basename_no_ext")
      inferred_type=$(infer_type "$file")
      inferred_title=$(echo "$basename_no_ext" | tr '-' ' ' | awk '{for(i=1;i<=NF;i++) $i=toupper(substr($i,1,1)) substr($i,2)}1')

      # Prepend frontmatter (preserves existing content)
      tmp=$(mktemp)
      cat > "$tmp" <<FRONTMATTER
---
id: ${inferred_id}
type: ${inferred_type}
title: ${inferred_title}
description: TODO — add a one-sentence description of what this file covers.
status: active
related: []
---

FRONTMATTER
      cat "$file" >> "$tmp"
      mv "$tmp" "$file"
      echo "   ✍️  Added frontmatter: $file"
    else
      # Check if description field exists; add it if missing
      if ! awk '/^---/{found++; next} found==1 && /^description:/{exit 0} found==2{exit 1}' "$file" 2>/dev/null; then
        # description field missing — insert after title line
        tmp=$(mktemp)
        awk '
          /^---/ { count++; print; next }
          count==1 && /^title:/ { print; print "description: TODO — add a one-sentence description of what this file covers."; next }
          { print }
        ' "$file" > "$tmp"
        mv "$tmp" "$file"
        echo "   ✍️  Added description field: $file"
      fi
    fi
  done
fi

# ─── Step 2: Infer edges (non-destructive — only appends missing edges) ──────

# Edge inference is intentionally left as agent-executed logic.
# Automated inference from bash is unreliable for semantic relationships.
# Agents running this script should follow context-graph-linker SKILL.md
# to manually review and curate related: blocks after the script runs.

# ─── Step 3: Build the INDEX ─────────────────────────────────────────────────

if [[ "$VALIDATE_ONLY" == false ]]; then
  echo "📇 Step 3: Building INDEX..."

  mkdir -p "${GRAPH_DIR}"

  # Collect nodes by type (bash 3 compatible — separate vars per type)
  nodes_epic=""; nodes_story=""; nodes_decision=""
  nodes_research=""; nodes_constraint=""; nodes_overview=""

  for file in "${context_files[@]}"; do
    node_id=$(get_field "$file" "id")
    node_type=$(get_field "$file" "type")
    node_title=$(get_field "$file" "title")
    node_desc=$(get_field "$file" "description")
    node_status=$(get_field "$file" "status")

    [[ -z "$node_id" ]] && continue
    [[ "$node_status" == "superseded" ]] && continue  # omit superseded from INDEX

    entry="- [[$node_id]] — ${node_desc:-$node_title}"

    case "$node_type" in
      epic)       nodes_epic="${nodes_epic}"$'\n'"$entry" ;;
      story)      nodes_story="${nodes_story}"$'\n'"$entry" ;;
      decision)   nodes_decision="${nodes_decision}"$'\n'"$entry" ;;
      research)   nodes_research="${nodes_research}"$'\n'"$entry" ;;
      constraint) nodes_constraint="${nodes_constraint}"$'\n'"$entry" ;;
      *)          nodes_overview="${nodes_overview}"$'\n'"$entry" ;;
    esac
  done

  # Write INDEX
  cat > "${INDEX_FILE}" <<'HEADER'
# Project Knowledge Index

> Entry point for on-demand context retrieval.
> Before any task touching architecture, technology choice, or project scope:
> scan this index, identify the relevant node slugs, then load only those files.
> Do not load the entire .context/ folder.

HEADER

  for type in epic story decision research constraint overview; do
    nodes_var="nodes_${type}"
    nodes="${!nodes_var}"
    if [[ -n "$nodes" ]]; then
      label=$(echo "$type" | awk '{print toupper(substr($0,1,1)) substr($0,2) "s"}')
      echo "## ${label}" >> "${INDEX_FILE}"
      echo "" >> "${INDEX_FILE}"
      echo "$nodes" | sed '/^$/d' >> "${INDEX_FILE}"
      echo "" >> "${INDEX_FILE}"
    fi
  done

  echo "   ✅ Wrote ${INDEX_FILE}"
fi

# ─── Step 4: Validate ────────────────────────────────────────────────────────

echo "🔍 Step 4: Validating graph..."

mkdir -p "${GRAPH_DIR}"

# Collect all known IDs into a temp file (bash 3 compatible)
known_ids_file=$(mktemp)
for file in "${context_files[@]}"; do
  node_id=$(get_field "$file" "id")
  [[ -n "$node_id" ]] && echo "${node_id}=${file}" >> "$known_ids_file"
done

id_known() {
  grep -q "^${1}=" "$known_ids_file" 2>/dev/null
}

id_file() {
  grep "^${1}=" "$known_ids_file" 2>/dev/null | cut -d= -f2-
}

orphans=()
broken_refs=()
drift_items=()

for file in "${context_files[@]}"; do
  node_id=$(get_field "$file" "id")
  node_status=$(get_field "$file" "status")
  [[ -z "$node_id" ]] && continue

  # Check for orphans: no related entries
  related_count=$(awk '/^---/{count++; next} count==1 && /^  - id:/{found++} count==2{exit} END{print found+0}' "$file")
  if [[ "$related_count" -eq 0 ]]; then
    orphans+=("$node_id ($file)")
  fi

  # Check for broken refs: related IDs that don't exist
  while IFS= read -r ref_id; do
    ref_id=$(echo "$ref_id" | tr -d ' ')
    if [[ -n "$ref_id" ]] && ! id_known "$ref_id"; then
      broken_refs+=("$node_id references unknown id: $ref_id")
    fi
  done < <(awk '/^---/{count++; next} count==1 && /^  - id:/{sub(/^.*id:[[:space:]]*/,""); print}' "$file")

  # Check for drift: active node superseded by another active node
  if [[ "$node_status" == "active" ]]; then
    while IFS= read -r ref_id; do
      ref_id=$(echo "$ref_id" | tr -d ' ')
      rel=$(awk "/^---/{count++; next} count==1 && /id: ${ref_id}/{found=1} found && /rel:/{sub(/.*rel:[[:space:]]*/,\"\"); print; exit}" "$file")
      if [[ "$rel" == "supersedes" ]]; then
        ref_file=$(id_file "$ref_id")
        superseded_status=$(get_field "${ref_file:-/dev/null}" "status" 2>/dev/null || echo "")
        if [[ "$superseded_status" == "active" ]]; then
          drift_items+=("DRIFT: $node_id supersedes $ref_id but $ref_id is still marked active")
        fi
      fi
    done < <(awk '/^---/{count++; next} count==1 && /^  - id:/{sub(/^.*id:[[:space:]]*/,""); print}' "$file")
  fi
done

# Write ORPHANS.md
{
  echo "# Orphaned Nodes"
  echo ""
  echo "> Nodes with no relationships. Consider linking them or removing them."
  echo ""
  if [[ ${#orphans[@]} -eq 0 ]]; then
    echo "_No orphans found._"
  else
    for o in "${orphans[@]}"; do echo "- $o"; done
  fi
} > "${ORPHANS_FILE}"

# Write BROKEN.md
{
  echo "# Broken Links"
  echo ""
  echo "> Related IDs that do not correspond to any known node."
  echo ""
  if [[ ${#broken_refs[@]} -eq 0 ]]; then
    echo "_No broken links found._"
  else
    for b in "${broken_refs[@]}"; do echo "- $b"; done
  fi
} > "${BROKEN_FILE}"

# Write DRIFT.md
{
  echo "# Drift Report"
  echo ""
  echo "> Contradictions and superseded-but-active nodes. Review before proceeding."
  echo ""
  if [[ ${#drift_items[@]} -eq 0 ]]; then
    echo "_No drift detected._"
  else
    for d in "${drift_items[@]}"; do echo "- $d"; done
  fi
} > "${DRIFT_FILE}"

echo "   Orphans: ${#orphans[@]}  |  Broken: ${#broken_refs[@]}  |  Drift: ${#drift_items[@]}"

# Cleanup temp file
rm -f "$known_ids_file"

# ─── Step 5: Append to CHANGELOG ────────────────────────────────────────────

if [[ "$VALIDATE_ONLY" == false ]]; then
  touch "${CHANGELOG_FILE}"
  timestamp=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
  mode="rebuild"
  echo "[${timestamp}] graph-link — ${mode} — ${#context_files[@]} nodes processed, ${#orphans[@]} orphans, ${#broken_refs[@]} broken, ${#drift_items[@]} drift" >> "${CHANGELOG_FILE}"
fi

echo ""
echo "✅ Graph updated."
echo "   INDEX:    ${INDEX_FILE}"
echo "   ORPHANS:  ${ORPHANS_FILE}"
echo "   BROKEN:   ${BROKEN_FILE}"
echo "   DRIFT:    ${DRIFT_FILE}"
if [[ "$VALIDATE_ONLY" == false ]]; then
  echo "   CHANGELOG: ${CHANGELOG_FILE}"
fi
echo ""
echo "💡 Next: review ORPHANS.md and DRIFT.md, then run context-maintenance skill"
echo "         to promote any new patterns and update related: edges as needed."
