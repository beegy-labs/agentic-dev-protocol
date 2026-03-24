# CDD (Context-Driven Development) Policy

> System SSOT and reconstruction baseline for AI-native organizations | **Last Updated**: 2026-03-15

## Definition

> Fixed definition: `identity.md`

CDD is the **system SSOT and reconstruction baseline** of the AI-native organization.

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
- Execution procedures or CLI tooling
- Approval governance
- Task management

## Purpose

- Define system identity
- Define architecture and behavioral constraints
- Define external contracts
- Define reconstruction criteria
- Provide baseline for subsequent changes
- Receive confirmed knowledge feedback from execution
- Enable human understanding, review, audit, and onboarding (via Layer 3)

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

### Sufficiency Test

| Result | Condition |
| ------ | --------- |
| Sufficient | All features reconstructable from CDD without reading code |
| Insufficient | Any feature requires reading code to understand behavior |

Coverage lens: Constitutional classification items = minimum required scope.

### Lifecycle Role

CDD is not a one-time design document. It must remain usable for:

- **Maintenance** — understanding current system state
- **Feature addition** — knowing where and how to extend
- **Modification** — understanding impact of changes
- **Deletion** — knowing what depends on what
- **Reconstruction** — rebuilding after loss

## CDD Internal Classification

> Canonical classification: `identity.md#cdd-internal-classification`

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
| Coding conventions and patterns | CLI commands or tooling |
| Security, testing, DB policies | Model-specific parameters |

## CDD vs SDD

For detailed comparison, see `sdd.md#cdd-vs-sdd`. In short: CDD defines what the system IS; SDD defines what to CHANGE.

## 4-Layer Structure

CDD expresses the same system knowledge through 4 layers tailored to different consumers. Meaning must be identical across layers; only format and target audience differ.

```
.ai/        → docs/llm/     → docs/en/        → docs/kr/
(Pointer)     (Machine SSOT)  (Human Underst.)   (Translated)
```

### Layer 1: Machine Pointer/Entry Layer

| Aspect | Detail |
| ------ | ------ |
| Purpose | Route to correct Layer 2 docs with minimal tokens; minimize entry cost |
| Consumers | LLM, ADD, orchestrators, low-context entry workflows |
| Contains | Indexes, domain pointers, read-first hints, minimal must-check rules, blocked-if signals |
| Does NOT contain | Long explanations, detailed contracts, detailed models |
| Path | `.ai/` |
| Editable | **Yes** |
| Format | Tables, links, ≤50 lines |
| Principle | Machine navigation layer, not a system description |

### Layer 2: Machine SSOT Layer

| Aspect | Detail |
| ------ | ------ |
| Purpose | Substantive system body for ADD and automation; machine SSOT; support auto-execution and reconstruction |
| Consumers | LLM, ADD, document-based reconstruction engines |
| Contains | Functionality, domain model, external contracts, invariants, topology, shared surfaces, structural rules |
| Path | `docs/llm/` |
| Editable | **Yes** |
| Format | YAML, tables, code blocks |
| Principle | The substantive CDD SSOT. Primary execution path: Layer 2 → ADD |

### Layer 3: Human Understanding Layer

> Sufficiency checklist: `identity.md#layer-3-sufficiency-checklist`

| Aspect | Detail |
| ------ | ------ |
| Purpose | Enable humans to understand, review, audit, and onboard into the AI organization's systems |
| Consumers | Reviewers, auditors, new members |
| Path | `docs/en/` |
| Editable | Auto-generated (NOT directly editable) |
| Format | Prose, examples, guides |

**Layer 3 is NOT the primary execution path.** The primary execution path is Layer 2 → ADD. Layer 3 exists for human understanding and oversight, not as an alternative execution layer.

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

Reason: ADD needs both a routing layer and a machine SSOT to function.

### Optional Layers

- Layer 3: Generate when needed (onboarding, review, audit, compliance)
- Layer 4: Generate when needed (multi-language team support)

### Layer 3/4 Generation Rules

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
│   ├── en/             # Layer 3 - NOT EDITABLE (Human understanding)
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

## Best Practices

| Practice | Description |
| -------- | ----------- |
| Reconstructability first | Every CDD doc should contribute to system rebuilding |
| Respect classification | Constitutional = normative; Operational = advisory; Reference = informational |
| Domain-based folders | Group by bounded domain |
| Layer 1 = Pointer only | Never put full specs in .ai/ |
| Layer 2 = Machine SSOT | Primary execution path: Layer 2 → ADD |
| Layer 3 = Human understanding | For review, audit, onboarding — not alternative execution |
| 1 file = 1 concept | Each file independently retrievable |
| Git = History | No separate changelog files |
| Stable knowledge only | Do not add transient or task-specific content |

## References

- Identity anchor: `docs/llm/policies/identity.md`
- Methodology: `docs/llm/policies/development-methodology.md`
- SDD Policy: `docs/llm/policies/sdd.md`
- ADD Policy: `docs/llm/policies/add.md`
- Token Optimization: `docs/llm/policies/token-optimization.md`
