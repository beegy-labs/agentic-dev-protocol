# CDD (Context-Driven Development) Policy

> Context management system for LLM | **Last Updated**: 2026-03-03

## Definition

CDD is a **Constitution of Knowledge** - SSOT defining all rules and patterns for consistent, high-quality LLM output.

## CDD vs SDD

| Aspect     | CDD                     | SDD                       |
| ---------- | ----------------------- | ------------------------- |
| Focus      | How (context, patterns) | What (task, spec)         |
| Location   | `.ai/`, `docs/llm/`     | `.specs/`                 |
| History    | Git (document changes)  | Files → DB (task records) |
| Human Role | None                    | Direction, Approval       |

## 4-Tier Structure

```
.ai/        → docs/llm/     → docs/en/    → docs/kr/
(Pointer)     (SSOT)          (Generated)   (Translated)
```

| Tier | Path        | Purpose        | Audience | Editable | Format                    |
| ---- | ----------- | -------------- | -------- | -------- | ------------------------- |
| 1    | `.ai/`      | Indicators     | LLM      | **Yes**  | Tables, links, ≤50 lines  |
| 2    | `docs/llm/` | Full specs     | LLM      | **Yes**  | YAML, tables, code blocks |
| 3    | `docs/en/`  | Human-readable | Human    | Auto-gen | Prose, examples, guides   |
| 4    | `docs/kr/`  | Translation    | Human    | Auto-gen | Same as docs/en/          |

## Tier Purpose Details

**Tier 1, 2 (LLM-facing)**:

- Core technical reference
- Token-efficient, high-density
- Always up-to-date with current patterns

**Tier 3, 4 (Human-facing)**:

- External memory for context switching
- Reduce cognitive load of "deep context"
- Onboarding material for new members

### Tier 3/4 Generation Rules

When generating human-readable docs (Tier 3/4) from Tier 2:

| Tier 2 Pattern              | Tier 3 Output   | Rationale                      |
| --------------------------- | --------------- | ------------------------------ |
| `foo.md` + `foo-impl.md`    | Single `foo.md` | Humans prefer complete context |
| `foo.md` + `foo-testing.md` | Single `foo.md` | No token limits for humans     |
| Split companion files       | Merge into main | Readability over retrieval     |

**Why merge?**

- Tier 2 splits optimize for LLM token limits and RAG retrieval
- Humans read sequentially; fragmented docs hurt comprehension
- `docs:generate` script handles merge automatically

## Scope

| CDD Contains                     | CDD Does NOT Contain         |
| -------------------------------- | ---------------------------- |
| Service/package structure        | Current task details (→ SDD) |
| Monorepo layout conventions      | Roadmap, progress (→ SDD)    |
| API patterns, rules              | Task history (→ SDD)         |
| Coding conventions               |                              |
| Token optimization format rules  |                              |
| Policies (security, testing, DB) |                              |

## Directory Structure

**Organization: Domain-based (recommended).** Group by bounded domain, not by artifact type.

```
project/
├── CLAUDE.md           # Claude entry point
├── GEMINI.md           # Gemini entry point
├── .ai/                # Tier 1 - EDITABLE (LLM pointers)
│   ├── README.md       # Navigation hub (domain index)
│   ├── rules.md        # Core DO/DON'T
│   ├── architecture.md # Architecture pointer
│   └── git-flow.md     # Git workflow pointer
├── docs/
│   ├── llm/            # Tier 2 - EDITABLE (SSOT)
│   │   ├── README.md   # Master index with keywords
│   │   ├── policies/   # Cross-cutting rules (all domains)
│   │   ├── {domain-a}/ # Domain folder (e.g. auth/)
│   │   ├── {domain-b}/ # Domain folder (e.g. inference/)
│   │   ├── {domain-c}/ # Domain folder (e.g. providers/)
│   │   └── research/   # External knowledge (by topic)
│   ├── en/             # Tier 3 - NOT EDITABLE (Generated)
│   └── kr/             # Tier 4 - NOT EDITABLE (Translated)
```

### Why Domain-Based

