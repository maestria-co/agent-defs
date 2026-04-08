#!/usr/bin/env bash
# graph-link.sh — Build and maintain the .context/ knowledge graph
#
# Usage:
#   bash scripts/graph-link.sh                 # full build + validate
#   bash scripts/graph-link.sh --rebuild       # same as default
#   bash scripts/graph-link.sh --validate-only # validate only, no file writes
#   bash scripts/graph-link.sh [path/to/.context]  # custom context dir
#
# Output:
#   .context/graph/INDEX.md    — primary navigation surface for agents
#   .context/graph/ORPHANS.md  — files with no inbound or outbound links
#   .context/graph/BROKEN.md   — markdown links pointing to missing files
#   .context/graph/CHANGELOG.md — append-only run log
#
# Prerequisites:
#   - Run from repository root
#   - .context/ directory must exist
#   - Requires: bash 3.2+, awk, grep, find, date (macOS compatible)

set -euo pipefail

# ─── Config ──────────────────────────────────────────────────────────────────

CONTEXT_DIR="${1:-.context}"
[[ "${1:-}" == --* ]] && CONTEXT_DIR=".context"  # don't treat flags as path

INDEX_FILE="${CONTEXT_DIR}/graph/INDEX.md"
GRAPH_DIR="${CONTEXT_DIR}/graph"
CHANGELOG_FILE="${GRAPH_DIR}/CHANGELOG.md"
VALIDATE_ONLY=false

for arg in "$@"; do
  case "$arg" in
    --validate-only) VALIDATE_ONLY=true ;;
    --rebuild)       ;;
    --*)             echo "Unknown flag: $arg" >&2; exit 1 ;;
  esac
done

# ─── Pre-flight ───────────────────────────────────────────────────────────────

if [[ ! -d ".git" ]]; then
  echo "❌ Run from the repository root (no .git found)." >&2
  exit 1
fi

if [[ ! -d "${CONTEXT_DIR}" ]]; then
  echo "❌ ${CONTEXT_DIR}/ not found. Run initialize-repo skill first." >&2
  exit 1
fi

# ─── Helpers ─────────────────────────────────────────────────────────────────

log()  { echo "▸ $*"; }
warn() { echo "⚠  $*" >&2; }

# get_field <file> <field> — extract a YAML frontmatter field value
get_field() {
  local file="$1" field="$2"
  awk "/^---/{found++; next} found==1 && /^${field}:/{sub(/^${field}:[[:space:]]*/,\"\"); print; exit}" "$file" 2>/dev/null
}

has_frontmatter() {
  head -1 "$1" 2>/dev/null | grep -q "^---"
}

# Infer node type from file path — matches actual context_template structure
infer_type() {
  local file="$1"
  case "$file" in
    */decisions/*)     echo "decision" ;;
    */retrospectives/*) echo "retrospective" ;;
    */domains/*)       echo "domain" ;;
    */workflows/*)     echo "workflow" ;;
    */standards*)      echo "standards" ;;
    *architecture*)    echo "architecture" ;;
    *testing*)         echo "testing" ;;
    *overview*)        echo "overview" ;;
    *)                 echo "overview" ;;
  esac
}

slugify() {
  echo "$1" | tr '[:upper:]' '[:lower:]' | tr -cs 'a-z0-9' '-' | sed 's/^-//;s/-$//'
}

# Extract first real prose sentence from a file (after frontmatter, skip headings/blanks)
extract_description() {
  local file="$1"
  awk '
    /^---/ { fm++; next }
    fm == 1 { next }
    fm >= 2 && /^#/ { next }
    fm >= 2 && /^>/ { sub(/^>[[:space:]]*/,""); print; exit }
    fm >= 2 && /^[[:space:]]*$/ { next }
    fm >= 2 { print; exit }
    fm == 0 && /^#/ { next }
    fm == 0 && /^[[:space:]]*$/ { next }
    fm == 0 { print; exit }
  ' "$file" 2>/dev/null | cut -c1-120
}

# resolve_link <source_file_relative_to_CONTEXT_DIR> <raw_link>
# Returns path relative to CONTEXT_DIR if it resolves to a real .md file
resolve_link() {
  local source_file="$1" raw_link="$2"
  local source_dir resolved
  source_dir="$(dirname "$source_file")"
  raw_link="${raw_link#./}"

  # Try resolving relative to source file's directory
  resolved="${source_dir}/${raw_link}"
  # Normalize ../ sequences with awk (no realpath needed)
  resolved="$(echo "$resolved" | awk '{
    n = split($0, parts, "/"); out = ""
    for (i=1; i<=n; i++) {
      if (parts[i] == "..") { sub(/\/[^\/]+$/, "", out) }
      else if (parts[i] != "." && parts[i] != "") { out = out "/" parts[i] }
    }
    print substr(out,2)  # strip leading /
  }')"

  if [[ -f "${CONTEXT_DIR}/${resolved}" && "${resolved}" == *.md ]]; then
    echo "$resolved"
  fi
}

# ─── Step 1: Collect files ───────────────────────────────────────────────────

