# Agentic Development Protocol

An **automated development methodology for AI-native organizations** — CDD-driven system memory, automated change planning, and autonomous execution.

## Identity

This methodology is designed for AI-native organizations. LLM-enabled execution is assumed, not optional.

| Term | Definition |
| ---- | ---------- |
| **CDD** | System SSOT and reconstruction baseline |
| **SDD** | CDD-derived change plan |
| **ADD** | Autonomous execution and policy selection engine |
| **Human** | Approver, exception judge, final reviewer |

### Core Loop

```
CDD (System Memory) → SDD (Change Plan) → ADD (Auto-Execution) → CDD (Feedback)
```

### Key Properties

- **AI-first execution**: Layer 2 → ADD is the primary execution path
- **Reconstructability**: CDD alone enables system reconstruction
- **CDD classification**: Constitutional (normative) / Operational (advisory) / Reference (informational)
- **Layer 3 = human understanding**: For review, audit, onboarding — not an alternative execution path
- **Minimal human role**: Humans approve and resolve exceptions, not operate

### Reading Order

1. `docs/llm/policies/identity.md` — Fixed definitions
2. `docs/llm/policies/development-methodology.md` — System architecture overview
3. `docs/llm/policies/cdd.md` — CDD policy
4. `docs/llm/policies/sdd.md` — SDD policy
5. `docs/llm/policies/add.md` — ADD policy

## Policies

| Policy | Purpose | File |
| ------ | ------- | ---- |
| **Identity** | Fixed definitions and identity anchor | `docs/llm/policies/identity.md` |
| **Methodology** | System architecture overview | `docs/llm/policies/development-methodology.md` |
| **CDD** | System SSOT and reconstruction baseline | `docs/llm/policies/cdd.md` |
| **SDD** | CDD-derived change planning | `docs/llm/policies/sdd.md` |
| **ADD** | Autonomous execution engine | `docs/llm/policies/add.md` |
| **Token Optimization** | Format rules for LLM-facing docs | `docs/llm/policies/token-optimization.md` |
| **Monorepo** | Backend/frontend layout conventions | `docs/llm/policies/monorepo.md` |
| **Agents Customization** | Project-specific AGENTS.md additions | `docs/llm/policies/agents-customization.md` |

## Distribution

This repository is the **Single Source of Truth** for development policies across all projects. Add it as a Git submodule and use symlinks to keep policies synchronized. Policy changes are infrequent — weekly sync with change detection is sufficient.

### Setup for New Projects

**1. Add Submodule**

```bash
git submodule add https://github.com/beegy-labs/agentic-dev-protocol vendor/agentic-dev-protocol
```

**2. Create Policy Symlinks**

```bash
./vendor/agentic-dev-protocol/scripts/setup-policy-links.sh
git add .
git commit -m "chore: Add agentic-dev-protocol with policy symlinks"
```

File-level symlinks are used (not directory symlinks) to preserve project-specific documentation.

| Symlink in project | Source in submodule |
| ------------------ | ------------------- |
| `docs/llm/policies/identity.md` | `vendor/.../policies/identity.md` |
| `docs/llm/policies/cdd.md` | `vendor/.../policies/cdd.md` |
| `docs/llm/policies/sdd.md` | `vendor/.../policies/sdd.md` |
| `docs/llm/policies/add.md` | `vendor/.../policies/add.md` |
| `docs/llm/policies/development-methodology.md` | `vendor/.../policies/development-methodology.md` |
| `docs/llm/policies/token-optimization.md` | `vendor/.../policies/token-optimization.md` |
| `docs/llm/policies/monorepo.md` | `vendor/.../policies/monorepo.md` |
| `docs/llm/policies/agents-customization.md` | `vendor/.../policies/agents-customization.md` |
| `docs/en/cdd.md` | `vendor/.../docs/en/cdd.md` |
| `docs/en/sdd.md` | `vendor/.../docs/en/sdd.md` |
| `docs/en/add.md` | `vendor/.../docs/en/add.md` |

### Sync (Weekly, on change only)

Add to target project's `.github/workflows/update-submodule.yml`:

```yaml
name: Update Policy Submodule

on:
  workflow_dispatch:
  schedule:
    - cron: '0 9 * * 1'  # Every Monday 09:00 UTC

permissions:
  contents: write

jobs:
  update:
    runs-on: arc-runner-set
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
            git commit -m "chore(policy): update agentic-dev-protocol"
            git push
          fi
```

Manual sync:

```bash
git submodule update --remote vendor/agentic-dev-protocol
git add vendor/agentic-dev-protocol
git commit -m "chore: Update agentic-dev-protocol"
git push
```

## Repository Structure

```
agentic-dev-protocol/
├── .ai/                             # Layer 1: Machine pointers
│   └── README.md
├── .specs/                          # SDD: Change plan bootstrap
│   └── README.md
├── docs/
│   ├── llm/                         # Layer 2: Machine SSOT
│   │   └── policies/
│   │       ├── identity.md          # Identity anchor
│   │       ├── cdd.md               # Context-Driven Development
│   │       ├── sdd.md               # Spec-Driven Development
│   │       ├── add.md               # Agent-Driven Development
│   │       ├── development-methodology.md
│   │       ├── development-methodology-details.md
│   │       ├── token-optimization.md
│   │       ├── monorepo.md
│   │       └── agents-customization.md
│   └── en/                          # Layer 3: Human understanding (auto-generated)
│       ├── README.md
│       ├── cdd.md
│       ├── sdd.md
│       └── add.md
└── scripts/
    └── setup-policy-links.sh
```

## Related Projects

| Project | Description |
| ------- | ----------- |
| [veronex](https://github.com/beegy-labs/veronex) | Production project |

## License

MIT