| Criterion | Type-based (`services/`, `guides/`) | Domain-based (`auth/`, `infra/`) |
| --------- | ----------------------------------- | -------------------------------- |
| Retrieval precision | Low (scattered across folders) | High (scoped by domain) |
| Token efficiency | Poor (loads cross-domain) | Good (loads single domain) |
| Path-as-signal | Weak (type, not domain) | Strong (path = domain) |
| Collocation | Low (5 folders for 1 domain) | High (1 folder per domain) |
| Code alignment | None | Direct mapping to architecture |

Reference: arXiv:2602.20478 (Codified Context) organizes 34 specs by subsystem, not by type.

### Domain Folder Guidelines

| Guideline | Detail |
| --------- | ------ |
| One folder per bounded domain | `auth/`, `billing/`, `infra/`, `frontend/` |
| `policies/` is always cross-cutting | Architecture, patterns, git-flow, terminology |
| `research/` for external knowledge | Sub-organized by topic: `research/frontend/`, `research/backend/` |
| New domains = new folders | Do not force-fit into existing domains |
| Monorepo: per-service domains | `api-gateway/`, `worker/`, `shared/` |

### Internal Structure per Domain

Each domain folder should contain focused files scoped to one concept:

| Internal Pattern | Example Files | When to Use |
| ---------------- | ------------- | ----------- |
| Core + routing/ops split | `ollama.md`, `ollama-routing.md` | Complex subsystems with separate concerns |
| Mechanism-per-file | `jwt-sessions.md`, `api-keys.md`, `rbac.md` | Multiple independent mechanisms |
| Lifecycle + analytics | `job-lifecycle.md`, `job-analytics.md` | Entities with observation pipeline |
| Deploy + platform | `deploy.md`, `deploy-helm.md` | Multi-target deployment |
| System + sub-pages | `design-system.md`, `pages/keys.md` | Frontend with shared system + page specs |

### Domain Examples (Reference Implementations)

**Backend API project:**

```
docs/llm/
├── policies/    # architecture.md, patterns-rust.md, git-flow.md
├── auth/        # jwt-sessions.md, api-keys.md, rbac.md, security.md
├── inference/   # job-lifecycle.md, job-analytics.md, openai-compat.md
├── providers/   # ollama.md, ollama-routing.md, gemini.md, pricing.md
├── infra/       # deploy.md, deploy-helm.md, otel-pipeline.md, hardware.md
├── frontend/    # design-system.md, i18n.md, pages/jobs.md, pages/keys.md
└── research/    # frontend/react.md, backend/rust-axum.md
```

**SaaS monorepo project:**

```
docs/llm/
├── policies/    # architecture.md, patterns.md, monorepo.md
├── auth/        # oauth.md, rbac.md, mfa.md
├── billing/     # plans.md, stripe.md, invoicing.md
├── api/         # rest.md, graphql.md, webhooks.md
├── worker/      # queue.md, retry.md, dead-letter.md
├── frontend/    # design-system.md, pages/dashboard.md, pages/settings.md
└── infra/       # ci-cd.md, k8s.md, monitoring.md
```

### Fallback: Type-Based (Early Projects)

For new projects where domains are not yet identified, use type-based as a temporary structure:

```
docs/llm/
├── policies/    # Always present
├── services/    # All service specs (flat)
├── guides/      # How-to documents
└── packages/    # Package documentation
```

Migrate to domain-based once 3+ domains emerge (typically within 2-4 weeks).

## Edit Rules

| DO                              | DO NOT                   |
| ------------------------------- | ------------------------ |
| Edit `.ai/` directly            | Edit `docs/en/` directly |
| Edit `docs/llm/` directly       | Edit `docs/kr/` directly |
| Run generate after llm/ changes | Skip generation step     |
| Run translate after en/ changes | Skip translation step    |

## History Management

**CDD History = Git**

| Item                      | Method                 |
| ------------------------- | ---------------------- |
| Document changes          | `git log`, `git blame` |
| Version tracking          | Git commits            |
| No separate history files | Use Git                |

**Note**: Task history is managed by SDD (`.specs/history/`), not CDD.

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