context_files=()
while IFS= read -r f; do
  context_files+=("$f")
done < <(find "${CONTEXT_DIR}" -name "*.md" \
           -not -name "overview.md" \
           -not -path "*/graph/*" \
           -not -path "*/tasks/*" \
         | sed "s|^${CONTEXT_DIR}/||" | sort)

if [[ ${#context_files[@]} -eq 0 ]]; then
  warn "No content files found in ${CONTEXT_DIR}/ (excluding overview.md, graph/, tasks/)."
  exit 0
fi

log "Found ${#context_files[@]} context files"

# ─── Step 2: Ensure frontmatter on every file ────────────────────────────────

if [[ "$VALIDATE_ONLY" == false ]]; then
  log "Checking frontmatter..."

  for f in "${context_files[@]}"; do
    full="${CONTEXT_DIR}/${f}"
    if ! has_frontmatter "$full"; then
      base="$(basename "$f" .md)"
      inferred_id="$(slugify "$base")"
      inferred_type="$(infer_type "$f")"
      inferred_title="$(echo "$base" | tr '-' ' ' | awk '{for(i=1;i<=NF;i++) $i=toupper(substr($i,1,1)) substr($i,2)}1')"
      extracted_desc="$(extract_description "$full")"
      desc="${extracted_desc:-TODO — add a one-sentence description of what this file covers.}"

      tmp="$(mktemp)"
      printf -- '---\nid: %s\ntype: %s\ntitle: %s\ndescription: %s\nstatus: active\nrelated: []\n---\n\n' \
        "$inferred_id" "$inferred_type" "$inferred_title" "$desc" > "$tmp"
      cat "$full" >> "$tmp"
      mv "$tmp" "$full"
      log "  ✍  Added frontmatter: $f"
    else
      # Add description: if missing
      if ! awk 'BEGIN{ok=0} /^---/{fm++; next} fm==1 && /^description:/{ok=1; exit} fm==2{exit} END{exit !ok}' "$full"; then
        extracted_desc="$(extract_description "$full")"
        desc="${extracted_desc:-TODO — add a one-sentence description of what this file covers.}"
        tmp="$(mktemp)"
        awk -v desc="$desc" '
          /^---/ { count++; print; next }
          count==1 && /^title:/ { print; print "description: " desc; next }
          { print }
        ' "$full" > "$tmp"
        mv "$tmp" "$full"
        log "  ✍  Added description: $f"
      fi
    fi
  done
fi

# ─── Step 3: Build edge map via content scanning ─────────────────────────────
# Scans @mentions and markdown links in file content.
# Ignores directory-as-sibling inference (too many false positives).

log "Scanning links..."

# edges_file: lines of "source_relative_path -> target_relative_path"
edges_file="$(mktemp)"

for f in "${context_files[@]}"; do
  full="${CONTEXT_DIR}/${f}"

  # Scan @mentions: @filename.md or @path/to/file.md
  while IFS= read -r mention; do
    mention="${mention#@}"
    resolved="$(resolve_link "$f" "$mention")"
    if [[ -n "$resolved" && "$resolved" != "$f" ]]; then
      echo "${f} -> ${resolved}" >> "$edges_file"
    fi
  done < <(grep -oE '@[A-Za-z0-9_./-]+\.md' "$full" 2>/dev/null || true)

  # Scan markdown links: [text](path.md)
  while IFS= read -r link; do
    resolved="$(resolve_link "$f" "$link")"
    if [[ -n "$resolved" && "$resolved" != "$f" ]]; then
      echo "${f} -> ${resolved}" >> "$edges_file"
    fi
  done < <(grep -oE '\]\([A-Za-z0-9_./-]+\.md\)' "$full" 2>/dev/null \
           | grep -oE '[A-Za-z0-9_./-]+\.md' || true)
done

# Deduplicate edges
sort -u "$edges_file" -o "$edges_file"
edge_count="$(wc -l < "$edges_file" | tr -d ' ')"
log "Found ${edge_count} edges"

# ─── Step 4: Build graph output ──────────────────────────────────────────────

render_graph() {
  echo "# Project Knowledge Index"
  echo ""
  echo "> Entry point for on-demand context retrieval."
  echo "> Before any task touching architecture, technology choice, or project scope:"
  echo "> scan this index, identify relevant files, then load only those."
  echo "> Do not load the entire .context/ folder."
  echo ""
  echo "<!-- Auto-generated by graph-link.sh — do not edit this file manually -->"
  echo ""

  # ── File Index table ──
  echo "## Context Index"
  echo ""
  echo "| File | Type | Description |"
  echo "|------|------|-------------|"

  for f in "${context_files[@]}"; do
    full="${CONTEXT_DIR}/${f}"
    node_type="$(get_field "$full" "type")"
    node_desc="$(get_field "$full" "description")"
    node_status="$(get_field "$full" "status")"
    [[ "$node_status" == "superseded" ]] && continue

    # Fall back to content extraction if description is unset or still TODO
    if [[ -z "$node_desc" || "$node_desc" == TODO* ]]; then
      node_desc="$(extract_description "$full")"
    fi
    [[ -z "$node_type" ]] && node_type="$(infer_type "$f")"

    desc_display="${node_desc:-—}"
    desc_display="$(echo "$desc_display" | cut -c1-100)"

    echo "| \`${f}\` | ${node_type} | ${desc_display} |"
  done
  echo ""

  # ── Dependency list ──
  echo "## File Dependencies"
  echo ""
  echo "<!-- Inferred from @mentions and markdown links in file content -->"
  echo ""

  for f in "${context_files[@]}"; do
    deps="$(grep "^${f} -> " "$edges_file" | cut -d'>' -f2- | sed 's/^ //' | sed 's/^/`/' | sed 's/$/`/' | paste -sd ', ' - || true)"
    if [[ -n "$deps" ]]; then
      echo "- \`${f}\` → [${deps}]"
    else
      echo "- \`${f}\` → [] <!-- no outbound links -->"
    fi
  done
}

# ─── Step 5: Validate ────────────────────────────────────────────────────────

log "Validating..."
mkdir -p "${GRAPH_DIR}"

# Build known-files index (temp file, bash 3 compatible)
known_files="$(mktemp)"
for f in "${context_files[@]}"; do echo "$f" >> "$known_files"; done

orphans=()
broken_refs=()

for f in "${context_files[@]}"; do
  full="${CONTEXT_DIR}/${f}"

  # Orphan: no inbound or outbound edges (and no frontmatter related: entries)
  outbound="$(grep -c "^${f} -> " "$edges_file" 2>/dev/null || true)"
  inbound="$(grep -c " -> ${f}$" "$edges_file" 2>/dev/null || true)"
  fm_related="$(awk '/^---/{fm++; next} fm==1 && /^  - id:/{found++} fm==2{exit} END{print found+0}' "$full" 2>/dev/null || true)"

  if [[ "$outbound" -eq 0 && "$inbound" -eq 0 && "$fm_related" -eq 0 ]]; then
    orphans+=("$f")
  fi

  # Broken: markdown links pointing to files that don't exist
  while IFS= read -r link; do
    resolved="$(resolve_link "$f" "$link")"
    if [[ -z "$resolved" && -n "$link" ]]; then
      broken_refs+=("${f}: dead link → ${link}")
    fi
  done < <(grep -oE '\]\([A-Za-z0-9_./-]+\.md\)' "${CONTEXT_DIR}/${f}" 2>/dev/null \
           | grep -oE '[A-Za-z0-9_./-]+\.md' || true)
done

# Write validation reports
{
  echo "# Orphaned Files"
  echo ""
  echo "> Files with no inbound or outbound links and no frontmatter \`related:\` entries."
  echo "> These are not discoverable from any other context file."
  echo ""
  if [[ ${#orphans[@]} -eq 0 ]]; then
    echo "_None._"
  else
    for o in "${orphans[@]}"; do echo "- \`$o\`"; done
  fi
} > "${GRAPH_DIR}/ORPHANS.md"

{
  echo "# Broken Links"
  echo ""
  echo "> Markdown links in .context/ files that point to files that do not exist."
  echo ""
  if [[ ${#broken_refs[@]} -eq 0 ]]; then
    echo "_None._"
  else
    for b in "${broken_refs[@]}"; do echo "- $b"; done
  fi
} > "${GRAPH_DIR}/BROKEN.md"

log "Orphans: ${#orphans[@]}  |  Broken: ${#broken_refs[@]}"

# ─── Step 6: Write INDEX.md ──────────────────────────────────────────────────

if [[ "$VALIDATE_ONLY" == false ]]; then
  mkdir -p "${GRAPH_DIR}"
  render_graph > "${INDEX_FILE}"
  log "Wrote ${INDEX_FILE}"

  # Changelog
  touch "${CHANGELOG_FILE}"
  timestamp="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"
  echo "[${timestamp}] graph-link — rebuild — ${#context_files[@]} files, ${edge_count} edges, ${#orphans[@]} orphans, ${#broken_refs[@]} broken" >> "${CHANGELOG_FILE}"
fi

# ─── Cleanup ──────────────────────────────────────────────────────────────────

rm -f "$edges_file" "$known_files"

# ─── Summary ──────────────────────────────────────────────────────────────────

echo ""
echo "✓ Graph built"
echo "  Files indexed : ${#context_files[@]}"
echo "  Edges found   : ${edge_count}"
echo "  Orphans       : ${#orphans[@]}"
echo "  Broken links  : ${#broken_refs[@]}"
if [[ "$VALIDATE_ONLY" == false ]]; then
  echo "  Index         : ${INDEX_FILE}"
  echo "  Reports       : ${GRAPH_DIR}/"
fi
echo ""
if [[ ${#orphans[@]} -gt 0 ]]; then
  echo "  ⚠  Review ${GRAPH_DIR}/ORPHANS.md — these files aren't reachable"
fi
if [[ ${#broken_refs[@]} -gt 0 ]]; then
  echo "  ⚠  Review ${GRAPH_DIR}/BROKEN.md — fix dead links"
fi
