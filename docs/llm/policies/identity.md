# Identity Anchor

> Fixed definitions that all documents must follow | **Last Updated**: 2026-03-15

## Methodology Identity

This methodology is designed for **AI-native organizations**.

- LLM-enabled execution is assumed, not optional
- Humans are approvers, exception judges, and final reviewers — not routine operators
- Automation is the default execution path

## Fixed Definitions

| Term | Definition |
| ---- | ---------- |
| **CDD** | System SSOT and reconstruction baseline |
| **SDD** | CDD-derived change plan |
| **ADD** | Autonomous execution and policy selection engine |
| **Human** | Approver, exception judge, final reviewer |

These definitions must not drift across documents. All other files must use these exact definitions or short restatements that preserve meaning.

## Core Loop

```
CDD (System Memory) → SDD (Change Plan) → ADD (Auto-Execution) → CDD (Feedback)
```

## Layer 3 Sufficiency Checklist

Layer 3 exists for human understanding, review, audit, and onboarding. It is NOT an alternative execution path.

Layer 3 is sufficient when:

- [ ] A person can explain the system's purpose from Layer 3 alone
- [ ] A person can review contracts, boundaries, and constraints from Layer 3 alone
- [ ] A person can perform change review from Layer 3 alone
- [ ] Layer 3 conveys Layer 2 meaning without omission

Layer 3 is NOT required to enable:

- Direct implementation by humans
- Human-driven execution as a fallback path

## CDD Internal Classification

| Classification | Nature | Mutability |
| -------------- | ------ | ---------- |
| **Constitutional** | Normative — violation forbidden | Requires approval |
| **Operational** | Advisory — best practices | Accumulates over time |
| **Reference** | Informational — catalogs and indexes | Updated after task completion |

## References

- Methodology: `docs/llm/policies/development-methodology.md`
- CDD: `docs/llm/policies/cdd.md`
- SDD: `docs/llm/policies/sdd.md`
- ADD: `docs/llm/policies/add.md`
