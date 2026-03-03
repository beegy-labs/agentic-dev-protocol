# Token Optimization Policy

> LLM-facing doc formatting rules to minimize token cost | **Last Updated**: 2026-02-27

## Scope

| Tier | Path | Token Rules Apply |
| ---- | ---- | ---------------- |
| 1 | `.ai/` | Strict |
| 2 | `docs/llm/` | Strict |
| 3 | `docs/en/` | Not applied (human-readable) |
| 4 | `docs/kr/` | Not applied (human-readable) |

## Forbidden Patterns

| Pattern | Example | Token Cost | Alternative |
| ------- | ------- | ---------- | ----------- |
| Emoji | 🚀 ✅ 🎯 ❌ 🔥 💡 | 1-3 tokens each | Remove; use ✓/✗ if needed |
| Decorative ASCII | `+----+` `|    |` borders | 1 token/char | Remove |
| Box drawing chars | `┌─┐ │ └─┘ ╔═╗` | 1 token/char | Remove |
| Deep nesting | ≥3 bullet levels | Context overhead | Convert to table |
| Excess indentation | 4-space or tab indent in YAML/lists | +1 token per indent unit | Use 2-space indent |
| Verbose preamble | "Please note that..." | 0 info density | Remove |
| Filler phrases | "The following table shows..." | Redundant | Remove |
| Repeated dividers | `---` `===` `***` as decoration | Visual noise | Single `---` per section max |
| H4/H5 headers | `#### SubSubSection` | Overhead | Merge to parent or table row |
| Long JSON | `{"key": "value", "arr": [...]}` | Bracket/quote overhead | YAML |
| Multi-blank lines | 3+ consecutive empty lines | Whitespace tokens | Max 1 blank line |
| Redundant context | Restating what was said above | Duplication | Remove |
| Verbose variable names | `authenticationServiceProvider` | More tokens | `authProvider` |

## Required Patterns

| Pattern | Why | Example |
| ------- | --- | ------- |
| Tables | Highest info density | `\| key \| value \|` |
| YAML | Fewer tokens than JSON | `key: value` |
| ✓/✗ | 1-token boolean | `\| Feature \| ✓ \|` |
| Short headers | Less overhead | `## Auth` not `## Authentication System` |
| Flat structure | Max 2 nesting levels | Table over nested bullets |
| Abbreviations | After first use | `auth`, `cfg`, `req`, `res`, `impl` |
| Inline refs | Avoids duplication | `→ docs/llm/policies/cdd.md` |
| Static-first ordering | Enables prefix caching | Fixed content before dynamic |
| Imperative headers | Concise | `## Edit Rules` not `## Rules for Editing` |

## Format Hierarchy

```
Tables > YAML > flat bullets > code blocks > prose
```

| Format | Use Case | Relative Token Cost |
| ------ | -------- | ------------------- |
| Table | Key-value, comparisons, rules | Lowest |
| YAML | Config, schemas, structured data | Low |
| Flat bullets | Short enumerable lists (≤5 items) | Medium |
| Code block | Actual code or commands only | Medium |
| Prose | Never in Tier 1/2 | Highest |

## Nesting Rules

| Level | Allowed | Action if Exceeded |
| ----- | ------- | ------------------ |
| 0 – top-level | ✓ | — |
| 1 – single indent | ✓ | — |
| 2 – double indent | Limited | Justify necessity |
| 3+ | ✗ | Convert to table |

## Header Rules

| Level | Use | Limit |
| ----- | --- | ----- |
| H1 (`#`) | Document title only | 1 per file |
| H2 (`##`) | Major sections | ≤8 per file |
| H3 (`###`) | Subsections only if table can't express | ≤4 per H2 |
| H4+ | ✗ | Convert to table row |

## Indentation Rules

Whitespace (spaces/tabs) is tokenized. BPE tokenizers merge leading spaces with the following word, so each indent level adds overhead.

| Context | Rule | Reason |
| ------- | ---- | ------ |
| YAML | 2-space indent | 4-space doubles whitespace tokens |
| Code examples | 2-space indent | Consistent, minimal overhead |
| Markdown bullets | 2-space per level | Standard; 4-space treated as code block |
| Tab chars (`\t`) | ✗ Forbidden | Unpredictable tokenization (1-4 tokens) |
| Max nesting depth | 2 levels | Each level adds indent tokens |
| Trailing whitespace | ✗ Forbidden | Hidden token cost |
| Table cell padding | Minimal | Align columns but avoid excessive spaces |

