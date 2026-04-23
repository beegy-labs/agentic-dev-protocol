# Token Optimization Policy

> LLM-facing doc formatting rules to minimize token cost | **Last Updated**: 2026-04-23

## Scope

Applies to CDD Layer 1 and Layer 2. Layer 3/4 (human docs) are exempt.

| Layer | Path | Applied |
| ----- | ---- | ------- |
| 1 | `.ai/` | Strict |
| 2 | `docs/llm/` | Strict |
| 3 | `docs/en/` | Not applied (human readability) |
| 4 | `docs/kr/` | Not applied (human readability) |

Goal: minimize token cost while preserving reconstructability, machine interpretability, searchability.

## Evidence-Based Rationale (2026)

Key facts:

- Modern BPE tokenizers merge frequent full words; abbreviation can *increase* tokens
- Claude 4.x tokenizer averages ~3.6 chars/token (English); budget 3.5–4.0 chars/token
- Non-English text has higher token-to-character ratios (CJK ~1 char/token)
- "Lost in the Middle" still holds at 1M-token context (Opus 4.7: ~93% @ 256K → ~76% @ 1M)
- Prefix caching (Anthropic, OpenAI, Claude Code) rewards static-first, no-timestamp, stable section order
- Markdown tables have high info density for flat data; YAML wins for 2+ level nested data
- SKILL.md / AGENTS.md / Cursor `.mdc` establish **YAML frontmatter** as a shared idiom

Sources:

- Anthropic prompt caching: `https://docs.anthropic.com/en/docs/build-with-claude/prompt-caching`
- OpenAI tokens: `https://help.openai.com/en/articles/4936856`
- OpenAI prompting: `https://developers.openai.com/api/docs/guides/prompting`
- Claude Skills (SKILL.md): `https://docs.anthropic.com/en/docs/agents-and-tools/agent-skills`
- AGENTS.md (OpenAI/Google/Cursor joint): `https://agents.md`
- Cursor Rules: `https://docs.cursor.com/context/rules`
- YAML 1.2.1: `https://yaml.org/spec/1.2.1/`
- CommonMark: `https://spec.commonmark.org/0.30/`
- Lost in the Middle (original): `https://arxiv.org/abs/2307.03172`
- Lost in the Middle @ 1M context (2025): `https://arxiv.org/abs/2511.13900`

## Language Rules

- Layer 1 and Layer 2 written in English
- Layer 1 and Layer 2 use ASCII-centric content where possible
- Layer 3 and Layer 4 may use natural language appropriate for human readability

## Structure Rules

| Rule | Detail |
| ---- | ------ |
| No tabs | Spaces only |
| Indent with spaces | 2-space indent |
| Max nesting depth | 2 levels (convert deeper to a table) |
| Prefer flat structure | Tables over nested lists |
| 1 file = 1 concept | Each file covers one topic |
| 1 section = 1 question | Each section answers one question |

## Format Selection (by data shape)

| Data shape | Best format | Rationale |
| ---------- | ----------- | --------- |
| Flat rows / enum tables | **Markdown table** | Highest density for 1-level rows |
| 2+ level nested data | **YAML** | Fewer delimiter tokens than Markdown lists at depth |
| Exact payload / schema / machine output | **JSON** | Required for fidelity |
| Runnable commands / code | **Fenced code block** | Preserves syntax |
| Procedure with few steps | **Ordered list** | Only if 2–5 steps; otherwise table |
| Free-form explanation | **Short prose (1–3 sentences)** | Only when no table fits |

## Frontmatter & Progressive Disclosure

Frontmatter is **allowed and encouraged** when the doc is a skill, rule, or routing entry. Follow the ecosystem standard (SKILL.md / Cursor `.mdc` / AGENTS.md):

```yaml
---
name: rust-review
description: Review Rust diffs against policies/patterns
globs:
  - "crates/**/*.rs"
alwaysApply: false
---
```

Progressive disclosure: only the frontmatter should be unconditionally loaded; body loads on match. Keep frontmatter under 10 lines.

