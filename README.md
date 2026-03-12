# Agentic Development Protocol

Central repository for LLM-based development methodology (CDD, SDD, ADD) policies.

## Overview

This repository is the **Single Source of Truth** for development policies across all projects.
Add it as a Git submodule and use symlinks to keep policies synchronized automatically.

```
agentic-dev-protocol (this repo)
        |
        | Git Submodule + GitHub Actions (6-hour sync)
        v
 vibe-coding-starter / my-girok / giterm / platform-mcp
```

## Core Policies

| Policy | Purpose | File |
| ------ | ------- | ---- |
| **CDD** | Context-Driven Development - 4-tier document architecture | `docs/llm/policies/cdd.md` |
| **SDD** | Spec-Driven Development - Task planning and tracking | `docs/llm/policies/sdd.md` |
| **ADD** | Agent-Driven Development - Autonomous execution | `docs/llm/policies/add.md` |
| **TOKEN** | Token Optimization - Format rules for LLM-facing docs | `docs/llm/policies/token-optimization.md` |
| **MONOREPO** | Monorepo Structure - Backend/frontend layout conventions | `docs/llm/policies/monorepo.md` |
| **AGENTS** | AGENTS.md Customization - Project-specific additions | `docs/llm/policies/agents-customization.md` |

## How It Works

### Auto-Update Flow

```
1. Developer modifies agentic-dev-protocol
   └── git push origin main

2. GitHub Actions (every 6 hours)
   └── git submodule update --remote

3. If changed, auto-commit and push
   └── all target projects receive latest policies

4. Done - All projects have latest policies
```

### Protection Mechanism

| Layer | Protection |
| ----- | ---------- |
| Submodule | Separate repo, cannot modify directly from target project |
| Symlink | Points to submodule, read-only effective |
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

**Important**: File-level symlinks are used, not directory symlinks.
This preserves your project-specific documentation in `docs/llm/` and `docs/en/`.

The script creates symlinks for all 6 policy files:

| Symlink in project | Source in submodule |
| ------------------ | ------------------- |
| `docs/llm/policies/cdd.md` | `vendor/.../policies/cdd.md` |
| `docs/llm/policies/sdd.md` | `vendor/.../policies/sdd.md` |
| `docs/llm/policies/add.md` | `vendor/.../policies/add.md` |
| `docs/llm/policies/token-optimization.md` | `vendor/.../policies/token-optimization.md` |
| `docs/llm/policies/monorepo.md` | `vendor/.../policies/monorepo.md` |
| `docs/llm/policies/agents-customization.md` | `vendor/.../policies/agents-customization.md` |
| `docs/en/cdd.md` | `vendor/.../docs/en/cdd.md` |
| `docs/en/sdd.md` | `vendor/.../docs/en/sdd.md` |
| `docs/en/add.md` | `vendor/.../docs/en/add.md` |

### 3. Add GitHub Actions Workflow

Create `.github/workflows/update-submodule.yml`:

```yaml
name: Update Submodule

on:
  schedule:
    - cron: '0 */6 * * *'
  workflow_dispatch:

permissions:
  contents: write

jobs:
  update:
    name: Sync agentic-dev-protocol
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v4
        with:
          ref: develop       # your default branch
          submodules: true
          token: ${{ secrets.GITHUB_TOKEN }}

      - name: Update and push if changed
        run: |
          git submodule update --remote vendor/agentic-dev-protocol
          if git diff --quiet; then
            echo "No changes detected"
            exit 0
          fi
          git config user.name "github-actions[bot]"
          git config user.email "github-actions[bot]@users.noreply.github.com"
          git add vendor/agentic-dev-protocol
          git commit -m "chore(policy): sync agentic-dev-protocol submodule"
          git push origin develop
```

> **Note**: Change `ref: develop` and `git push origin develop` to match your project's default branch (e.g., `main`).

## Repository Structure

```
agentic-dev-protocol/
├── docs/
│   ├── llm/                         # Tier 2: LLM-optimized (SSOT)
│   │   └── policies/
│   │       ├── cdd.md               # Context-Driven Development
│   │       ├── sdd.md               # Spec-Driven Development
│   │       ├── add.md               # Agent-Driven Development
│   │       ├── token-optimization.md # Token format rules
│   │       ├── monorepo.md          # Monorepo structure
│   │       ├── agents-customization.md # AGENTS.md guide
│   │       ├── development-methodology.md
│   │       └── development-methodology-details.md
│   └── en/                          # Tier 3: Human-readable (auto-generated)
│       ├── cdd.md
│       ├── sdd.md
│       └── add.md
├── scripts/
│   └── setup-policy-links.sh        # Symlink automation
└── .ai/
    └── README.md                    # LLM entry point template
```

## Target Project Structure (After Setup)

```
my-project/
├── .github/workflows/
│   └── update-submodule.yml          # Auto-sync workflow
├── vendor/
│   └── agentic-dev-protocol/         # [Submodule] Read-only
├── docs/
│   ├── llm/
│   │   └── policies/
│   │       ├── cdd.md                # [Symlink] Shared policy
│   │       ├── sdd.md                # [Symlink] Shared policy
│   │       ├── add.md                # [Symlink] Shared policy
│   │       ├── token-optimization.md # [Symlink] Shared policy
│   │       ├── monorepo.md           # [Symlink] Shared policy
│   │       ├── agents-customization.md # [Symlink] Shared policy
│   │       └── project-specific.md   # [Project] Your own docs
│   └── en/
│       ├── cdd.md                    # [Symlink] Shared
│       ├── sdd.md                    # [Symlink] Shared
│       ├── add.md                    # [Symlink] Shared
│       └── guides/                   # [Project] Your own docs
├── .ai/
│   ├── README.md                     # [Project] LLM entry point
│   └── rules.md                      # [Project] Project rules
└── .specs/                           # [Project] Task specs
```

## CDD 4-Tier Structure

| Tier | Path | Purpose | Editable | Token Rules |
| ---- | ---- | ------- | -------- | ----------- |
| 1 | `.ai/` | LLM entry point (≤50 lines) | Yes | Strict |
| 2 | `docs/llm/` | SSOT, full specs | Yes | Strict |
| 3 | `docs/en/` | Human-readable (auto-generated) | No | None |
| 4 | `docs/{locale}/` | Translations (auto-generated) | No | None |

## SDD 3-Layer Structure

```
.specs/{app}/
├── roadmap.md            # L1: Master direction (load on planning only)
├── scopes/
│   └── {year}-{period}.md  # L2: Scope details (load at work start)
└── tasks/
    └── {year}-{period}.md  # L3: Task list (always load during work)
```

## Manual Update

```bash
# Update submodule to latest
git submodule update --remote vendor/agentic-dev-protocol
git add vendor/agentic-dev-protocol
git commit -m "chore: Update agentic-dev-protocol"
git push
```

## Contributing

1. Modify policies in this repository
2. Push to `main` branch
3. GitHub Actions auto-updates all target repos within 6 hours

To trigger an immediate update in a target project:
Go to GitHub → Actions → Update Policy Submodule → Run workflow

## Related Projects

- [vibe-coding-starter](https://github.com/beegy-labs/vibe-coding-starter) - Monorepo template
- [my-girok](https://github.com/beegy-labs/my-girok) - Production project
- [giterm](https://github.com/beegy-labs/giterm) - Vibe Coding Orchestrator
- [platform-mcp](https://github.com/beegy-labs/platform-mcp) - MCP Server for Kubernetes monitoring

## License

MIT
