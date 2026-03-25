# ADD (Agent-Driven Development)

> Autonomous execution and policy selection engine for AI-native organizations | Last Updated: 2026-03-25

## Definition

> Fixed definition: `identity.md`

ADD is the **autonomous execution and policy selection engine** of the AI-native organization.

ADD reads change plans, classifies work types, selects appropriate policies and skills, and auto-executes within CDD constraints.

```
ADD = Work type classification + policy selection + skill selection + autonomous execution
```

The primary execution path is **Layer 2 → ADD**. This is not optional — it is the default operating mode.

## Purpose

- Classify work type
- Select appropriate execution policy
- Select appropriate skill / workflow / toolchain
- Execute autonomously within CDD constraints
- Escalate to humans only when necessary
- Verify automatically
- Feed confirmed knowledge back to CDD after completion

## Questions ADD Answers

- What type of work is this?
- Which execution policy should apply?
- Which skill or workflow is needed?
- Can this be judged automatically?
- When should a human be consulted?
- What should be reflected in CDD after completion?

## System Position

```
CDD (System Memory) ──constraints──→ ADD ──feedback──→ CDD
                                      ↑
SDD (Change Plan) ──────tasks──────→ ADD ──progress──→ SDD
```

| Input | Source | Purpose |
| ----- | ------ | ------- |
| Constraints, patterns, domain model | CDD | Execution boundaries |
| Change plan, task list | SDD | What to execute |
| Execution policies | ADD internal | How to execute |

| Output | Destination | Purpose |
| ------ | ----------- | ------- |
| Implemented changes | Codebase | Deliverable |
| Confirmed knowledge | CDD | Feedback loop |
| Progress updates | SDD | Task tracking |

## Work Type Classification

ADD must classify each piece of work:

| Work Type | Description |
| --------- | ----------- |
| Feature addition | New functionality |
| Feature modification | Change existing behavior |
| Bug fix | Correct defect |
| Contract change | Modify external interface |
| Refactoring | Restructure without behavior change |
| Code quality improvement | Linting, typing, coverage |
| Frontend work | UI/UX implementation |
| Backend work | API/service implementation |
| Migration | Data or schema migration |
| Test strengthening | Add/improve tests |
| Docs/policy update | Documentation or policy changes |

## Policy Registry

ADD selects the appropriate execution policy based on work type. Policies define constraints and patterns for each category.

| Policy | When Applied | Key Constraint |
| ------ | ------------ | -------------- |
| `feature-addition` | Adding new capabilities | CDD basis required; spec-first |
| `bug-fix` | Correcting defects | Regression test required |
| `regression-safe` | Changes with high regression risk | Full test suite before merge |
| `migration-safe` | Data or schema migrations | Rollback plan required |
| `frontend` | UI/UX changes | Design spec reference |
| `backend-contract` | API contract modifications | Constitutional — may require approval |
| `refactor` | Structural changes without behavior change | No behavior change verification |
| `quality-improvement` | Coverage, linting, typing improvements | No functional change |

> Policy details will be defined in separate files as each policy matures. Until then, this registry is the canonical list.

## Skill Registry

ADD selects the appropriate skill/workflow based on the work's technical domain.

| Skill | Scope | Typical Toolchain |
| ----- | ----- | ----------------- |
| `frontend` | UI components, pages, styling | React, CSS, Storybook |
| `backend` | APIs, services, data layer | NestJS, Prisma, GraphQL |
| `migration` | Schema changes, data transforms | Prisma migrate, SQL |
| `refactor` | Code restructuring | AST tools, IDE refactoring |
| `testing` | Test creation, coverage improvement | Jest, Playwright |
| `docs-policy` | Documentation, policy updates | Markdown, YAML |

> Skill details will be defined in separate files as each skill matures. Until then, this registry is the canonical list.

## Autonomous Decision Process

```
1. Determine work type
   └── What kind of change is this?

2. Assess scope and risk
   └── Can this proceed autonomously, or does it require approval?

3. Select execution policy
   └── Which constraints and patterns apply? (from CDD)

4. Select skill / workflow / toolchain
   └── What tools and approaches fit this work?

5. Execute
   └── Carry out the work within CDD constraints

6. Verify
   └── Tests, lint, build, contract checks

7. Report and feedback
   └── Update SDD progress; feed confirmed knowledge to CDD
```

## Scope

### ADD Contains

- Work type classification
- Execution policy selection
- Skill/workflow selection
- Autonomous execution
- Automatic verification
- Stop/resume capability
- Deficiency handling
- Escalation
- CDD feedback after completion

### ADD Does NOT Contain

- System identity redefinition (→ CDD)
- Change scope definition itself (→ SDD)
- Excessive human operational rules
- Project governance as a primary function

## Entry Points

```
AGENTS.md → executor config (CLAUDE.md / GEMINI.md) → .add/
(router)    (executor-specific)                        (workflow details)
```

| File | Purpose |
| ---- | ------- |
| `AGENTS.md` | Shared router — executor-agnostic, <50 lines |
| `CLAUDE.md` / `GEMINI.md` | Executor-specific config |
| `.add/` | Project workflow directory — see convention below |

## .add/ Directory Convention

Every project using ADD maintains a `.add/` directory as the **workflow execution layer**. This directory is the concrete implementation of ADD for that project.

### File Types

| Type | Role | Examples |
| ---- | ---- | -------- |
| Workflow | Executable steps for a specific trigger | `implementation.md`, `bug-fix.md`, `code-review.md` |
| Reference | Read before execution — cross-cutting rules | `best-practices.md`, `performance.md`, `skills.md` |
| Index | Navigation entry point — which file to use | `README.md` |
| Redirect | Points to canonical workflow, no duplicate content | `feature-addition.md → implementation.md` |

