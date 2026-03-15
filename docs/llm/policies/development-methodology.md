# Development Methodology

> Roles, principles, and governance for executor-driven development | **Last Updated**: 2026-03-14

## Core Philosophy

### Primary Goal

Consistently guarantee **highest-quality output** instead of producing low-quality deliverables in bulk.

### Economic Principle

The most expensive resource is **expert labor**, not tools. Optimize for senior developer's time and creative immersion.

### Execution Strategy

Senior developers direct **3-5 projects simultaneously** by delegating all non-creative work to executors (LLMs or developers).

| Delegate to Executor | Reserve for Human |
|---|---|
| Detailed planning | Direction setting |
| Code implementation | Architecture decisions |
| Documentation | Code review |
| Routine problem-solving | Creative problem-solving |

## Terminology

This methodology uses executor-neutral language:

| Term | Definition |
|---|---|
| **Architect** | Human who sets direction, reviews, approves |
| **Domain Owner** | Delegated authority for a specific domain (may be Architect or Executor) |
| **Executor** | Entity that implements (LLM, developer, or automated agent) |

The methodology is executor-agnostic. All procedures apply regardless of whether the executor is an LLM, a human developer, or an automated system.

## Collaboration Model

### Architect

| Aspect | Description |
|---|---|
| Qualification | Senior+ understanding 80%+ of project |
| Role | Manage entire project lifecycle |
| Responsibilities | Direction, design, architecture, code review, governance |
| Authority | Approve plans, guarantee quality, delegate domain authority |

### Domain Owner

| Aspect | Description |
|---|---|
| Appointed by | Architect (Phase 1) |
| Scope | One bounded domain |
| Authority | Approve domain-local constitutional changes |
| Constraint | Cross-domain and global changes must escalate to Architect |

### Executor

| Aspect | Description |
|---|---|
| Role | Implement approved tasks within boundaries |
| Scope | Plan generation, code implementation, CDD updates |
| Autonomy | Execute within approved CDD + SDD boundaries |
| Escalation | On CDD gap, consensus failure, or constitutional change need |

## Three-Layer Architecture

```
CDD (Context-Driven Development)     -> System identity, constraints, knowledge
    |
    v
SDD (Spec-Driven Development)        -> Temporal planning, coordination
    |
    v
ADD (Agent-Driven Development)       -> Execution, verification, escalation
    |
    v
Update CDD -> Loop
```

### Responsibility Separation

| Layer | Defines | Does NOT Define |
|---|---|---|
| CDD | System identity, invariants, shared surfaces, taxonomy | Plans, execution procedures, approval rules |
| SDD | Temporal scope, tasks, dependencies, resource coordination | System identity, execution procedures |
| ADD | Execution rules, verification, escalation, CDD updates | System identity, task planning |

### Boundary Tests

| # | Test | Yes → | No → |
|---|------|-------|------|
| 1 | Still valid after scope completes? | CDD | SDD |
| 2 | Referenced by multiple scopes? | CDD | SDD |
| 3 | Needed to rebuild system without code? | CDD | SDD or unnecessary |

## Phase Lifecycle

### Phase 1: Foundation (Architect)

Architect creates CDD Constitutional draft and domain partitioning:

**Minimum requirements:**
- Entity list with primary keys and relationships
- Service/component boundaries
- Authentication/authorization model
- API style and error format
- Domain partitioning for N parallel executors
- Shared surfaces identification

### Phase 2: Planning (Architect + Executors)

```
Phase 2a: Each executor writes SDD draft (parallel, feature branches)
Phase 2b: Each executor identifies CDD Constitutional gaps → proposes supplements
Phase 2c: Architect integrates CDD proposals + resolves conflicts → Constitutional finalized
```

### Phase 3: Execution (Executors, CDD Constitutional read-only)

- Executors implement SDD tasks autonomously
- CDD Constitutional is read-only
- Deficiencies → stop, report, wait for approval, resume
- Affected-domain-only stops (others continue)

### Phase 4: Capitalization (Executors + Architect)

- CDD Operational: patterns, conventions accumulated
- CDD Reference: feature registry, API catalog updated
- Operational → Constitutional promotion if criteria met
- SDD scope archived to history

### Role Matrix by Phase

