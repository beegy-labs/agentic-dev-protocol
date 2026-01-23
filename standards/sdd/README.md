# SDD (Spec-Driven Development) Standard

> **Version**: 1.0 | **Last Updated**: 2026-01-23
> **Based on**: my-girok reference implementation

---

## Purpose

SDD transforms massive roadmaps into executable plans through human-commanded staged automation.

**Core Concept**: WHAT → WHEN → HOW

---

## Directory Structure

### Monorepo Structure (Standard)

```
.specs/
├── README.md                               # Navigation and overview
└── apps/
    └── {app-name}/                         # Per-application separation
        ├── roadmap.md                      # L1: WHAT to build
        ├── scopes/                         # L2: WHEN to build
        │   └── {year}-{scope}.md          # e.g., 2026-scope1.md
        ├── tasks/                          # L3: HOW to build
        │   └── {year}-{scope}.md          # e.g., 2026-scope1.md
        └── history/                        # L4: Completed archives
            ├── scopes/                     # Archived scope records
            └── decisions/                  # Decision records
```

**Why per-app separation?**
- Independent roadmaps per application
- Prevents Git conflicts when multiple teams work
- Clear ownership and scope boundaries

---

## 3-Layer Structure: WHAT → WHEN → HOW

| Layer | File | Question | Author | Content |
|-------|------|----------|--------|---------|
| **L1: Roadmap** | `roadmap.md` | WHAT to build? | Human designs → LLM documents | Feature list, priorities, dependencies |
| **L2: Scope** | `scopes/{scope}.md` | WHEN to build? | Human defines → LLM documents | Work range, period, selected items |
| **L3: Tasks** | `tasks/{scope}.md` | HOW to build? | LLM generates → Human approves | Step-by-step plan, CDD references |

---

## Layer 1: roadmap.md (WHAT)

**Purpose**: Define overall feature roadmap and direction

**Content**:
- Complete feature list for 6-12 months
- Priority levels (P0: Critical, P1: Important, P2: Nice-to-have)
- Dependencies between features
- Status tracking (Pending → Planning → Complete → Done)

**Example**:

```markdown
# {App} Roadmap

## Feature Spec
- `feature-spec.md` (v1.0, 97/100)

## 2026

| Scope | Priority | Feature       | Status          | Scope File               |
|-------|----------|---------------|-----------------|--------------------------|
| 1     | P0       | Email Service | ✅ Spec Complete| → `scopes/2026-scope1.md`|
| 2     | P0       | Login         | 📋 Planning     | -                        |
| 3     | P0       | Roles         | Pending         | -                        |

## Dependencies

Email Service → Login (password reset needs email)
Login → Roles (role assignment needs auth)
```

**Authoring**:
1. Human: "We need Email, Login, Roles features"
2. LLM: Documents as structured roadmap.md

---

## Layer 2: scopes/{scope}.md (WHEN)

**Purpose**: Extract work range from roadmap for specific period

**Content**:
- Work period (2026-01 ~ 2026-02, or 2026-Q1)
- Selected items from roadmap
- Completion target/goal
- Detailed feature breakdown

**Example**:

```markdown
# Scope: 2026-Scope1 (Email Service)

## Status

| Phase            | Status      | Date       |
|------------------|-------------|------------|
| Scope Definition | ✅ Complete | 2026-01-22 |
| Task Generation  | ✅ Complete | 2026-01-22 |
| Human Approval   | ✅ Approved | 2026-01-22 |
| Implementation   | 🔄 In Progress| 2026-01-22|

## Period
2026-01 ~ 2026-02 (2 months)

## Items from Roadmap
- Scope 1: Email Service (from roadmap.md)

## Target
Complete email infrastructure so all services can send emails.

## Features
- mail-service: Email delivery service
- notification-service: Unified notification hub
```

**Authoring**:
1. Human: "For Jan-Feb 2026, focus on Scope 1 (Email Service)"
2. LLM: Documents as scopes/2026-scope1.md

---

## Layer 3: tasks/{scope}.md (HOW)

**Purpose**: Break down scope into executable steps

**Content**:
- CDD references (which .ai/ or docs/llm/ files to read)
- Task decomposition (Feature → Steps)
- Execution phases (Parallel vs Sequential)
- Dependencies (Step A → Step B)
- Checklist format

**Example**:

```markdown
# Tasks: 2026-Scope1

## CDD References

| CDD Document                    | Purpose               |
|---------------------------------|-----------------------|
| `.ai/rules.md`                  | Core DO/DON'T rules   |
| `.ai/architecture.md`           | Architecture patterns |
| `docs/llm/guides/grpc.md`       | gRPC patterns         |
| `docs/llm/policies/database.md` | Database patterns     |

## Status

| Service              | Total | Completed | In Progress | Pending |
|----------------------|-------|-----------|-------------|---------|
| mail-service         | 16    | 8         | 2           | 6       |
| notification-service | 15    | 0         | 0           | 15      |

---

## Phase 1 (Parallel) - Can run simultaneously

- [ ] Step M1: Define mail.proto
- [ ] Step M2: Create mail-service skeleton
- [ ] Step N1: Define notification.proto

## Phase 2 (Sequential) - Must complete Phase 1 first

- [ ] Step M3: Implement gRPC handlers (depends on M1, M2)
- [ ] Step M4: Add database layer (depends on M3)

## Phase 3 (Sequential) - Must complete Phase 2 first

- [ ] Step M5: Integrate Kafka (depends on M4)
- [ ] Step M6: Integrate AWS SES (depends on M5)
```

**Authoring**:
1. LLM: Reads scope + CDD, generates task breakdown
2. Human: Reviews, modifies if needed, approves
3. Execution: ADD (Agent-Driven Development) runs tasks

---

## Execution Modes

### Parallel Tasks

Tasks that can run simultaneously (no dependencies):

```markdown
## Phase 1 (Parallel)
- [ ] Define mail.proto
- [ ] Define notification.proto
- [ ] Create UI mockups
```

**Benefit**: Multiple agents can work concurrently

---

### Sequential Tasks

Tasks that must run in order (dependencies):

```markdown
## Phase 2 (Sequential)
- [ ] Implement gRPC service (depends on proto)
- [ ] Add database layer (depends on gRPC)
- [ ] Add caching (depends on database)
```

**Benefit**: Clear dependency chain, prevents conflicts

---

## Process Flow

```
┌─────────────────────────────────────────────────────────────┐
│  1. [Human→LLM] Roadmap Design                              │
│     Human: "We need features A, B, C"                       │
│     LLM: Documents roadmap.md                               │
└─────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────┐
│  2. [Human→LLM] Scope Definition                            │
│     Human: "For Q1, focus on feature A"                     │
│     LLM: Documents scopes/2026-Q1.md                        │
└─────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────┐
│  3. [LLM] Task Generation                                   │
│     LLM: Reads scope + CDD                                  │
│     LLM: Generates tasks/2026-Q1.md                         │
│     LLM: Determines phases, dependencies                    │
└─────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────┐
│  4. [Human] Review & Approval                               │
│     Human: Reviews generated tasks                          │
│     Human: Modifies if needed                               │
│     Human: Approves for execution                           │
└─────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────┐
│  5. [ADD] Execution                                         │
│     Orchestrator distributes tasks to agents                │
│     Agents execute independently                            │
│     Results collected and validated                         │
└─────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────┐
│  6. [System] Learning (Future)                              │
│     If human modified tasks: Diff → Learning data           │
│     Improves future task generation                         │
└─────────────────────────────────────────────────────────────┘
```

---

## History Management

### Completed Scopes

When scope completes:
1. Move `scopes/{scope}.md` → `history/scopes/`
2. Move `tasks/{scope}.md` → `history/scopes/`
3. Update roadmap.md status

**Purpose**: Historical record, audit trail

---

### Decisions

Record major decisions:

```markdown
# history/decisions/2026-01-21-menu-structure-priority.md

## Decision
Prioritize menu structure before feature implementation

## Reasoning
- Menu structure affects all features
- Prevents rework later
- Better UX planning

## Impact
- Delayed Scope 1 by 1 week
- Improved overall architecture
```

**Purpose**: Explain "why" for future reference

---

## Token Load Strategy

Optimize LLM context:

| Situation | Load | Skip |
|-----------|------|------|
| **Planning** | `roadmap.md` | scopes, tasks, history |
| **Work Start** | `scopes/{scope}.md`, `tasks/{scope}.md` | roadmap, other scopes |
| **Continue Work** | `tasks/{scope}.md` | Everything else |

