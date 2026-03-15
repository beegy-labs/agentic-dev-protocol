# Agentic Development Protocol

> A CDD-driven autonomous development methodology for AI-native organizations

## What is This?

The Agentic Development Protocol is an automated development methodology designed for AI-native organizations. In this system, AI executors (ADD) perform implementation autonomously, while humans serve as approvers, exception judges, and final reviewers.

| Component | Purpose |
| --------- | ------- |
| **CDD** | System SSOT and reconstruction baseline — the organization's system memory |
| **SDD** | CDD-derived change plan — transforms requests into executable plans |
| **ADD** | Autonomous execution engine — classifies work, selects policy/skill, auto-executes |
| **Human** | Approver, exception judge, final reviewer — not a routine operator |

## How It Works

```
CDD (System Memory) → SDD (Change Plan) → ADD (Auto-Execution) → CDD (Feedback)
```

### 1. CDD Defines the System

CDD is the system's Single Source of Truth. It defines system identity, boundaries, contracts, invariants, and reconstruction criteria. If all code were lost, CDD alone should enable rebuilding an equivalent system.

CDD knowledge is classified as:
- **Constitutional**: Normative rules that cannot be violated (domain model, contracts, invariants)
- **Operational**: Advisory patterns accumulated through implementation experience
- **Reference**: Informational catalogs (feature lists, API indexes)

### 2. SDD Plans Changes

When a change is needed, SDD interprets it against CDD and produces an executable plan:
1. Identify what to change
2. Analyze impact against CDD boundaries
3. Decompose into tasks with dependencies and ordering
4. Define completion criteria

### 3. ADD Executes Autonomously

ADD is the primary execution engine:
1. Classifies the work type (feature, bug fix, migration, etc.)
2. Selects the appropriate execution policy
3. Selects the appropriate skill/workflow
4. Executes within CDD constraints
5. Verifies (tests, lint, build)
6. Feeds confirmed knowledge back to CDD

### 4. Humans Review and Approve

Humans do not write implementation code or manage task-level execution. They:
- Approve scope-level plans
- Resolve ambiguity when escalated
- Make decisions that automation cannot safely make
- Review final output
- Approve system identity changes

## Layer Structure

The same system knowledge is expressed through 4 layers for different consumers:

| Layer | Path | Purpose | Editable |
| ----- | ---- | ------- | -------- |
| 1 | `.ai/` | Machine pointer — routes to Layer 2 with minimal tokens | Yes |
| 2 | `docs/llm/` | Machine SSOT — substantive system body for ADD | Yes |
| 3 | `docs/en/` | Human understanding — review, audit, onboarding (this layer) | Auto-generated |
| 4 | `docs/{locale}/` | Translation — Layer 3 in other languages | Auto-generated |

Layer 3 (this layer) exists for human understanding and oversight. It is **not** an alternative execution path — the primary execution path is Layer 2 → ADD.

## Getting Started

1. Read [CDD](./cdd.md) to understand the system knowledge base
2. Read [SDD](./sdd.md) to understand change planning
3. Read [ADD](./add.md) to understand autonomous execution

## Quick Reference

| I want to... | Read |
| ------------ | ---- |
| Understand system knowledge management | [CDD](./cdd.md) |
| Plan a change | [SDD](./sdd.md) |
| Understand autonomous execution | [ADD](./add.md) |
| Review fixed definitions | `docs/llm/policies/identity.md` |