| Role | Phase 1 | Phase 2 | Phase 3 | Phase 4 |
|---|---|---|---|---|
| Architect | CDD draft + partitioning | CDD integration + approval | Escalation handling | Operational review |
| Domain Owner | - | Domain CDD review | Domain-local approvals | Domain review |
| Executor | - | SDD writing + CDD gap proposal | Implementation (CDD read-only) | Operational + Reference writing |

---

## Governance

**Governance does not redefine** CDD/SDD/ADD content. It only controls approval, audit, and notification.

### Approval Matrix

| Change Level | Scope | Approval Authority | Notification |
|---|---|---|---|
| `editorial` | Any | Executor self-approval | None |
| `clarification` | Any | Executor self-approval | Architect post-review |
| `constitutional` | domain-local | Domain Owner | Architect post-review |
| `constitutional` | cross-domain | Architect | Affected domains |
| `constitutional` | global | Architect | All executors |
| `migration-required` | Any | Architect | All affected domains |

### Scope Judgment Criteria

| Condition | Scope |
|---|---|
| Closes within one domain, no external consumers | `domain-local` |
| Affects contracts/entities referenced by other domains | `cross-domain` |
| Changes Shared Surfaces Registry items | `cross-domain` (minimum) |
| Auth model, deployment model, tech stack changes | `global` |
| Global invariant changes | `global` |

### Periodic Audits

Three audits run at milestone completion (or periodically, project decides frequency). Keep lightweight — flag issues, do not rewrite.

**Boundary Audit** — Did recent changes land in the correct layer?

| Check | Question |
|---|---|
| CDD purity | Did any schedule, scope, or execution procedure leak into CDD? |
| SDD purity | Did any system truth, invariant, or architecture leak into SDD? |
| ADD purity | Did any system scope, contract, or task plan leak into ADD? |
| Governance purity | Did governance redefine CDD/SDD/ADD content instead of controlling approval? |

**Parallel Audit** — Were shared surface rules followed?

| Check | Question |
|---|---|
| Claims | Were all shared surface modifications preceded by a claim? |
| Conflicts | Were concurrent claim conflicts resolved via Domain Owner or Architect? |
| Migrations | Did schema migrations follow the migration queue sequence? |
| Contracts | Were contract-first rules followed for cross-scope dependencies? |

**Drift Audit** — Does CDD Constitutional match reality?

| Check | Question |
|---|---|
| Machine reconstruction | Can a new executor reconstruct core system from Tier 2 alone? |
| Human reconstruction | Can a developer onboard + implement from Tier 3 alone? |
| Constitutional accuracy | Does CDD Constitutional still match the actual implemented system? |
| Coverage | Are all required 3-axis categories filled or marked N/A? |
| Operational creep | Has any Operational content become de facto binding without promotion? |

### Change Notification Rules

| Scope | Who to Notify | When |
|---|---|---|
| domain-local | Domain executors | After approval |
| cross-domain | Affected domain owners + executors | Before merge |
| global | All executors + all domain owners | Before merge |

### Post-Review SLA (Recommended)

| Change Level | Recommended Response Time |
|---|---|
| `editorial` / `clarification` | No SLA (post-review) |
| `constitutional` domain-local | Within same work session |
| `constitutional` cross-domain | Within 4 hours |
| `constitutional` global | Within 1 business day |
| `migration-required` | Within 1 business day |

## Summary: Policy vs Roadmap

### Active Now

- Core Philosophy
- Collaboration Model (Architect / Domain Owner / Executor)
- CDD 3-Classification (Constitutional / Operational / Reference)
- CDD 4-Tier Structure
- SDD 3-Layer Planning + Phase 2 Workflow
- ADD Execution + Deficiency Handling
- Governance (Approval Matrix, Scope Judgment, Audit)

### Future Roadmap

| Component | Phase |
|---|---|
| SDD Learning Loop | Medium-term |
| ADD Multi-Executor Consensus | Medium-term |
| ADD Experience Distillation | Long-term |
| Custom Executor Ecosystem | Long-term |

## References

| Policy | File | Status |
|---|---|---|
| CDD | `docs/llm/policies/cdd.md` | Active |
| CDD Operations | `docs/llm/policies/cdd-operations.md` | Active |
| SDD | `docs/llm/policies/sdd.md` | Active |
| ADD | `docs/llm/policies/add.md` | Active |
| TOKEN | `docs/llm/policies/token-optimization.md` | Active |
| MONOREPO | `docs/llm/policies/monorepo.md` | Active |

---

_Full details: `development-methodology-details.md`_
