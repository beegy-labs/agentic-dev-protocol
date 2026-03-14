# Development Methodology - Details

> Advanced concepts and roadmap details | **Last Updated**: 2026-03-14

## Ultimate Goal: Vibe Coding

Protect senior developers from:

| Threat | Protection |
|---|---|
| Context switching | Single-project focus sessions |
| Repetitive tasks | Full executor delegation |
| Implementation constraints | High-level thinking only |
| Unpredictable interrupts | Self-resolving executors |

**Result**: Focus exclusively on direction, design, and creative problem-solving.

## Interaction Principles

```yaml
architect_actions:
  - 'Set direction (what to build)'
  - 'Review and approve plans'
  - 'Code review final output'
  - 'Update CDD Constitutional when architecture changes'
  - 'Update SDD when scope changes'
  - 'Delegate domain authority to Domain Owners'

architect_does_not:
  - 'Write implementation code'
  - 'Debug routine issues'
  - 'Handle repetitive tasks'

executor_actions:
  - 'Generate detailed plans from intent'
  - 'Implement approved plans'
  - 'Self-resolve problems (consensus)'
  - 'Report CDD deficiencies (not fill with inference)'
  - 'Update CDD Operational + Reference after work'
  - 'Request help only on consensus failure'
```

## ADD: Human Intervention Protocol

When escalation is necessary:

| Requirement | Description |
|---|---|
| Context Summary | Concise problem description |
| Attempts Made | What self-resolution was tried |
| Specific Question | Focused, actionable question |
| Options | Present choices with trade-offs |
| Deficiency Classification | CDD_MISSING / CDD_AMBIGUOUS / SDD_MISSING |

**Response Types**: Update CDD Constitutional (invariant), Update CDD Operational (pattern), Update SDD (scope), Direct guidance (one-time)

## Multi-Executor Consensus (Roadmap)

```yaml
status: '[Roadmap]'
phase: 'Medium-term'

process:
  1: 'Problem occurs during implementation'
  2: 'Summon peer executors for verification'
  3: 'Each executor independently evaluates'
  4: 'Consensus reached -> proceed'
  5: 'Consensus failed -> escalate to Architect'

validation_requirement:
  - 'Consensus alone is insufficient'
  - 'Must include execution-based verification'
  - 'Tests, linting, compilation required'
```

## Experience Distillation (Roadmap)

```yaml
status: '[Roadmap]'
phase: 'Long-term'

process:
  1_record: 'All trial-and-error, resolutions, escalations'
  2_analyze: 'Identify patterns worth preserving'
  3_evaluate: 'Apply 4 promotion criteria (integrity/compatibility/contract/sync)'
  4_promote: 'Move from Operational to Constitutional with approval'

benefit:
  - 'System learns from experience'
  - 'Prevents repeated mistakes'
  - 'Keeps active context lean'
```

## Long-Term Vision: Data as Asset

| Data Type | Source | Value |
|---|---|---|
| Intent | Human goal statements | What we want |
| Plans | Executor-generated plans | How we plan |
| Modifications | Architect's plan edits | Tacit knowledge |
| Implementation | Final code | How we build |
| Resolutions | Problem-solving records | How we fix |
| Deficiency Reports | CDD gap discoveries | What we missed |

## Phased Approach

```yaml
phase_1_current:
  approach: 'CDD/SDD/ADD framework with external executors'
  focus: 'Process optimization, data collection'

phase_2_medium:
  approach: 'RAG + Fine-tuned adapters'
  benefit: 'Domain-specialized responses'

phase_3_long:
  approach: 'Custom executor ecosystem'
  benefit: 'Full independence, competitive advantage'
```

---

_Summary: `development-methodology.md`_
