# CDD (Context-Driven Development) Policy

> Reconstructable system knowledge base | **Last Updated**: 2026-03-15

## Definition

CDD is the **absolute SSOT** of the system and a **reconstructable system knowledge base**.

CDD defines:

- System identity
- System boundaries
- Functionality
- External contracts
- Invariants
- Reconstruction criteria

CDD does NOT define:

- Schedules or roadmap management
- Current progress or task state
- Execution procedures
- Approval governance
- Task management

## Purpose

- Define system identity
- Define architecture and behavioral constraints
- Define external contracts
- Define reconstruction criteria
- Provide baseline for subsequent changes
- Receive confirmed knowledge feedback from execution

## Questions CDD Answers

- What is this system?
- What must be identical for it to be the same system?
- What contracts does it provide externally?
- What constraints must always be upheld?
- What are the system boundaries?
- What is required for a valid reconstruction?

## Core Property: Reconstructability

If all code is lost, CDD alone must allow reconstruction of an **equivalent system**.

| Must Be Identical | May Differ |
| ----------------- | ---------- |
| Provided functionality | Internal code structure |
| System boundaries | Function/variable/class names |
| Domain model | Internal module decomposition |
| External contracts | Implementation details |
| Core state transition semantics | Framework-internal usage |
| Auth/authz boundaries | UI presentation |
| Data ownership | Visual design |
| Core invariants | Non-critical optimizations |
| Failure handling semantics | |

What must be identical is the system's essence; what may differ is the implementation approach.

### Lifecycle Role

CDD is not a one-time design document. It must remain usable for:

- **Maintenance** — understanding current system state
- **Feature addition** — knowing where and how to extend
- **Modification** — understanding impact of changes
- **Deletion** — knowing what depends on what
- **Reconstruction** — rebuilding after loss

## CDD Internal Classification

CDD has 3 internal classifications:

### Constitutional

Normative layer of the system.

| Aspect | Detail |
| ------ | ------ |
| Contains | Domain model, external contracts, system boundaries, core invariants, auth/authz model, shared surface definitions, reconstruction criteria |
| Nature | Normative — violation forbidden |
| Mutability | Cannot be changed without approval |
| During ADD execution | Read-only in general |

### Operational

Non-normative knowledge accumulated through implementation.

| Aspect | Detail |
| ------ | ------ |
| Contains | Implementation patterns, repeatedly validated practices, implementation guides, troubleshooting knowledge |
| Nature | Advisory by default |
| Mutability | Cannot override Constitutional; can be promoted if warranted |

### Reference

Derived information layer.

| Aspect | Detail |
| ------ | ------ |
| Contains | Feature catalog, API catalog, screen/page maps, index documents |
| Nature | Non-normative, informational |
| Mutability | Incrementally updated after task completion |
| Limitation | Cannot serve as sole normative basis |

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
| System topology | Execution policies (→ ADD) |
| Shared surface definitions | Project management state |
| Auth/authz model | Schedules |
| Service/package structure | Approval governance details |
| Coding conventions and patterns | |
| Security, testing, DB policies | |

## 4-Layer Structure

CDD expresses the same system knowledge through 4 layers tailored to different consumers. Meaning must be identical across layers; only format and target audience differ.

```
.ai/        → docs/llm/     → docs/en/    → docs/kr/
(Pointer)     (Machine SSOT)  (Human Recon)  (Translated)
```

### Layer 1: Machine Pointer/Entry Layer

| Aspect | Detail |
| ------ | ------ |
| Purpose | Route to correct Layer 2 docs with minimal tokens; minimize entry cost |
| Consumers | LLM, automation systems, orchestrators, low-context entry workflows |
| Contains | Indexes, domain pointers, read-first hints, minimal must-check rules, blocked-if signals |
| Does NOT contain | Long explanations, detailed contracts, detailed models, detailed architecture |
| Path | `.ai/` |
| Editable | **Yes** |
| Format | Tables, links, ≤50 lines |
| Principle | Layer 1 is a machine navigation layer, not a system description |

