---
name: find-context-template
description: >
  Locate the context_template directory in the agent-defs installation. Use when
  the initialize-repo or initialize-workspace skill needs to find the template
  but the path is unknown.
---

# Skill: Find Context Template

## Purpose

Reliably locate the agent-defs context_template directory across different
installation layouts (local clone, VS Code extension, npm install, etc.). This
skill implements a systematic search strategy that covers common installation
patterns and provides clear diagnostics when the template cannot be found.

---

## Search Sequence

Try in order, stop at first match.

### 1. Sibling Directory (Local Development)

```bash
# Check ../agent-defs/context_template/
if [ -d "../agent-defs/context_template" ]; then
  TEMPLATE_PATH="$(cd ../agent-defs/context_template && pwd)"
fi
```

**Use case:** Developer cloned agent-defs as a sibling to the project repo.

**Path pattern:**
```
repos/
├── project/          ← You are here
└── agent-defs/
    └── context_template/
```

---

### 2. Two Levels Up

```bash
# Check ../../agent-defs/context_template/
if [ -d "../../agent-defs/context_template" ]; then
  TEMPLATE_PATH="$(cd ../../agent-defs/context_template && pwd)"
fi
```

**Use case:** Running from within a subdirectory of the project.

**Path pattern:**
```
repos/
├── project/
│   └── subdirectory/  ← You are here
└── agent-defs/
    └── context_template/
```

---

### 3. Conventional Tools Directory

```bash
# Check ~/tools/agent-defs/context_template/
if [ -d "$HOME/tools/agent-defs/context_template" ]; then
  TEMPLATE_PATH="$HOME/tools/agent-defs/context_template"
fi
```

**Use case:** User installed agent-defs in a central tools directory.

**Path pattern:**
```
~/tools/
└── agent-defs/
    └── context_template/
```

---

### 4. User-Level Install

```bash
# Check ~/.copilot/context_template/
if [ -d "$HOME/.copilot/context_template" ]; then
  TEMPLATE_PATH="$HOME/.copilot/context_template"
fi
```

**Use case:** System-wide installation in user home directory.

**Path pattern:**
```
~/.copilot/
└── context_template/
```

---

### 5. Home Directory Search (Limited Depth)

```bash
# Search for context_template/ in home directory (max 3 levels deep)
TEMPLATE_PATH=$(find "$HOME" -maxdepth 3 -type d -name "context_template" -path "*/agent-defs/*" 2>/dev/null | head -n 1)
```

**Use case:** Template is somewhere in home directory but location unknown.

**Constraints:**
- Maximum 3 levels deep (performance)
- Must be inside an `agent-defs` directory
- Takes first match found

---

### 6. VS Code Extension Storage

```bash
# Check VS Code extension directories
VSCODE_EXTENSIONS="$HOME/.vscode/extensions"

# Find agent-defs extension
EXTENSION_PATH=$(find "$VSCODE_EXTENSIONS" -maxdepth 2 -type d -name "*agent-defs*" 2>/dev/null | head -n 1)

if [ -n "$EXTENSION_PATH" ]; then
  if [ -d "$EXTENSION_PATH/context_template" ]; then
    TEMPLATE_PATH="$EXTENSION_PATH/context_template"
  fi
fi
```

**Use case:** Template bundled with a VS Code extension.

**Path pattern:**
```
~/.vscode/extensions/
└── publisher.agent-defs-1.0.0/
    └── context_template/
```

---

## Template Verification

**Goal:** Confirm the found directory is actually a valid context_template.

### Required Files/Directories

A valid context_template must contain:

```
context_template/
├── overview.md (or overview.md.template)
├── standards/
├── domains/
└── architecture/ (or decisions/)
```

### Verification Script

```bash
verify_template() {
  local path=$1
  
  # Check for overview file
  if [ ! -f "$path/overview.md" ] && [ ! -f "$path/overview.md.template" ]; then
    return 1
  fi
  
  # Check for standards directory
  if [ ! -d "$path/standards" ]; then
    return 1
  fi
  
  # Check for domains directory
  if [ ! -d "$path/domains" ]; then
    return 1
  fi
  
  # Check for architecture or decisions directory
  if [ ! -d "$path/architecture" ] && [ ! -d "$path/decisions" ]; then
    return 1
  fi
  
  return 0
}

# Use it
if verify_template "$TEMPLATE_PATH"; then
  echo "Valid template found at: $TEMPLATE_PATH"
else
  echo "Invalid template structure at: $TEMPLATE_PATH"
  TEMPLATE_PATH=""
fi
```

---

## Complete Search Script

