# CDD (Context-Driven Development) Policy

> Reconstructable system knowledge base | **Last Updated**: 2026-03-15

## Definition

CDD is the **Reconstructable Single Source of Truth (SSOT)** of the system.

### Core Property: Reconstructability

If all code is lost, CDD alone must allow reconstruction of an **equivalent system**.

| Equivalent Means | May Differ |
| ---------------- | ---------- |
| Same functional capabilities | Code structure |
| Same system boundaries | Implementation details |
| Same domain model | Variable/function naming |
| Same external contracts | UI design specifics |
| Same invariants and core behavior | Internal optimizations |

### Lifecycle Role

CDD is not a one-time design document. It must remain usable for:

- **Maintenance** — understanding current system state
- **Feature addition** — knowing where and how to extend
- **Modification** — understanding impact of changes
- **Deletion** — knowing what depends on what
- **Reconstruction** — rebuilding after loss

## CDD vs SDD

| Aspect | CDD | SDD |
| ------ | --- | --- |
| Purpose | What the system IS | What to CHANGE |
| Nature | Stable knowledge base | Transient change plans |
| Location | `.ai/`, `docs/llm/` | `.specs/` |
| Derived from | System reality | CDD |
| History | Git (document changes) | Files → DB (task records) |

## Scope

| CDD Contains | CDD Does NOT Contain |
| ------------ | -------------------- |
| Domain model and boundaries | Current task details (→ SDD) |
| System invariants and constraints | Roadmap, progress (→ SDD) |
| External contracts (APIs, protocols) | Task history (→ SDD) |
| Service/package structure | Execution policies (→ ADD) |
| Coding conventions and patterns | Project management state |
| Security, testing, DB policies | |
| Monorepo layout conventions | |

## 4-Tier Structure

```
.ai/        → docs/llm/     → docs/en/    → docs/kr/
(Pointer)     (SSOT)          (Generated)   (Translated)
```

| Tier | Path | Purpose | Audience | Editable | Format |
| ---- | ---- | ------- | -------- | -------- | ------ |
| 1 | `.ai/` | Indicators | LLM | **Yes** | Tables, links, ≤50 lines |
| 2 | `docs/llm/` | Full specs | LLM | **Yes** | YAML, tables, code blocks |
| 3 | `docs/en/` | Human-readable | Human | Auto-gen | Prose, examples, guides |
| 4 | `docs/kr/` | Translation | Human | Auto-gen | Same as docs/en/ |

## Tier Purpose Details

**Tier 1, 2 (LLM-facing)**:

- Core technical reference for system reconstruction
- Token-efficient, high-density
- Always up-to-date with current system state

**Tier 3, 4 (Human-facing)**:

- External memory for human context switching
- Onboarding material
- Review and approval support

### Tier 3/4 Generation Rules

When generating human-readable docs (Tier 3/4) from Tier 2:

| Tier 2 Pattern | Tier 3 Output | Rationale |
| -------------- | ------------- | --------- |
| `foo.md` + `foo-impl.md` | Single `foo.md` | Humans prefer complete context |
| `foo.md` + `foo-testing.md` | Single `foo.md` | No token limits for humans |
| Split companion files | Merge into main | Readability over retrieval |

## Directory Structure

**Organization: Domain-based (recommended).** Group by bounded domain, not by artifact type.

```
project/
├── CLAUDE.md           # Claude entry point
├── GEMINI.md           # Gemini entry point
├── .ai/                # Tier 1 - EDITABLE (LLM pointers)
│   ├── README.md       # Navigation hub (domain index)
│   ├── rules.md        # Core DO/DON'T
│   ├── architecture.md # Architecture pointer
│   └── git-flow.md     # Git workflow pointer
├── docs/
│   ├── llm/            # Tier 2 - EDITABLE (SSOT)
│   │   ├── README.md   # Master index with keywords
│   │   ├── policies/   # Cross-cutting rules (all domains)
│   │   ├── {domain-a}/ # Domain folder (e.g. auth/)
│   │   ├── {domain-b}/ # Domain folder (e.g. inference/)
│   │   └── research/   # External knowledge (by topic)
│   ├── en/             # Tier 3 - NOT EDITABLE (Generated)
│   └── kr/             # Tier 4 - NOT EDITABLE (Translated)
```

### Why Domain-Based

| Criterion | Type-based (`services/`, `guides/`) | Domain-based (`auth/`, `infra/`) |
| --------- | ----------------------------------- | -------------------------------- |
| Retrieval precision | Low (scattered across folders) | High (scoped by domain) |
| Token efficiency | Poor (loads cross-domain) | Good (loads single domain) |
| Path-as-signal | Weak (type, not domain) | Strong (path = domain) |
| Collocation | Low (5 folders for 1 domain) | High (1 folder per domain) |
| Code alignment | None | Direct mapping to architecture |

### Domain Folder Guidelines

| Guideline | Detail |
| --------- | ------ |
| One folder per bounded domain | `auth/`, `billing/`, `infra/`, `frontend/` |
| `policies/` is always cross-cutting | Architecture, patterns, git-flow, terminology |
| `research/` for external knowledge | Sub-organized by topic |
| New domains = new folders | Do not force-fit into existing domains |

### Internal Structure per Domain

| Internal Pattern | Example Files | When to Use |
| ---------------- | ------------- | ----------- |
| Core + routing/ops split | `ollama.md`, `ollama-routing.md` | Complex subsystems |
| Mechanism-per-file | `jwt-sessions.md`, `api-keys.md`, `rbac.md` | Multiple independent mechanisms |
| Lifecycle + analytics | `job-lifecycle.md`, `job-analytics.md` | Entities with observation pipeline |
| Deploy + platform | `deploy.md`, `deploy-helm.md` | Multi-target deployment |

