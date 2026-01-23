# LLM Documentation

> CDD Tier 2 - SSOT (Single Source of Truth) | Detailed Specifications

## Purpose

This directory contains the **detailed specifications** referenced by Tier 1 (`.ai/`).

## Structure

| Directory      | Purpose                                    | Max Lines |
| -------------- | ------------------------------------------ | --------- |
| `policies/`    | Core methodology and policy definitions    | 200       |
| `services/`    | Service-level detailed specifications      | 200       |
| `packages/`    | Package-level documentation                | 150       |
| `apps/`        | Application-level specifications           | 150       |
| `guides/`      | Development guides and how-tos             | 150       |
| `components/`  | Component-level specifications             | 100       |
| `features/`    | Feature specifications                     | 100       |
| `templates/`   | Reusable templates                         | 100       |
| `references/`  | External knowledge and best practices      | 300       |

## Core Policies

| Policy                      | File                             |
| --------------------------- | -------------------------------- |
| Development Methodology     | `policies/development-methodology.md` |
| CDD (Context-Driven Dev)    | `policies/cdd.md`                |
| SDD (Spec-Driven Dev)       | `policies/sdd.md`                |
| ADD (Agent-Driven Dev)      | `policies/add.md`                |

## Line Limits

### Framework Documents (Exempt)

These define the methodology itself and are exempt from line limits:

- `policies/cdd.md`
- `policies/sdd.md`
- `policies/add.md`
- `policies/development-methodology.md`

### Regular Documents

| Path              | Max Lines | Rationale                     |
| ----------------- | --------- | ----------------------------- |
| `policies/`       | 200       | Core rules, frequently loaded |
| `services/`       | 200       | Per-service SSOT              |
| `guides/`         | 150       | Focused how-to, splittable    |
| `apps/`           | 150       | Per-app specification         |
| `packages/`       | 150       | Package documentation         |
| `components/`     | 100       | Single component spec         |
| `templates/`      | 100       | Small templates               |
| `features/`       | 100       | Feature specifications        |
| `references/`     | 300       | External knowledge, complete  |

**Tolerance**: 1-10 lines over limit acceptable if splitting would fragment content.

## Split Naming Conventions

When a document exceeds limits and needs splitting:

| Content Type   | Suffix Example              |
| -------------- | --------------------------- |
| Implementation | `-impl.md`                  |
| Testing        | `-testing.md`               |
| Operations     | `-operations.md`, `-ops.md` |
| Advanced       | `-advanced.md`              |
| Patterns       | `-patterns.md`              |
| Security       | `-security.md`              |
| Architecture   | `-arch.md`                  |

## Edit Rules

| DO                              | DO NOT                   |
| ------------------------------- | ------------------------ |
| Edit files in this directory    | Edit `docs/en/` directly |
| Run `pnpm docs:generate` after  | Edit `docs/kr/` directly |
| Keep files under line limits    | Skip generation step     |
| Split large files appropriately | Skip translation step    |

## Generation

```bash
# Generate Tier 3 (docs/en/) from Tier 2 (docs/llm/)
pnpm docs:generate

# Translate Tier 3 to Tier 4 (docs/kr/)
pnpm docs:translate --locale kr
```

---

**Full CDD Policy**: `policies/cdd.md`