### Required Files

| File | Type | Purpose |
| ---- | ---- | ------- |
| `README.md` | Index | Trigger → workflow selection table; reference doc map; SSOT ownership map |
| `best-practices.md` | Reference | Cross-cutting project rules read before all execution |
| `skills.md` | Reference | Project skill registry — stacks, crates, file ownership per domain |
| `escalation.md` | Workflow | When and how to escalate to humans |

### SSOT Principles

| Principle | Rule |
| --------- | ---- |
| One fact, one file | Each rule or pattern lives in exactly one `.add/` or CDD file — never duplicated |
| Workflow deduplication | If two workflows share the same steps, one becomes a redirect to the other |
| Reference over copy | Workflow files reference CDD docs for patterns; they do not copy CDD content inline |
| Ownership declared | `README.md` declares which file owns which content domain |

### Workflow File Structure

Each workflow file follows this standard layout:

```markdown
# <Workflow Name>

> ADD Execution | Last Updated: YYYY-MM-DD

## Trigger
<one-line condition that activates this workflow>

## Read Before Execution
<table: doc | path | when>

## Execution
<table: step | action>

## Rules
<table: rule | detail>
```

### Deduplication Pattern

When a work type maps naturally to an existing workflow, create a redirect instead of a duplicate:

```markdown
# Feature Addition

> ADD — Redirect | Last Updated: YYYY-MM-DD

Use `implementation.md`. Feature addition and implementation share the same workflow.

Key difference: if no spec exists, create `.specs/{app}/scopes/{scope}.md` before Step 1.
```

## Spec-First Validation

Before executing, ADD validates that a spec exists:

```
Request: "Implement X"
    │
    v
Read .specs/{app}/roadmap.md
    │
    v
Keyword search
    │
    ├── Found → Read tasks/{scope}/ → Execute
    └── Not found → Escalate: "No spec. Create spec first?"
```

## Execution Modes

### Single Executor
```
Request → AGENTS.md → Executor → Implementation
```

### Parallel Execution
```
Orchestrator (reads tasks.md)
    ├── Executor 1 (Task A) ──\
    ├── Executor 2 (Task B) ───┼── Merge results
    └── Executor 3 (Task C) ──/
```

### Git Worktree (Parallel Isolation)
```bash
git worktree add ../project-task-a -b feat/task-a
git worktree add ../project-task-b -b feat/task-b
```

## Escalation Protocol

ADD operates autonomously by default. Escalation to humans occurs only when necessary.

```yaml
level_1_self_resolution:
  actions:
    - Re-read relevant CDD docs
    - Search codebase for precedents
    - Run tests to validate assumptions
  escalate_if: 'Cannot resolve with available information'

level_2_escalation:
  to: Human
  provides:
    - Context summary
    - What was attempted
    - Specific question or decision needed
    - Options with trade-offs
  human_responds_by:
    - Updating CDD (missing pattern/constraint)
    - Updating SDD (unclear requirement)
    - Direct guidance (one-time decision)
```

### When to Escalate

| Escalate | Do NOT Escalate |
| -------- | --------------- |
| System identity change | Routine implementation decisions |
| Unresolved CDD ambiguity | Standard error resolution |
| Policy conflict | Toolchain selection |
| Insufficient auto-judgment confidence | Test failures with clear cause |
| High-risk contract change | Refactoring within established patterns |
| Scope boundary unclear | |
| Irreversible action with uncertain outcome | |

## Human Intervention

**Humans do NOT write code or manage execution.** For full human role definition, see `development-methodology.md#human-role`.

When escalation occurs:

1. Review the escalation report
2. Identify root cause
3. Update the appropriate layer:
   - Missing pattern → CDD (Operational)
   - Missing constraint → CDD (Constitutional — requires approval)
   - Unclear requirement → SDD
   - One-time decision → Direct guidance
4. ADD resumes execution

## CDD Feedback

After execution completes, ADD evaluates what was learned. For canonical CDD update rules, see `cdd.md#cdd-update-rules`.

| CDD Classification | Condition | Action |
| ------------------- | --------- | ------ |
| Constitutional | System identity/boundary/contract changed | Update (requires approval) |
| Operational | New pattern confirmed through use | Update (accumulate) |
| Reference | Feature/API/screen catalog changed | Update (index refresh) |
| None | No new stable knowledge | Archive in SDD history only |

Only **confirmed, stable knowledge** enters CDD.

## Verification

After work completion:

- [ ] Tests pass
- [ ] Lint passes
- [ ] Build succeeds
- [ ] SDD tasks marked complete
- [ ] CDD updated if new knowledge confirmed
- [ ] Completed scope archived to history/

## Best Practices

| Practice | Rule |
| -------- | ---- |
| Autonomous first | Attempt self-resolution before escalating |
| Classify work type | Always determine work type before execution |
| Select policy | Choose appropriate execution policy from registry |
| Spec-first | Validate spec exists before implementing |
| CDD-constrained | Never violate Constitutional constraints without escalation |
| Small, verifiable steps | Break work into independently verifiable chunks |
| Selective feedback | Only feed confirmed knowledge back to CDD |
| Minimal escalation | Escalate decisions, not status updates |

## References

- Identity anchor: `docs/llm/policies/identity.md`
- CDD: `docs/llm/policies/cdd.md`
- SDD: `docs/llm/policies/sdd.md`
- Methodology: `docs/llm/policies/development-methodology.md`
- Token Optimization: `docs/llm/policies/token-optimization.md`
