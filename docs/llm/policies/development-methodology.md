# Development Methodology

> CDD-Driven Autonomous Development for AI-Native Organizations | **Last Updated**: 2026-03-15

## Identity

This methodology is designed for **AI-native organizations**.

It is not a general-purpose development process. It is an automated software evolution system where AI executors perform implementation and humans intervene only for approval, exception handling, and final review.

### Foundational Premises

- LLM-enabled execution is assumed, not optional
- CDD is the organization's system memory and reconstructable SSOT
- SDD transforms requested changes into executable plans
- ADD autonomously selects execution policy and performs implementation
- Humans are approvers, exception judges, and final reviewers — not routine operators

### Core Loop

```
CDD (System Memory) → SDD (Change Plan) → ADD (Auto-Execution) → CDD (Feedback)
```

### One-Line Definition

This methodology is an automated development methodology designed for AI-native organizations — maintaining system knowledge through CDD, planning changes through SDD, auto-executing through ADD, with humans performing only approval and exception judgment.

## Core Philosophy

### 1. CDD-Centered Principle

The center is CDD, not humans. All planning and execution reference CDD. Code is a deliverable; the system's essence is defined in CDD.

### 2. Reconstruction-First Principle

CDD alone must enable rebuilding a system with identical functionality and system identity, even if all code is lost.

### 3. Change Derivation Principle

Changes are not invented arbitrarily. They are interpreted against CDD, planned through SDD, and executed through ADD.

### 4. Auto-Execution Principle

ADD classifies work types, selects appropriate policies and skills, and executes automatically. This is the primary execution path.

### 5. Minimal Human Intervention Principle

Humans are approvers, exception judges, and final reviewers. They do not perform routine implementation or coordination.

### 6. AI-First Execution Principle

The primary execution path is Layer 2 → ADD. Layer 3 exists for human understanding, review, and onboarding — not as an alternative execution path.

## System Architecture

```
CDD (System Memory / Reconstructable SSOT)
  │
  │  defines constraints, domain model, contracts, invariants
  │
  v
SDD (Change Planning Layer)
  │
  │  derives executable change plans: add / change / delete / migrate / improve
  │
  v
ADD (Autonomous Execution Engine)
  │
  │  classifies work → selects policy → selects skill/toolchain → executes
  │
  v
CDD Update (Feedback Loop)
  │
  │  newly confirmed knowledge feeds back into CDD
  │
  └──→ CDD
```

## Layer Roles

| Layer | Role | Core Property |
| ----- | ---- | ------------- |
| **CDD** | AI organization's system memory and reconstructable SSOT | Even without code, the system can be rebuilt |
| **SDD** | CDD-derived change planning | Every plan traces back to CDD constraints |
| **ADD** | Autonomous judgment + execution engine | Classifies work, selects policy/skill, executes within CDD constraints |
| **Human** | Policy approver, exception judge, final reviewer | Intervenes only when automation cannot safely proceed |

## Reconstruction Principle

### Must Be Identical

- Provided functionality
- System boundaries
- Domain model
- External contracts
- Core state transition semantics
- Auth/authz boundaries
- Data ownership
- Core invariants
- Failure handling semantics

### May Differ

- Internal code structure
- Function/variable/class names
- Internal module decomposition
- Implementation details
- Framework-internal usage
- UI presentation
- Visual design
- Non-critical optimizations

## Human Role

Humans are the organization's **policy approvers, exception judges, and final reviewers**.

| Human Does | Human Does NOT |
| ---------- | -------------- |
| Approve scope-level plans | Write implementation code |
| Resolve ambiguity when escalated | Manage task-level progress |
| Make decisions automation cannot | Coordinate execution details |
| Review final output | Debug routine issues |
| Approve system identity changes | Operate the system day-to-day |
| Audit and onboard via Layer 3 | Execute through Layer 3 |

### Human Intervention Triggers

- System identity change
- Unresolved CDD ambiguity
- Policy conflict
- Insufficient auto-judgment confidence
- High-risk contract change
- Exceptional approval situations

## SSOT and No-Duplication Principle

| Allowed | Forbidden |
| ------- | --------- |
| Summaries | Duplicating identical definitions across files |
| Pointers / links | Silent drift between duplicated definitions |
| Short restatements with references | Multiple canonical copies |

## Feedback Loop

```
Execution Complete
    │
    ├── Constitutional knowledge changed? → CDD update (requires approval)
    ├── New operational pattern confirmed? → CDD update (accumulate)
    ├── Reference catalog changed? → CDD update (index refresh)
    └── No new knowledge → Archive in SDD history only
```

## Active Components

| Component | Policy | Status |
| --------- | ------ | ------ |
| CDD | `docs/llm/policies/cdd.md` | Active |
| SDD | `docs/llm/policies/sdd.md` | Active |
| ADD | `docs/llm/policies/add.md` | Active |
| Token Optimization | `docs/llm/policies/token-optimization.md` | Active |
| Monorepo Structure | `docs/llm/policies/monorepo.md` | Active |

## Final Definitions

- **CDD**: AI organization's system memory and reconstructable SSOT
- **SDD**: CDD-derived change planning layer
- **ADD**: Work type classification, policy selection, skill selection, and autonomous execution engine
- **Human**: Policy approver, exception judge, and final reviewer

## Final Goal

- CDD alone must enable system reconstruction
- Layer 2 → ADD is the primary execution path
- Layer 3 serves human understanding, review, audit, and onboarding
- SDD must transform all change requests into executable plans
- ADD must autonomously judge and execute most changes
- Humans must be approvers and exception judges, not routine operators
- All execution results must feed back into CDD

## References

- Full details: `development-methodology-details.md`
- CDD Policy: `docs/llm/policies/cdd.md`
- SDD Policy: `docs/llm/policies/sdd.md`
- ADD Policy: `docs/llm/policies/add.md`
