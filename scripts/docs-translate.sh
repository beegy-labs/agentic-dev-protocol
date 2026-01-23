#!/bin/bash

# docs-translate.sh
# Translate Tier 3 (docs/en/) to Tier 4 (docs/kr/, docs/ja/, etc.)
# Part of llm-dev-protocol standard

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Default values
PROVIDER="auto"
MODEL=""
LOCALE="kr"  # kr, ja, zh, es, fr, de
FILE=""
FORCE=false
RETRY_FAILED=false
CLEAN=false

# Paths
SOURCE_DIR="docs/en"
FAILED_FILES=".docs-translate-failed.json"

# Locale names
declare -A LOCALE_NAMES=(
  [kr]="Korean"
  [ja]="Japanese"
  [zh]="Chinese (Simplified)"
  [es]="Spanish"
  [fr]="French"
  [de]="German"
)

# Parse arguments
while [[ $# -gt 0 ]]; do
  case $1 in
    -l|--locale)
      LOCALE="$2"
      shift 2
      ;;
    -p|--provider)
      PROVIDER="$2"
      shift 2
      ;;
    -m|--model)
      MODEL="$2"
      shift 2
      ;;
    -f|--file)
      FILE="$2"
      shift 2
      ;;
    --force)
      FORCE=true
      shift
      ;;
    --retry-failed)
      RETRY_FAILED=true
      shift
      ;;
    --clean)
      CLEAN=true
      shift
      ;;
    -h|--help)
      cat << EOF
Documentation Translation (CDD Tier 3 → Tier 4)

Translate human-readable documentation (docs/en/) to target language

Usage:
  $0 [options]

Options:
  -l, --locale <code>    Target locale: kr, ja, zh, es, fr, de (default: kr)
  -p, --provider <name>  LLM provider: auto, local, claude, gemini, openai
                         (default: auto - auto-detect available provider)
  -m, --model <name>     Model name (optional, provider default if not specified)
  -f, --file <path>      Translate specific file only (relative to docs/en/)
  --force                Retranslate even if target exists and is newer
  --retry-failed         Retry only files that failed in previous run
  --clean                Clear failed history and restart all files
  -h, --help             Show this help

Supported Locales:
  kr - Korean (한국어)
  ja - Japanese (日本語)
  zh - Chinese Simplified (简体中文)
  es - Spanish (Español)
  fr - French (Français)
  de - German (Deutsch)

Provider Auto-Detection:
  1. Check for local LLM (Ollama, vLLM, LM Studio)
  2. If not found, use Claude CLI
  3. If not found, use Gemini CLI
  4. If not found, error

Examples:
  $0 --locale kr                      # Translate to Korean
  $0 --locale ja --provider claude    # Translate to Japanese with Claude
  $0 --locale zh --file README.md     # Translate specific file to Chinese
  $0 --locale kr --retry-failed       # Retry failed Korean translations
  $0 --locale kr --clean              # Clean and retranslate all to Korean

EOF
      exit 0
      ;;
    *)
      echo "Unknown option: $1"
      echo "Use -h or --help for usage information"
      exit 1
      ;;
  esac
done

TARGET_DIR="docs/$LOCALE"
LOCALE_NAME="${LOCALE_NAMES[$LOCALE]}"

if [ -z "$LOCALE_NAME" ]; then
  echo -e "${RED}✗ Unsupported locale: $LOCALE${NC}"
  echo "Supported locales: ${!LOCALE_NAMES[@]}"
  exit 1
fi

# Detect available LLM provider
detect_provider() {
  echo -e "${BLUE}Detecting available LLM provider...${NC}"

  # Check local LLM
  if command -v ollama &> /dev/null && ollama list &> /dev/null; then
    echo "local"
    return
  fi

  if curl -s http://localhost:11434/api/tags &> /dev/null; then
    echo "local"
    return
  fi

  # Check vLLM
  if curl -s http://localhost:8000/v1/models &> /dev/null; then
    echo "local"
    return
  fi

  # Check LM Studio
  if curl -s http://localhost:1234/v1/models &> /dev/null; then
    echo "local"
    return
  fi

  # Check Claude CLI
  if command -v claude &> /dev/null; then
    echo "claude"
    return
  fi

  # Check Gemini CLI
  if command -v gemini &> /dev/null || command -v aistudio &> /dev/null; then
    echo "gemini"
    return
  fi

  # Check OpenAI CLI
  if command -v openai &> /dev/null && [ -n "$OPENAI_API_KEY" ]; then
    echo "openai"
    return
  fi

  echo "none"
}

