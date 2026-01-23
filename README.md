# LLM Development Protocol

> **Enforced Standard for LLM-Driven Development** | Automatically Propagates to All Projects

## Overview

`llm-dev-protocol` is a **mandatory standard** that enforces consistent structure across all projects for reliable LLM automation. When this repository changes, CI/CD pipelines **automatically propagate** updates to configured projects, ensuring all projects maintain identical LLM agent orchestration structure.

## Core Methodologies

This framework consists of three interconnected methodologies:

```
CDD (Context-Driven Development)     → Rules, patterns, conventions
    ↓
SDD (Spec-Driven Development)        → Tasks, roadmap, progress
    ↓
ADD (Agent-Driven Development)       → Autonomous execution
    ↓
Update CDD → Loop
```

| Methodology | Focus | Documentation |
| ----------- | ----- | ------------- |
| **CDD** | HOW (patterns, context) | [docs/llm/policies/cdd.md](docs/llm/policies/cdd.md) |
| **SDD** | WHAT (specs, tasks) | [docs/llm/policies/sdd.md](docs/llm/policies/sdd.md) |
| **ADD** | DO (autonomous execution) | [docs/llm/policies/add.md](docs/llm/policies/add.md) |

**Full overview**: [docs/llm/policies/development-methodology.md](docs/llm/policies/development-methodology.md)

## Quick Start

### For LLM Agents

1. **Read entry point**: [AGENTS.md](AGENTS.md) - Multi-LLM standard policy
2. **Agent-specific docs** (auto-generated from AGENTS.md):
   - **CLAUDE.md**: Optimized for Claude (long context, complex reasoning)
   - **GEMINI.md**: Optimized for Gemini (1M+ context, multimodal)
   - **CURSOR.md**: Optimized for Cursor (IDE integration, inline edits)

   These files are **automatically generated** by `scripts/generate-agent-docs.sh`

### For Developers

1. **Understand the methodology**: Read [docs/llm/policies/development-methodology.md](docs/llm/policies/development-methodology.md)
2. **Apply to your project**: Copy standard structure to your project
3. **Setup CI/CD**: Use provided workflows for multi-project propagation

## Project Structure

```
llm-dev-protocol/
├── AGENTS.md                      # Multi-LLM standard policy (SSOT)
├── CLAUDE.md.template             # Claude-specific template
├── GEMINI.md.template             # Gemini-specific template
│
├── .ai/                           # CDD Tier 1 - Indicators (≤50 lines)
│   └── README.md
│
├── docs/
│   ├── llm/                       # CDD Tier 2 - SSOT (detailed specs)
│   │   ├── policies/              # Core methodology definitions
│   │   │   ├── development-methodology.md
│   │   │   ├── cdd.md
│   │   │   ├── sdd.md
│   │   │   └── add.md
│   │   └── README.md
│   ├── en/                        # CDD Tier 3 - Auto-generated (English)
│   └── kr/                        # CDD Tier 4 - Auto-translated (Korean)
│
├── .specs/                        # SDD - Specifications
│   └── README.md
│
├── .github/workflows/             # CI/CD for standard propagation
│   └── propagate-to-projects.yml
│
├── scripts/                       # Automation scripts
│   ├── sync-standards.sh          # Main sync orchestrator
│   ├── sync-agents-md.sh          # AGENTS.md marker-based sync
│   ├── generate-agent-docs.sh     # Auto-generate Claude/Gemini/Cursor docs
│   ├── docs-generate.sh           # CDD Tier 2 → Tier 3
│   ├── docs-translate.sh          # CDD Tier 3 → Tier 4
│   ├── migrate-agents-md.sh       # Migrate existing AGENTS.md
│   └── validate-structure.sh      # Structure validation
│
├── templates/                     # Project initialization templates
│   └── project-init/
│
└── projects.json                  # Target projects configuration
```

## Key Features

### Standard Enforcement

- **Mandatory Structure**: All projects MUST follow identical directory structure
- **Automatic Propagation**: Changes to this repo trigger updates across all configured projects
- **CI/CD Validation**: Projects failing validation are automatically fixed
- **Version Control**: All standard changes tracked and synchronized

### Methodology Stack

- **CDD 4-Tier Documentation**: Token-optimized LLM context + human-readable docs
- **SDD 3-Layer Structure**: WHAT → WHEN → HOW task breakdown with human approval gates
- **ADD Multi-Agent Orchestration**: Parallel execution, consensus protocol, self-resolution
- **Auto-Generation Scripts**:
  - `docs-generate.sh`: Tier 2 (llm) → Tier 3 (en)
  - `docs-translate.sh`: Tier 3 (en) → Tier 4 (kr, ja, zh, etc.)
- **LLM Provider Auto-Detection**: Supports local LLM (Ollama, vLLM, LM Studio) and cloud LLMs (Claude, Gemini, OpenAI)

### Benefits

