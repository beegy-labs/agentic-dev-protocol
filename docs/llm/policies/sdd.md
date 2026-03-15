# Spec-Driven Development (SDD) Policy

> Temporal planning and coordination system | **Last Updated**: 2026-03-14

## Definition

SDD defines **what to build, when, and in what order**. It is the temporal planning layer that decomposes CDD's permanent system definition into time-bound scopes and tasks.

**SDD does not define** system truth, invariants, global architecture, or execution procedures.

## CDD / SDD / ADD Separation

| | CDD | SDD | ADD |
|---|---|---|---|
| Question | What is this system? | What do we build when? | How do we execute? |
| Temporality | Permanent | **Temporal** (archived on completion) | Procedural |
| Content | Identity, constraints | Plans, scopes, tasks, coordination | Execution rules |

### What SDD Defines

- Which part of CDD to build when (temporal planning)
- Task priority, order, dependencies
- Completion criteria
- Cross-scope dependencies
- Shared resource coordination (claim, queue, ordering)

### What SDD Does NOT Define

- What the system is (→ CDD Constitutional)
- Implementation patterns (→ CDD Operational)
- Execution procedures (→ ADD)
- System identity, invariants (→ CDD Constitutional)

## CDD Constitutional Basis Rule

SDD scope creation requires CDD Constitutional validation:

- Scope cannot introduce features, entities, or interfaces not defined in CDD Constitutional
- If CDD Constitutional is insufficient, supplement CDD first (Phase 2b)
- CDD Reference (Feature Registry, API Catalog) incompleteness does NOT block scope creation

## Directory Structure

```
.specs/
├── README.md
└── apps/{app}/
    ├── {feature}.md              # Spec (What to build)
    ├── roadmap.md                # L1: Master roadmap
    ├── scopes/                   # L2: Active scopes
    │   ├── 2026-Q1.md
    │   └── 2026-Q2.md
    ├── tasks/                    # L3: Scope-specific tasks
    │   ├── 2026-Q1.md
    │   └── 2026-Q2.md
    └── history/
        ├── scopes/               # Completed scope archives
        └── decisions/            # Roadmap decision records
```

## 3-Layer Work Structure

| Layer | File | Owner | Human Role |
|---|---|---|---|
| **L1 Roadmap** | `roadmap.md` | Architect | Direction (Master) |
| **L2 Scope** | `scopes/{scope}.md` | Architect+Executor | **Approval** |
| **L3 Tasks** | `tasks/{scope}.md` | Executor | Autonomous |

## Phase 2 Workflow (SDD + CDD Co-Creation)

When creating new scopes, SDD and CDD Constitutional are refined together:

```
Phase 2a: Each executor writes SDD draft (parallel, feature branches)
  - Create scopes/{scope}.md + tasks/{scope}.md
  - Based on CDD Constitutional draft from Phase 1

Phase 2b: Each executor identifies CDD Constitutional gaps
  - Propose CDD supplements as separate commits
  - Only propose for own domain

Phase 2c: Architect integrates CDD supplement proposals
  - Resolve conflicts across domains
  - Finalize CDD Constitutional
  - Determine merge order for feature branches
```

**Commit rules:**
- SDD commits and CDD commits separated within same branch
- Architect determines merge order (matters for shared entities)

## Domain Partitioning

For N parallel executors, the Architect assigns domain ownership in Phase 1:

```yaml
partitioning:
  domains:
    auth: executor-a
    payment: executor-b
    dashboard: executor-c
  shared_entities:
    User: auth (owner), payment (consumer)
    Order: payment (owner), dashboard (consumer)
  rule: 'Owner integrates fields; consumers propose via Phase 2b'
```

- Each executor proposes CDD changes only for its own domain
- Shared entities are owned by one domain; others propose additions
- Conflicts resolved by Architect in Phase 2c

## Cross-Scope Dependencies

When scope A depends on scope B's output:

```yaml
# In scopes/payment.md
depends_on:
  - scope: auth
    requires: [User entity, POST /auth/verify endpoint]
    strategy: contract-first  # auth defines contract first, payment starts
```

| Strategy | Description | When to use |
|---|---|---|
| `contract-first` | Dependency defines contract only, consumer starts immediately | Most common |
| `sequential` | Wait for dependency scope to complete | Hard dependency |
| `parallel-merge` | Both work in parallel, merge at integration point | Independent work with shared output |

## Shared Resource Coordination

Shared surfaces are defined in CDD Constitutional. SDD manages **how** they are coordinated:

