#!/bin/bash

# validate-structure.sh
# Validate project structure against llm-dev-protocol standards

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Parse arguments
QUIET=false
PROJECT_PATH=""

while [[ $# -gt 0 ]]; do
  case $1 in
    --quiet)
      QUIET=true
      shift
      ;;
    *)
      PROJECT_PATH="$1"
      shift
      ;;
  esac
done

if [ -z "$PROJECT_PATH" ]; then
  echo "Usage: $0 <project_path> [--quiet]"
  exit 1
fi

if [ ! -d "$PROJECT_PATH" ]; then
  echo -e "${RED}✗ Project directory not found: $PROJECT_PATH${NC}"
  exit 1
fi

# Validation counters
ERRORS=0
WARNINGS=0
SUCCESS=0

log_error() {
  ((ERRORS++))
  if [ "$QUIET" = false ]; then
    echo -e "${RED}✗ ERROR: $1${NC}"
  fi
}

log_warning() {
  ((WARNINGS++))
  if [ "$QUIET" = false ]; then
    echo -e "${YELLOW}⚠ WARNING: $1${NC}"
  fi
}

log_success() {
  ((SUCCESS++))
  if [ "$QUIET" = false ]; then
    echo -e "${GREEN}✓ $1${NC}"
  fi
}

# Mandatory files (CDD/SDD/ADD standards only)
MANDATORY_FILES=(
  "AGENTS.md"
  "docs/llm/policies/development-methodology.md"
  "docs/llm/policies/cdd.md"
  "docs/llm/policies/sdd.md"
  "docs/llm/policies/add.md"
)

# Mandatory directories (CDD/SDD structure only)
MANDATORY_DIRS=(
  ".ai"
  ".specs"
  "docs/llm"
  "docs/llm/policies"
)

# CDD scripts (LLM document generation standards)
MANDATORY_SCRIPTS=(
  "scripts/docs-generate.sh"
  "scripts/docs-translate.sh"
)

if [ "$QUIET" = false ]; then
  echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  echo -e "${BLUE}  Validating: $(basename "$PROJECT_PATH")${NC}"
  echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  echo ""
fi

# Check mandatory directories
if [ "$QUIET" = false ]; then
  echo -e "${BLUE}Checking mandatory directories...${NC}"
fi

for dir in "${MANDATORY_DIRS[@]}"; do
  if [ -d "$PROJECT_PATH/$dir" ]; then
    log_success "Directory exists: $dir"
  else
    log_error "Missing mandatory directory: $dir"
  fi
done

echo ""

# Check mandatory files
if [ "$QUIET" = false ]; then
  echo -e "${BLUE}Checking mandatory files...${NC}"
fi

for file in "${MANDATORY_FILES[@]}"; do
  if [ -f "$PROJECT_PATH/$file" ]; then
    log_success "File exists: $file"
  else
    log_error "Missing mandatory file: $file"
  fi
done

echo ""

# Check CDD scripts (mandatory for LLM document generation)
if [ "$QUIET" = false ]; then
  echo -e "${BLUE}Checking CDD scripts...${NC}"
fi

for script in "${MANDATORY_SCRIPTS[@]}"; do
  if [ -f "$PROJECT_PATH/$script" ]; then
    if [ -x "$PROJECT_PATH/$script" ]; then
      log_success "Script exists and executable: $script"
    else
      log_warning "Script exists but not executable: $script"
    fi
  else
    log_error "Missing CDD script: $script"
  fi
done

echo ""

# Check file line limits (Tier 1: .ai/)
if [ "$QUIET" = false ]; then
  echo -e "${BLUE}Checking Tier 1 (.ai/) line limits (≤50 lines)...${NC}"
fi

if [ -d "$PROJECT_PATH/.ai" ]; then
  while IFS= read -r file; do
    LINE_COUNT=$(wc -l < "$file")
    RELATIVE_PATH="${file#$PROJECT_PATH/}"

    if [ "$LINE_COUNT" -le 50 ]; then
      log_success "$RELATIVE_PATH ($LINE_COUNT lines)"
    elif [ "$LINE_COUNT" -le 60 ]; then
      log_warning "$RELATIVE_PATH ($LINE_COUNT lines) exceeds limit by $((LINE_COUNT - 50))"
    else
      log_error "$RELATIVE_PATH ($LINE_COUNT lines) significantly exceeds 50-line limit"
    fi
  done < <(find "$PROJECT_PATH/.ai" -type f -name "*.md" ! -name "README.md")
fi

echo ""

# Check file line limits (Tier 2: docs/llm/ - excluding framework docs)
if [ "$QUIET" = false ]; then
  echo -e "${BLUE}Checking Tier 2 (docs/llm/) line limits...${NC}"
fi

# Framework documents (exempt from limits)
FRAMEWORK_DOCS=(
  "docs/llm/policies/cdd.md"
  "docs/llm/policies/sdd.md"
  "docs/llm/policies/add.md"
  "docs/llm/policies/development-methodology.md"
)

if [ -d "$PROJECT_PATH/docs/llm" ]; then
  while IFS= read -r file; do
    RELATIVE_PATH="${file#$PROJECT_PATH/}"
    LINE_COUNT=$(wc -l < "$file")

    # Skip framework documents
    IS_FRAMEWORK=false
    for framework_doc in "${FRAMEWORK_DOCS[@]}"; do
      if [ "$RELATIVE_PATH" = "$framework_doc" ]; then
        IS_FRAMEWORK=true
        break
      fi
    done

    if [ "$IS_FRAMEWORK" = true ]; then
      log_success "$RELATIVE_PATH ($LINE_COUNT lines) [FRAMEWORK - EXEMPT]"
      continue
    fi

    # Determine limit based on directory
    LIMIT=200
    if [[ "$RELATIVE_PATH" == *"/guides/"* ]] || [[ "$RELATIVE_PATH" == *"/apps/"* ]] || [[ "$RELATIVE_PATH" == *"/packages/"* ]]; then
      LIMIT=150
    elif [[ "$RELATIVE_PATH" == *"/components/"* ]] || [[ "$RELATIVE_PATH" == *"/templates/"* ]] || [[ "$RELATIVE_PATH" == *"/features/"* ]]; then
      LIMIT=100
    elif [[ "$RELATIVE_PATH" == *"/references/"* ]]; then
      LIMIT=300
    fi

    if [ "$LINE_COUNT" -le "$LIMIT" ]; then
      log_success "$RELATIVE_PATH ($LINE_COUNT/$LIMIT lines)"
    elif [ "$LINE_COUNT" -le $((LIMIT + 10)) ]; then
      log_warning "$RELATIVE_PATH ($LINE_COUNT/$LIMIT lines) within tolerance"
    else
      log_error "$RELATIVE_PATH ($LINE_COUNT/$LIMIT lines) exceeds limit, consider splitting"
    fi
  done < <(find "$PROJECT_PATH/docs/llm" -type f -name "*.md" ! -name "README.md")
fi

echo ""

# Summary
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}  Validation Summary${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "Success: ${GREEN}$SUCCESS${NC}"
echo -e "Warnings: ${YELLOW}$WARNINGS${NC}"
echo -e "Errors: ${RED}$ERRORS${NC}"
echo ""

if [ $ERRORS -gt 0 ]; then
  echo -e "${RED}✗ Validation failed with $ERRORS error(s)${NC}"
  exit 1
elif [ $WARNINGS -gt 0 ]; then
  echo -e "${YELLOW}⚠ Validation passed with $WARNINGS warning(s)${NC}"
  exit 0
else
  echo -e "${GREEN}✓ Validation passed${NC}"
  exit 0
fi
