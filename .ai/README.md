# Agentic Development Protocol

> Layer 1 - Machine Pointer (≤50 lines) | AI-Native Organization

## Identity

This methodology assumes AI-native organizations. LLM execution is the default path.

```
CDD (System Memory) → SDD (Change Plan) → ADD (Auto-Execution) → CDD (Feedback)
```

## Read First

| Document | Purpose |
| -------- | ------- |
| `docs/llm/policies/identity.md` | Fixed definitions — read before any work |
| `docs/llm/policies/development-methodology.md` | System architecture overview |

## Core Policies

| Policy | SSOT |
| ------ | ---- |
| CDD | `docs/llm/policies/cdd.md` |
| SDD | `docs/llm/policies/sdd.md` |
| ADD | `docs/llm/policies/add.md` |
| Token Optimization | `docs/llm/policies/token-optimization.md` |
| Monorepo | `docs/llm/policies/monorepo.md` |

## Layer Structure

| Layer | Path | Purpose |
| ----- | ---- | ------- |
| 1 | `.ai/` | Machine pointer (this file) |
| 2 | `docs/llm/` | Machine SSOT |
| 3 | `docs/en/` | Human understanding (auto-generated) |
| 4 | `docs/{locale}/` | Translation (auto-generated) |

## Must-Check Before Work

- Read `identity.md` for fixed definitions
- Read relevant CDD domain docs before implementation
- Validate spec exists before executing (spec-first)