## Forbidden Patterns (Layer 1 and Layer 2)

| Pattern | Token Cost | Alternative |
| ------- | ---------- | ----------- |
| Emoji | 2–4 tokens each (up to 10) | Remove; use `✓`/`✗` if a boolean is required |
| Decorative Unicode | 1 token/char | Remove |
| Box-drawing characters | 1 token/char | Remove |
| Tabs | Unpredictable (1–4 tokens) | 2-space indent |
| Long unstructured prose | Low info density | Tables, YAML |
| Unnecessary raw HTML | Overhead | Remove |
| Deep nested lists (≥3) | Context overhead | Convert to a table |
| Deep headers (H4+) | Overhead | Merge to parent or row |
| 3+ consecutive blank lines | Whitespace tokens | Max 1 blank line |
| Verbose preamble ("Please note…") | 0 info density | Remove |
| Filler phrases ("The following table shows…") | Redundant | Remove |

## Required Patterns

| Pattern | Why |
| ------- | --- |
| Tables for flat data | Highest density |
| YAML for nested data | Delimiter economy at depth |
| `✓` / `✗` | 1-token boolean |
| Short imperative headers | Less overhead (`## Edit Rules`, not `## Rules for Editing`) |
| Flat structure (max 2 levels) | Minimizes indent tokens |
| Inline references | Avoids duplication |

### Optional Patterns (not required)

| Pattern | Status | Note |
| ------- | ------ | ---- |
| Abbreviations (`auth`, `cfg`, `impl`) | Optional | Modern BPE tokenizers already merge full words; abbreviation may *increase* tokens or hurt readability |
| Single-letter enum values | Discouraged | Token savings are tiny and legibility loss is large |

## Format Hierarchy

```
Flat data:   Tables > YAML > bullets > prose
Nested data: YAML > Tables > bullets > prose
Code:        Fenced code blocks (Markdown > HTML)
```

## Information Placement Rules

- Critical rules at the top of the document
- Required inputs and constraints before examples
- Examples toward the end
- Never bury critical rules in the middle of long documents (Lost in the Middle — still holds at 1M context)

## Vocabulary Rules

- Use stable key vocabulary; one name per concept
- Prefer canonical naming over aliases
- Prefer enums over free text

Canonical example keys:

- `task_type`
- `domain`
- `policy`
- `constraints`
- `requires_human_approval`

## Example Rules

- Keep examples minimal
- 1 representative example per pattern
- Example must not exceed the rule body length
- No decorative examples

## SSOT No-Duplication Rule

- Rules, tables, and definitions have exactly one canonical source
- Do not duplicate identical policy blocks across files
- Other files may only summarize or link

## Machine-Actionable Preference

Prefer explicit structured fields over prose.

Good:

```yaml
task_type: feature_add
requires_cdd_basis: true
requires_human_approval: false
risk: medium
```

Bad:

```
This task appears to add a feature and may require approval depending on overall impact.
```

## Searchability Rules

| Rule | Detail |
| ---- | ------ |
| Stable headings | Predictable and consistent across revisions |
| Short headings | Concise and scannable |
| Classification before explanation | Categorize first, explain second |
| Actionable before commentary | What to do before why |
| Static-first ordering | Fixed content before dynamic (enables prefix caching) |

## Neutrality Rule

Do not embed vendor-, model-, or tool-specific numeric values in core policies.

Excluded from core policy:

- Vendor-specific prompt caching thresholds
- Tool-specific schema token counts
- Model-specific pricing ratios
- Community benchmark ratios

These belong in a separate operational appendix.

## Nesting & Header Rules

| Level | Rule |
| ----- | ---- |
| H1 (`#`) | Document title only, 1 per file |
| H2 (`##`) | Major sections, ≤8 per file |
| H3 (`###`) | Subsections only if a table cannot express, ≤4 per H2 |
| H4+ | Forbidden — convert to a table row |
| Bullet nesting level 2 | Allowed (justify if used) |
| Bullet nesting level 3+ | Forbidden — convert to a table |

