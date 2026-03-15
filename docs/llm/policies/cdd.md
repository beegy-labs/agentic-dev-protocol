# CDD (Context-Driven Development) Policy

> System reconstruction constitution | **Last Updated**: 2026-03-14

## Definition

CDD is a **System Reconstruction Constitution**. All code may be lost, but CDD alone must enable reconstruction of the same system. CDD defines the persistent identity, constraints, and accumulated knowledge of a system.

**CDD does not define** schedule, scope, execution procedure, or approval rules.

## CDD / SDD / ADD Separation

| | CDD | SDD | ADD |
|---|---|---|---|
| Question | What is this system? | What do we build when? | How do we execute? |
| Temporality | Permanent (valid until changed) | Temporal (archived on completion) | Procedural (repeated per task) |
| Location | `.ai/`, `docs/llm/` | `.specs/` | `AGENTS.md`, `.ai/workflows/` |
| Content | Identity, constraints, knowledge | Plans, scopes, tasks, coordination | Execution rules, verification, escalation |

### Boundary Tests

When unsure where content belongs, apply in order:

| # | Test | Yes | No |
|---|------|-----|-----|
| 1 | Still valid after scope completes? | CDD | SDD |
| 2 | Referenced by multiple scopes? | CDD | SDD |
| 3 | Needed to rebuild system without code? | CDD | SDD or unnecessary |

### Boundary Judgment Examples

| Scenario | Layer | Classification | Reasoning |
|---|---|---|---|
| New API parameter added to existing endpoint | CDD | Constitutional (API Contract) | External contract change; persists after scope |
| New API parameter is internal-only (between own services) | CDD | Constitutional (Shared Contract) if cross-domain; IMPL_DETAIL if same domain | Cross-domain contract = Constitutional |
| Shared package internal refactoring (no interface change) | SDD | No claim needed | No external contract change; internal module split = IMPL_DETAIL |
| Shared package interface change | SDD | Claim required | Shared Surface; consumers must be notified |
| Auth domain adds token rotation policy | CDD | Constitutional, domain-local | Invariant change but closes within auth domain |
| Auth domain changes JWT → session-based auth | CDD | Constitutional, global | Auth model change affects all domains |
| Test fixture used only by one domain | SDD | No claim needed | Not a shared surface |
| Test fixture shared across domains | SDD | Claim required | Shared surface; domain-separated by default |
| New helper function in service layer | Neither | IMPL_DETAIL | Internal implementation; no CDD basis needed |
| New domain entity (e.g., Invoice) | CDD | Constitutional (Domain Model) | Permanent system identity |
| Error retry count changed from 3 to 5 | Depends | Constitutional if SLA/invariant defines it; IMPL_DETAIL otherwise | Check if Failure Handling invariant specifies retry policy |
| Logging format changed | Depends | Constitutional if Observability invariant defines format; Operational otherwise | Check if format is in Constitutional invariants |

Additional boundary cases are accumulated in `docs/llm/policies/boundary-cases.md` as they arise during operation.

## CDD Internal Structure

CDD content is classified into three tiers with distinct authority levels:

| Classification | Authority | Description |
|---------------|-----------|-------------|
| **Constitutional** | Normative (binding) | System identity, constraints, architecture decisions, invariants |
| **Operational** | Non-authoritative (advisory) | Implementation patterns, conventions, guides |
| **Reference** | Non-normative (informational) | Derived catalogs, cumulative listings |

### Constitutional

Defines what the system **is** and what it **must not violate**.

- Changes require approval (see Governance in `development-methodology.md`)
- Read-only during execution (ADD phase)
- Violation by SDD scope or ADD implementation is prohibited

### Operational

Accumulated implementation experience. **Non-authoritative by default.**

- Operational guidance does not override Constitutional rules
- Operational content becomes binding only through explicit promotion
- Writable during and after execution
- Operational citation alone cannot block implementation
- Constitutional basis cannot be replaced by Operational reference
- Unpromoted Operational is a review opinion, not policy

### Reference

Derived, cumulative artifacts. **Non-normative.**

- Reference is derivative, informational, and non-normative
- Reference cannot be used as constitutional justification
- Reference incompleteness does not block scope creation or implementation unless a Constitutional rule explicitly requires it
- Reference absence alone cannot block scope creation
- Updated automatically as scopes complete

## Required Content Categories (4-Axis Template)

The protocol defines categories. Each project fills in the content. Review all categories during project initialization. Mark non-applicable items as N/A with reason.

### Axis 1: System Definition (What) — Constitutional