### Layer 2: Machine SSOT Layer

| Aspect | Detail |
| ------ | ------ |
| Purpose | Provide substantive system body for automation systems; maintain machine SSOT; support auto-execution and reconstruction |
| Consumers | LLM, ADD, document-based reconstruction engines, automation systems |
| Contains | Functionality, domain model, external contracts, invariants, topology, shared surfaces, system-level structural rules |
| Path | `docs/llm/` |
| Editable | **Yes** |
| Format | YAML, tables, code blocks |
| Principle | Layer 2 is the substantive CDD SSOT that automation systems read |

### Layer 3: Human Reconstruction Layer

| Aspect | Detail |
| ------ | ------ |
| Purpose | Enable humans to understand, reconstruct, and evolve the system |
| Consumers | Developers, reviewers, new members, human implementers when LLM is unavailable |
| Path | `docs/en/` |
| Editable | Auto-generated (NOT directly editable) |
| Format | Prose, examples, guides |

Layer 3 must enable:

- Onboarding
- System understanding
- Building an equivalent system
- Maintenance
- Feature addition, modification, deletion
- Contract change response

**Layer 3 is NOT a simple summary. It is a human reconstruction document that enables humans to build and evolve an equivalent system.**

### Layer 4: Translation/Localization Layer

| Aspect | Detail |
| ------ | ------ |
| Purpose | Convey Layer 3 meaning identically in other languages |
| Path | `docs/kr/` (or other locale) |
| Editable | Auto-generated |
| Principle | Only language changes; meaning must NOT change |

## Layer Generation Rules

### Mandatory Layers

- Layer 1: **Required**
- Layer 2: **Required**

Reason: Automation systems need both a routing layer and a machine SSOT to function.

### Optional Layers

- Layer 3: Generate when needed
- Layer 4: Generate when needed

### Layer 3 Generation Conditions

- Human fallback is needed
- Onboarding quality matters
- Preparing for LLM-unavailable scenarios
- Long-term maintenance handover is considered

### Layer 4 Generation Conditions

- Multi-language team support is needed
- Direct use by specific language-region developers is needed

### Practical Recommendation

- Important projects: Layer 3 strongly recommended
- Multi-language operations: Layer 4 recommended

## Tier 3/4 Generation Rules

When generating human-readable docs (Layer 3/4) from Layer 2:

| Layer 2 Pattern | Layer 3 Output | Rationale |
| --------------- | -------------- | --------- |
| `foo.md` + `foo-impl.md` | Single `foo.md` | Humans prefer complete context |
| `foo.md` + `foo-testing.md` | Single `foo.md` | No token limits for humans |
| Split companion files | Merge into main | Readability over retrieval |

## Directory Structure

**Organization: Domain-based (recommended).** Group by bounded domain, not by artifact type.

```
project/
├── CLAUDE.md           # Claude entry point
├── GEMINI.md           # Gemini entry point
├── .ai/                # Layer 1 - EDITABLE (Machine pointers)
│   ├── README.md       # Navigation hub (domain index)
│   ├── rules.md        # Core DO/DON'T
│   ├── architecture.md # Architecture pointer
│   └── git-flow.md     # Git workflow pointer
├── docs/
│   ├── llm/            # Layer 2 - EDITABLE (Machine SSOT)
│   │   ├── README.md   # Master index with keywords
│   │   ├── policies/   # Cross-cutting rules (all domains)
│   │   ├── {domain-a}/ # Domain folder (e.g. auth/)
│   │   ├── {domain-b}/ # Domain folder (e.g. inference/)
│   │   └── research/   # External knowledge (by topic)
│   ├── en/             # Layer 3 - NOT EDITABLE (Human reconstruction)
│   └── kr/             # Layer 4 - NOT EDITABLE (Translated)
```