| Option           | Description                                  |
| ---------------- | -------------------------------------------- |
| `--provider, -p` | LLM provider: ollama (default), gemini       |
| `--model, -m`    | Specific model name                          |
| `--file, -f`     | Generate single file (relative to docs/llm/) |
| `--force`        | Regenerate even if up-to-date                |
| `--retry-failed` | Process only previously failed files         |
| `--clean`        | Clear failed history and restart all         |

### docs:translate (docs/en → docs/kr)

```bash
pnpm docs:translate --locale kr             # Translate all
pnpm docs:translate --locale kr --file <p>  # Translate specific file
pnpm docs:translate --locale kr --retry-failed  # Retry failed only
pnpm docs:translate --locale kr --clean     # Clear history + translate all
pnpm docs:translate --provider gemini       # Use Gemini provider
```

| Option           | Description                                     |
| ---------------- | ----------------------------------------------- |
| `--locale, -l`   | Target locale: kr (default), ja, zh, es, fr, de |
| `--provider, -p` | LLM provider: ollama (default), gemini          |
| `--model, -m`    | Specific model name                             |
| `--file, -f`     | Translate single file (relative to docs/en/)    |
| `--retry-failed` | Process only previously failed files            |
| `--clean`        | Clear failed history and restart all            |

## Supported Providers

| Provider | Generate | Translate | Default Model |
| -------- | -------- | --------- | ------------- |
| Ollama   | ✓        | ✓         | gpt-oss:20b   |
| Gemini   | ✓        | ✓         | gemini-pro    |

## Failed Files Recovery

Scripts track failed files for retry:

| Script    | Failed Files Location         |
| --------- | ----------------------------- |
| generate  | `.docs-generate-failed.json`  |
| translate | `.docs-translate-failed.json` |

### Recovery Workflow

```bash
# 1. First run - some files fail
pnpm docs:translate --locale kr
# Output: Success: 45, Failed: 5

# 2. Retry only failed files
pnpm docs:translate --locale kr --retry-failed
# Output: Retrying 5 failed files...

# 3. Or restart everything
pnpm docs:translate --locale kr --clean
# Output: Cleared failed files history
```

## Line Limits (RAG Optimized)

Based on 128k context window optimization and RAG best practices.

### Tier 1 (.ai/)

```yaml
max_lines: 50
tokens: ~500
purpose: Quick navigation, pointers to Tier 2
```

### Tier 2 (docs/llm/) - By Folder Role

| Folder Role | Max Lines | Tokens | Rationale |
| ----------- | --------- | ------ | --------- |
| `policies/` | 200 | ~2,000 | Core rules, frequently loaded |
| `{domain}/` (core docs) | 200 | ~2,000 | Per-domain SSOT |
| `{domain}/pages/` | 150 | ~1,500 | UI page specs, focused |
| `research/` | 200 | ~2,000 | External knowledge, reference |
| `README.md` (index) | 200 | ~2,000 | Master index with keywords |

### Tolerance (Minor Over-Limit)

Files exceeding limit by **1-10 lines** are acceptable:

- Splitting would cause excessive fragmentation
- No significant RAG retrieval impact
- Review during major updates

### Exceptions (Framework Documents)

These documents define the methodology itself and are exempt from line limits:

| File                                  | Reason                                   |
| ------------------------------------- | ---------------------------------------- |
| `policies/cdd.md`                     | CDD framework definition (this document) |
| `policies/sdd.md`                     | SDD framework definition with templates  |
| `policies/development-methodology.md` | Core methodology (loads cdd.md, sdd.md)  |

**Criteria for exception:**

- Document defines the framework/methodology itself
- Requires full context to understand (splitting breaks comprehension)
- Loaded infrequently (onboarding, planning sessions only)

### Split Guidelines

**Minimum sizes after split:**

| Folder Role | Main File | Companion File | Total Before Split |
| ----------- | --------- | -------------- | ------------------ |
| `policies/` | ≥120 | ≥60 | >200 |
| `{domain}/` (core) | ≥120 | ≥60 | >200 |
| `{domain}/pages/` | ≥90 | ≥50 | >150 |
| `research/` | ≥120 | ≥60 | >200 |

**Split decision criteria:**