```bash
#!/bin/bash

find_context_template() {
  local template_path=""
  local search_log=()
  
  # 1. Sibling directory
  search_log+=("Checking ../agent-defs/context_template")
  if [ -d "../agent-defs/context_template" ]; then
    template_path="$(cd ../agent-defs/context_template && pwd)"
    search_log+=("✅ Found at: $template_path")
  else
    search_log+=("❌ Not found")
  fi
  
  # 2. Two levels up
  if [ -z "$template_path" ]; then
    search_log+=("Checking ../../agent-defs/context_template")
    if [ -d "../../agent-defs/context_template" ]; then
      template_path="$(cd ../../agent-defs/context_template && pwd)"
      search_log+=("✅ Found at: $template_path")
    else
      search_log+=("❌ Not found")
    fi
  fi
  
  # 3. Conventional tools directory
  if [ -z "$template_path" ]; then
    search_log+=("Checking ~/tools/agent-defs/context_template")
    if [ -d "$HOME/tools/agent-defs/context_template" ]; then
      template_path="$HOME/tools/agent-defs/context_template"
      search_log+=("✅ Found at: $template_path")
    else
      search_log+=("❌ Not found")
    fi
  fi
  
  # 4. User-level install
  if [ -z "$template_path" ]; then
    search_log+=("Checking ~/.copilot/context_template")
    if [ -d "$HOME/.copilot/context_template" ]; then
      template_path="$HOME/.copilot/context_template"
      search_log+=("✅ Found at: $template_path")
    else
      search_log+=("❌ Not found")
    fi
  fi
  
  # 5. Home directory search
  if [ -z "$template_path" ]; then
    search_log+=("Searching home directory (max depth 3)...")
    template_path=$(find "$HOME" -maxdepth 3 -type d -name "context_template" -path "*/agent-defs/*" 2>/dev/null | head -n 1)
    if [ -n "$template_path" ]; then
      search_log+=("✅ Found at: $template_path")
    else
      search_log+=("❌ Not found")
    fi
  fi
  
  # 6. VS Code extensions
  if [ -z "$template_path" ]; then
    search_log+=("Checking VS Code extensions...")
    local vscode_ext="$HOME/.vscode/extensions"
    local extension_path=$(find "$vscode_ext" -maxdepth 2 -type d -name "*agent-defs*" 2>/dev/null | head -n 1)
    
    if [ -n "$extension_path" ] && [ -d "$extension_path/context_template" ]; then
      template_path="$extension_path/context_template"
      search_log+=("✅ Found at: $template_path")
    else
      search_log+=("❌ Not found")
    fi
  fi
  
  # Verify the template
  if [ -n "$template_path" ]; then
    search_log+=("Verifying template structure...")
    
    if [ -f "$template_path/overview.md" ] || [ -f "$template_path/overview.md.template" ]; then
      search_log+=("✅ overview.md found")
    else
      search_log+=("❌ overview.md missing")
      template_path=""
    fi
    
    if [ -d "$template_path/standards" ]; then
      search_log+=("✅ standards/ found")
    else
      search_log+=("❌ standards/ missing")
      template_path=""
    fi
    
    if [ -d "$template_path/domains" ]; then
      search_log+=("✅ domains/ found")
    else
      search_log+=("❌ domains/ missing")
      template_path=""
    fi
  fi
  
  # Output results
  if [ -n "$template_path" ]; then
    echo "✅ Context template found and verified:"
    echo "$template_path"
    return 0
  else
    echo "❌ Context template not found"
    echo ""
    echo "Search log:"
    printf '%s\n' "${search_log[@]}"
    echo ""
    echo "Please provide the path to the context_template directory."
    return 1
  fi
}

# Run it
find_context_template
```

---

## Output Formats

### Success

```
✅ Context template found and verified:
/Users/username/tools/agent-defs/context_template
```

### Failure with Diagnostics

```
❌ Context template not found

Search log:
Checking ../agent-defs/context_template
❌ Not found
Checking ../../agent-defs/context_template
❌ Not found
Checking ~/tools/agent-defs/context_template
❌ Not found
Checking ~/.copilot/context_template
❌ Not found
Searching home directory (max depth 3)...
❌ Not found
Checking VS Code extensions...
❌ Not found

Please provide the path to the context_template directory.
```

---

## Manual Path Specification

If the search fails, ask the user:

```markdown
## Context Template Not Found

I searched the following locations but couldn't find the context_template directory:

- ../agent-defs/context_template
- ../../agent-defs/context_template
- ~/tools/agent-defs/context_template
- ~/.copilot/context_template
- Home directory (searched 3 levels deep)
- VS Code extensions directory

Please provide the absolute path to your agent-defs installation's context_template directory.

Example:
```
/Users/username/repos/agent-defs/context_template
```

I will then verify the path and proceed with initialization.
```

### Path Validation

After user provides a path:

```bash
USER_PATH="$1"

# Verify it exists
if [ ! -d "$USER_PATH" ]; then
  echo "❌ Directory does not exist: $USER_PATH"
  exit 1
fi

# Verify it's a valid template
if verify_template "$USER_PATH"; then
  echo "✅ Valid template found at: $USER_PATH"
  # Proceed with initialization
else
  echo "❌ Invalid template structure at: $USER_PATH"
  echo "Expected files/directories: overview.md, standards/, domains/"
  exit 1
fi
```

---

## Integration with Other Skills

### initialize-repo

```bash
# At the start of initialize-repo
echo "Finding context template..."
TEMPLATE_PATH=$(find_context_template)

if [ -z "$TEMPLATE_PATH" ]; then
  echo "Cannot proceed without context template."
  exit 1
fi

# Use TEMPLATE_PATH for initialization
cp -r "$TEMPLATE_PATH" ./.context
```

### initialize-workspace

```bash
# For each project in workspace
for PROJECT in "${PROJECTS[@]}"; do
  cd "$PROJECT"
  
  TEMPLATE_PATH=$(find_context_template)
  
  if [ -z "$TEMPLATE_PATH" ]; then
    echo "⚠️ Skipping $PROJECT: template not found"
    continue
  fi
  
  # Initialize using found template
  cp -r "$TEMPLATE_PATH" ./.context
done
```

---

## Constraints

- **Do not fabricate a path** — Only return verified, existing paths
- **Do not proceed without verification** — Every found path must pass the verification check
- **Report all searched locations when asking for help** — User needs to see what was tried
- **Stop at first valid match** — Do not search all locations if an early one succeeds
- **Do not search indefinitely** — Limit home directory search to 3 levels deep
- **Handle permissions errors gracefully** — If `find` fails due to permissions, note it in the log but continue
- **Never use a template with missing required files** — Incomplete templates produce incomplete context
