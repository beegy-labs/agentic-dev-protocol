# CDD Operations

> CLI, line limits, split guidelines, format rules | **Last Updated**: 2026-03-14

## CLI Commands

### docs:generate (docs/llm → docs/en)

```bash
pnpm docs:generate                    # Generate all (incremental)
pnpm docs:generate --force            # Regenerate all files
pnpm docs:generate --file <path>      # Generate specific file
pnpm docs:generate --retry-failed     # Retry only failed files
pnpm docs:generate --clean            # Clear history + generate all
pnpm docs:generate --provider gemini  # Use Gemini provider
```

| Option | Description |
|---|---|
| `--provider, -p` | LLM provider: ollama (default), gemini |
| `--model, -m` | Specific model name |
| `--file, -f` | Generate single file (relative to docs/llm/) |
| `--force` | Regenerate even if up-to-date |
| `--retry-failed` | Process only previously failed files |
| `--clean` | Clear failed history and restart all |

### docs:translate (docs/en → docs/kr)

```bash
pnpm docs:translate --locale kr             # Translate all
pnpm docs:translate --locale kr --file <p>  # Translate specific file
pnpm docs:translate --locale kr --retry-failed  # Retry failed only
pnpm docs:translate --locale kr --clean     # Clear history + translate all
pnpm docs:translate --provider gemini       # Use Gemini provider
```

| Option | Description |
|---|---|
| `--locale, -l` | Target locale: kr (default), ja, zh, es, fr, de |
| `--provider, -p` | LLM provider: ollama (default), gemini |
| `--model, -m` | Specific model name |
| `--file, -f` | Translate single file (relative to docs/en/) |
| `--retry-failed` | Process only previously failed files |
| `--clean` | Clear failed history and restart all |

## Supported Providers

| Provider | Generate | Translate | Default Model |
|---|---|---|---|
| Ollama | ✓ | ✓ | gpt-oss:20b |
| Gemini | ✓ | ✓ | gemini-pro |

## Failed Files Recovery

| Script | Failed Files Location |
|---|---|
| generate | `.docs-generate-failed.json` |
| translate | `.docs-translate-failed.json` |

```bash
# 1. First run - some files fail
pnpm docs:translate --locale kr
# Output: Success: 45, Failed: 5

# 2. Retry only failed files
pnpm docs:translate --locale kr --retry-failed

# 3. Or restart everything
pnpm docs:translate --locale kr --clean
```

## Line Limits

### Tier 1 (.ai/)

```yaml
max_lines: 50
tokens: ~500
purpose: Quick navigation, pointers to Tier 2
```

### Tier 2 (docs/llm/) - By Folder Role

| Folder Role | Max Lines | Tokens | Rationale |
|---|---|---|---|
| `policies/` | 200 | ~2,000 | Core rules, frequently loaded |
| `{domain}/` (core docs) | 200 | ~2,000 | Per-domain SSOT |
| `{domain}/pages/` | 150 | ~1,500 | UI page specs, focused |
| `research/` | 200 | ~2,000 | External knowledge, reference |
| `README.md` (index) | 200 | ~2,000 | Master index with keywords |

### Tolerance

Files exceeding limit by **1-10 lines** are acceptable:
- Splitting would cause excessive fragmentation
- No significant retrieval impact
- Review during major updates

### Exceptions (Framework Documents)

| File | Reason |
|---|---|
| `policies/cdd.md` | CDD framework definition |
| `policies/sdd.md` | SDD framework definition with templates |
| `policies/development-methodology.md` | Core methodology |

### Split Guidelines

**Minimum sizes after split:**

| Folder Role | Main File | Companion File | Total Before Split |
|---|---|---|---|
| `policies/` | ≥120 | ≥60 | >200 |
| `{domain}/` (core) | ≥120 | ≥60 | >200 |
| `{domain}/pages/` | ≥90 | ≥50 | >150 |
| `research/` | ≥120 | ≥60 | >200 |

