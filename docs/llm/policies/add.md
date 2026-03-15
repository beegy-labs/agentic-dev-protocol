# ADD (Agent-Driven Development)

> Execution, verification, and escalation procedures | **Last Updated**: 2026-03-14

## Definition

ADD defines **how to execute** approved SDD tasks. It governs execution procedures, verification, escalation, stop/resume behavior, and CDD update procedures.

**Principle**: Executors implement, architects approve.

**ADD does not define** system scope, contracts, architectural decisions, or task planning.

## CDD / SDD / ADD Separation

| | CDD | SDD | ADD |
|---|---|---|---|
| Question | What is this system? | What do we build when? | **How do we execute?** |
| Content | Identity, constraints | Plans, coordination | **Execution, verification, escalation** |

### What ADD Defines

- Procedure to read CDD and execute SDD tasks
- CDD Constitutional read-only enforcement during execution
- Deficiency discovery behavior (stop, report, resume)
- Self-resolution and escalation protocol
- Task-level verification
- CDD update procedures (Operational, Reference, promotion)

### What ADD Does NOT Define

- System specification (→ CDD)
- Task planning, scheduling, coordination (→ SDD)
- Approval rules, audit cadence (→ Governance)

## Relationship

```
CDD (IDENTITY) --constrains--> SDD (PLAN) --executed-by--> ADD (DO)
    ^                                                         |
    +------------------ updates (Operational/Reference) ------+
```

| Phase | Layer | Input | Output |
|---|---|---|---|
| CDD | Identity | Architecture decisions | Constitutional + Operational + Reference |
| SDD | Planning | Roadmap + CDD Constitutional | Scopes + Tasks + Claims |
| ADD | Execution | Approved tasks + CDD | Code + CDD updates |

## CDD Constitutional Read-Only Rule

During ADD execution:
- Load CDD Constitutional on entry (mandatory)
- Direct modification of CDD Constitutional is prohibited
- Implementation without CDD basis is prohibited (for non-IMPL_DETAIL items)
- CDD Operational and Reference may be updated

## Entry Points

```
AGENTS.md -> CLAUDE.md / GEMINI.md -> .ai/workflows/
(router)    (user creates)           (details)
```

| File | Purpose |
|---|---|
| AGENTS.md | Shared router (<50 lines) |
| CLAUDE.md | Claude-specific (user creates) |
| GEMINI.md | Gemini-specific (user creates) |

## Spec-First Validation

```
User: "Implement X"
    |
    v
Read .specs/{app-name}/roadmap.md
    |
    v
Keyword search
    |
    +-> Found -> Read tasks/{scope}/ -> Check CDD basis -> Implement
    +-> Not found -> "[!] Create spec first?"
```

Response when no spec:
```
[!] No spec for '{keyword}'.
1. Create spec first? (Recommended)
2. Implement directly?
```

## Deficiency Handling Procedure

When a CDD gap is discovered during execution:

| Classification | Behavior |
|---|---|
| `CDD_MISSING` | Stop implementation. Propose CDD supplement. Wait for approval. Resume. |
| `CDD_AMBIGUOUS` | Stop implementation. Propose clarification. Wait for approval. Resume. |
| `SDD_MISSING` | Stop implementation. Propose SDD supplement to scope owner. Resume. |
| `IMPL_DETAIL` | Continue implementation. No CDD basis needed. |

Classification definitions are in CDD (`cdd.md` Incompleteness Taxonomy).

### Deficiency Report Format

```yaml
type: CDD_MISSING | CDD_AMBIGUOUS | SDD_MISSING
domain: auth
description: 'Refresh token rotation policy not defined'
impact: 'Cannot implement token refresh endpoint'
proposal: 'Add rotation policy to CDD Constitutional invariants'
affected_tasks: ['task-auth-003']
```

## Escalation Protocol

### Self-Resolution (Within Execution)

```yaml
step_1: Self-resolution
  - Re-read CDD (Constitutional + Operational)
  - Search codebase
  - Run tests

step_2: Peer consensus (if multi-executor)
  - condition: self-resolution fails

step_3: Escalation
  - condition: consensus fails
  - action: Report to approval authority
```

### Constitutional Change Escalation

When CDD Constitutional change is needed during ADD:

