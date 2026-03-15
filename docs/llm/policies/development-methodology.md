# Development Methodology

> CDD-Driven Autonomous System Delivery | **Last Updated**: 2026-03-15

## Core Philosophy

### Primary Goal

Build a **self-sustaining delivery system** where CDD is the single source of truth, SDD plans changes against CDD, and ADD autonomously executes — with humans intervening only for approval, ambiguity, and exceptions.

### Design Principle

This is a **system architecture for automated software evolution**, not a team collaboration manual.

```
CDD (Knowledge) → SDD (Change Plan) → ADD (Execution) → CDD (Feedback)
```

### Key Properties

| Property | Description |
| -------- | ----------- |
| CDD Reconstructability | If all code is lost, CDD alone enables reconstruction of an equivalent system |
| SDD Derivability | Every change plan is derived from CDD, not invented independently |
| ADD Autonomy | Execution proceeds without human involvement unless escalation is required |
| Minimal Human Role | Humans approve, review, and resolve exceptions — they do not operate |

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
| **ADD** | Autonomous judgment + execution engine | Selects policy, skill, toolchain; executes within CDD constraints |
| **Human** | Approval / exception / final decision | Intervenes only when automation cannot safely proceed |

## Human Role

Humans are **not primary operators**. The system is designed so that normal work proceeds without constant human coordination.

| Human Does | Human Does NOT |
| ---------- | -------------- |
| Approve scope-level plans | Write implementation code |
| Resolve ambiguity when escalated | Manage task-level progress |
| Make decisions automation cannot | Coordinate execution details |
| Review final output | Debug routine issues |
| Update CDD when patterns emerge | Operate the system day-to-day |

## Feedback Loop

```
Execution Complete
    │
    ├── New pattern discovered? → Update CDD (policies, domain docs)
    ├── New domain boundary? → Update CDD (structure)
    ├── Contract changed? → Update CDD (contracts)
    └── No new knowledge → Archive in SDD history only
```

CDD is the **input** to execution and the **output** of learning. It must never become a project management checklist.

## Active Components

| Component | Policy | Status |
| --------- | ------ | ------ |
| CDD | `docs/llm/policies/cdd.md` | Active |
| SDD | `docs/llm/policies/sdd.md` | Active |
| ADD | `docs/llm/policies/add.md` | Active |
| Token Optimization | `docs/llm/policies/token-optimization.md` | Active |
| Monorepo Structure | `docs/llm/policies/monorepo.md` | Active |

## References

- Full details: `development-methodology-details.md`
- CDD Policy: `docs/llm/policies/cdd.md`
- SDD Policy: `docs/llm/policies/sdd.md`
- ADD Policy: `docs/llm/policies/add.md`