**Split decision criteria:**

| Condition | Action |
|---|---|
| Over limit by 1-10 lines | Keep as-is (tolerance) |
| Over limit by 11-30 lines | Evaluate semantic split |
| Over limit by >30 lines | Split required |
| Companion would be <50 lines | Keep as-is (fragmented) |
| Clear semantic boundary exists | Split (impl/testing/ops) |

**Split naming conventions:**

| Content Type | Suffix Example |
|---|---|
| Implementation | `-impl.md` |
| Testing | `-testing.md` |
| Operations | `-operations.md`, `-ops.md` |
| Advanced | `-advanced.md` |
| Patterns | `-patterns.md` |
| Security | `-security.md` |
| Architecture | `-arch.md` |

## Context Budget (Machine-Optimized Tier)

```
128k context allocation (typical LLM):
├── System prompt:     ~5k tokens
├── Conversation:     ~20k tokens
├── Code context:     ~30k tokens
└── Documents:        ~70k tokens (35 × 2,000 avg)
```

Adjust allocation based on executor context window size.

## Format Rules

| Tier | Format | Optimization |
|---|---|---|
| 1 | Tables, links only | Minimal tokens |
| 2 | YAML, tables, code blocks | Token efficiency |
| 3 | Prose, examples (auto-gen) | Human readability |

## Token Optimization (Tier 1 & 2)

**Full rules**: `docs/llm/policies/token-optimization.md`

| Category | Forbidden | Required |
|---|---|---|
| Characters | Emoji, box-drawing chars, decorative ASCII | Plain text, ✓/✗ only |
| Indentation | Tab chars, 4-space indent, trailing spaces | 2-space indent, max 2 levels |
| Structure | ≥3 nesting levels, H4+ headers | Tables, flat bullets (≤2 levels) |
| Format | JSON configs, verbose prose | YAML configs, tables > prose |
| Phrases | "Please note", "As mentioned", filler text | Imperative, concise |
| Whitespace | 3+ consecutive blank lines | Max 1 blank line |
| Caching | Dynamic content before static | Static-first ordering |

## Language Policy

**All CDD documents MUST be written in English.**

- Code: English
- Documentation: English
- Comments: English
- Commits: English

## Domain Folder Guidelines

| Guideline | Detail |
|---|---|
| One folder per bounded domain | `auth/`, `billing/`, `infra/`, `frontend/` |
| `policies/` is always cross-cutting | Architecture, patterns, git-flow, terminology |
| `research/` for external knowledge | Sub-organized by topic |
| New domains = new folders | Do not force-fit into existing domains |

### Internal Structure per Domain

| Internal Pattern | Example Files | When to Use |
|---|---|---|
| Core + routing/ops split | `ollama.md`, `ollama-routing.md` | Complex subsystems |
| Mechanism-per-file | `jwt-sessions.md`, `api-keys.md` | Multiple independent mechanisms |
| Lifecycle + analytics | `job-lifecycle.md`, `job-analytics.md` | Entities with observation pipeline |

### Fallback: Type-Based (Early Projects)

For new projects where domains are not yet identified:

```
docs/llm/
├── policies/
├── services/
├── guides/
└── packages/
```

Migrate to domain-based once 3+ domains emerge.

## Workflow Example

```bash
# 1. Developer updates domain SSOT
vim docs/llm/auth/jwt-sessions.md

# 2. Generate English docs
pnpm docs:generate

# 3. Translate to Korean
pnpm docs:translate --locale kr

# 4. Commit all changes
git add docs/
git commit -m "docs: update auth jwt-sessions"
```

## AI Entry Points

| AI | Entry File | First Read |
|---|---|---|
| Claude | CLAUDE.md | .ai/rules.md |
| Gemini | GEMINI.md | .ai/rules.md |

## References

- CDD Policy: `docs/llm/policies/cdd.md`
- Token Optimization: `docs/llm/policies/token-optimization.md`