- **LLM Reliability**: Identical structure = consistent LLM behavior across all projects
- **Zero Drift**: Standards auto-sync, no manual copy-paste
- **Scalable**: Add new projects by registering in `projects.json`

## AGENTS.md Structure

### Marker-Based Sections

Each project's `AGENTS.md` has two sections:

```markdown
<!-- BEGIN: STANDARD POLICY -->
... synced from llm-dev-protocol (read-only) ...
<!-- END: STANDARD POLICY -->

<!-- BEGIN: PROJECT CUSTOM -->
... project-specific content (safe to edit) ...
<!-- END: PROJECT CUSTOM -->
```

**Standard Section**: Automatically synced from llm-dev-protocol
**Custom Section**: Project-specific rules, tech stack, compliance requirements (preserved during sync)

**Guide**: [docs/llm/policies/agents-customization.md](docs/llm/policies/agents-customization.md)

### What Goes in Custom Section?

- **Tech Stack**: Frameworks, libraries, versions
- **Domain Rules**: Business constraints, validation rules
- **Compliance**: HIPAA, GDPR, PCI-DSS requirements
- **Integration**: External APIs, rate limits, auth methods
- **On-Call**: Incident response, escalation procedures

## Use Cases

### Individual Projects

Copy the standard structure to your project:

```bash
# Copy core files
cp llm-dev-protocol/AGENTS.md my-project/
cp llm-dev-protocol/CLAUDE.md.template my-project/CLAUDE.md
cp llm-dev-protocol/GEMINI.md.template my-project/GEMINI.md

# Copy directory structure
cp -r llm-dev-protocol/.ai my-project/
cp -r llm-dev-protocol/docs my-project/
cp -r llm-dev-protocol/.specs my-project/
```

### Multi-Project Organizations

Configure `projects.json` to apply standards across all projects:

```json
{
  "projects": [
    {"path": "../my-girok", "enabled": true},
    {"path": "../project-a", "enabled": true},
    {"path": "../project-b", "enabled": false}
  ]
}
```

Then use CI/CD workflow to propagate changes automatically.

### CDD Documentation Workflow

After syncing standards to a project, generate documentation:

```bash
cd my-project

# 1. Generate Tier 3 (human-readable English) from Tier 2 (SSOT)
./scripts/docs-generate.sh              # Auto-detect LLM provider
./scripts/docs-generate.sh --provider local  # Force local LLM (Ollama)
./scripts/docs-generate.sh --provider claude # Use Claude CLI

# 2. Translate Tier 3 to Tier 4 (target language)
./scripts/docs-translate.sh --locale kr      # Korean
./scripts/docs-translate.sh --locale ja      # Japanese
./scripts/docs-translate.sh --locale zh      # Chinese
```

**Supported Providers**:
- **local**: Ollama, vLLM, LM Studio (free, private)
- **claude**: Claude CLI (requires API key)
- **gemini**: Gemini CLI (requires API key)
- **openai**: OpenAI CLI (requires API key)
- **auto**: Auto-detect (default)

## Benefits

### For Developers

- **Reduced Context Switching**: CDD Tier 3/4 serves as external memory
- **Consistent Patterns**: All projects follow same structure
- **Scalability**: Senior developers manage 3-5 projects simultaneously

### For LLM Agents

- **Token Efficiency**: CDD Tier 1-2 optimized for context window
- **Clear Task Boundaries**: SDD defines exact scope and success criteria
- **Autonomous Execution**: ADD enables self-resolution with peer consensus

### For Organizations

- **Knowledge Capital**: CDD continuously accumulates team knowledge
- **Quality Guarantee**: Multi-LLM consensus reduces errors
- **Onboarding**: New members quickly understand all projects through Tier 3/4

## Philosophy

### Primary Goal

Consistently guarantee **highest-quality output** instead of producing low-quality deliverables in bulk.

### Economic Principle

The most expensive resource is **expert labor**, not tools. Optimize for senior developer's time and creative immersion.

### Execution Strategy

Senior developers direct **3-5 projects simultaneously** by delegating all non-creative work to LLM agents.

## License

MIT License - See [LICENSE](LICENSE)

## Contributing

This is an open-source standard methodology. Contributions welcome:

1. Fork the repository
2. Create a feature branch
3. Submit a pull request

## References

- **CDD Policy**: [docs/llm/policies/cdd.md](docs/llm/policies/cdd.md)
- **SDD Policy**: [docs/llm/policies/sdd.md](docs/llm/policies/sdd.md)
- **ADD Policy**: [docs/llm/policies/add.md](docs/llm/policies/add.md)
- **Full Methodology**: [docs/llm/policies/development-methodology.md](docs/llm/policies/development-methodology.md)

---

**Start here**: [AGENTS.md](AGENTS.md) for LLM agents, [docs/llm/policies/development-methodology.md](docs/llm/policies/development-methodology.md) for humans.