| Category | Definition | Required |
|----------|-----------|----------|
| Domain Model | Core entities, relationships, boundaries | Yes |
| API/Interface Contract | Externally exposed interfaces, input/output shapes | Yes |
| State Transitions | State transition rules for stateful entities | N/A allowed |
| User Flows | Core user scenarios (if user-facing) | N/A allowed |

### Axis 2: Architecture (How) — Constitutional

| Category | Definition | Required |
|----------|-----------|----------|
| System Topology | Components and their relationships | Yes |
| Tech Stack | Languages, frameworks, runtimes | Yes |
| Layer Structure | Internal layer architecture per component | Yes |
| Data Architecture | Storage structure (DB, cache, files) | N/A allowed |
| Communication Patterns | Inter-component communication (sync/async) | N/A allowed |
| External Dependencies | External system integrations | N/A allowed |
| Deployment Topology | Deployment structure | N/A allowed |
| System-Level Directory | Architecture-level code placement (apps/, packages/, services/) | Yes |

### Axis 3: Invariants (Rules) — Constitutional

| Category | Definition | Required |
|----------|-----------|----------|
| Failure Handling | Failure tolerance approach | Yes |
| Security Boundaries | Authentication/authorization boundaries | N/A allowed |
| Data Ownership | Data ownership/access rules | N/A allowed |
| Consistency Rules | Data consistency requirements | N/A allowed |
| Performance Constraints | Performance requirements (SLA) | N/A allowed |
| Compliance | Regulatory/legal requirements | N/A allowed |
| Observability | Monitoring minimum requirements | N/A allowed |

### Axis 4: Shared Surfaces — Constitutional

Each project registers shared resources that multiple domains depend on:

| Category | Definition | Example |
|----------|-----------|---------|
| Shared Schema | DB schemas used by multiple domains | `users` table |
| Shared Packages | Internal packages used across domains | `@org/auth-utils` |
| Shared Contracts | Inter-domain API contracts | `POST /auth/verify` |
| Shared Config | Environment variables shared across domains | `DATABASE_URL` |
| Shared CI Surface | Shared pipeline/deployment config | `deploy.yml` |

Rules:
- Register during project initialization
- New shared surface discovery requires CDD update (constitutional change)
- Unregistered resources cannot be treated as shared

### Operational Content

| Category | Description |
|----------|-------------|
| Implementation patterns | Patterns that worked well (non-binding) |
| Coding conventions | Style, naming, file structure details |
| Detailed directory rules | Internal folder structure beyond system-level |
| Guides | How-to documents for specific tasks |

### Reference Content

| Category | Description | Updated when |
|----------|-------------|-------------|
| Feature Registry | Cumulative list of implemented features | Scope completion |
| API Catalog | Full list of implemented endpoints | Scope completion |
| Screen/Page Map | Implemented screens and navigation | Scope completion |

**Reference update responsibility:**

| Aspect | Rule |
|---|---|
| Trigger | Scope close (when SDD scope moves to history) |
| Responsibility | Executor who completed the scope |
| Review | Domain Owner verifies completeness |
| Failure | If executor omits update, Domain Owner fills gap before scope archive is finalized |
| Method | Manual update by executor (automated scripts may assist but executor is accountable) |

## Constitutional Mechanisms

### Constitutional Guarantee

| Must be identical across implementations | May differ |
|----------------------------------------|-----------|
| Functional requirements | Function/variable names |
| System boundaries | Internal module splits |
| Domain model | Implementation order |
| API contracts | Code style details |
| Architecture constraints | |
| Invariant rules | |

### Code Justification Rule

CDD Constitutional basis is required for:
- New features
- New external interfaces (API endpoints)
- New domain entities
- Invariant changes
- Architecture decision changes

CDD basis is NOT required for (IMPL_DETAIL):
- Internal functions, helpers, utilities
- Algorithm choices
- Internal module organization
- Error handling within established policy
- Test code
- Refactoring without external contract changes

### Authority Order

- Constitutional > Operational > Reference
- Global policy > domain docs > project-specific rules
- Higher level wins on conflict

### Incompleteness Taxonomy

Classification of CDD gaps (behavior rules are in ADD):

| Classification | Definition |
|---------------|------------|
| `CDD_MISSING` | Required Constitutional category not written |
| `CDD_AMBIGUOUS` | Category exists but interpretation unclear |
| `SDD_MISSING` | No SDD task for requested work |
| `IMPL_DETAIL` | Internal implementation detail, no CDD basis needed |

### Change Classification

| Level | Definition | Example |
|-------|-----------|---------|
| `editorial` | Wording only, no meaning change | Fix typo |
| `clarification` | Meaning reinforcement, no rule change | Add example to existing rule |
| `constitutional` | System rule change | Add new invariant |
| `migration-required` | Existing implementation must change | Change auth model |

