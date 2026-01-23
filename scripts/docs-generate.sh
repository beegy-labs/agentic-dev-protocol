#!/bin/bash

# docs-generate.sh
# Generate Tier 3 (docs/en/) from Tier 2 (docs/llm/)
# Part of llm-dev-protocol standard

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Default values
PROVIDER="auto"  # auto, local, claude, gemini, openai
MODEL=""
FILE=""
FORCE=false
RETRY_FAILED=false
CLEAN=false

# Paths
SOURCE_DIR="docs/llm"
TARGET_DIR="docs/en"
FAILED_FILES=".docs-generate-failed.json"

# Parse arguments
while [[ $# -gt 0 ]]; do
  case $1 in
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
Documentation Generation (CDD Tier 2 → Tier 3)

Converts SSOT (docs/llm/) to human-readable documentation (docs/en/)

Usage:
  $0 [options]

Options:
  -p, --provider <name>  LLM provider: auto, local, claude, gemini, openai
                         (default: auto - auto-detect available provider)
  -m, --model <name>     Model name (optional, provider default if not specified)
  -f, --file <path>      Generate specific file only (relative to docs/llm/)
  --force                Regenerate even if target exists and is newer
  --retry-failed         Retry only files that failed in previous run
  --clean                Clear failed history and restart all files
  -h, --help             Show this help

Provider Auto-Detection:
  1. Check for local LLM (Ollama, vLLM, LM Studio)
  2. If not found, use Claude CLI
  3. If not found, use Gemini CLI
  4. If not found, error

Examples:
  $0                              # Auto-detect provider
  $0 --provider local             # Force local LLM
  $0 --provider claude            # Use Claude CLI
  $0 --provider gemini            # Use Gemini CLI
  $0 --file policies/security.md  # Generate specific file
  $0 --retry-failed               # Retry failed files
  $0 --clean                      # Clean and regenerate all

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
      # Check Ollama models
      if command -v ollama &> /dev/null; then
        # Prefer larger models for documentation
        if ollama list | grep -q "qwen2.5:32b"; then
          echo "qwen2.5:32b"
        elif ollama list | grep -q "qwen2.5:14b"; then
          echo "qwen2.5:14b"
        elif ollama list | grep -q "llama3.1:8b"; then
          echo "llama3.1:8b"
        else
          # Return first available model
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

# Generate using local LLM (Ollama/vLLM/LM Studio)
generate_local() {
  local source=$1
  local target=$2
  local model=$3

  local content=$(cat "$source")
  local prompt=$(cat << EOF
You are a technical documentation generator.

Convert the following SSOT (Single Source of Truth) documentation from docs/llm/ to human-readable documentation for docs/en/.

**Guidelines**:
1. Convert technical tables and YAML to prose and examples
2. Add concrete examples where helpful
3. Maintain accuracy - don't add information not in source
4. Use clear, professional English
5. Keep markdown formatting
6. Add code examples where appropriate

**Source Document**:
$content

**Output**: Generate the human-readable version in markdown format.
EOF
)

  # Try Ollama first
  if command -v ollama &> /dev/null; then
    echo "$prompt" | ollama run "$model" > "$target" 2>/dev/null
    return $?
  fi

  # Try vLLM (OpenAI-compatible API)
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

# Generate using Claude CLI
generate_claude() {
  local source=$1
  local target=$2

  local prompt="Convert this SSOT documentation to human-readable English documentation. Add examples, use prose instead of tables where appropriate, maintain accuracy."

  cat "$source" | claude --prompt "$prompt" > "$target" 2>/dev/null
  return $?
}

# Generate using Gemini CLI
generate_gemini() {
  local source=$1
  local target=$2

  local gemini_cmd=$(command -v gemini || command -v aistudio)
  local prompt="Convert this SSOT documentation to human-readable English documentation. Add examples, use prose instead of tables where appropriate, maintain accuracy."

  cat "$source" | $gemini_cmd "$prompt" > "$target" 2>/dev/null
  return $?
}

# Generate using OpenAI CLI
generate_openai() {
  local source=$1
  local target=$2
  local model=$3

  local content=$(cat "$source")
  local prompt="Convert this SSOT documentation to human-readable English documentation. Add examples, use prose instead of tables where appropriate, maintain accuracy.

$content"

  openai api completions.create \
    -m "$model" \
    -p "$prompt" \
    -t 0.3 \
    -M 16384 > "$target" 2>/dev/null
  return $?
}

# Main generation function
generate_file() {
  local source=$1
  local target=$2
  local provider=$3
  local model=$4

  local rel_path="${source#$SOURCE_DIR/}"

  echo -n "  Generating: $rel_path ... "

  # Create target directory
  mkdir -p "$(dirname "$target")"

  # Generate based on provider
  case $provider in
    local)
      if generate_local "$source" "$target" "$model"; then
        echo -e "${GREEN}✓${NC}"
        return 0
      else
        echo -e "${RED}✗${NC}"
        return 1
      fi
      ;;
    claude)
      if generate_claude "$source" "$target"; then
        echo -e "${GREEN}✓${NC}"
        return 0
      else
        echo -e "${RED}✗${NC}"
        return 1
      fi
      ;;
    gemini)
      if generate_gemini "$source" "$target"; then
        echo -e "${GREEN}✓${NC}"
        return 0
      else
        echo -e "${RED}✗${NC}"
        return 1
      fi
      ;;
    openai)
      if generate_openai "$source" "$target" "$model"; then
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
echo -e "${BLUE}  CDD Documentation Generation (Tier 2 → Tier 3)${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# Check source directory
if [ ! -d "$SOURCE_DIR" ]; then
  echo -e "${RED}✗ Source directory not found: $SOURCE_DIR${NC}"
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

# Generate files
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

  if generate_file "$SOURCE_FILE" "$TARGET_FILE" "$PROVIDER" "$MODEL"; then
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

    if generate_file "$source" "$target" "$PROVIDER" "$MODEL"; then
      ((SUCCESS++))
    else
      ((FAILED++))
    fi
  done < <(find "$SOURCE_DIR" -type f -name "*.md" ! -name "README.md")
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
  echo -e "${YELLOW}To retry failed files: $0 --retry-failed${NC}"
  exit 1
fi

echo -e "${GREEN}✓ Documentation generation complete${NC}"
exit 0