```
1. Assess change scope:
   - domain-local: change closes within one domain, no external consumers
   - cross-domain: affects contracts/entities referenced by other domains
   - global: affects auth model, deployment, tech stack, or global invariants

2. Determine affected domains

3. Stop only affected domain work (others continue)

4. Submit proposal to approval authority:
   - domain-local → Domain Owner
   - cross-domain → Architect
   - global → Architect + notify all

5. Approval received → update CDD Constitutional → notify affected → resume
```

### Scope Judgment Criteria

Defined in `development-methodology.md` Governance → Scope Judgment Criteria (SSOT). Summary:
- domain-local: closes within one domain, no external consumers
- cross-domain: affects contracts/entities referenced by other domains, or Shared Surfaces Registry items
- global: auth model, deployment model, tech stack, or global invariant changes

## Execution Modes

### Single Executor

```
User -> AGENTS.md -> Executor -> Implementation
```

### Multi-Executor (Parallel)

```
Orchestrator (reads tasks.md)
    |
    +-> Executor 1 (Task A) --\
    +-> Executor 2 (Task B) ---+-> Merge results
    +-> Executor 3 (Task C) --/
```

### Git Worktree (Parallel Isolation)

```bash
git worktree add ../project-task-a -b feat/task-a
git worktree add ../project-task-b -b feat/task-b
# Executors work isolated, merge when done
```

## Task Execution

From tasks.md:
```
Phase 1 (Parallel): Task A, B -> simultaneous
Phase 2 (Sequential): Task C -> after Phase 1
```

Progress tracking:
```
Completed: [x] Task A, B
In Progress: [ ] Task C
Blocked: [ ] Task D (waiting C)
```

## Task-Level Verification

After each task completion:
- [ ] Implementation does not violate CDD Constitutional
- [ ] SDD task completion criteria met
- [ ] Tests pass
- [ ] Lint passes
- [ ] Build succeeds
- [ ] Spec tasks checked off

## CDD Update Procedures

### Operational Update (After Task Completion)

Record implementation experience in CDD Operational:
- Patterns that worked well
- Conventions established
- Troubleshooting knowledge

Operational content is non-authoritative by default.

### Reference Update (After Scope Completion)

Update CDD Reference with cumulative artifacts:
- Feature Registry (new features implemented)
- API Catalog (new endpoints created)
- Screen Map (new screens built)

### Operational → Constitutional Promotion

When a discovered pattern may be an invariant, apply these criteria. If any is Yes, propose promotion:

| # | Criterion | Question |
|---|------|----------|
| 1 | Integrity | Does violating this break system correctness? |
| 2 | Compatibility | Does this affect cross-domain compatibility? |
| 3 | Contract | Does this change an external contract? |
| 4 | Synchronization | Does this require other executors to re-sync? |

**Promotion procedure:**
1. Record pattern in Operational
2. Evaluate against 4 criteria
3. If any Yes → propose promotion with Change Classification `constitutional`
4. Assess scope (domain-local / cross-domain / global)
5. Submit to appropriate approval authority
6. On approval → move to Constitutional + notify per scope

## Human Intervention

**Human does NOT write code.**

When escalation reaches human:
1. Review incident report
2. Identify root cause
3. Update appropriate layer:
   - Missing system identity → CDD Constitutional
   - Unclear requirement → SDD scope
   - Missing pattern → CDD Operational
4. Restart affected executors

## Agent Config

### AGENTS.md (Shared)

```markdown
## Entry
1. Read .ai/README.md
2. Check .specs/{app-name}/roadmap.md

## Rules
- No direct commit to main
- Check spec before implementation
- CDD Constitutional is read-only during execution

## Workflows
| Action | Guide |
|--------|-------|
| Implement | .ai/workflows/implementation.md |
```

## Best Practices

| Practice | Rule |
|---|---|
| Spec first | Validate SDD + CDD basis before implement |
| Small steps | Verifiable chunks |
| Update progress | Check tasks done |
| Capitalize | Update CDD Operational with patterns |
| Constitutional read-only | Never modify Constitutional during execution |
| Report deficiencies | Do not fill CDD gaps with inference |
| Scope-limited stops | Only affected domains stop on escalation |

## References

- CDD: `docs/llm/policies/cdd.md`
- SDD: `docs/llm/policies/sdd.md`
- Methodology: `docs/llm/policies/development-methodology.md`
- Token Optimization: `docs/llm/policies/token-optimization.md`
- Monorepo Structure: `docs/llm/policies/monorepo.md`