### Traceability

- SDD cannot create scope violating CDD invariants
- ADD cannot start implementation without CDD basis (for non-IMPL_DETAIL items)
- On task completion, verify CDD Constitutional compliance

## 4-Tier Structure

```
.ai/        → docs/llm/     → docs/en/    → docs/kr/
(Pointer)     (SSOT)          (Generated)   (Translated)
```

Content coverage is identical across all tiers. Only format differs.

| Tier | Path | Audience | Format | Verification |
|------|------|----------|--------|-------------|
| 1 | `.ai/` | Machine | Pointers, links, ≤50 lines | Correctly routes to Tier 2? |
| 2 | `docs/llm/` | Machine | YAML, tables, ASCII only | Can executor reconstruct system from this alone? |
| 3 | `docs/en/` | Human | Prose, diagrams, examples | Can developer onboard + implement from this alone? |
| 4 | `docs/kr/` | Human | Tier 3 translation | Same as Tier 3 |

### Tier 1, 2 (Machine-optimized)

- Information-dense, token-efficient format
- Always up-to-date with current system state
- Optimized for automated retrieval and processing

### Tier 3, 4 (Human-optimized)

- Onboarding: new team members understand the system
- Implementation: developers can build from this specification
- Generated from Tier 2 via batch synchronization

### Tier 3/4 Generation Rules

When generating human-readable docs (Tier 3/4) from Tier 2:

| Tier 2 Pattern | Tier 3 Output | Rationale |
|----------------|---------------|-----------|
| `foo.md` + `foo-impl.md` | Single `foo.md` | Humans prefer complete context |
| `foo.md` + `foo-testing.md` | Single `foo.md` | No token limits for humans |
| Split companion files | Merge into main | Readability over retrieval |

## Scope

| CDD Contains | CDD Does NOT Contain |
|---|---|
| System identity (Constitutional) | Current task details (→ SDD) |
| Architecture decisions | Roadmap, progress (→ SDD) |
| Domain model, invariants | Task history (→ SDD) |
| Shared surfaces registry | Shared resource coordination (→ SDD) |
| Implementation patterns (Operational) | Execution procedures (→ ADD) |
| Feature/API catalogs (Reference) | Verification procedures (→ ADD) |
| Format and language rules | Approval/audit rules (→ Governance) |

## Directory Structure

**Organization: Domain-based (recommended).** Group by bounded domain, not by artifact type.

```
project/
├── CLAUDE.md           # Claude entry point
├── GEMINI.md           # Gemini entry point
├── .ai/                # Tier 1 - EDITABLE (Machine pointers)
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

## Edit Rules

| DO | DO NOT |
|---|---|
| Edit `.ai/` directly | Edit `docs/en/` directly |
| Edit `docs/llm/` directly | Edit `docs/kr/` directly |
| Run generate after llm/ changes | Skip generation step |
| Run translate after en/ changes | Skip translation step |

## History Management

**CDD History = Git**

| Item | Method |
|---|---|
| Document changes | `git log`, `git blame` |
| Version tracking | Git commits |
| No separate history files | Use Git |

## Update Requirements

| Change Type | .ai/ | docs/llm/ |
|---|---|---|
| New API endpoint | README.md (domain index) | `{domain}/` relevant file |
| New domain | README.md (add domain) | Create `{domain}/` folder |
| New pattern | rules.md | policies/ |
| New policy | rules.md summary | policies/ full |
| Cross-cutting change | architecture.md | policies/ + affected domains |

## Best Practices

| Practice | Description |
|---|---|
| Domain-based folders | Group by bounded domain, not by artifact type |
| Tier 1 = Pointer only | Never put full specs in .ai/ |
| Tier 2 = SSOT | Single source of truth |
| 1 file = 1 concept | Each file independently retrievable |
| Git = History | No separate changelog files in CDD |
| Token efficiency | Tables > prose, YAML > JSON (Tier 1/2) |
| Cross-reference | .ai/ always links to docs/llm/ |
| Static-first ordering | Fixed content before dynamic |

## References

- Operations (CLI, Line Limits, Split): `docs/llm/policies/cdd-operations.md`
- Methodology: `docs/llm/policies/development-methodology.md`
- SDD Policy: `docs/llm/policies/sdd.md`
- ADD Policy: `docs/llm/policies/add.md`
- Token Optimization: `docs/llm/policies/token-optimization.md`
- Monorepo Structure: `docs/llm/policies/monorepo.md`
