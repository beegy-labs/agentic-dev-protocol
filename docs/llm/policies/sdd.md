# SDD (Spec-Driven Development)

> Human-commanded task planning | Last Updated: 2026-01-25

## Core

```
Human = Direction (WHAT/WHY)
LLM   = Documentation + Planning (HOW)
```

**Principle**: Human explains, LLM writes everything.

## 3-Layer Structure

```
roadmap.md      Human explains -> LLM documents (big picture)
scopes/{id}.md  Human explains -> LLM documents (scope)
tasks/{scope}/  Human requests -> LLM generates (plan)
```

| Layer | File | Human | LLM |
|-------|------|-------|-----|
| L1 Roadmap | roadmap.md | Explains | Documents |
| L2 Scope | scopes/*.md | Explains | Documents |
| L3 Tasks | tasks/{scope}/ | Requests + Approves | Generates |

## Directory

SDD specs are organized by **app/solution unit** (not monorepo structure).
One spec = one complete application (may span multiple packages).

```
.specs/{app-name}/
+-- roadmap.md
+-- scopes/
|   +-- 2026-S1.md
+-- tasks/
|   +-- 2026-S1/
|       +-- index.md
|       +-- 01-backend.md   # Target: services/
|       +-- 02-frontend.md  # Target: apps/
+-- history/
```

## Workflow

```
L1: [Human] "Building todo app with React frontend and Python API"
    [LLM] -> .specs/todo-app/roadmap.md

L2: [Human] "First scope: basic CRUD for both frontend and backend"
    [LLM] -> scopes/2026-S1.md

L3: [Human] "Plan with parallel tasks for backend/frontend, then integration"
    [LLM] -> tasks/2026-S1/
            - index.md (status, deps)
            - 01-backend.md (Target: services/, parallel)
            - 02-frontend.md (Target: apps/, parallel)
            - 03-integration.md (sequential, after 01+02)

[Human] "Approved" -> Execute
        "Revise X" -> LLM revises

Execute -> Success -> CDD T1/T2 update (mandatory) -> Archive to history/
        -> Failure -> Feedback -> Human decides
```

## Templates

### roadmap.md

```markdown
# Roadmap: {App Name}

## Tech Stack
| Layer | Tech | Location |
|-------|------|----------|
| Frontend | React | apps/ |
| Backend | Python | services/ |

| Feature | Priority | Status |
|---------|----------|--------|
| CRUD API | P0 | Planned |
| UI | P0 | Planned |

| Scope | Features | Target |
|-------|----------|--------|
| 2026-S1 | Basic CRUD | Q1 |
```

### scopes/{id}.md

```markdown
# Scope: 2026-Scope1

## Direction
{Human's explanation verbatim}

## Target
- Google OAuth
- Native login

## Priority
1. Google Auth
2. Native Auth
```

### tasks/{scope}/index.md

```markdown
# Tasks: 2026-S1

## Status
| Total | Done | Progress | Pending |
|-------|------|----------|---------|
| 3 | 0 | 0 | 3 |

## Dependencies
[01] --+
       +--> [03]
[02] --+

## Parallel Groups
| Group | Tasks | Start |
|-------|-------|-------|
| A | 01,02 | Now |
| B | 03 | After A |

## Summary
| # | Task | Target | Depends | Status |
|---|------|--------|---------|--------|
| 01 | Backend | services/ | - | Pending |
| 02 | Frontend | apps/ | - | Pending |
| 03 | Integration | apps/ | 01,02 | Blocked |
```

### tasks/{scope}/{nn}-{name}.md

```markdown
# Task 01: Backend Setup

> Target: services/example-service/

## Steps
### Phase 1 (Setup)
- [ ] Create project structure
- [ ] Add dependencies

### Phase 2 (Implementation)
- [ ] Create endpoints
- [ ] Add database

## Verify
pnpm --filter example-service test

## Done
- [ ] Steps complete
- [ ] Tests pass
```

## Feedback Loop

```
Failure -> Feedback Report -> Human Review
                                |
                                +-> "Revise scope" -> Re-plan
                                +-> "Proceed" -> Retry
                                +-> "Cancel" -> Archive
```

### Feedback Template

```markdown
# Feedback: {Task}

## Failure
- Task: 01-google-auth.md
- Error: API rate limit

## Options
1. Retry with backoff
2. Use mock for dev
3. Different provider

## Decision Required
```

## Retention

| Status | Location | Keep | Access |
|--------|----------|------|--------|
| Active | scopes/, tasks/ | Until done | Direct |
| Done | history/ | 90 days | Direct |
| Archive | DB/S3 | Forever | Query |

## Success Metrics

| Metric | Target |
|--------|--------|
| Coverage | >=80% |
| Tasks | 100% done |
| CDD T1 | .ai/ pointer added |
| CDD T2 | docs/llm/ SSOT updated |
| Archive | Moved to history/ |

## Best Practices

| Practice | Rule |
|----------|------|
| Human explains | Don't write, explain |
| LLM documents | All writing by LLM |
| Approve/Reject | Human judges only |
| Parallel first | Identify parallel tasks |
| Feedback loop | Failures trigger review |

## References

- CDD: docs/llm/policies/cdd.md
- ADD: docs/llm/policies/add.md
