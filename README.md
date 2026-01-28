# Agentic Development Protocol

Central repository for LLM-based development methodology (CDD, SDD, ADD) policies.

## Overview

This repository is the **Single Source of Truth** for development policies across all monorepos.

```
agentic-dev-protocol (this repo)
        │
        │ Git Submodule + GitHub Actions (6-hour sync)
        ▼
┌───────────────────┬───────────────────┬───────────────────┐
│  vibe-coding-     │     my-girok      │     giterm        │
│  starter          │                   │                   │
│  (main)           │    (develop)      │    (develop)      │
└───────────────────┴───────────────────┴───────────────────┘
```

## Core Methodology

| Policy | Purpose | File |
|--------|---------|------|
| **CDD** | Context-Driven Development - 4-tier document architecture | `docs/llm/policies/cdd.md` |
| **SDD** | Spec-Driven Development - Human explains, LLM documents | `docs/llm/policies/sdd.md` |
| **ADD** | Agent-Driven Development - Autonomous execution | `docs/llm/policies/add.md` |

## How It Works

### Auto-Update Flow

```
1. Developer modifies agentic-dev-protocol
   └── git push origin main

2. GitHub Actions (every 6 hours)
   └── git submodule update --remote

3. If changed, auto-commit and push
   └── my-girok (develop), vibe-coding-starter (main), giterm (develop)

4. Done - All projects have latest policies
```

### Protection Mechanism

| Layer | Protection |
|-------|------------|
| Submodule | Separate repo, can't modify directly |
| Symlink | Points to submodule, read-only |
| GitHub Actions | Auto-overwrites on schedule |

## Setup for New Projects

### 1. Add Submodule

```bash
git submodule add https://github.com/beegy-labs/agentic-dev-protocol vendor/agentic-dev-protocol
```

### 2. Create Policy Symlinks

```bash
# Run setup script (creates file-level symlinks)
./vendor/agentic-dev-protocol/scripts/setup-policy-links.sh

# Commit
git add .
git commit -m "chore: Add agentic-dev-protocol with policy symlinks"
```

**Important**: Use file-level symlinks, not directory symlinks.
This preserves your project-specific documentation in `docs/llm/` and `docs/en/`.

### 3. Add GitHub Actions Workflow

Create `.github/workflows/update-submodule.yml`:

```yaml
name: Update Policy Submodule

on:
  workflow_dispatch:
  schedule:
    - cron: '0 */6 * * *'

permissions:
  contents: write

jobs:
  update:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
        with:
          submodules: true

      - name: Update submodule
        run: git submodule update --remote vendor/agentic-dev-protocol

      - name: Commit and push if changed
        run: |
          if ! git diff --quiet; then
            git config user.name "github-actions[bot]"
            git config user.email "github-actions[bot]@users.noreply.github.com"
            git add vendor/agentic-dev-protocol
            git commit -m "chore(policy): Update agentic-dev-protocol"
            git push
          fi
```

## Repository Structure

```
agentic-dev-protocol/
├── docs/
│   ├── llm/                    # Tier 2: LLM-optimized (SSOT)
│   │   └── policies/
│   │       ├── cdd.md
│   │       ├── sdd.md
│   │       ├── add.md
│   │       └── ...
│   └── en/                     # Tier 3: Human-readable
│       ├── README.md
│       ├── cdd.md
│       ├── sdd.md
│       └── add.md
├── scripts/
│   └── setup-policy-links.sh   # Symlink automation script
└── vendor/                     # External dependencies (future)
```

## Target Repo Structure

```
my-girok/
├── .github/workflows/
│   └── update-submodule.yml        # Auto-sync workflow
├── vendor/
│   └── agentic-dev-protocol/       # [Submodule] Read-only
├── docs/
│   ├── llm/
│   │   └── policies/
│   │       ├── cdd.md -> symlink   # [Shared] From submodule
│   │       ├── sdd.md -> symlink   # [Shared] From submodule
│   │       ├── add.md -> symlink   # [Shared] From submodule
│   │       └── project-specific.md # [Project] Your own docs
│   ├── en/
│   │   ├── cdd.md -> symlink       # [Shared] From submodule
│   │   ├── sdd.md -> symlink       # [Shared] From submodule
│   │   ├── add.md -> symlink       # [Shared] From submodule
│   │   └── guides/                 # [Project] Your own docs
│   └── project/                    # [Project] Project-specific
├── .ai/                            # Project-specific context
└── .specs/                         # Project-specific specs
```

## CDD 4-Tier Structure

```
Tier 1: .ai/              ← Entry point (≤50 lines, ASCII only)
Tier 2: docs/llm/         ← SSOT (≤300 lines, ASCII only)
Tier 3: docs/en/          ← Human-readable (Unicode OK)
Tier 4: docs/{locale}/    ← Translations (Unicode OK)
```

## SDD 3-Layer Structure

```
.specs/{app}/
├── roadmap.md           # L1: Big picture
├── scopes/{id}.md       # L2: Scope details
└── tasks/{scope}/       # L3: Task breakdown
    ├── index.md
    └── 01-task.md
```

## Manual Update (if needed)

```bash
# Update submodule to latest
git submodule update --remote vendor/agentic-dev-protocol
git add vendor/agentic-dev-protocol
git commit -m "chore: Update agentic-dev-protocol"
git push
```

## Manual Trigger (urgent update)

Go to GitHub → Actions → Update Policy Submodule → Run workflow

## Contributing

1. Modify policies in this repository
2. Push to main branch
3. GitHub Actions auto-updates all target repos (within 6 hours)

## Related

- [vibe-coding-starter](https://github.com/beegy-labs/vibe-coding-starter) - Monorepo template
- [my-girok](https://github.com/beegy-labs/my-girok) - Production project
- [giterm](https://github.com/beegy-labs/giterm) - Vibe Coding Orchestrator

## License

MIT