| Resource Type | Coordination Method |
|---|---|
| Shared Schema (DB) | Register in migration queue, sequence-number based |
| Shared Packages | Claim → work → release (lock model) |
| Shared Contracts | Provider registers contract first → consumer references |
| Shared Config | Addition is free; modification/deletion requires claim |
| Shared CI Surface | Claim required, concurrent modification prohibited |
| Test Fixtures | Domain-separated; shared fixtures require claim |

**Claim rules:**
- Claims are declared in SDD task items
- Concurrent claim conflict → escalate to approval authority (Domain Owner or Architect)
- Modifying shared surface without claim is prohibited

**Ownership rules:**
- Each shared surface has exactly one owner domain (registered in CDD)
- Owner domain may modify freely; consumer domains must claim
- Ownership transfer requires Architect approval (constitutional change)

**Claim Ledger:**

All claims are tracked in a single ledger file: `.specs/claims.yml`

```yaml
# .specs/claims.yml
claims:
  - surface: 'users table schema'
    owner: executor-a
    scope: 2026-Q1
    status: active        # claimed | active | released | expired
    acquired: 2026-01-15
    timeout: scope-completion
  - surface: '@org/auth-utils interface'
    owner: executor-b
    scope: 2026-Q2
    status: claimed
    acquired: 2026-02-01
    timeout: 2026-02-15   # explicit deadline
```

| Field | Required | Description |
|---|---|---|
| surface | Yes | Shared surface name (must match CDD registry) |
| owner | Yes | Executor or domain holding the claim |
| scope | Yes | SDD scope the claim belongs to |
| status | Yes | `claimed` → `active` → `released` or `expired` |
| acquired | Yes | Date claim was acquired |
| timeout | Yes | `scope-completion` or explicit date |

**Claim lifecycle:**

| Phase | Rule |
|---|---|
| Acquire | Declare in `.specs/claims.yml` before starting work |
| Activate | Set to `active` when work begins on the surface |
| Release | Set to `released` on task completion or scope archive |
| Timeout | Claims expire when timeout date passes or scope completes |
| Conflict | First claim wins; second claim must wait or escalate |
| Escalation | Domain Owner resolves within-domain; Architect resolves cross-domain |

**Timeout and takeover rules:**

| Situation | Rule |
|---|---|
| Task completed | Claim auto-released |
| Scope archived | All scope claims auto-released |
| Explicit timeout passed | Claim status → `expired` |
| Owner unresponsive (no progress for 2+ working days) | Claim considered abandoned |
| Abandoned claim | Any executor may request takeover via Domain Owner |
| Takeover procedure | Domain Owner approves → new owner updates ledger → notify original owner |
| Domain Owner unresponsive | Escalate to Architect for takeover approval |

**Migration queue rules (Shared Schema):**
- Each migration gets a monotonic sequence number
- Only one executor writes to migration queue at a time
- Executor must claim the queue, apply migration, release
- Conflicting schema changes → Architect resolves ordering

**Contract-first rules (Shared Contracts):**
- Provider publishes contract (interface only, no implementation) before consumer starts
- Consumer may begin work once contract is committed to branch
- Contract changes after consumer starts require cross-domain escalation
- Contract must include: endpoint, input/output shape, error format

**Integration rules (Shared Surface merge):**
- Shared surface changes require passing checks before merge: tests, lint, build, schema validation
- Executor must verify no other active claims conflict before merge
- If conflicting active claims exist, coordinate with claim owners before merge
- Migration merges are sequential: only one migration merges at a time

**Cross-scope dependency blocking:**
- `sequential` strategy: consumer scope is blocked until dependency scope completes
- `contract-first` strategy: consumer is blocked only until contract commit, not full implementation
- `parallel-merge` strategy: no blocking; integration test at merge point

## File Roles (Token Optimization)

| File | Content | Token Strategy |
|---|---|---|
| `roadmap.md` | Master roadmap (all) | **Planning only** load |
| `scopes/{scope}.md` | Current work scope | Load at work start |
| `tasks/{scope}.md` | Detailed tasks | Always load during work |
| `history/scopes/` | Completed scopes | **Skip during work** |
| `history/decisions/` | Decision records | Load only when needed |

## Multi-Scope: Concurrent Work Support

