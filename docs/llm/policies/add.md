# ADD (Agent-Driven Development)

> Autonomous execution engine | Last Updated: 2026-03-15

## Definition

ADD is the **autonomous execution engine** that carries out SDD change plans within CDD constraints. ADD does not merely execute tasks — it determines work type, selects execution policy, chooses appropriate skills and toolchains, and proceeds autonomously.

```
ADD = Autonomous judgment + policy selection + execution within CDD constraints
```

## System Position

```
CDD (SSOT) ──constraints──→ ADD ──feedback──→ CDD
                              ↑
SDD (Change Plan) ──tasks──→ ADD ──progress──→ SDD
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

## Autonomous Decision Process

When ADD receives work, it follows this judgment sequence:

```
1. Determine work type
   └── What kind of change is this? (add / change / delete / migrate / improve)

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

## Entry Points

```
AGENTS.md → CLAUDE.md / GEMINI.md → .ai/workflows/
(router)    (executor config)       (workflow details)
```

| File | Purpose |
| ---- | ------- |
| AGENTS.md | Shared router (<50 lines) |
| CLAUDE.md | Claude-specific config |
| GEMINI.md | Gemini-specific config |

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
# Executors work isolated, merge when done
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
| Ambiguous requirement with multiple valid interpretations | Routine implementation decisions |
| CDD constraint conflict | Standard error resolution |
| Scope boundary unclear | Toolchain selection |
| Security/compliance decision needed | Test failures with clear cause |
| Irreversible action with uncertain outcome | Refactoring within established patterns |

## Human Intervention

**Humans do NOT write code or manage execution.**

When escalation occurs:

1. Review the escalation report
2. Identify root cause
3. Update the appropriate layer:
   - Missing pattern → CDD
   - Unclear requirement → SDD
   - One-time decision → Direct guidance
4. ADD resumes execution

## CDD Feedback

After execution completes, ADD evaluates what was learned:

| Condition | Action |
| --------- | ------ |
| New pattern confirmed through use | Update CDD policies/ |
| New domain boundary discovered | Add CDD domain folder |
| External contract changed | Update CDD contract docs |
| No new stable knowledge | Archive in SDD history only |

Only **confirmed, stable knowledge** enters CDD. Experimental or one-time solutions do not.

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
| Spec-first | Validate spec exists before implementing |
| CDD-constrained | Never violate CDD constraints without escalation |
| Small, verifiable steps | Break work into independently verifiable chunks |
| Classify work type | Always determine add/change/delete/migrate/improve |
| Selective feedback | Only feed confirmed knowledge back to CDD |
| Minimal escalation | Escalate decisions, not status updates |

## References

- CDD: `docs/llm/policies/cdd.md`
- SDD: `docs/llm/policies/sdd.md`
- Methodology: `docs/llm/policies/development-methodology.md`
- Token Optimization: `docs/llm/policies/token-optimization.md`
