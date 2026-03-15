# Token Optimization Policy

> LLM-facing doc formatting rules to minimize token cost | **Last Updated**: 2026-03-15

## Scope

Applies primarily to CDD Layer 1 and Layer 2.

Goal: reduce token cost while maintaining reconstructability, machine interpretability, and searchability.

| Layer | Path | Token Rules |
| ----- | ---- | ----------- |
| 1 | `.ai/` | Strict |
| 2 | `docs/llm/` | Strict |
| 3 | `docs/en/` | Not applied (human readability priority) |
| 4 | `docs/kr/` | Not applied (human readability priority) |

## Evidence-Based Rationale

Key facts:

- Tokens respond to whitespace, punctuation, and partial words, not just whole words
- Non-English text can have higher token-to-character ratios
- Concise YAML-style or bulleted blocks are recommended for LLM prompts
- YAML targets human-readable structure while aligning with JSON
- Important information in the middle of long contexts may suffer degraded performance
- Markdown/CommonMark has complex tab and deep-indentation interpretation

Sources:

- OpenAI tokens: `https://help.openai.com/en/articles/4936856`
- OpenAI prompting: `https://developers.openai.com/api/docs/guides/prompting`
- YAML 1.2.1: `https://yaml.org/spec/1.2.1/`
- CommonMark: `https://spec.commonmark.org/0.30/`
- Lost in the Middle: `https://arxiv.org/abs/2307.03172`

## Language Rules

- Layer 1 and Layer 2 must be written in English
- Layer 1 and Layer 2 should use ASCII-centric content where possible
- Layer 3 and Layer 4 may use natural language appropriate for human readability

## Structure Rules

| Rule | Detail |
| ---- | ------ |
| No tabs | Use spaces only |
| Indent with spaces | 2-space indent |
| Max nesting depth | 2 levels |
| Prefer flat structure | Tables over nested lists |
| 1 file = 1 concept | Each file covers one topic |
| 1 section = 1 question | Each section answers one question |

## Format Rules

### Recommended

- Layer 1: pointer lists, short bullets, minimal key:value
- Layer 2: YAML block style, Markdown tables, short enums

### JSON Exception

JSON is allowed only when:

- Showing an exact external payload example
- Defining an exact schema
- Showing a machine-enforced output structure

## Forbidden Patterns (Layer 1 and Layer 2)

| Pattern | Token Cost | Alternative |
| ------- | ---------- | ----------- |
| Emoji | 1-3 tokens each | Remove; use ✓/✗ if needed |
| Decorative Unicode | 1 token/char | Remove |
| Box-drawing characters | 1 token/char | Remove |
| Tabs | Unpredictable (1-4 tokens) | 2-space indent |
| Long unstructured prose | Low info density | Tables, YAML |
| Unnecessary raw HTML | Overhead | Remove |
| Deep nested lists (≥3) | Context overhead | Convert to table |
| Deep headers (H4+) | Overhead | Merge to parent or table row |
| 3+ consecutive blank lines | Whitespace tokens | Max 1 blank line |
| Verbose preamble ("Please note...") | 0 info density | Remove |
| Filler phrases ("The following table shows...") | Redundant | Remove |

## Required Patterns

| Pattern | Why |
| ------- | --- |
| Tables | Highest info density |
| YAML | Fewer tokens than JSON |
| ✓/✗ | 1-token boolean |
| Short headers | Less overhead |
| Flat structure (max 2 levels) | Minimize indent tokens |
| Abbreviations after first use | `auth`, `cfg`, `req`, `res`, `impl` |
| Inline refs | Avoids duplication |
| Imperative headers | `## Edit Rules` not `## Rules for Editing` |

## Format Hierarchy

```
Tables > YAML > flat bullets > code blocks > prose
```

## Information Placement Rules

- Important rules go at the beginning of the document
- Required inputs and constraints go before examples
- Examples go toward the end
- Do not bury critical rules in the middle of long documents

This rule addresses the potential for information loss in long contexts (Lost in the Middle).

## Vocabulary Rules

- Use stable key vocabulary
- Do not use multiple names for the same concept
- Prefer canonical naming over aliases
- Prefer enums over free text where possible

Example canonical keys:

- `task_type`
- `domain`
- `policy`
- `constraints`
- `requires_human_approval`

## Example Rules

- Keep examples minimal
- 1 representative example per pattern (recommended)
- Examples must not be longer than the rule body
- Remove decorative examples

## SSOT No-Duplication Rule

- Rules, tables, and definitions must have exactly one canonical source
- Do not duplicate identical policy blocks across multiple files
- Other files should provide only summaries or links

## Machine-Actionable Preference

Prefer explicit structured fields over prose where possible.

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
| Stable headings | Headings should be predictable and consistent |
| Short headings | Concise and scannable |
| Classification before explanation | Categorize first, explain second |
| Actionable before commentary | What to do before why |
| Static-first ordering | Fixed content before dynamic (enables prefix caching) |

## Neutrality Rule

Do not embed vendor-specific, model-specific, or tool-specific numerical values in core policies.

Exclude from core policy:

- Vendor-specific prompt caching thresholds
- Tool-specific schema token counts
- Model-specific pricing ratios
- Community benchmark ratios

These belong in a separate operational appendix.

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

| Context | Rule | Reason |
| ------- | ---- | ------ |
| YAML | 2-space indent | 4-space doubles whitespace tokens |
| Code examples | 2-space indent | Consistent, minimal overhead |
| Markdown bullets | 2-space per level | Standard |
| Tab chars | ✗ Forbidden | Unpredictable tokenization |
| Max nesting | 2 levels | Each level adds indent tokens |
| Trailing whitespace | ✗ Forbidden | Hidden token cost |

## Code Block Policy

Allowed for:

- Actual commands / bash scripts
- Real code samples
- Functional diagrams (flow arrows, directory trees)

Forbidden for:

- Decorative boxes or borders
- Content that fits in a table
- Prose wrapped in backticks

## Token Budget Guidelines

Estimate: ~4 chars = 1 token (English).

| Doc Type | Target | Max |
| -------- | ------ | --- |
| Layer 1 (`.ai/`) | ~300 tokens | 500 |
| Layer 2 `policies/` | ~1,500 tokens | 2,000 |
| Layer 2 `{domain}/` (core) | ~1,500 tokens | 2,000 |
| Layer 2 `{domain}/pages/` | ~1,000 tokens | 1,500 |
| Layer 2 `research/` | ~1,500 tokens | 2,000 |

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
| Tables preferred | No nested bullets where table fits |
| YAML not JSON | No JSON in config examples (exceptions noted above) |
| No filler text | No "please note", "as mentioned", "the following" |
| Header ≤H3 | No H4 or deeper |
| Max 1 blank line | No 3+ consecutive blank lines |
| Canonical vocabulary | Consistent naming, no aliases |
| No vendor-specific values | In core policy |

## References

- CDD Policy: `docs/llm/policies/cdd.md`
- Layer structure: `docs/llm/policies/cdd.md#4-layer-structure`
- SDD (token load strategy): `docs/llm/policies/sdd.md#token-load-strategy`