# Get default model for provider
get_default_model() {
  local provider=$1

  case $provider in
    local)
      if command -v ollama &> /dev/null; then
        if ollama list | grep -q "qwen2.5:32b"; then
          echo "qwen2.5:32b"
        elif ollama list | grep -q "qwen2.5:14b"; then
          echo "qwen2.5:14b"
        else
          ollama list | awk 'NR==2 {print $1}'
        fi
      else
        echo "local-default"
      fi
      ;;
    claude)
      echo "claude-3-5-sonnet-20241022"
      ;;
    gemini)
      echo "gemini-2.0-flash-exp"
      ;;
    openai)
      echo "gpt-4o"
      ;;
    *)
      echo "unknown"
      ;;
  esac
}

# Translate using local LLM
translate_local() {
  local source=$1
  local target=$2
  local model=$3
  local locale_name=$4

  local content=$(cat "$source")
  local prompt=$(cat << EOF
You are a professional translator.

Translate the following English documentation to $locale_name.

**Guidelines**:
1. Maintain markdown formatting exactly
2. Translate content naturally and professionally
3. Keep code blocks, URLs, and technical terms in English
4. Keep proper nouns (product names, company names) in English
5. Preserve all links and references
6. Don't add or remove information

**Source Document (English)**:
$content

**Output**: The translated document in $locale_name in markdown format.
EOF
)

  # Try Ollama first
  if command -v ollama &> /dev/null; then
    echo "$prompt" | ollama run "$model" > "$target" 2>/dev/null
    return $?
  fi

  # Try vLLM
  if curl -s http://localhost:8000/v1/models &> /dev/null; then
    curl -s -X POST http://localhost:8000/v1/completions \
      -H "Content-Type: application/json" \
      -d "{\"model\":\"$model\",\"prompt\":\"$prompt\",\"max_tokens\":16384,\"temperature\":0.3}" \
      | jq -r '.choices[0].text' > "$target"
    return $?
  fi

  # Try LM Studio
  if curl -s http://localhost:1234/v1/models &> /dev/null; then
    curl -s -X POST http://localhost:1234/v1/completions \
      -H "Content-Type: application/json" \
      -d "{\"model\":\"$model\",\"prompt\":\"$prompt\",\"max_tokens\":16384,\"temperature\":0.3}" \
      | jq -r '.choices[0].text' > "$target"
    return $?
  fi

  return 1
}

# Translate using Claude CLI
translate_claude() {
  local source=$1
  local target=$2
  local locale_name=$3

  local prompt="Translate this English documentation to $locale_name. Maintain markdown formatting, keep code blocks and technical terms in English, translate content naturally and professionally."

  cat "$source" | claude --prompt "$prompt" > "$target" 2>/dev/null
  return $?
}

# Translate using Gemini CLI
translate_gemini() {
  local source=$1
  local target=$2
  local locale_name=$3

  local gemini_cmd=$(command -v gemini || command -v aistudio)
  local prompt="Translate this English documentation to $locale_name. Maintain markdown formatting, keep code blocks and technical terms in English, translate content naturally and professionally."

  cat "$source" | $gemini_cmd "$prompt" > "$target" 2>/dev/null
  return $?
}

# Translate using OpenAI CLI
translate_openai() {
  local source=$1
  local target=$2
  local model=$3
  local locale_name=$4

  local content=$(cat "$source")
  local prompt="Translate this English documentation to $locale_name. Maintain markdown formatting, keep code blocks and technical terms in English, translate content naturally and professionally.

$content"

  openai api completions.create \
    -m "$model" \
    -p "$prompt" \
    -t 0.3 \
    -M 16384 > "$target" 2>/dev/null
  return $?
}

