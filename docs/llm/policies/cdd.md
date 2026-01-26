# CDD (Context-Driven Development)

> LLM context management | Last Updated: 2026-01-25

## Core

```
CDD = Constitution of Knowledge
Principle: More value per token
```

| Aspect | CDD | SDD |
|--------|-----|-----|
| Focus | HOW (patterns) | WHAT (tasks) |
| Location | .ai/, docs/llm/ | .specs/ |
| Human | Define patterns | Direction + Approval |

## 4-Tier Structure

```
.ai/ (T1) -> docs/llm/ (T2) -> docs/en/ (T3) -> docs/{locale}/ (T4)
[Pointer]    [SSOT]           [Generated]      [Translated]
[LLM]        [LLM]            [Human]          [Human]
```

| Tier | Path | Max Lines | SSOT | Sync |
|------|------|-----------|------|------|
| 1 | .ai/ | 50 | Yes | Real-time |
| 2 | docs/llm/ | 300 | Yes | Real-time |
| 3 | docs/en/ | - | No | Batch |
| 4 | docs/{locale}/ | - | No | Batch |

**Edit Flow**: T1/T2 (edit) -> T3 (generate) -> T4 (translate)

## File Size Limits

| Size | Lines | Tokens | Use |
|------|-------|--------|-----|
| XS | <=30 | ~300 | index.md |
| S | <=50 | ~500 | .ai/*.md |
| M | <=150 | ~1.5k | guides/ |
| L | <=300 | ~3k | policies/ |
| XL | <=500 | ~5k | references/ |

## Context Budget (128k)

```
System:      ~5k
Conversation: ~20k
Code:        ~30k
Documents:   ~70k (target 40% utilization)
```

## Load Strategy

| Action | Load | Skip |
|--------|------|------|
| Start | .ai/README.md | All else |
| Find | index.md | Content files |
| Deep dive | Specific file | Others |
| Implement | CDD + SDD spec | History |

### Dynamic Presets

| Task | Load |
|------|------|
| Implement | .ai/README + tasks/ + guides/ |
| Review | workflows/review + changed files |
| Debug | Error + related code + tech/ |
| Plan | README + roadmap + scopes/ |

## Token Optimization

| Technique | Savings | Priority |
|-----------|---------|----------|
| Index-first | 60-80% | High |
| Tables > prose | 30-50% | High |
| Tiered loading | 40-60% | High |
| ASCII-only | 2-5% | Required |

### Character Policy

| Tier | Charset | Reason |
|------|---------|--------|
| T1/T2 | ASCII only | Token efficiency, LLM parsing |
| T3/T4 | Unicode OK | Human readability, emojis, Mermaid |

### ASCII Mapping (T1/T2)

| Original | ASCII |
|----------|-------|
| Box chars | +, -, \| |
| Arrows | ->, <- |
| Checks | [x], Y/N |
| Emojis | [!], [i] |

```bash
# Validate T1/T2
grep -rP '[^\x00-\x7F]' .ai/ docs/llm/
```

## Primacy/Recency Bias

| Position | Recall | Content |
|----------|--------|---------|
| First 20% | High | Rules, current task |
| Middle 60% | Low | References, examples |
| Last 10% | High | Output format |

## Observability

```yaml
target: 40% context utilization
alert: >60% -> split task
metrics: tokens/session, files/task
```

## T3 Generation

| T2 (LLM) | T3 (Human) |
|----------|------------|
| Tables | Prose |
| ASCII art | Mermaid |
| Split files | Merged docs |
| Minimal | Explanatory |

```
Generate: docs/llm/ -> docs/en/
Translate: docs/en/ -> docs/{locale}/
```

## Index Format

```markdown
# {Category} Index

| Name | Path | Keywords |
|------|------|----------|
| Auth | auth.md | jwt, session |
```

## Best Practices

| Practice | Rule |
|----------|------|
| Index first | Every dir needs index.md |
| T1 = Pointer | No full specs in .ai/ |
| T2 = SSOT | Single source of truth |
| Tables > prose | Token efficiency |
| 40% budget | Leave room for code |

## References

- SDD: docs/llm/policies/sdd.md
- ADD: docs/llm/policies/add.md
- Best Practices: docs/llm/references/2026-best-practices.md
