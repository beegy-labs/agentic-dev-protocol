# llm-dev-protocol Architecture

> Technical design for multi-project standard enforcement

## Overview

`llm-dev-protocol` is a **centralized standard repository** that enforces consistent LLM development methodology across multiple projects through automated synchronization.

## Core Concept

```
llm-dev-protocol (SSOT)
    │
    ├─► Sync ─► Project A (AGENTS.md: Standard + Custom A)
    │
    ├─► Sync ─► Project B (AGENTS.md: Standard + Custom B)
    │
    └─► Sync ─► Project C (AGENTS.md: Standard + Custom C)
```

**Key Insight**:
- **Standard Policy** (common): Synced from llm-dev-protocol
- **Custom Configuration** (unique): Preserved in each project

## Marker-Based Section Isolation

### File Structure

```markdown
AGENTS.md:
┌─────────────────────────────────────────┐
│ <!-- BEGIN: STANDARD POLICY -->         │
│                                         │
│   ... synced from llm-dev-protocol ...  │
│   ... read-only in projects ...         │
│                                         │
│ <!-- END: STANDARD POLICY -->           │
├─────────────────────────────────────────┤
│ <!-- BEGIN: PROJECT CUSTOM -->          │
│                                         │
│   ... project-specific content ...      │
│   ... safe to edit ...                  │
│                                         │
│ <!-- END: PROJECT CUSTOM -->            │
└─────────────────────────────────────────┘
```

### Sync Behavior

```python
def sync_agents_md(source, target):
    # Extract sections using markers
    standard_new = extract_between(source, "BEGIN: STANDARD POLICY", "END: STANDARD POLICY")
    custom_existing = extract_between(target, "BEGIN: PROJECT CUSTOM", "END: PROJECT CUSTOM")

    # Merge: new standard + existing custom
    merged = standard_new + "\n---\n" + custom_existing

    # Write to target
    write(target, merged)
```

**Result**:
- Standard updates propagate to all projects
- Each project's customizations remain intact
- Zero manual merge conflicts

## Directory Structure

```
llm-dev-protocol/
│
├── AGENTS.md                          # Standard policy (with markers)
├── CLAUDE.md.template                 # Agent-specific template
├── GEMINI.md.template                 # Agent-specific template
│
├── .ai/                               # CDD Tier 1
│   └── README.md                      # Navigation
│
├── docs/
│   ├── llm/                           # CDD Tier 2 (SSOT)
│   │   ├── policies/
│   │   │   ├── development-methodology.md  # Core methodology
│   │   │   ├── cdd.md                      # Context-Driven Dev
│   │   │   ├── sdd.md                      # Spec-Driven Dev
│   │   │   ├── add.md                      # Agent-Driven Dev
│   │   │   └── agents-customization.md     # Customization guide
│   │   └── README.md
│   ├── en/                            # CDD Tier 3 (auto-generated)
│   └── kr/                            # CDD Tier 4 (auto-translated)
│
├── .specs/                            # SDD structure
│   └── README.md
│
├── .github/workflows/
│   └── propagate-to-projects.yml      # CI/CD automation
│
├── scripts/
│   ├── sync-standards.sh              # Main sync orchestrator
│   ├── sync-agents-md.sh              # Marker-based AGENTS.md sync
│   ├── migrate-agents-md.sh           # Migrate existing to markers
│   └── validate-structure.sh          # Structure validation
│
├── projects.json                      # Project registry
├── README.md                          # Project overview
├── QUICKSTART.md                      # Getting started
├── ARCHITECTURE.md                    # This file
└── LICENSE                            # MIT License
```

## Component Architecture

### 1. Standard Repository (llm-dev-protocol)

**Role**: Single Source of Truth (SSOT) for development methodology

**Contents**:
- `AGENTS.md`: Multi-LLM standard policy
- `docs/llm/policies/*.md`: Methodology definitions (CDD, SDD, ADD)
- Templates for agent-specific files
- Sync and validation scripts

**Update Flow**:
```
Developer updates standard
    ↓
Commit to llm-dev-protocol
    ↓
CI/CD triggers
    ↓
Sync to all registered projects
```

### 2. Project Repositories

**Role**: Consume standards + add project-specific customizations

**Contents**:
- `AGENTS.md`: Standard (synced) + Custom (local)
- `CLAUDE.md`, `GEMINI.md`: Agent-specific (local)
- `.ai/`, `docs/llm/`, `.specs/`: Project-specific content

