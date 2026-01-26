# Agentic Development Protocol

Central repository for LLM-based development methodology (CDD, SDD, ADD) policies.

## Overview

This repository is the **Single Source of Truth** for development policies across all monorepos.

```
agentic-dev-protocol (this repo)
        │
        │ Git Submodule + Renovate (Auto-merge)
        ▼
┌───────────────────┬───────────────────┐
│  vibe-coding-     │     my-girok      │
│  starter          │                   │
│  (main)           │    (develop)      │
└───────────────────┴───────────────────┘
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

2. Renovate detects submodule change (within minutes)
   └── Creates update commit in target repos

3. Target repos auto-merge
   └── my-girok (develop), vibe-coding-starter (main)

4. Done - All projects have latest policies
```

### Protection Mechanism

| Layer | Protection |
|-------|------------|
| Submodule | Separate repo, can't modify directly |
| Symlink | Points to submodule, read-only |
| Renovate | Auto-overwrites on any change |

## Setup for New Projects

### 1. Add Submodule

```bash
# Add agentic-dev-protocol as submodule
git submodule add https://github.com/beegy-labs/agentic-dev-protocol vendor/agentic-dev-protocol

# Create symlinks
mkdir -p docs
ln -s ../vendor/agentic-dev-protocol/docs/llm docs/llm
ln -s ../vendor/agentic-dev-protocol/docs/en docs/en

git add .
git commit -m "chore: Add agentic-dev-protocol as submodule"
```

### 2. Add Renovate Config

Create `renovate.json`:

```json
{
  "$schema": "https://docs.renovatebot.com/renovate-schema.json",
  "extends": ["config:recommended"],
  "git-submodules": {
    "enabled": true
  },
  "packageRules": [
    {
      "matchManagers": ["git-submodules"],
      "matchPackageNames": ["agentic-dev-protocol"],
      "automerge": true,
      "automergeType": "branch",
      "schedule": ["at any time"],
      "commitMessagePrefix": "chore(policy):",
      "commitMessageTopic": "agentic-dev-protocol"
    }
  ]
}
```

### 3. Install Renovate GitHub App

Install from: https://github.com/apps/renovate

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
├── vendor/                     # External dependencies (future)
└── renovate.json
```

## Target Repo Structure

```
my-girok/
├── vendor/
│   └── agentic-dev-protocol/       # [Submodule] Read-only
├── docs/
│   ├── llm -> ../vendor/.../llm    # [Symlink]
│   ├── en -> ../vendor/.../en      # [Symlink]
│   └── project/                    # Project-specific docs
├── .ai/                            # Project-specific context
├── .specs/                         # Project-specific specs
└── renovate.json                   # Auto-merge config
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

## Contributing

1. Modify policies in this repository
2. Push to main branch
3. Renovate auto-updates all target repos

## Related

- [vibe-coding-starter](https://github.com/beegy-labs/vibe-coding-starter) - Monorepo template
- [my-girok](https://github.com/beegy-labs/my-girok) - Production project

## License

MIT