# Main translation function
translate_file() {
  local source=$1
  local target=$2
  local provider=$3
  local model=$4
  local locale_name=$5

  local rel_path="${source#$SOURCE_DIR/}"

  echo -n "  Translating: $rel_path ... "

  # Create target directory
  mkdir -p "$(dirname "$target")"

  # Translate based on provider
  case $provider in
    local)
      if translate_local "$source" "$target" "$model" "$locale_name"; then
        echo -e "${GREEN}✓${NC}"
        return 0
      else
        echo -e "${RED}✗${NC}"
        return 1
      fi
      ;;
    claude)
      if translate_claude "$source" "$target" "$locale_name"; then
        echo -e "${GREEN}✓${NC}"
        return 0
      else
        echo -e "${RED}✗${NC}"
        return 1
      fi
      ;;
    gemini)
      if translate_gemini "$source" "$target" "$locale_name"; then
        echo -e "${GREEN}✓${NC}"
        return 0
      else
        echo -e "${RED}✗${NC}"
        return 1
      fi
      ;;
    openai)
      if translate_openai "$source" "$target" "$model" "$locale_name"; then
        echo -e "${GREEN}✓${NC}"
        return 0
      else
        echo -e "${RED}✗${NC}"
        return 1
      fi
      ;;
    *)
      echo -e "${RED}Unknown provider${NC}"
      return 1
      ;;
  esac
}

# Main execution
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}  CDD Documentation Translation (Tier 3 → Tier 4)${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# Check source directory
if [ ! -d "$SOURCE_DIR" ]; then
  echo -e "${RED}✗ Source directory not found: $SOURCE_DIR${NC}"
  echo -e "${YELLOW}Run docs-generate.sh first to generate Tier 3 (docs/en/)${NC}"
  exit 1
fi

# Auto-detect provider if set to auto
if [ "$PROVIDER" = "auto" ]; then
  PROVIDER=$(detect_provider)
  if [ "$PROVIDER" = "none" ]; then
    echo -e "${RED}✗ No LLM provider found${NC}"
    echo "Please install one of: Ollama, Claude CLI, Gemini CLI, or OpenAI CLI"
    exit 1
  fi
fi

echo -e "Target Locale: ${GREEN}$LOCALE_NAME ($LOCALE)${NC}"
echo -e "Provider: ${GREEN}$PROVIDER${NC}"

# Get model
if [ -z "$MODEL" ]; then
  MODEL=$(get_default_model "$PROVIDER")
fi

if [ -n "$MODEL" ] && [ "$MODEL" != "unknown" ]; then
  echo -e "Model: ${GREEN}$MODEL${NC}"
fi

echo ""

# Clean failed files if requested
if [ "$CLEAN" = true ] && [ -f "$FAILED_FILES" ]; then
  rm "$FAILED_FILES"
  echo -e "${YELLOW}🧹 Cleared failed files history${NC}"
  echo ""
fi

# Translate files
SUCCESS=0
FAILED=0

if [ -n "$FILE" ]; then
  # Single file
  SOURCE_FILE="$SOURCE_DIR/$FILE"
  TARGET_FILE="$TARGET_DIR/$FILE"

  if [ ! -f "$SOURCE_FILE" ]; then
    echo -e "${RED}✗ Source file not found: $SOURCE_FILE${NC}"
    exit 1
  fi

  if translate_file "$SOURCE_FILE" "$TARGET_FILE" "$PROVIDER" "$MODEL" "$LOCALE_NAME"; then
    ((SUCCESS++))
  else
    ((FAILED++))
  fi
else
  # All files
  while IFS= read -r source; do
    rel_path="${source#$SOURCE_DIR/}"
    target="$TARGET_DIR/$rel_path"

    # Skip if not forced and target is newer
    if [ "$FORCE" = false ] && [ -f "$target" ] && [ "$target" -nt "$source" ]; then
      echo "  Skipping: $rel_path (up to date)"
      continue
    fi

    if translate_file "$source" "$target" "$PROVIDER" "$MODEL" "$LOCALE_NAME"; then
      ((SUCCESS++))
    else
      ((FAILED++))
    fi
  done < <(find "$SOURCE_DIR" -type f -name "*.md")
fi

# Summary
echo ""
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}  Summary${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "Success: ${GREEN}$SUCCESS${NC}"
echo -e "Failed: ${RED}$FAILED${NC}"
echo ""

if [ $FAILED -gt 0 ]; then
  echo -e "${YELLOW}To retry failed files: $0 --locale $LOCALE --retry-failed${NC}"
  exit 1
fi

echo -e "${GREEN}✓ Translation complete${NC}"
exit 0