| Condition                      | Action                   |
| ------------------------------ | ------------------------ |
| Over limit by 1-10 lines       | Keep as-is (tolerance)   |
| Over limit by 11-30 lines      | Evaluate semantic split  |
| Over limit by >30 lines        | Split required           |
| Companion would be <50 lines   | Keep as-is (fragmented)  |
| Clear semantic boundary exists | Split (impl/testing/ops) |
| Independent lookup value       | Split (enums, tables)    |

**Split naming conventions:**

| Content Type   | Suffix Example              |
| -------------- | --------------------------- |
| Implementation | `-impl.md`                  |
| Testing        | `-testing.md`               |
| Operations     | `-operations.md`, `-ops.md` |
| Advanced       | `-advanced.md`              |
| Patterns       | `-patterns.md`              |
| Security       | `-security.md`              |
| Architecture   | `-arch.md`                  |

### Context Budget (128k)

```
128k context allocation:
├── System prompt:     ~5k tokens
├── Conversation:     ~20k tokens
├── Code context:     ~30k tokens
└── Documents:        ~70k tokens (35 × 2,000 avg)
```

### Format Rules

| Tier | Format                     | Optimization      |
| ---- | -------------------------- | ----------------- |
| 1    | Tables, links only         | Minimal tokens    |
| 2    | YAML, tables, code blocks  | Token efficiency  |
| 3    | Prose, examples (auto-gen) | Human readability |

### Token Optimization (Tier 1 & 2)

**Full rules**: `docs/llm/policies/token-optimization.md`

| Category | Forbidden | Required |
| -------- | --------- | -------- |
| Characters | Emoji, box-drawing chars, decorative ASCII | Plain text, ✓/✗ only |
| Indentation | Tab chars, 4-space indent, trailing spaces | 2-space indent, max 2 levels |
| Structure | ≥3 nesting levels, H4+ headers | Tables, flat bullets (≤2 levels) |
| Format | JSON configs, verbose prose | YAML configs, tables > prose |
| Phrases | "Please note", "As mentioned", filler text | Imperative, concise |
| Whitespace | 3+ consecutive blank lines | Max 1 blank line |
| Caching | Dynamic content before static | Static-first ordering |

### Language Policy

**All CDD documents MUST be written in English.**

- Code: English
- Documentation: English
- Comments: English
- Commits: English

## Update Requirements

| Change Type | .ai/ | docs/llm/ |
| ----------- | ---- | --------- |
| New API endpoint | README.md (domain index) | `{domain}/` relevant file |
| New domain | README.md (add domain) | Create `{domain}/` folder |
| New pattern | rules.md | policies/ |
| New policy | rules.md summary | policies/ full |
| New UI page | README.md | `frontend/pages/` |
| Cross-cutting change | architecture.md | policies/ + affected domains |

## AI Entry Points

| AI     | Entry File | First Read   |
| ------ | ---------- | ------------ |
| Claude | CLAUDE.md  | .ai/rules.md |
| Gemini | GEMINI.md  | .ai/rules.md |

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

## Best Practices

| Practice | Description |
| -------- | ----------- |
| Domain-based folders | Group by bounded domain, not by artifact type |
| Tier 1 = Pointer only | Never put full specs in .ai/ |
| Tier 2 = SSOT | Single source of truth for LLM |
| 1 file = 1 concept | Each file independently retrievable by RAG |
| Git = History | No separate changelog files in CDD |
| Token efficiency | Tables > prose, YAML > JSON |
| Cross-reference | .ai/ always links to docs/llm/ |
| No emoji/ASCII art | Forbidden in Tier 1/2 (→ token-optimization.md) |
| No deep nesting | Max 2 nesting levels; convert to table |
| Static-first ordering | Fixed content before dynamic (prefix caching) |
| README index | Master index with keywords for retrieval routing |

## References

- Methodology: `docs/llm/policies/development-methodology.md`
- Methodology Details: `docs/llm/policies/development-methodology-details.md`
- SDD Policy: `docs/llm/policies/sdd.md`
- ADD Policy: `docs/llm/policies/add.md`
- Token Optimization: `docs/llm/policies/token-optimization.md`
- Monorepo Structure: `docs/llm/policies/monorepo.md`
- Agents Customization: `docs/llm/policies/agents-customization.md`
