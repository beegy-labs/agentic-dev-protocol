# Development Methodology

> CDD-Driven Autonomous Development for AI-Native Organizations | **Last Updated**: 2026-03-15

## Identity

> Fixed definitions: `identity.md`

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

The center is CDD, not code. All planning and execution reference CDD. Code is a deliverable; the system's essence is defined in CDD.

### 2. Reconstruction-First Principle

CDD alone must enable rebuilding a system with identical functionality and system identity, even if all code is lost. For reconstruction criteria details, see `cdd.md#core-property-reconstructability`.

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
| **CDD** | System SSOT and reconstruction baseline | Even without code, the system can be rebuilt |
| **SDD** | CDD-derived change planning | Every plan traces back to CDD constraints |
| **ADD** | Autonomous execution engine | Classifies work, selects policy/skill, executes within CDD constraints |
| **Human** | Approver, exception judge, final reviewer | Intervenes only when automation cannot safely proceed |

## Human Role

Humans are the organization's **approvers, exception judges, and final reviewers**. For detailed escalation protocol and intervention rules, see `add.md#escalation-protocol`.

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
| Identity | `docs/llm/policies/identity.md` | Active |
| CDD | `docs/llm/policies/cdd.md` | Active |
| SDD | `docs/llm/policies/sdd.md` | Active |
| ADD | `docs/llm/policies/add.md` | Active |
| Token Optimization | `docs/llm/policies/token-optimization.md` | Active |
| Monorepo Structure | `docs/llm/policies/monorepo.md` | Active |

## References

- Identity anchor: `docs/llm/policies/identity.md`
- Full details: `development-methodology-details.md`
- CDD Policy: `docs/llm/policies/cdd.md`
- SDD Policy: `docs/llm/policies/sdd.md`
- ADD Policy: `docs/llm/policies/add.md`