**Benefit**: Minimize token usage, focus on relevant context

---

## Multi-Scope Support

Multiple teams/developers can work on different scopes:

| Person | Scope | Tasks | Conflicts? |
|--------|-------|-------|------------|
| Team A | `2026-scope1` | `tasks/2026-scope1.md` | ❌ No |
| Team B | `2026-scope2` | `tasks/2026-scope2.md` | ❌ No |

**Benefit**: Parallel progress without Git conflicts

---

## Validation Checklist

### Structure Validation

```yaml
Required:
  - [ ] .specs/README.md exists
  - [ ] .specs/apps/{app}/roadmap.md exists
  - [ ] .specs/apps/{app}/scopes/ directory exists
  - [ ] .specs/apps/{app}/tasks/ directory exists

Optional but Recommended:
  - [ ] .specs/apps/{app}/history/scopes/ exists
  - [ ] .specs/apps/{app}/history/decisions/ exists
```

### Content Validation

```yaml
roadmap.md:
  - [ ] Has feature list with priorities
  - [ ] Shows dependencies
  - [ ] Tracks status

scopes/{scope}.md:
  - [ ] Has work period defined
  - [ ] References roadmap items
  - [ ] Defines completion target

tasks/{scope}.md:
  - [ ] References CDD (Tier 1-2)
  - [ ] Has phase structure (Parallel/Sequential)
  - [ ] Shows dependencies
  - [ ] Uses checklist format
```

---

## Reference Implementation

**Project**: my-girok

**Location**: `.specs/apps/web-admin/`

**Files**:
- `roadmap.md`: 6 scopes defined for 2026
- `scopes/2026-scope1.md`: Email Service scope
- `tasks/2026-scope1.md`: 38 implementation steps

**Status**: ✅ Validated and operational

---

## Best Practices

### 1. Granular Tasks

**Good** (≤3 hour tasks):
```markdown
- [ ] Define mail.proto (30 min)
- [ ] Create mail-service skeleton (1 hour)
- [ ] Implement SendEmail RPC (2 hours)
```

**Bad** (too large):
```markdown
- [ ] Build entire mail service (3 days)
```

---

### 2. Clear Dependencies

**Good** (explicit):
```markdown
## Phase 2 (Sequential)
- [ ] M3: Implement gRPC handlers (depends on M1: proto)
```

**Bad** (implicit):
```markdown
- [ ] Implement gRPC handlers (needs proto first)
```

---

### 3. CDD References

**Good** (specific):
```markdown
## CDD References
- `.ai/rules.md`: Error handling rules
- `docs/llm/guides/grpc.md`: Service patterns
```

**Bad** (vague):
```markdown
Follow the docs
```

---

## Integration with CDD

SDD Tasks **must** reference CDD:

```markdown
# tasks/2026-scope1.md

## CDD References

| Document | Why |
|----------|-----|
| `.ai/rules.md` | Core rules (always) |
| `.ai/architecture.md` | System patterns |
| `docs/llm/services/mail-service.md` | Service-specific patterns |
```

**Benefit**: LLM reads CDD → Generates code following patterns

---

## Integration with ADD

SDD provides inputs to ADD:

```
tasks/2026-scope1.md (SDD Output)
         ↓
Orchestrator (ADD)
         ↓
  Agent 1: M1, M2
  Agent 2: N1, N2
         ↓
Results → Validation → Done
```

---

## FAQ

### Q: Single app vs Monorepo?

**Single App**:
```
.specs/
├── roadmap.md          # Root level
├── scopes/
└── tasks/
```

**Monorepo** (Recommended):
```
.specs/
└── apps/{app}/
    ├── roadmap.md      # Per-app
    ├── scopes/
    └── tasks/
```

---

### Q: How often to update roadmap?

- **Monthly**: Review and adjust priorities
- **Quarterly**: Major roadmap revisions
- **On-demand**: When business needs change

---

### Q: Can tasks span multiple scopes?

**No**. Each task belongs to one scope.

If task is too large:
1. Split into smaller tasks
2. Distribute across scopes
3. Use dependencies to link

---

## Templates

See `templates/sdd/` for:
- `roadmap.template.md`
- `scope.template.md`
- `tasks.template.md`

---

**Standard Version**: 1.0
**Last Updated**: 2026-01-23
**Reference**: my-girok/.specs/
