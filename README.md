# Agentic Development Protocol

A **CDD-driven automated software evolution** system.

## Core Concept

```
CDD → SDD → ADD → CDD (feedback loop)
```

| Layer | Role |
| ----- | ---- |
| **CDD** | Reconstructable SSOT — if all code is lost, CDD enables rebuilding an equivalent system |
| **SDD** | CDD-derived change planning — transforms requests into executable plans |
| **ADD** | Autonomous execution engine — classifies work type, selects policy/skill, executes within CDD constraints |
| **Human** | Approval, exception handling, and final decisions only |

### Key Properties

- **Reconstructability**: CDD alone enables system reconstruction
- **Dual-path guarantee**: Layer 2 for machine auto-execution, Layer 3 for human reconstruction
- **CDD internal classification**: Constitutional (normative) / Operational (advisory) / Reference (informational)
- **Minimal human role**: Humans approve and resolve exceptions, not operate

## Policies

| Policy | Purpose | File |
| ------ | ------- | ---- |
| **CDD** | Context-Driven Development - Reconstructable knowledge base | `docs/llm/policies/cdd.md` |
| **SDD** | Spec-Driven Development - Change planning layer | `docs/llm/policies/sdd.md` |
| **ADD** | Agent-Driven Development - Autonomous execution engine | `docs/llm/policies/add.md` |
| **Methodology** | System architecture overview | `docs/llm/policies/development-methodology.md` |
| **TOKEN** | Token Optimization - Format rules for LLM-facing docs | `docs/llm/policies/token-optimization.md` |
| **MONOREPO** | Monorepo Structure - Backend/frontend layout conventions | `docs/llm/policies/monorepo.md` |
| **AGENTS** | AGENTS.md Customization - Project-specific additions | `docs/llm/policies/agents-customization.md` |

## Distribution

This repository is the **Single Source of Truth** for development policies across all projects.
Add it as a Git submodule and use symlinks to keep policies synchronized.

```
agentic-dev-protocol (this repo)
        |
        | Git Submodule + GitHub Actions (6-hour sync)
        v
 target projects
```

### Auto-Update Flow

```
1. Modify policies in this repository → git push origin main
2. GitHub Actions (every 6 hours) → git submodule update --remote
3. If changed → auto-commit and push
4. All target projects receive latest policies
```

## Setup for New Projects

### 1. Add Submodule

```bash
git submodule add https://github.com/beegy-labs/agentic-dev-protocol vendor/agentic-dev-protocol
```

### 2. Create Policy Symlinks

```bash
./vendor/agentic-dev-protocol/scripts/setup-policy-links.sh
git add .
git commit -m "chore: Add agentic-dev-protocol with policy symlinks"
```

File-level symlinks are used (not directory symlinks) to preserve project-specific documentation.

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
│   ├── llm/                         # Tier 2: LLM-optimized (SSOT)
│   │   └── policies/
│   │       ├── cdd.md               # Context-Driven Development
│   │       ├── sdd.md               # Spec-Driven Development
│   │       ├── add.md               # Agent-Driven Development
│   │       ├── development-methodology.md
│   │       ├── development-methodology-details.md
│   │       ├── token-optimization.md
│   │       ├── monorepo.md
│   │       └── agents-customization.md
│   └── en/                          # Tier 3: Human-readable (auto-generated)
│       ├── cdd.md
│       ├── sdd.md
│       └── add.md
├── scripts/
│   └── setup-policy-links.sh
└── .ai/
    └── README.md
```

## CDD 4-Tier Structure

| Tier | Path | Purpose | Editable |
| ---- | ---- | ------- | -------- |
| 1 | `.ai/` | LLM entry point (≤50 lines) | Yes |
| 2 | `docs/llm/` | SSOT, full specs | Yes |
| 3 | `docs/en/` | Human-readable (auto-generated) | No |
| 4 | `docs/{locale}/` | Translations (auto-generated) | No |

## Manual Update

```bash
git submodule update --remote vendor/agentic-dev-protocol
git add vendor/agentic-dev-protocol
git commit -m "chore: Update agentic-dev-protocol"
git push
```

## License

MIT