### Indentation Token Impact

| Indent Style | Tokens per Level | Total (3 levels) |
| ------------ | ---------------- | ---------------- |
| Tab (`\t`) | 1-4 | 3-12 |
| 4-space | ~2 | ~6 |
| 2-space | ~1 | ~3 |
| 0-space (flat table) | 0 | 0 |

**Rule**: Prefer flat tables over nested structures. Each nesting level costs tokens.

### Before/After: Indentation

**Before** (4-space indent, 3 levels):
```yaml
config:
    database:
        host: localhost
        port: 5432
        options:
            pool: 10
```

**After** (2-space indent, flat where possible):
```yaml
db_host: localhost
db_port: 5432
db_pool: 10
```

## Code Block Policy

Code blocks are **allowed** for:
- Actual commands / bash scripts
- Real code samples
- Functional diagrams (flow arrows `→`, directory trees using `├──`)

Code blocks are **forbidden** for:
- Decorative boxes or borders
- Content that fits in a table
- Prose wrapped in backticks

## Before/After Examples

### Nested bullets → Table

**Before** (high token cost):
```
- Authentication
  - OAuth2
    - Google provider
    - GitHub provider
  - API Key
    - Header-based auth
```

**After** (low token cost):

| Auth Method | Provider | Transport |
| ----------- | -------- | --------- |
| OAuth2 | Google, GitHub | Bearer token |
| API Key | Internal | Header |

### Verbose prose → Table

**Before**:
```
Please note that when working with the authentication system,
you should always make sure to validate tokens before processing requests.
```

**After**:

| Rule | Value |
| ---- | ----- |
| Token validation | Required before processing |

### JSON → YAML

**Before**:
```json
{
  "provider": "ollama",
  "model": "llama3",
  "maxTokens": 2000
}
```

**After**:
```yaml
provider: ollama
model: llama3
maxTokens: 2000
```

### Emoji-decorated header → Plain header

Before:
```
## 🚀 Getting Started
```

After:
```
## Getting Started
```

## Token Budget Guidelines

Estimate: ~4 chars = 1 token (English). Target/max per file type:

| Doc Type | Target | Max |
| -------- | ------ | --- |
| Tier 1 (`.ai/`) | ~300 tokens | 500 |
| Tier 2 `policies/` | ~1,500 tokens | 2,000 |
| Tier 2 `{domain}/` (core) | ~1,500 tokens | 2,000 |
| Tier 2 `{domain}/pages/` | ~1,000 tokens | 1,500 |
| Tier 2 `research/` | ~1,500 tokens | 2,000 |

## Prefix Caching Optimization

Static content loads faster via provider prefix caching (50-90% token cost reduction on repeated loads):

| Rule | Detail |
| ---- | ------ |
| Static first | Place fixed content (headers, rules) before dynamic content |
| Consistent structure | Don't reorder sections between sessions |
| No timestamps in static regions | Timestamps invalidate cache |
| Avoid session-specific data in system docs | Keeps prefix stable |

## Compliance Checklist

Before committing Tier 1/2 docs:

| Check | Pass Condition |
| ----- | -------------- |
| No emoji | No Unicode emoji chars (U+1F000–U+1FFFF range) |
| No decorative ASCII | No `+--+` borders, no box-drawing chars outside code blocks |
| Nesting ≤2 | No 3+ indent bullet levels |
| Tables preferred | No nested bullet structures where table fits |
| YAML not JSON | No `{` `}` in config examples (use YAML) |
| No filler text | No "please note", "as mentioned", "the following" |
| Header ≤H3 | No H4 (`####`) or deeper |
| Max 1 blank line | No 3+ consecutive blank lines |

## References

- CDD Policy: `docs/llm/policies/cdd.md`
- Tier structure: `docs/llm/policies/cdd.md#4-tier-structure`
- SDD (token load strategy): `docs/llm/policies/sdd.md#token-load-strategy`
- Monorepo (applies to package docs): `docs/llm/policies/monorepo.md`
