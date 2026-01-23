#!/bin/bash

# Sync llm-dev-protocol standards to my-girok
# Usage: ./scripts/sync-to-my-girok.sh

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROTOCOL_DIR="$(dirname "$SCRIPT_DIR")"
MY_GIROK_DIR="${MY_GIROK_DIR:-../my-girok}"

echo "======================================"
echo "llm-dev-protocol → my-girok Sync"
echo "======================================"
echo ""

# Check if my-girok directory exists
if [ ! -d "$MY_GIROK_DIR" ]; then
    echo "❌ my-girok directory not found: $MY_GIROK_DIR"
    echo "Set MY_GIROK_DIR environment variable or ensure my-girok is at ../my-girok"
    exit 1
fi

echo "📁 Protocol dir: $PROTOCOL_DIR"
echo "📁 my-girok dir: $MY_GIROK_DIR"
echo ""

# Function to sync AGENTS.md with marker-based approach
sync_agents_md() {
    echo "🔄 Syncing AGENTS.md..."

    local source="$PROTOCOL_DIR/AGENTS.md"
    local target="$MY_GIROK_DIR/AGENTS.md"

    if [ ! -f "$source" ]; then
        echo "❌ Source AGENTS.md not found"
        return 1
    fi

    # Extract STANDARD POLICY section
    sed -n '/<!-- BEGIN: STANDARD POLICY -->/,/<!-- END: STANDARD POLICY -->/p' "$source" > /tmp/standard_section.md

    if [ -f "$target" ]; then
        echo "   Updating existing AGENTS.md..."

        # Keep everything before BEGIN marker
        sed -n '1,/<!-- BEGIN: STANDARD POLICY -->/p' "$target" > /tmp/agents_new.md

        # Add new standard section
        cat /tmp/standard_section.md >> /tmp/agents_new.md

        # Add everything after END marker
        sed -n '/<!-- END: STANDARD POLICY -->/,$p' "$target" | tail -n +2 >> /tmp/agents_new.md

        mv /tmp/agents_new.md "$target"
        echo "   ✅ AGENTS.md updated"
    else
        echo "   Creating new AGENTS.md..."
        cp "$source" "$target"
        echo "   ✅ AGENTS.md created"
    fi
}

# Function to sync policy files
sync_policies() {
    echo "🔄 Syncing policy files..."

    mkdir -p "$MY_GIROK_DIR/docs/llm/policies"

    for policy in cdd sdd add; do
        local source="$PROTOCOL_DIR/standards/${policy}/README.md"
        local target="$MY_GIROK_DIR/docs/llm/policies/${policy}.md"

        if [ -f "$source" ]; then
            if [ ! -f "$target" ]; then
                echo "   Creating ${policy}.md..."
                cp "$source" "$target"
                echo "   ✅ ${policy}.md created"
            else
                echo "   ⏭️  ${policy}.md exists (skipping)"
            fi
        fi
    done
}

# Function to validate structure
validate_structure() {
    echo "🔍 Validating my-girok structure..."

    local errors=0

    # Check CDD
    if [ ! -d "$MY_GIROK_DIR/.ai" ]; then
        echo "   ❌ .ai/ directory missing"
        ((errors++))
    fi

    if [ ! -d "$MY_GIROK_DIR/docs/llm" ]; then
        echo "   ❌ docs/llm/ directory missing"
        ((errors++))
    fi

    # Check SDD
    if [ ! -d "$MY_GIROK_DIR/.specs" ]; then
        echo "   ❌ .specs/ directory missing"
        ((errors++))
    fi

    if [ $errors -eq 0 ]; then
        echo "   ✅ Structure validation passed"
        return 0
    else
        echo "   ❌ $errors validation errors"
        return 1
    fi
}

# Main execution
main() {
    sync_agents_md
    echo ""

    sync_policies
    echo ""

    validate_structure
    echo ""

    echo "======================================"
    echo "✅ Sync completed successfully!"
    echo "======================================"
    echo ""
    echo "Next steps:"
    echo "1. cd $MY_GIROK_DIR"
    echo "2. git diff (review changes)"
    echo "3. git add AGENTS.md docs/llm/policies/"
    echo "4. git commit -m 'sync: Update from llm-dev-protocol'"
    echo "5. git push"
}

main
