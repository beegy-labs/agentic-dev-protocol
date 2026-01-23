#!/bin/bash

# sync-standards.sh
# Synchronize llm-dev-protocol standards to configured projects

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Parse arguments
DRY_RUN=false
FORCE=false

while [[ $# -gt 0 ]]; do
  case $1 in
    --dry-run)
      DRY_RUN=true
      shift
      ;;
    --force)
      FORCE=true
      shift
      ;;
    *)
      echo "Unknown option: $1"
      echo "Usage: $0 [--dry-run] [--force]"
      exit 1
      ;;
  esac
done

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}  LLM Development Protocol - Standard Sync${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

if [ "$DRY_RUN" = true ]; then
  echo -e "${YELLOW}⚠️  DRY RUN MODE - No changes will be made${NC}"
  echo ""
fi

# Check if projects.json exists
if [ ! -f "$PROJECT_ROOT/projects.json" ]; then
  echo -e "${RED}✗ projects.json not found${NC}"
  exit 1
fi

# Parse projects.json
PROJECTS=$(jq -c '.projects[] | select(.enabled == true)' "$PROJECT_ROOT/projects.json")

if [ -z "$PROJECTS" ]; then
  echo -e "${YELLOW}⚠️  No enabled projects found in projects.json${NC}"
  exit 0
fi

# Count projects
PROJECT_COUNT=$(echo "$PROJECTS" | wc -l)
echo -e "Found ${GREEN}$PROJECT_COUNT${NC} enabled project(s)"
echo ""

# Process each project
SUCCESS_COUNT=0
ERROR_COUNT=0

while IFS= read -r project; do
  PROJECT_NAME=$(echo "$project" | jq -r '.name')
  PROJECT_PATH=$(echo "$project" | jq -r '.path')

  echo -e "${BLUE}▶ Processing: $PROJECT_NAME${NC}"

  # Resolve absolute path
  if [[ "$PROJECT_PATH" = /* ]]; then
    ABS_PATH="$PROJECT_PATH"
  else
    ABS_PATH="$(cd "$PROJECT_ROOT" && realpath "$PROJECT_PATH" 2>/dev/null || echo "")"
  fi

  if [ -z "$ABS_PATH" ] || [ ! -d "$ABS_PATH" ]; then
    echo -e "  ${RED}✗ Project not found: $PROJECT_PATH${NC}"
    ((ERROR_COUNT++))
    echo ""
    continue
  fi

  echo -e "  Path: $ABS_PATH"

  # Sync AGENTS.md (mandatory) - Use marker-based sync
  if [ "$DRY_RUN" = true ]; then
    echo -e "  ${YELLOW}[DRY RUN]${NC} Would sync: AGENTS.md (preserving custom section)"
  else
    # Source the marker-based sync function
    source "$SCRIPT_DIR/sync-agents-md.sh"

    if sync_agents_md "$PROJECT_ROOT/AGENTS.md" "$ABS_PATH/AGENTS.md"; then
      echo -e "  ${GREEN}✓${NC} Synced: AGENTS.md (custom section preserved)"
    else
      echo -e "  ${RED}✗${NC} Failed to sync: AGENTS.md"
      ((ERROR_COUNT++))
    fi
  fi

  # Sync policy files (from projects.json sync config)
  SYNC_CONFIG=$(echo "$project" | jq -r '.sync')

  if [ "$SYNC_CONFIG" != "null" ]; then
    while IFS= read -r entry; do
      FILE=$(echo "$entry" | jq -r '.key')
      ENABLED=$(echo "$entry" | jq -r '.value')

      if [ "$ENABLED" = "true" ] && [ -f "$PROJECT_ROOT/$FILE" ]; then
        TARGET_DIR="$ABS_PATH/$(dirname "$FILE")"

        if [ "$DRY_RUN" = true ]; then
          echo -e "  ${YELLOW}[DRY RUN]${NC} Would sync: $FILE"
        else
          mkdir -p "$TARGET_DIR"
          cp -f "$PROJECT_ROOT/$FILE" "$ABS_PATH/$FILE"
          echo -e "  ${GREEN}✓${NC} Synced: $FILE"
        fi
      fi
    done < <(echo "$SYNC_CONFIG" | jq -c 'to_entries[]')
  fi

  # Sync CDD scripts (mandatory for all projects)
  echo -e "  ${BLUE}Syncing CDD scripts...${NC}"
  CDD_SCRIPTS=$(jq -r '.sync_rules.cdd_scripts[]' "$PROJECT_ROOT/projects.json" 2>/dev/null || echo "")

  if [ -n "$CDD_SCRIPTS" ]; then
    while IFS= read -r script; do
      if [ -f "$PROJECT_ROOT/$script" ]; then
        TARGET_DIR="$ABS_PATH/$(dirname "$script")"

        if [ "$DRY_RUN" = true ]; then
          echo -e "  ${YELLOW}[DRY RUN]${NC} Would sync: $script"
        else
          mkdir -p "$TARGET_DIR"
          cp -f "$PROJECT_ROOT/$script" "$ABS_PATH/$script"
          chmod +x "$ABS_PATH/$script"
          echo -e "  ${GREEN}✓${NC} Synced: $script"
        fi
      fi
    done <<< "$CDD_SCRIPTS"
  fi

  # Sync optional files (only if they don't exist - initial setup only)
  echo -e "  ${BLUE}Syncing optional files (if missing)...${NC}"
  OPTIONAL_FILES=$(jq -r '.sync_rules.optional_files.files[]' "$PROJECT_ROOT/projects.json" 2>/dev/null || echo "")

  if [ -n "$OPTIONAL_FILES" ]; then
    while IFS= read -r file; do
      if [ -f "$PROJECT_ROOT/$file" ]; then
        TARGET_FILE="$ABS_PATH/$file"

        # Only copy if target doesn't exist
        if [ ! -f "$TARGET_FILE" ]; then
          TARGET_DIR="$ABS_PATH/$(dirname "$file")"

          if [ "$DRY_RUN" = true ]; then
            echo -e "  ${YELLOW}[DRY RUN]${NC} Would copy (initial): $file"
          else
            mkdir -p "$TARGET_DIR"
            cp "$PROJECT_ROOT/$file" "$TARGET_FILE"
            echo -e "  ${GREEN}✓${NC} Copied (initial): $file"
          fi
        else
          echo -e "  ${BLUE}↷${NC} Skipped (exists): $file"
        fi
      fi
    done <<< "$OPTIONAL_FILES"
  fi

  # Generate agent-specific docs (CLAUDE.md, GEMINI.md, etc.)
  if [ -f "$SCRIPT_DIR/generate-agent-docs.sh" ]; then
    echo -e "  ${BLUE}Generating agent-specific docs...${NC}"
    if [ "$DRY_RUN" = true ]; then
      echo -e "  ${YELLOW}[DRY RUN]${NC} Would generate: CLAUDE.md, GEMINI.md, CURSOR.md"
    else
      if bash "$SCRIPT_DIR/generate-agent-docs.sh" --project "$ABS_PATH" --all 2>&1 | grep -q "complete"; then
        echo -e "  ${GREEN}✓${NC} Generated: CLAUDE.md, GEMINI.md, CURSOR.md"
      else
        echo -e "  ${YELLOW}⚠${NC}  Agent docs generation had warnings"
      fi
    fi
  fi

  # Validate structure (if validator exists)
  if [ -f "$SCRIPT_DIR/validate-structure.sh" ]; then
    echo -e "  ${BLUE}Validating structure...${NC}"
    if bash "$SCRIPT_DIR/validate-structure.sh" "$ABS_PATH" --quiet; then
      echo -e "  ${GREEN}✓${NC} Structure validation passed"
    else
      echo -e "  ${YELLOW}⚠${NC}  Structure validation warnings (see above)"
    fi
  fi

  ((SUCCESS_COUNT++))
  echo -e "  ${GREEN}✓ Completed: $PROJECT_NAME${NC}"
  echo ""
done <<< "$PROJECTS"

# Summary
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}  Summary${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "Total projects: ${BLUE}$PROJECT_COUNT${NC}"
echo -e "Successful: ${GREEN}$SUCCESS_COUNT${NC}"
if [ $ERROR_COUNT -gt 0 ]; then
  echo -e "Errors: ${RED}$ERROR_COUNT${NC}"
fi
echo ""

if [ "$DRY_RUN" = true ]; then
  echo -e "${YELLOW}⚠️  This was a dry run. Run without --dry-run to apply changes.${NC}"
fi

exit 0