### Why Domain-Based

| Criterion | Type-based | Domain-based |
| --------- | ---------- | ------------ |
| Retrieval precision | Low (scattered) | High (scoped by domain) |
| Token efficiency | Poor (cross-domain) | Good (single domain) |
| Path-as-signal | Weak | Strong (path = domain) |
| Collocation | Low | High (1 folder per domain) |
| Code alignment | None | Direct mapping |

### Domain Folder Guidelines

| Guideline | Detail |
| --------- | ------ |
| One folder per bounded domain | `auth/`, `billing/`, `infra/`, `frontend/` |
| `policies/` is always cross-cutting | Architecture, patterns, git-flow, terminology |
| `research/` for external knowledge | Sub-organized by topic |
| New domains = new folders | Do not force-fit into existing domains |

### Fallback: Type-Based (Early Projects)

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

## CDD Update Rules

CDD is the input to execution and the output of learning.

### By Classification

| Classification | Update Rule | Approval |
| -------------- | ----------- | -------- |
| **Constitutional** | No arbitrary changes during execution. Only reflects system identity changes. | Required |
| **Operational** | Reflects implementation experience after work. Accumulates validated patterns. | Not required |
| **Reference** | Reflects results after work. Updates feature, API, screen catalogs. | Not required |

Constitutional layer must be controlled. Operational and Reference layers grow through use.

### Update Triggers

| Trigger | CDD Action |
| ------- | ---------- |
| New domain boundary discovered | Add domain folder |
| New pattern confirmed through use | Add to policies/ (Operational) |
| External contract changed | Update contract docs (Constitutional — requires approval) |
| Invariant added or modified | Update domain docs (Constitutional — requires approval) |
| System boundary shifted | Update architecture (Constitutional — requires approval) |
| Feature implemented | Update Reference catalog |

CDD should **not** be updated as a routine task-completion checklist.

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

### Layer 1 (.ai/)

```yaml
max_lines: 50
tokens: ~500
purpose: Quick navigation, pointers to Layer 2
```

### Layer 2 (docs/llm/) - By Folder Role

| Folder Role | Max Lines | Tokens | Rationale |
| ----------- | --------- | ------ | --------- |
| `policies/` | 200 | ~2,000 | Core rules, frequently loaded |
| `{domain}/` (core docs) | 200 | ~2,000 | Per-domain SSOT |
| `{domain}/pages/` | 150 | ~1,500 | UI page specs |
| `research/` | 200 | ~2,000 | External knowledge |
| `README.md` (index) | 200 | ~2,000 | Master index |

### Exceptions (Framework Documents)

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

## AI Entry Points

| AI | Entry File | First Read |
| -- | ---------- | ---------- |
| Claude | CLAUDE.md | .ai/rules.md |
| Gemini | GEMINI.md | .ai/rules.md |

## Best Practices

| Practice | Description |
| -------- | ----------- |
| Reconstructability first | Every CDD doc should contribute to system rebuilding |
| Respect classification | Constitutional = normative; Operational = advisory; Reference = informational |
| Domain-based folders | Group by bounded domain, not by artifact type |
| Layer 1 = Pointer only | Never put full specs in .ai/ |
| Layer 2 = Machine SSOT | Substantive body for automation |
| Layer 3 = Human reconstruction | Not just summary — must enable human system building |
| 1 file = 1 concept | Each file independently retrievable by RAG |
| Git = History | No separate changelog files in CDD |
| Stable knowledge only | Do not add transient or task-specific content |

## References

- Methodology: `docs/llm/policies/development-methodology.md`
- SDD Policy: `docs/llm/policies/sdd.md`
- ADD Policy: `docs/llm/policies/add.md`
- Token Optimization: `docs/llm/policies/token-optimization.md`
- Monorepo Structure: `docs/llm/policies/monorepo.md`
