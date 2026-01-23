# LLM Development Protocol

> CDD Tier 1 - Indicator (≤50 lines) | Multi-LLM Compatible

## Tier 1 Role

| Rule        | Description                                    |
| ----------- | ---------------------------------------------- |
| Max Lines   | ≤50 lines per file                             |
| Purpose     | Quick reference, SSOT links                    |
| Detail      | Refer to `docs/llm/policies/` (Tier 2)         |
| Methodology | `docs/llm/policies/development-methodology.md` |

## Core Methodology

| Policy | Purpose                      | SSOT                           |
| ------ | ---------------------------- | ------------------------------ |
| CDD    | Context-Driven Development   | `docs/llm/policies/cdd.md`     |
| SDD    | Spec-Driven Development      | `docs/llm/policies/sdd.md`     |
| ADD    | Agent-Driven Development     | `docs/llm/policies/add.md`     |

## Development Flow

```
CDD (HOW - Patterns) → SDD (WHAT - Tasks) → ADD (DO - Execution)
```

| Phase | Focus              | Output             |
| ----- | ------------------ | ------------------ |
| CDD   | Patterns & Context | Documentation      |
| SDD   | Task Planning      | tasks/{scope}.md   |
| ADD   | Execution          | Code & CDD updates |

## Quick Links

| Topic       | Tier 2 SSOT                                        |
| ----------- | -------------------------------------------------- |
| Methodology | `docs/llm/policies/development-methodology.md`     |
| Details     | `docs/llm/policies/development-methodology-details.md` |

**CDD Policy**: `docs/llm/policies/cdd.md`