```yaml
scenario:
  executor_a: 'Q1 - Auth system'
  executor_b: 'Q2 - Payment'

files:
  executor_a:
    load: ['scopes/2026-Q1.md', 'tasks/2026-Q1.md']
    skip: ['roadmap.md', 'scopes/2026-Q2.md', 'tasks/2026-Q2.md', 'history/*']
  executor_b:
    load: ['scopes/2026-Q2.md', 'tasks/2026-Q2.md']
    skip: ['roadmap.md', 'scopes/2026-Q1.md', 'tasks/2026-Q1.md', 'history/*']
```

## Token Load Strategy

| Situation | Load | Skip |
|---|---|---|
| **Planning** | `roadmap.md` | `scopes/*`, `tasks/*`, `history/*` |
| **Work Start** | `scopes/{scope}.md`, `tasks/{scope}.md` | `roadmap.md`, other scopes, `history/*` |
| **Continue** | `tasks/{scope}.md` | Everything else |
| **Review Done** | `history/scopes/{scope}.md` | Active files |

## Scope ID Format

```
{year}-{period}
```

| Component | Description | Example |
|---|---|---|
| year | Year | `2026` |
| period | Quarter/Phase | `Q1`, `Q2`, `Phase1` |

## Workflow

```
L1: roadmap.md (Master direction)
    ↓ Architect selects scope
L2: scopes/{scope}.md (Architect approval)
    ↓ Executor details
L3: tasks/{scope}.md (Executor autonomous)
    ↓ Complete
history/scopes/{scope}.md (Archive)
    ↓
Post-Task: CDD Operational + Reference update
```

## Scope Lifecycle

```yaml
create:
  trigger: 'Architect selects range from roadmap'
  action: 'Create scopes/{scope}.md + tasks/{scope}.md'
  prerequisite: 'CDD Constitutional covers related domain'

active:
  work: 'Executor implements tasks'
  update: 'Progress tracked in tasks/{scope}.md'

complete:
  trigger: 'All tasks done'
  action:
    - 'Merge scope + tasks → history/scopes/{scope}.md'
    - 'Delete active files'
    - 'Update CDD Operational (patterns found)'
    - 'Update CDD Reference (feature registry, API catalog)'
```

## File Templates

### roadmap.md (L1)

```markdown
# Roadmap

> L1: Master direction | Load on planning only

## 2026

| Q | Priority | Feature | Status |
|---|----------|---------|--------|
| Q1 | P0 | Auth system | → scopes/2026-Q1.md |
| Q2 | P0 | Payment | Pending |

## Dependencies

- Auth → Payment → Dashboard
```

### scopes/{scope}.md (L2)

```markdown
# Scope: 2026-Q1

> L2: Architect approval required

## Target

Auth system implementation

## Period

2026-01-01 ~ 2026-03-31

## CDD Constitutional Basis

- Domain Model: User, Session entities
- Architecture: JWT auth, Redis session store
- Invariants: All API endpoints require authentication

## Items

| Priority | Feature | Status |
|----------|---------|--------|
| P0 | JWT middleware | todo |
| P1 | Login/logout API | todo |
| P2 | RBAC | todo |

## Shared Resource Claims

- Shared Schema: `users` table (owner)
- Shared Config: `JWT_SECRET` (addition)

## Cross-Scope Dependencies

(none)

## Success Criteria

- All auth endpoints functional
- RBAC enforcement verified
- 80% test coverage
```

### tasks/{scope}.md (L3)

```markdown
# Tasks: 2026-Q1

> L3: Executor autonomous | Based on scopes/2026-Q1.md

## Active

- [ ] Implement JWT middleware

## Pending

- [ ] Create login/logout endpoints
- [ ] Implement RBAC guards
- [ ] Add rate limiting

## Completed

- [x] Define User entity schema (01-20)

## Blocked

(none)
```

## Best Practices

| Practice | Description |
|---|---|
| Roadmap = Planning only | Do not load during work |
| Scope = 1 executor 1 scope | Separate scopes for concurrent work |
| Tasks = Focused | Include only current scope tasks |
| History = Archive only | Save after completion, skip during work |
| CDD basis first | Verify Constitutional coverage before scope creation |
| Claim before touch | Declare shared resource claims in scope |
| Naming = Consistent | Follow `{year}-{period}` format |

## Future: DB Migration

```
Current: .specs/history/*.md (Git)
    ↓
Future:  DB MCP (Searchable, zero tokens, analytics)
```

## References

- Methodology: `docs/llm/policies/development-methodology.md`
- CDD Policy: `docs/llm/policies/cdd.md`
- ADD Policy: `docs/llm/policies/add.md`
- Token Optimization: `docs/llm/policies/token-optimization.md`
- Monorepo Structure: `docs/llm/policies/monorepo.md`
