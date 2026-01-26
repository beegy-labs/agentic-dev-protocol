# ADD (Agent-Driven Development)

> Autonomous execution of SDD tasks | Last Updated: 2026-01-25

## Core

```
ADD = Execute approved SDD tasks through supervised autonomy
```

**Principle**: Agents implement, humans approve.

## Relationship

```
CDD (HOW) --referenced--> SDD (WHAT) --executed--> ADD (DO)
    ^                                                 |
    +------------------ feedback ---------------------+
```

| Phase | Focus | Input | Output |
|-------|-------|-------|--------|
| CDD | Patterns | Experience | Documentation |
| SDD | Planning | Roadmap | Specs + Tasks |
| ADD | Execution | Approved tasks | Code + CDD updates |

## Entry Points

```
AGENTS.md -> CLAUDE.md / GEMINI.md -> .ai/workflows/
(router)    (user creates)           (details)
```

| File | Purpose |
|------|---------|
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
    +-> Found -> Read tasks/{scope}/ -> Implement
    +-> Not found -> "[!] Create spec first?"
```

Response when no spec:
```
[!] No spec for '{keyword}'.
1. Create spec first? (Recommended)
2. Implement directly?
```

## Execution Modes

### Single Agent
```
User -> AGENTS.md -> Agent -> Implementation
```

### Multi-Agent (Parallel)
```
Orchestrator (reads tasks.md)
    |
    +-> Agent 1 (Task A) --\
    +-> Agent 2 (Task B) ---+-> Merge results
    +-> Agent 3 (Task C) --/
```

### Git Worktree (Parallel Isolation)
```bash
git worktree add ../project-task-a -b feat/task-a
git worktree add ../project-task-b -b feat/task-b
# Agents work isolated, merge when done
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

## Self-Resolution Protocol

```yaml
step_1: Self-resolution
  - Re-read CDD
  - Search codebase
  - Run tests

step_2: Peer consensus (if multi-agent)
  - condition: self-resolution fails

step_3: Incident report -> Human
  - condition: consensus fails
  - human: Update CDD/SDD, restart agent
```

## Human Intervention

**Human does NOT write code.**

When needed:
1. Review incident report
2. Identify root cause
3. Update layer:
   - Missing pattern -> CDD
   - Unclear requirement -> SDD
4. Restart agents

## Experience Capitalization

```
Task done -> Update CDD T1/T2 (mandatory) -> Archive to history/
```

**Mandatory** after SDD completion:

| Tier | Action | Example |
|------|--------|---------|
| T1 | Add pointer to .ai/services/ | {service}.md + index.md |
| T2 | Update SSOT in docs/llm/ | guides/, references/ |

Then archive completed tasks to `.specs/{app}/history/`.

## Agent Config

### AGENTS.md (Shared)
```markdown
## Entry
1. Read .ai/README.md
2. Check .specs/{app-name}/roadmap.md

## Rules
- No direct commit to main
- Check spec before implementation

## Workflows
| Action | Guide |
|--------|-------|
| Implement | .ai/workflows/implementation.md |
```

### CLAUDE.md (User)
```markdown
default: claude-sonnet-4-20250514
complex: claude-opus-4-20250514
```

### GEMINI.md (User)
```markdown
default: gemini-2.0-flash
```

## Verification

After work:
- [ ] Tests pass
- [ ] Lint passes
- [ ] Build succeeds
- [ ] Spec tasks checked
- [ ] Moved to completed/
- [ ] CDD updated if new patterns

## Best Practices

| Practice | Rule |
|----------|------|
| Spec first | Validate before implement |
| Small steps | Verifiable chunks |
| Update progress | Check tasks done |
| Capitalize | Update CDD with patterns |
| Human gates | Approval at checkpoints |

## References

- CDD: docs/llm/policies/cdd.md
- SDD: docs/llm/policies/sdd.md
- Workflow: .ai/workflows/implementation.md
