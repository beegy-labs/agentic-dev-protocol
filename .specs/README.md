# SDD (Spec-Driven Development)

> Development Blueprints | Human-Commanded Staged Auto-Design

## Purpose

This directory contains **development specifications** that define WHAT to build, WHEN to build it, and HOW to implement it.

## Structure

```
.specs/
├── README.md                # This file
├── roadmap.md               # L1: WHAT - Overall features & direction
│
├── scopes/                  # L2: WHEN - Work range extraction
│   ├── 2026-Q1.md          # Example: Q1 scope
│   └── 2026-Q2.md          # Example: Q2 scope
│
├── tasks/                   # L3: HOW - Detailed implementation plans
│   ├── 2026-Q1.md          # Example: Q1 tasks (references CDD)
│   └── 2026-Q2.md          # Example: Q2 tasks
│
└── history/                 # L4: DONE - Completed archives
    ├── scopes/              # Archived completed scopes
    │   └── 2026-01-feature-name.md
    └── decisions/           # Decision records
        └── 2026-01-21-decision-topic.md
```

## 3-Layer Structure: WHAT → WHEN → HOW

| Layer       | File                | Purpose           | Human Role       | LLM Role |
| ----------- | ------------------- | ----------------- | ---------------- | -------- |
| **Roadmap** | `roadmap.md`        | **WHAT** to build | Design & Plan    | Document |
| **Scope**   | `scopes/{scope}.md` | **WHEN** to build | Define range     | Document |
| **Tasks**   | `tasks/{scope}.md`  | **HOW** to build  | Review & Approve | Generate |

## Workflow

1. **[Human→LLM] Roadmap Design**: Human designs overall direction, LLM documents
2. **[Human→LLM] Scope Definition**: Human defines work range, LLM documents
3. **[LLM] Task Generation**: LLM generates detailed tasks referencing CDD
4. **[Human] Task Review & Approval**: Commander reviews and approves execution plan
5. **[LLM] Execution (ADD Phase)**: Coder LLM implements tasks
6. **[System] Completion & Archive**: Merge to history, update CDD

## Token Load Strategy

| Situation       | Load                                    | Skip                           |
| --------------- | --------------------------------------- | ------------------------------ |
| **Planning**    | `roadmap.md`                            | scopes, tasks, history         |
| **Work Start**  | `scopes/{scope}.md`, `tasks/{scope}.md` | roadmap, other scopes, history |
| **Continue**    | `tasks/{scope}.md`                      | Everything else                |
| **Review Done** | `history/scopes/{scope}.md`             | Active files                   |

## Task Execution Modes

Tasks can be designated as **parallel** or **sequential**:

```yaml
execution_order:
  - phase: 1
    mode: parallel      # Independent tasks, run simultaneously
    tasks:
      - Task A
      - Task B

  - phase: 2
    mode: sequential    # Dependent tasks, run in order
    tasks:
      - Task C (waits for Phase 1)
      - Task D (waits for Task C)
```

## Multi-Scope Support

Multiple developers can work on different scopes simultaneously without conflicts:

- Person A: `scopes/2026-Q1.md` + `tasks/2026-Q1.md`
- Person B: `scopes/2026-Q2.md` + `tasks/2026-Q2.md`
- No Git conflicts, independent progress

## History File Naming

Archive files should use descriptive names:

```
history/scopes/{YYYY-MM}-{descriptive-name}.md
history/decisions/{YYYY-MM-DD}-{decision-topic}.md

Examples:
- 2026-01-auth-service-implementation.md
- 2026-02-15-database-migration-strategy.md
```

## Best Practices

| Practice                 | Description                                    |
| ------------------------ | ---------------------------------------------- |
| Roadmap = Planning only  | Do not load during implementation              |
| Scope = 1 person 1 scope | Separate scopes for concurrent work            |
| Tasks = CDD reference    | Always consult CDD for implementation patterns |
| Tasks = Explicit modes   | Clearly mark parallel vs sequential tasks      |
| History = Archive only   | Skip during active work                        |

---

**Full SDD Policy**: `docs/llm/policies/sdd.md`
