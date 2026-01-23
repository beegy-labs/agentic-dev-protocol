# LLM Development Protocol

Central repository for LLM-based development methodology (CDD, SDD, ADD) policies and documentation generation scripts.

## Quick Start

Use [vibe-coding-starter](https://github.com/beegy-labs/vibe-coding-starter) for a ready-to-use monorepo template with CDD, SDD, ADD pre-configured.

## Core Methodology

| Policy | Purpose | File |
|--------|---------|------|
| **CDD** | Context-Driven Development - 4-tier document architecture | `docs/llm/policies/cdd.md` |
| **SDD** | Spec-Driven Development - WHAT→WHEN→HOW structure | `docs/llm/policies/sdd.md` |
| **ADD** | Agent-Driven Development - Multi-agent autonomous execution | `docs/llm/policies/add.md` |

## Repository Structure

```
llm-dev-protocol/
├── .ai/README.md                         # CDD Tier 1 indicator
├── docs/llm/policies/                    # Policy files (6)
│   ├── cdd.md                            # Context-Driven Development
│   ├── sdd.md                            # Spec-Driven Development
│   ├── add.md                            # Agent-Driven Development
│   ├── development-methodology.md        # Core philosophy
│   ├── development-methodology-details.md
│   └── agents-customization.md           # AGENTS.md customization
└── scripts/docs/                         # Documentation scripts
    ├── generate.ts                       # Tier 2 → Tier 3
    ├── translate.ts                      # Tier 3 → Tier 4
    ├── utils.ts
    ├── tsconfig.json
    ├── providers/                        # LLM providers
    │   ├── ollama.ts                     # Local LLM
    │   ├── gemini.ts                     # Google Gemini
    │   ├── claude.ts                     # Anthropic Claude
    │   └── openai.ts                     # OpenAI
    └── prompts/
        ├── generate.txt
        └── translate.txt
```

## Usage

### 1. Setup Sync in Your Project

Create `scripts/sync-protocol.sh`:

```bash
#!/bin/bash
set -e

PROTOCOL_REPO="https://github.com/beegy-labs/llm-dev-protocol.git"
TEMP_DIR=$(mktemp -d)
trap "rm -rf ${TEMP_DIR}" EXIT

git clone --depth 1 --quiet "${PROTOCOL_REPO}" "${TEMP_DIR}/src"

# Sync policies
mkdir -p docs/llm/policies
for f in cdd.md sdd.md add.md development-methodology.md development-methodology-details.md agents-customization.md; do
  cp "${TEMP_DIR}/src/docs/llm/policies/${f}" "docs/llm/policies/${f}"
done

# Sync scripts
mkdir -p scripts/docs/providers scripts/docs/prompts
cp ${TEMP_DIR}/src/scripts/docs/*.ts scripts/docs/
cp ${TEMP_DIR}/src/scripts/docs/tsconfig.json scripts/docs/
cp ${TEMP_DIR}/src/scripts/docs/providers/*.ts scripts/docs/providers/
cp ${TEMP_DIR}/src/scripts/docs/prompts/*.txt scripts/docs/prompts/

echo "✅ Sync complete"
```

Add to `package.json`:

```json
{
  "scripts": {
    "sync:protocol": "scripts/sync-protocol.sh"
  }
}
```

### 2. Run Sync

```bash
pnpm sync:protocol
```

### 3. Generate Documentation (CDD Tier 3/4)

```bash
# Tier 2 → Tier 3 (SSOT → Human-readable)
pnpm docs:generate --provider ollama
pnpm docs:generate --provider gemini
pnpm docs:generate --provider claude
pnpm docs:generate --provider openai

# Tier 3 → Tier 4 (English → Translation)
pnpm docs:translate --locale kr --provider gemini
```

## CDD 4-Tier Structure

```
Tier 1: .ai/README.md          ← Entry point (≤50 lines)
Tier 2: docs/llm/**/*.md       ← SSOT (LLM optimized)
Tier 3: docs/en/**/*.md        ← Human-readable (generated)
Tier 4: docs/{locale}/**/*.md  ← Translations (generated)
```

## SDD 3-Layer Structure

```
.specs/apps/{app}/
├── roadmap.md           # L1: WHAT - Overall direction
├── scopes/{scope}.md    # L2: WHEN - Work scope
└── tasks/{scope}.md     # L3: HOW - Implementation plan
```

## Sync Policy

| Directory | Sync | Reason |
|-----------|------|--------|
| `docs/llm/policies/` | ✅ | Common policies |
| `scripts/docs/` | ✅ | Doc generation scripts |
| `.ai/` | ❌ | Project-specific customization |
| `.specs/` | ❌ | Project-specific specs |

## Related

- [vibe-coding-starter](https://github.com/beegy-labs/vibe-coding-starter) - Monorepo template with CDD, SDD, ADD

## Contributing

1. Modify policies/scripts in this repository
2. Push to main branch
3. Run `pnpm sync:protocol` in each project

## License

MIT
