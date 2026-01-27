#!/bin/bash
# Setup policy symlinks from vendor/agentic-dev-protocol to project docs
#
# Usage: Run from target project root after adding submodule
#   ./vendor/agentic-dev-protocol/scripts/setup-policy-links.sh
#
# This script creates file-level symlinks (not directory symlinks)
# to preserve project-specific documentation.

set -e

# Detect script location (vendor/agentic-dev-protocol/scripts/)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VENDOR_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# Detect project root (3 levels up from script)
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../../.." && pwd)"

# Source paths (in vendor)
VENDOR_LLM_POLICIES="$VENDOR_ROOT/docs/llm/policies"
VENDOR_EN="$VENDOR_ROOT/docs/en"

# Target paths (in project)
TARGET_LLM_POLICIES="$PROJECT_ROOT/docs/llm/policies"
TARGET_EN="$PROJECT_ROOT/docs/en"

# Policy files to symlink
POLICY_FILES="cdd.md sdd.md add.md"

# Human-readable files to symlink
EN_FILES="cdd.md sdd.md add.md"

echo "=== Policy Links Setup ==="
echo "Vendor: $VENDOR_ROOT"
echo "Project: $PROJECT_ROOT"
echo ""

# Function to create symlink
create_link() {
    local source="$1"
    local target="$2"
    local relative="$3"

    if [ ! -f "$source" ]; then
        echo "[SKIP] Source not found: $source"
        return
    fi

    # Create target directory if needed
    mkdir -p "$(dirname "$target")"

    # Remove existing file (not symlink) if exists
    if [ -f "$target" ] && [ ! -L "$target" ]; then
        echo "[WARN] Removing existing file: $target"
        rm -f "$target"
    fi

    # Create symlink if not exists
    if [ ! -L "$target" ]; then
        ln -sf "$relative" "$target"
        echo "[OK] $target -> $relative"
    else
        echo "[EXISTS] $target"
    fi
}

# Create docs/llm/policies symlinks
echo "--- docs/llm/policies ---"
for file in $POLICY_FILES; do
    create_link \
        "$VENDOR_LLM_POLICIES/$file" \
        "$TARGET_LLM_POLICIES/$file" \
        "../../../vendor/agentic-dev-protocol/docs/llm/policies/$file"
done

echo ""

# Create docs/en symlinks
echo "--- docs/en ---"
for file in $EN_FILES; do
    create_link \
        "$VENDOR_EN/$file" \
        "$TARGET_EN/$file" \
        "../../vendor/agentic-dev-protocol/docs/en/$file"
done

echo ""
echo "=== Setup Complete ==="
echo ""
echo "Next steps:"
echo "1. git add docs/"
echo "2. git commit -m 'chore: Setup policy symlinks'"
echo "3. Configure renovate.json for auto-updates"
