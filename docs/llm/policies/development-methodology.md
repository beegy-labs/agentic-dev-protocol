# Development Methodology

> CDD-Driven Autonomous System Delivery | **Last Updated**: 2026-03-15

## Purpose

Build a CDD-driven automated software evolution system satisfying all of the following simultaneously:

- CDD is the absolute SSOT of the system
- SDD transforms requested changes into executable change plans
- ADD automatically interprets and executes those plans
- Humans perform only approval, review, and exception judgment
- Completed results and confirmed knowledge feed back into CDD
- CDD alone enables reconstruction of an equivalent system even if all code is lost
- When LLM is available, automated execution must be possible
- When LLM is unavailable, humans can build and maintain the same system by reading documentation

Core loop:

```
CDD → SDD → ADD → CDD
```

CDD is both the starting point and the endpoint.

## Core Philosophy

### 2.1 CDD-Centered Principle

The center of this methodology is not humans. The center is CDD.

All planning and execution must reference CDD. Code is a deliverable; the system's essence must be defined in CDD.

### 2.2 Reconstruction-First Principle

The highest-priority property is reconstructability.

Even if all code is lost, CDD alone must enable rebuilding a system with identical functionality and identical system identity.

### 2.3 Change Derivation Principle

Changes are not invented arbitrarily. They are first interpreted against CDD, planned through SDD, and executed through ADD.

### 2.4 Auto-Execution Principle

ADD is not a simple implementation tool. ADD classifies work types, selects appropriate policies and skills, and executes automatically within its capable scope.

### 2.5 Minimal Human Intervention Principle

Humans are not routine operators. Humans are approvers, exception judges, and final reviewers.

### 2.6 Dual-Path Guarantee Principle

- When LLM/automation is available: Layer 2 alone must enable automatic interpretation and execution.
- When LLM/automation is unavailable: Layer 3 alone must enable humans to build and evolve an equivalent system.

## System Architecture

```
CDD (Reconstructable SSOT)
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
  │  determines work type → selects policy → selects skill/toolchain → executes
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
| **CDD** | Reconstructable system knowledge base | SSOT — even without code, the system can be rebuilt |
| **SDD** | CDD-derived change planning | Every plan traces back to CDD constraints |
| **ADD** | Autonomous judgment + execution engine | Classifies work, selects policy/skill/toolchain, executes within CDD constraints |
| **Human** | Approval / exception / final decision | Intervenes only when automation cannot safely proceed |

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

Summary: what must be identical is the system's essence; what may differ is the implementation approach.

## Human Role

Humans are **not primary operators**.

| Human Does | Human Does NOT |
| ---------- | -------------- |
| Approve scope-level plans | Write implementation code |
| Resolve ambiguity when escalated | Manage task-level progress |
| Make decisions automation cannot | Coordinate execution details |
| Review final output | Debug routine issues |
| Approve system identity changes | Operate the system day-to-day |

### Human Intervention Triggers

- System identity change
- Unresolved CDD ambiguity
- Policy conflict
- Insufficient auto-judgment confidence
- High-risk contract change
- Exceptional approval situations

## SSOT and No-Duplication Principle

Definitions, tables, classifications, and rule blocks must have exactly one canonical source.

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

CDD is the **input** to execution and the **output** of learning.

## Active Components

| Component | Policy | Status |
| --------- | ------ | ------ |
| CDD | `docs/llm/policies/cdd.md` | Active |
| SDD | `docs/llm/policies/sdd.md` | Active |
| ADD | `docs/llm/policies/add.md` | Active |
| Token Optimization | `docs/llm/policies/token-optimization.md` | Active |
| Monorepo Structure | `docs/llm/policies/monorepo.md` | Active |

## Final Definitions

- **CDD**: Reconstructable SSOT that enables rebuilding the system
- **SDD**: CDD-derived change planning layer
- **ADD**: Work type classification, policy selection, skill selection, and autonomous execution layer
- **Human**: Minimal-intervention authority for approval and exception judgment only

## Final Goal

- CDD alone must enable system reconstruction
- Layer 2 alone must enable machine auto-interpretation and auto-execution
- Layer 3 alone must enable humans to build an equivalent system
- SDD must transform all change requests into executable plans
- ADD must autonomously judge and execute most changes
- Humans must be approvers and exception judges, not routine operators
- All execution results must feed back into CDD to strengthen the knowledge base

One-line summary: This policy is an automated software evolution system centered on CDD — reconstructing systems, planning changes, executing automatically, with humans performing only necessary judgments.

## References

- Full details: `development-methodology-details.md`
- CDD Policy: `docs/llm/policies/cdd.md`
- SDD Policy: `docs/llm/policies/sdd.md`
- ADD Policy: `docs/llm/policies/add.md`
