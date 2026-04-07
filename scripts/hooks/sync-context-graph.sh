#!/usr/bin/env bash
# sync-context-graph.sh — Git pre-commit hook: sync .context/ graph on changes
#
# Installed by setup-hooks.sh into .git/hooks/pre-commit
# Safe to run on repos that haven't initialized the graph yet (no-op).

set -euo pipefail

CONTEXT_DIR=".context"
GRAPH_DIR="${CONTEXT_DIR}/graph"
SCRIPT="scripts/graph-link.sh"

# No-op if .context/ doesn't exist (repo not initialized)
[[ ! -d "${CONTEXT_DIR}" ]] && exit 0

# No-op if graph has never been initialized
[[ ! -d "${GRAPH_DIR}" ]] && exit 0

# No-op if the graph script isn't present
[[ ! -f "${SCRIPT}" ]] && exit 0

# Check if any .context/ files (outside graph/ and tasks/) are staged
changed=$(git diff --cached --name-only | grep "^${CONTEXT_DIR}/" | grep -v "^${CONTEXT_DIR}/graph/" | grep -v "^${CONTEXT_DIR}/tasks/" || true)

if [[ -z "$changed" ]]; then
  exit 0  # nothing in .context/ changed — skip
fi

echo "🔗 .context/ changes detected — syncing knowledge graph..."
bash "${SCRIPT}"

# Stage the updated graph files so they're included in the commit
git add "${GRAPH_DIR}/" 2>/dev/null || true

echo "   Graph files staged for commit."
