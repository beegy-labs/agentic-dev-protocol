#!/bin/bash

# sync-agents-md.sh
# Smart sync for AGENTS.md with marker-based section preservation

set -e

# Usage: sync_agents_md <source_file> <target_file>
sync_agents_md() {
  local SOURCE="$1"
  local TARGET="$2"

  if [ ! -f "$SOURCE" ]; then
    echo "ERROR: Source file not found: $SOURCE"
    return 1
  fi

  if [ ! -f "$TARGET" ]; then
    echo "INFO: Target file doesn't exist, copying entire source"
    cp "$SOURCE" "$TARGET"
    return 0
  fi

  # Extract standard section from source
  local STANDARD_START="<!-- BEGIN: STANDARD POLICY"
  local STANDARD_END="<!-- END: STANDARD POLICY"
  local CUSTOM_START="<!-- BEGIN: PROJECT CUSTOM"
  local CUSTOM_END="<!-- END: PROJECT CUSTOM"

  # Check if target has markers
  if ! grep -q "$STANDARD_START" "$TARGET"; then
    echo "WARNING: Target has no markers, backup and replace entirely"
    cp "$TARGET" "${TARGET}.backup.$(date +%Y%m%d%H%M%S)"
    cp "$SOURCE" "$TARGET"
    return 0
  fi

  # Extract custom section from target (preserve project-specific content)
  local CUSTOM_SECTION=""
  if grep -q "$CUSTOM_START" "$TARGET"; then
    CUSTOM_SECTION=$(sed -n "/$CUSTOM_START/,/$CUSTOM_END/p" "$TARGET")
  fi

  # Extract standard section from source
  local STANDARD_SECTION=$(sed -n "/$STANDARD_START/,/$STANDARD_END/p" "$SOURCE")

  # Build new file
  {
    # Standard section from source
    echo "$STANDARD_SECTION"
    echo ""
    echo "---"
    echo ""

    # Custom section from target (or default from source if none exists)
    if [ -n "$CUSTOM_SECTION" ]; then
      echo "$CUSTOM_SECTION"
    else
      # Use default custom section from source
      sed -n "/$CUSTOM_START/,/$CUSTOM_END/p" "$SOURCE"
    fi
  } > "${TARGET}.tmp"

  # Replace target with merged content
  mv "${TARGET}.tmp" "$TARGET"

  return 0
}

# Export function for use in other scripts
export -f sync_agents_md

# If called directly (not sourced)
if [ "${BASH_SOURCE[0]}" = "${0}" ]; then
  if [ $# -ne 2 ]; then
    echo "Usage: $0 <source_agents.md> <target_agents.md>"
    exit 1
  fi

  sync_agents_md "$1" "$2"
fi