**Update Flow**:
```
llm-dev-protocol updates
    ↓
sync-standards.sh runs
    ↓
STANDARD POLICY section replaced
    ↓
PROJECT CUSTOM section preserved
    ↓
Project gets new standards, keeps customizations
```

### 3. Sync System

**Components**:

| Script | Purpose | Marker-Aware |
| ------ | ------- | ------------ |
| `sync-standards.sh` | Main orchestrator, syncs to all projects | Yes |
| `sync-agents-md.sh` | AGENTS.md marker-based merge | Yes |
| `migrate-agents-md.sh` | Convert existing AGENTS.md to markers | N/A |
| `validate-structure.sh` | Validate project compliance | No |

**Flow**:
```
sync-standards.sh
    │
    ├─► For each enabled project in projects.json
    │       │
    │       ├─► sync-agents-md.sh (AGENTS.md)
    │       │       │
    │       │       ├─► Extract STANDARD from source
    │       │       ├─► Extract CUSTOM from target
    │       │       └─► Merge and write
    │       │
    │       ├─► Copy policy files (if enabled)
    │       │
    │       └─► validate-structure.sh
    │
    └─► Summary report
```

## Synchronization Strategy

### Marker Detection

```bash
# Check if file has markers
if grep -q "BEGIN: STANDARD POLICY" file.md && \
   grep -q "BEGIN: PROJECT CUSTOM" file.md; then
    # Marker-based sync
    sync_with_markers()
else
    # Full replace (or migrate first)
    migrate_to_markers()
fi
```

### Section Extraction

```bash
# Extract standard section from source
sed -n '/BEGIN: STANDARD POLICY/,/END: STANDARD POLICY/p' source.md

# Extract custom section from target
sed -n '/BEGIN: PROJECT CUSTOM/,/END: PROJECT CUSTOM/p' target.md
```

### Merge Strategy

```
New file = Source[STANDARD] + Target[CUSTOM]
```

**Guarantees**:
- Standard changes always propagate
- Custom changes never lost
- No manual conflict resolution needed

## Configuration

### projects.json

```json
{
  "projects": [
    {
      "name": "my-girok",
      "path": "../my-girok",
      "enabled": true,
      "sync": {
        "AGENTS.md": true,                                   // Marker-based
        "docs/llm/policies/development-methodology.md": true, // Full replace
        "docs/llm/policies/cdd.md": true,                    // Full replace
        "docs/llm/policies/sdd.md": true,                    // Full replace
        "docs/llm/policies/add.md": true                     // Full replace
      }
    }
  ],
  "sync_rules": {
    "mandatory_files": ["AGENTS.md"],
    "marker_based_sync": {
      "AGENTS.md": {
        "preserve_section": "PROJECT CUSTOM",
        "sync_section": "STANDARD POLICY"
      }
    },
    "never_sync": [
      "CLAUDE.md",      // Agent-specific (project maintains)
      "GEMINI.md",      // Agent-specific (project maintains)
      ".ai/services/**",
      ".ai/packages/**",
      "docs/llm/services/**",
      ".specs/**"
    ]
  }
}
```

## Validation

### Structure Checks

```bash
./scripts/validate-structure.sh /path/to/project

# Validates:
# ✓ Mandatory files exist
# ✓ Mandatory directories exist
# ✓ Marker presence in AGENTS.md
# ✓ Line limits (Tier 1: ≤50, Tier 2: ≤200)
# ✓ Standard section matches llm-dev-protocol version
```

### Continuous Validation

```yaml
# .github/workflows/validate.yml
on: [push, pull_request]
jobs:
  validate:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - run: ./scripts/validate-structure.sh .
```

## Migration Path

### For Existing Projects

```bash
# 1. Backup
cp AGENTS.md AGENTS.md.backup

# 2. Migrate to markers
./scripts/migrate-agents-md.sh /path/to/project

# 3. Validate
./scripts/validate-structure.sh /path/to/project

# 4. Test sync
./scripts/sync-standards.sh --dry-run

# 5. Apply
./scripts/sync-standards.sh
```

**Migration Logic**:
```python
def migrate(existing_file):
    # Heuristic: Detect project-specific sections
    if has_tech_stack(existing_file) or has_custom_rules(existing_file):
        custom = extract_custom_sections(existing_file)
    else:
        custom = default_custom_template()

    # Rebuild with markers
    new_file = standard_with_markers() + custom_with_markers(custom)

    return new_file
```

## Scalability

### Current: Manual Execution

```bash
# Run manually when standards change
./scripts/sync-standards.sh
```

### Future: Automated CI/CD