## Indentation Rules

| Context | Rule | Reason |
| ------- | ---- | ------ |
| YAML | 2-space indent | 4-space doubles whitespace tokens |
| Code examples | 2-space indent | Minimal overhead |
| Markdown bullets | 2-space per level | Standard |
| Tab chars | Forbidden | Unpredictable tokenization |
| Trailing whitespace | Forbidden | Hidden cost |

## Code Block Policy

Allowed for:

- Runnable commands / scripts
- Real code samples
- Functional diagrams (flow arrows, directory trees)

Forbidden for:

- Decorative boxes or borders
- Content that fits in a table
- Prose wrapped in backticks

## Token Budget Guidelines

Estimate: **3.5–4.0 chars = 1 token (English)**; newer tokenizers (Claude 4.x) tend toward 3.6. Budget conservatively.

| Doc Type | Target | Max |
| -------- | ------ | --- |
| Layer 1 (`.ai/`) | ~300 tokens | 500 |
| Layer 2 `policies/` | ~1,500 tokens | 2,000 |
| Layer 2 `{domain}/` (core) | ~1,500 tokens | 2,000 |
| Layer 2 `{domain}/pages/` | ~1,000 tokens | 1,500 |
| Layer 2 `research/` | ~1,500 tokens | 2,000 |

## Line Limits

| Layer / Folder | Max Lines | Tokens | Rationale |
| -------------- | --------- | ------ | --------- |
| Layer 1 (`.ai/`) | 50 | ~500 | Quick navigation, pointers to Layer 2 |
| `policies/` | 200 | ~2,000 | Core rules, frequently loaded |
| `{domain}/` (core docs) | 200 | ~2,000 | Per-domain SSOT |
| `{domain}/pages/` | 150 | ~1,500 | UI page specs |
| `research/` | 200 | ~2,000 | External knowledge |
| `README.md` (index) | 200 | ~2,000 | Master index |

### Exceptions (Framework Documents)

| File | Reason |
| ---- | ------ |
| `policies/identity.md` | Identity anchor |
| `policies/cdd.md` | CDD framework definition |
| `policies/sdd.md` | SDD framework definition |
| `policies/add.md` | ADD framework definition |
| `policies/development-methodology.md` | Core methodology |
| `policies/token-optimization.md` | This policy (meta — enforces itself) |

### Split Guidelines

| Condition | Action |
| --------- | ------ |
| Over by 1–10 lines | Tolerance — keep as-is |
| Over by 11–30 lines | Evaluate semantic split |
| Over by >30 lines | Split required |
| Companion file would be <50 lines | Keep as-is |
| Clear semantic boundary | Split |

## Prefix Caching Optimization

| Rule | Detail |
| ---- | ------ |
| Static first | Fixed content (headers, rules) before dynamic content |
| Consistent structure | Do not reorder sections between sessions |
| No timestamps in static regions | Timestamps invalidate cache |
| Avoid session-specific data | Keeps prefix stable |

## Compliance Checklist

Before committing Layer 1/2 docs:

| Check | Pass Condition |
| ----- | -------------- |
| No emoji | No Unicode emoji chars |
| No decorative ASCII | No box-drawing chars outside code blocks |
| Nesting ≤2 | No 3+ indent levels |
| Tables preferred | No nested bullets where a table fits |
| YAML for nested data | No JSON outside the allowed exceptions |
| No filler text | No "please note", "as mentioned", "the following" |
| Header ≤H3 | No H4 or deeper |
| Max 1 blank line | No 3+ consecutive blank lines |
| Canonical vocabulary | Consistent naming, no aliases |
| No vendor-specific values | In core policy |
| Frontmatter within limits | ≤10 lines; uses shared schema |

## References

- Identity anchor: `docs/llm/policies/identity.md`
- CDD Policy: `docs/llm/policies/cdd.md`
- Layer structure: `docs/llm/policies/cdd.md#4-layer-structure`
- SDD token load strategy: `docs/llm/policies/sdd.md#token-load-strategy`