### Fallback: Type-Based (Early Projects)

For new projects where domains are not yet identified:

```
docs/llm/
├── policies/    # Always present
├── services/    # All service specs (flat)
├── guides/      # How-to documents
└── packages/    # Package documentation
```

Migrate to domain-based once 3+ domains emerge.

## Edit Rules

| DO | DO NOT |
| -- | ------ |
| Edit `.ai/` directly | Edit `docs/en/` directly |
| Edit `docs/llm/` directly | Edit `docs/kr/` directly |
| Run generate after llm/ changes | Skip generation step |
| Run translate after en/ changes | Skip translation step |

## History Management

**CDD History = Git**

| Item | Method |
| ---- | ------ |
| Document changes | `git log`, `git blame` |
| Version tracking | Git commits |
| No separate history files | Use Git |

## CDD Update Triggers

CDD is updated when the system's knowledge changes, not when tasks complete.

| Trigger | CDD Action |
| ------- | ---------- |
| New domain boundary discovered | Add domain folder |
| New pattern confirmed through use | Add to policies/ |
| External contract changed | Update contract docs |
| Invariant added or modified | Update domain docs |
| System boundary shifted | Update architecture |

CDD should **not** be updated as a routine task-completion checklist. Only confirmed, stable knowledge enters CDD.

## CLI Commands

### docs:generate (docs/llm → docs/en)

```bash
pnpm docs:generate                    # Generate all (incremental)
pnpm docs:generate --force            # Regenerate all files
pnpm docs:generate --file <path>      # Generate specific file
pnpm docs:generate --retry-failed     # Retry only failed files
pnpm docs:generate --clean            # Clear history + generate all
pnpm docs:generate --provider gemini  # Use Gemini provider
```

### docs:translate (docs/en → docs/kr)

```bash
pnpm docs:translate --locale kr             # Translate all
pnpm docs:translate --locale kr --file <p>  # Translate specific file
pnpm docs:translate --locale kr --retry-failed  # Retry failed only
pnpm docs:translate --locale kr --clean     # Clear history + translate all
```

## Line Limits (RAG Optimized)

### Tier 1 (.ai/)

```yaml
max_lines: 50
tokens: ~500
purpose: Quick navigation, pointers to Tier 2
```

### Tier 2 (docs/llm/) - By Folder Role

| Folder Role | Max Lines | Tokens | Rationale |
| ----------- | --------- | ------ | --------- |
| `policies/` | 200 | ~2,000 | Core rules, frequently loaded |
| `{domain}/` (core docs) | 200 | ~2,000 | Per-domain SSOT |
| `{domain}/pages/` | 150 | ~1,500 | UI page specs, focused |
| `research/` | 200 | ~2,000 | External knowledge, reference |
| `README.md` (index) | 200 | ~2,000 | Master index with keywords |

### Exceptions (Framework Documents)

These documents define the methodology itself and are exempt from line limits:

| File | Reason |
| ---- | ------ |
| `policies/cdd.md` | CDD framework definition |
| `policies/sdd.md` | SDD framework definition |
| `policies/add.md` | ADD framework definition |
| `policies/development-methodology.md` | Core methodology |

### Split Guidelines

| Condition | Action |
| --------- | ------ |
| Over limit by 1-10 lines | Keep as-is (tolerance) |
| Over limit by 11-30 lines | Evaluate semantic split |
| Over limit by >30 lines | Split required |
| Companion would be <50 lines | Keep as-is |
| Clear semantic boundary exists | Split |

### Context Budget (128k)

```
128k context allocation:
├── System prompt:     ~5k tokens
├── Conversation:     ~20k tokens
├── Code context:     ~30k tokens
└── Documents:        ~70k tokens (35 × 2,000 avg)
```

### Token Optimization (Tier 1 & 2)

**Full rules**: `docs/llm/policies/token-optimization.md`

| Category | Forbidden | Required |
| -------- | --------- | -------- |
| Characters | Emoji, box-drawing chars | Plain text, ✓/✗ only |
| Indentation | Tab chars, 4-space indent | 2-space indent, max 2 levels |
| Structure | ≥3 nesting levels, H4+ headers | Tables, flat bullets (≤2 levels) |
| Format | JSON configs, verbose prose | YAML configs, tables > prose |
| Whitespace | 3+ consecutive blank lines | Max 1 blank line |

### Language Policy

**All CDD documents MUST be written in English.**

## AI Entry Points

| AI | Entry File | First Read |
| -- | ---------- | ---------- |
| Claude | CLAUDE.md | .ai/rules.md |
| Gemini | GEMINI.md | .ai/rules.md |

## Best Practices

| Practice | Description |
| -------- | ----------- |
| Reconstructability first | Every CDD doc should contribute to system rebuilding |
| Domain-based folders | Group by bounded domain, not by artifact type |
| Tier 1 = Pointer only | Never put full specs in .ai/ |
| Tier 2 = SSOT | Single source of truth |
| 1 file = 1 concept | Each file independently retrievable by RAG |
| Git = History | No separate changelog files in CDD |
| Token efficiency | Tables > prose, YAML > JSON |
| Stable knowledge only | Do not add transient or task-specific content |
| Static-first ordering | Fixed content before dynamic (prefix caching) |

## References

- Methodology: `docs/llm/policies/development-methodology.md`
- SDD Policy: `docs/llm/policies/sdd.md`
- ADD Policy: `docs/llm/policies/add.md`
- Token Optimization: `docs/llm/policies/token-optimization.md`
- Monorepo Structure: `docs/llm/policies/monorepo.md`
