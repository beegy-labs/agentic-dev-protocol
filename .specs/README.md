# SDD Specs Directory

> Reference bootstrap — adapt to your project's needs

This directory contains SDD change plans. See `docs/llm/policies/sdd.md` for full policy.

## Structure

```
.specs/
├── README.md
└── apps/{app}/
    ├── roadmap.md            # L1: Direction (load on planning only)
    ├── scopes/               # L2: Active change scopes
    │   └── {scope}.md        # e.g. 2026-Q1.md
    ├── tasks/                # L3: Executable task lists
    │   └── {scope}.md        # e.g. 2026-Q1.md
    └── history/
        ├── scopes/           # Completed scope archives
        └── decisions/        # Decision records
```

## Usage

| Phase | Load | Skip |
| ----- | ---- | ---- |
| Planning | `roadmap.md` | `scopes/*`, `tasks/*`, `history/*` |
| Work Start | `scopes/{scope}.md`, `tasks/{scope}.md` | `roadmap.md`, other scopes, `history/*` |
| Continue | `tasks/{scope}.md` | Everything else |
| Review | `history/scopes/{scope}.md` | Active files |

## Notes

- This is a reference bootstrap, not a rigid standard
- Adapt folder structure to your project's scale
- See `docs/llm/policies/sdd.md` for templates and lifecycle rules
