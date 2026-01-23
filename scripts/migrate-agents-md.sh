#!/bin/bash

# migrate-agents-md.sh
# Migrate existing AGENTS.md to marker-based structure

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Parse arguments
PROJECT_PATH=""
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
      PROJECT_PATH="$1"
      shift
      ;;
  esac
done

if [ -z "$PROJECT_PATH" ]; then
  echo "Usage: $0 <project_path> [--dry-run] [--force]"
  echo ""
  echo "Migrates existing AGENTS.md to marker-based structure."
  echo ""
  echo "Options:"
  echo "  --dry-run  Show what would be done without making changes"
  echo "  --force    Skip confirmation prompts"
  exit 1
fi

if [ ! -d "$PROJECT_PATH" ]; then
  echo -e "${RED}✗ Project directory not found: $PROJECT_PATH${NC}"
  exit 1
fi

AGENTS_FILE="$PROJECT_PATH/AGENTS.md"

if [ ! -f "$AGENTS_FILE" ]; then
  echo -e "${RED}✗ AGENTS.md not found in project${NC}"
  exit 1
fi

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}  AGENTS.md Migration to Marker-Based Structure${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "Project: ${BLUE}$(basename "$PROJECT_PATH")${NC}"
echo -e "File: ${BLUE}$AGENTS_FILE${NC}"
echo ""

# Check if already migrated
if grep -q "BEGIN: STANDARD POLICY" "$AGENTS_FILE" && grep -q "BEGIN: PROJECT CUSTOM" "$AGENTS_FILE"; then
  echo -e "${GREEN}✓ AGENTS.md already has marker-based structure${NC}"
  echo ""
  echo "Nothing to do."
  exit 0
fi

# Backup
BACKUP_FILE="${AGENTS_FILE}.backup.$(date +%Y%m%d%H%M%S)"

if [ "$DRY_RUN" = false ]; then
  if [ "$FORCE" = false ]; then
    echo -e "${YELLOW}⚠ This will modify AGENTS.md${NC}"
    echo -e "A backup will be created at: ${BACKUP_FILE}"
    echo ""
    read -p "Continue? (y/N) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
      echo "Aborted."
      exit 0
    fi
  fi

  cp "$AGENTS_FILE" "$BACKUP_FILE"
  echo -e "${GREEN}✓ Backup created: $BACKUP_FILE${NC}"
  echo ""
fi

# Detect llm-dev-protocol location
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LDP_ROOT="$(dirname "$SCRIPT_DIR")"
LDP_AGENTS="$LDP_ROOT/AGENTS.md"

if [ ! -f "$LDP_AGENTS" ]; then
  echo -e "${RED}✗ llm-dev-protocol AGENTS.md not found${NC}"
  echo -e "Expected at: $LDP_AGENTS"
  exit 1
fi

echo -e "${BLUE}Analyzing existing AGENTS.md...${NC}"

# Heuristic: Detect project-specific content
# Assume content after "Agent Entry Files" section is project-specific
# Or content containing specific tech stack/rules is custom

# Simple approach: Extract everything after a certain point as "custom"
# For now, we'll use a simple split strategy

SPLIT_MARKER="## Directory Structure (Mandatory)"

if grep -q "$SPLIT_MARKER" "$AGENTS_FILE"; then
  echo -e "${YELLOW}⚠ Detected standard structure marker${NC}"
  echo -e "  Using standard from llm-dev-protocol"
  echo -e "  Preserving content after standard as custom"
else
  echo -e "${YELLOW}⚠ No clear split point detected${NC}"
  echo -e "  Will use entire llm-dev-protocol standard"
  echo -e "  Original content will be backed up"
fi

# Extract standard section from llm-dev-protocol
STANDARD_START="<!-- BEGIN: STANDARD POLICY"
STANDARD_END="<!-- END: STANDARD POLICY"

STANDARD_SECTION=$(sed -n "/$STANDARD_START/,/$STANDARD_END/p" "$LDP_AGENTS")

# Try to extract custom content from existing file
# Look for project-specific sections (architecture, tech stack, etc.)
CUSTOM_SECTION=""

# Check for common project-specific sections
if grep -qi "Architecture & Stack" "$AGENTS_FILE" || \
   grep -qi "Project-Specific Rules" "$AGENTS_FILE" || \
   grep -qi "Domain-Specific" "$AGENTS_FILE"; then

  echo -e "${GREEN}✓ Detected project-specific content${NC}"

  # Extract everything after the directory structure as custom
  CUSTOM_CONTENT=$(sed -n '/## Directory Structure/,$p' "$AGENTS_FILE" | tail -n +2)

  if [ -n "$CUSTOM_CONTENT" ]; then
    CUSTOM_SECTION="<!-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ -->
<!-- BEGIN: PROJECT CUSTOM (Safe to edit in project repositories)      -->
<!-- Add project-specific configurations below this marker              -->
<!-- See: docs/llm/policies/agents-customization.md for guidelines      -->
<!-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ -->

## Project-Specific Configuration

$CUSTOM_CONTENT

<!-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ -->
<!-- END: PROJECT CUSTOM                                                -->
<!-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ -->"
  fi
else
  echo -e "${YELLOW}⚠ No project-specific content detected${NC}"
  echo -e "  Using default custom section from llm-dev-protocol"

  # Use default custom section from llm-dev-protocol
  CUSTOM_START="<!-- BEGIN: PROJECT CUSTOM"
  CUSTOM_END="<!-- END: PROJECT CUSTOM"
  CUSTOM_SECTION=$(sed -n "/$CUSTOM_START/,/$CUSTOM_END/p" "$LDP_AGENTS")
fi

# Build new file
NEW_CONTENT="${STANDARD_SECTION}

---

${CUSTOM_SECTION}"

if [ "$DRY_RUN" = true ]; then
  echo ""
  echo -e "${YELLOW}[DRY RUN] Would write:${NC}"
  echo ""
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "$NEW_CONTENT" | head -30
  echo "..."
  echo "$NEW_CONTENT" | tail -20
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
else
  echo "$NEW_CONTENT" > "$AGENTS_FILE"
  echo -e "${GREEN}✓ Migration complete${NC}"
  echo ""
  echo "Next steps:"
  echo "  1. Review $AGENTS_FILE"
  echo "  2. Edit PROJECT CUSTOM section as needed"
  echo "  3. Restore from backup if needed: $BACKUP_FILE"
fi

echo ""
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}✓ Done${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

exit 0