```yaml
# .github/workflows/propagate-to-projects.yml
on:
  push:
    branches: [main]
    paths:
      - 'AGENTS.md'
      - 'docs/llm/policies/**'

jobs:
  propagate:
    - Checkout all project repos
    - Run sync for each
    - Create PRs with changes
    - Auto-merge if validation passes
```

**Scalability Targets**:
- 10 projects: Manual sync acceptable
- 50 projects: Automated CI/CD required
- 100+ projects: Distributed sync agents

## Security Considerations

### Access Control

| Component | Access Level | Reason |
| --------- | ------------ | ------ |
| `llm-dev-protocol` | Admin only | Changes affect all projects |
| `STANDARD POLICY` section | Read-only (projects) | Prevent drift |
| `PROJECT CUSTOM` section | Project write | Local autonomy |

### Audit Trail

```bash
# Track all standard changes
git log AGENTS.md
git log docs/llm/policies/

# Track project-specific changes
cd /path/to/project
git log AGENTS.md -- '*PROJECT CUSTOM*'
```

### Validation Gates

```yaml
# Pre-commit hook
#!/bin/bash
if git diff --cached AGENTS.md | grep -A 5 "BEGIN: STANDARD POLICY"; then
    echo "ERROR: Do not edit STANDARD POLICY section"
    echo "Edit in llm-dev-protocol and sync"
    exit 1
fi
```

## Performance

### Sync Time

| Projects | Time (Manual) | Time (CI/CD) |
| -------- | ------------- | ------------ |
| 1        | <1s           | ~30s         |
| 10       | ~5s           | ~2min        |
| 50       | ~25s          | ~10min       |
| 100      | ~50s          | ~20min       |

**Optimization**:
- Parallel project sync
- Incremental updates (only changed files)
- Caching validation results

### File Sizes

| File | Size | Lines | Purpose |
| ---- | ---- | ----- | ------- |
| `AGENTS.md` | ~15KB | ~250 | Standard + Custom |
| `development-methodology.md` | ~5KB | ~95 | Overview |
| `cdd.md` | ~20KB | ~350 | CDD framework |
| `sdd.md` | ~25KB | ~415 | SDD framework |
| `add.md` | ~15KB | ~233 | ADD framework |

**Total per project**: ~80KB (5 core files)

## Extensibility

### Adding New Standards

```bash
# 1. Create in llm-dev-protocol
vim docs/llm/policies/new-standard.md

# 2. Update projects.json
{
  "sync": {
    "docs/llm/policies/new-standard.md": true
  }
}

# 3. Sync to all projects
./scripts/sync-standards.sh
```

### Adding New Agent Types

```bash
# 1. Create template
cp CLAUDE.md.template CURSOR.md.template

# 2. Customize for Cursor
vim CURSOR.md.template

# 3. Update AGENTS.md standard
vim AGENTS.md  # Add Cursor to agent table

# 4. Sync
./scripts/sync-standards.sh
```

### Custom Sync Rules

```json
// projects.json
{
  "project_overrides": {
    "special-project": {
      "sync": {
        "AGENTS.md": false,  // Don't sync (manual management)
        "docs/llm/policies/cdd.md": true
      }
    }
  }
}
```

## Monitoring

### Sync Status Dashboard

```bash
# Check all projects
for project in $(jq -r '.projects[].path' projects.json); do
    echo "=== $project ==="
    ./scripts/validate-structure.sh "$project" --quiet
    echo ""
done

# Output:
# === ../my-girok ===
# ✓ Validated (0 errors, 0 warnings)
#
# === ../project-a ===
# ⚠ Validated (0 errors, 2 warnings)
```

### Version Tracking

```markdown
<!-- In AGENTS.md -->
> **Version**: 1.0.0 | **Last Updated**: 2026-01-23

<!-- In each project's AGENTS.md -->
> **Standard Version**: 1.0.0 | **Project Updated**: 2026-01-23
```

## Future Enhancements

| Feature | Status | Description |
| ------- | ------ | ----------- |
| Web Dashboard | Planned | Visual sync status for all projects |
| Slack Notifications | Planned | Alert on sync failures |
| PR Auto-Creation | Planned | Create PRs instead of direct commit |
| Diff Preview | Planned | Show what will change before sync |
| Rollback | Planned | Revert to previous standard version |
| Multi-Org Support | Future | Support projects across GitHub orgs |

---

**Version**: 1.0.0
**Last Updated**: 2026-01-23
**Maintainers**: llm-dev-protocol team
