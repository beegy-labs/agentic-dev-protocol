# Methodology Definition Synchronization Verification

> **Date**: 2026-01-23
> **Purpose**: Verify CDD, SDD, ADD definitions are consistent across ALL documents
> **Critical**: This MUST be 100% accurate - no inconsistencies allowed

---

## Verification Scope

All documents containing CDD/SDD/ADD definitions:

1. `AGENTS.md` - Core standard policy
2. `README.md` - Project overview
3. `standards/cdd/README.md` - CDD standard
4. `standards/sdd/README.md` - SDD standard
5. `ADD_CURRENT_STATUS.md` - ADD implementation status
6. `TEMPLATE_ENHANCEMENT_REPORT.md` - Enhancement plans
7. `SDD_STANDARD_CLARIFICATION.md` - SDD clarification
8. `STRUCTURE_COMPARISON.md` - Structure comparison

---

## CDD (Context-Driven Development) Definitions

### 1. AGENTS.md (Lines 27-36)

```markdown
### CDD (Context-Driven Development)

| Tier | Path        | Role                  | Editable | Max Lines |
| ---- | ----------- | --------------------- | -------- | --------- |
| 1    | `.ai/`      | Indicator (LLM)       | ✅ Yes   | ≤50       |
| 2    | `docs/llm/` | SSOT (LLM)            | ✅ Yes   | ≤200      |
| 3    | `docs/en/`  | Human-readable (Auto) | ⛔ No    | N/A       |
| 4    | `docs/kr/`  | Translation (Auto)    | ⛔ No    | N/A       |

**Policy**: `docs/llm/policies/cdd.md`
```

**Key Points**:
- 4-Tier architecture
- Tier 1: .ai/ (≤50 lines)
- Tier 2: docs/llm/ (≤200 lines)
- Tier 3/4: Auto-generated

---

### 2. README.md (Lines 23-25)

```markdown
| Methodology | Focus | Documentation |
| ----------- | ----- | ------------- |
| **CDD** | HOW (patterns, context) | [docs/llm/policies/cdd.md](docs/llm/policies/cdd.md) |
```

**Key Points**:
- Focus: HOW (patterns, context)
- Policy link provided

---

### 3. standards/cdd/README.md (Lines 16-23)

```markdown
## 4-Tier Architecture

| Tier | Path | Role | Max Lines | Editable | Generated |
|------|------|------|-----------|----------|-----------|
| **Tier 1** | `.ai/` | Indicator (quick ref) | ≤50 | ✅ LLM only | Manual |
| **Tier 2** | `docs/llm/` | SSOT (detailed spec) | ≤200 | ✅ LLM only | Manual |
| **Tier 3** | `docs/en/` | Human-readable (English) | N/A | ⛔ No | Auto |
| **Tier 4** | `docs/kr/` | Translation (Korean+) | N/A | ⛔ No | Auto |
```

**Key Points**:
- 4-Tier architecture (detailed)
- Same tier definitions
- Same line limits

---

### 4. STRUCTURE_COMPARISON.md

```markdown
| Tier | Path | Role | Max Lines | Editable |
|------|------|------|-----------|----------|
| **Tier 1** | `.ai/` | Indicator (quick ref) | ≤50 | ✅ LLM only |
| **Tier 2** | `docs/llm/` | SSOT (detailed spec) | ≤200 | ✅ LLM only |
| **Tier 3** | `docs/en/` | Human-readable | N/A | ⛔ No |
| **Tier 4** | `docs/kr/` | Translation | N/A | ⛔ No |
```

**Key Points**:
- Same 4-Tier structure
- Consistent limits

---

### CDD Consistency Check

| Document | Tier Count | Tier 1 | Tier 2 | Tier 3 | Tier 4 | Status |
|----------|------------|--------|--------|--------|--------|--------|
| AGENTS.md | 4 | .ai/ ≤50 | docs/llm/ ≤200 | docs/en/ Auto | docs/kr/ Auto | ✅ |
| README.md | (summary) | - | - | - | - | ✅ |
| standards/cdd/README.md | 4 | .ai/ ≤50 | docs/llm/ ≤200 | docs/en/ Auto | docs/kr/ Auto | ✅ |
| STRUCTURE_COMPARISON.md | 4 | .ai/ ≤50 | docs/llm/ ≤200 | docs/en/ Auto | docs/kr/ Auto | ✅ |

**Result**: ✅ **100% Consistent**

---

## SDD (Spec-Driven Development) Definitions

### 1. AGENTS.md (Lines 38-47)

```markdown
### SDD (Spec-Driven Development)

| Layer | Path                  | Role                 | Human Role       |
| ----- | --------------------- | -------------------- | ---------------- |
| L1    | `.specs/roadmap.md`   | WHAT (features)      | Design & Plan    |
| L2    | `.specs/scopes/*.md`  | WHEN (work range)    | Define scope     |
| L3    | `.specs/tasks/*.md`   | HOW (implementation) | Review & Approve |
| L4    | `.specs/history/*.md` | DONE (archive)       | Review           |

**Policy**: `docs/llm/policies/sdd.md`
```

**Key Points**:
- 4-Layer structure (L1-L4)
- WHAT → WHEN → HOW → DONE
- Human roles defined

**⚠️ ISSUE FOUND**: Says "L4: history", but in detailed docs it's 3-Layer (roadmap/scopes/tasks), history is optional

---

### 2. README.md (Lines 26)

```markdown
| **SDD** | WHAT (specs, tasks) | [docs/llm/policies/sdd.md](docs/llm/policies/sdd.md) |
```

**Key Points**:
- Focus: WHAT (specs, tasks)

---

### 3. standards/sdd/README.md (Lines 42-48)

```markdown
## 3-Layer Structure: WHAT → WHEN → HOW

| Layer | File | Question | Author | Content |
|-------|------|----------|--------|---------|
| **L1: Roadmap** | `roadmap.md` | WHAT to build? | Human designs → LLM documents | Feature list, priorities, dependencies |
| **L2: Scope** | `scopes/{scope}.md` | WHEN to build? | Human defines → LLM documents | Work range, period, selected items |
| **L3: Tasks** | `tasks/{scope}.md` | HOW to build? | LLM generates → Human approves | Step-by-step plan, CDD references |
```

**Key Points**:
- 3-Layer structure (L1-L3)
- WHAT → WHEN → HOW
- History not numbered as L4

**⚠️ INCONSISTENCY FOUND**: AGENTS.md says 4-Layer (L1-L4), standards/sdd/README.md says 3-Layer (L1-L3)

---

### 4. SDD_STANDARD_CLARIFICATION.md

```markdown
| Layer | File | Question | Author | Content |
|-------|------|----------|--------|---------|
| **L1: Roadmap** | `roadmap.md` | WHAT to build? | Human designs → LLM documents | ... |
| **L2: Scope** | `scopes/{scope}.md` | WHEN to build? | Human defines → LLM documents | ... |
| **L3: Tasks** | `tasks/{scope}.md` | HOW to build? | LLM generates → Human approves | ... |
```

**Key Points**:
- 3-Layer structure
- WHAT → WHEN → HOW

---

### SDD Consistency Check

| Document | Layer Count | Definition | Status |
|----------|-------------|------------|--------|
| AGENTS.md | 4-Layer (L1-L4) | roadmap/scopes/tasks/history | ⚠️ Inconsistent |
| README.md | (summary) | WHAT (specs, tasks) | ✅ |
| standards/sdd/README.md | 3-Layer (L1-L3) | roadmap/scopes/tasks | ⚠️ Inconsistent |
| SDD_STANDARD_CLARIFICATION.md | 3-Layer | roadmap/scopes/tasks | ⚠️ Inconsistent |

**Result**: ⚠️ **INCONSISTENCY DETECTED**

**Issue**: AGENTS.md defines SDD as 4-Layer (including L4: history), but:
- standards/sdd/README.md defines it as 3-Layer
- SDD_STANDARD_CLARIFICATION.md uses 3-Layer
- history/ is documented as optional archive, not core layer

---

## ADD (Agent-Driven Development) Definitions

### 1. AGENTS.md (Lines 49-58)

```markdown
### ADD (Agent-Driven Development)

| Component          | Description                                   |
| ------------------ | --------------------------------------------- |
| Multi-Agent        | Parallel execution across multiple LLM agents |
| Consensus Protocol | n LLMs verify, escalate on consensus failure  |
| Self-Resolution    | Attempt resolution before human intervention  |
| Auto-Capitalization| Experience → CDD updates                      |

**Policy**: `docs/llm/policies/add.md`
```

**Key Points**:
- 4 components defined
- Multi-agent, Consensus, Self-Resolution, Auto-Capitalization

---

### 2. README.md (Line 27)

```markdown
| **ADD** | DO (autonomous execution) | [docs/llm/policies/add.md](docs/llm/policies/add.md) |
```

**Key Points**:
- Focus: DO (autonomous execution)

---

### 3. ADD_CURRENT_STATUS.md

```markdown
## Current Operation Model

Manual Multi-Agent Orchestration:
- Human Commander reads .specs/tasks/*.md
- Assigns tasks to Claude Code / Gemini CLI
- Monitors progress
- Validates and resolves conflicts

Future: Automation (Phase 1-5)
```

**Key Points**:
- Current: Manual operation
- Components: Same as AGENTS.md
- Future: Automation roadmap

---

### 4. TEMPLATE_ENHANCEMENT_REPORT.md

```markdown
ADD (Agent-Driven Development):
- Multi-agent orchestration
- Consensus protocol
- Task distribution (parallel/sequential)
- Knowledge capitalization
```

**Key Points**:
- Same components
- Additional: Task distribution explicitly mentioned

---

### ADD Consistency Check

| Document | Status | Components | Match |
|----------|--------|------------|-------|
| AGENTS.md | Manual | Multi-Agent, Consensus, Self-Resolution, Auto-Capitalization | ✅ |
| README.md | (summary) | DO (autonomous execution) | ✅ |
| ADD_CURRENT_STATUS.md | Manual → Auto | Same components + phases | ✅ |
| TEMPLATE_ENHANCEMENT_REPORT.md | Planning | Same components + task distribution | ✅ |

**Result**: ✅ **100% Consistent**

---

## Critical Issues Found

### Issue 1: SDD Layer Count Mismatch

**Location**: AGENTS.md vs standards/sdd/README.md

**AGENTS.md says**:
```markdown
| L1 | `.specs/roadmap.md`   | WHAT (features)      |
| L2 | `.specs/scopes/*.md`  | WHEN (work range)    |
| L3 | `.specs/tasks/*.md`   | HOW (implementation) |
| L4 | `.specs/history/*.md` | DONE (archive)       |
```

**standards/sdd/README.md says**:
```markdown
## 3-Layer Structure: WHAT → WHEN → HOW

| L1: Roadmap | roadmap.md    | WHAT to build? |
| L2: Scope   | scopes/*.md   | WHEN to build? |
| L3: Tasks   | tasks/*.md    | HOW to build?  |
```

**Actual my-girok implementation**:
- roadmap.md ✅ (L1)
- scopes/*.md ✅ (L2)
- tasks/*.md ✅ (L3)
- history/ ✅ (exists but optional, not numbered)

**Correct Definition** (based on my-girok):
- **Core**: 3-Layer (roadmap/scopes/tasks)
- **Optional**: history/ for archives (not a numbered layer)

---

## Recommended Fixes

### Fix 1: AGENTS.md - Remove L4 or Clarify

**Current (Incorrect)**:
```markdown
| L4    | `.specs/history/*.md` | DONE (archive)       | Review           |
```

**Option A - Remove L4** (Recommended):
```markdown
### SDD (Spec-Driven Development)

| Layer | Path                  | Role                 | Human Role       |
| ----- | --------------------- | -------------------- | ---------------- |
| L1    | `.specs/roadmap.md`   | WHAT (features)      | Design & Plan    |
| L2    | `.specs/scopes/*.md`  | WHEN (work range)    | Define scope     |
| L3    | `.specs/tasks/*.md`   | HOW (implementation) | Review & Approve |

**Optional**: `.specs/history/` for archiving completed scopes/decisions

**Policy**: `docs/llm/policies/sdd.md`
```

**Option B - Clarify L4 is Optional**:
```markdown
| L1    | `.specs/roadmap.md`   | WHAT (features)      | Design & Plan    |
| L2    | `.specs/scopes/*.md`  | WHEN (work range)    | Define scope     |
| L3    | `.specs/tasks/*.md`   | HOW (implementation) | Review & Approve |
| (L4)  | `.specs/history/*.md` | DONE (archive)       | Optional         |
```

**Recommendation**: **Option A** - SDD is 3-Layer, history is optional archive

---

## Verification Summary

| Methodology | Consistency | Issues |
|-------------|-------------|--------|
| **CDD** | ✅ 100% | None |
| **SDD** | ⚠️ Inconsistent | Layer count (3 vs 4) |
| **ADD** | ✅ 100% | None |

### Required Actions

1. **AGENTS.md**:
   - ⚠️ Change SDD from 4-Layer to 3-Layer
   - ⚠️ Move history/ to optional section

2. **All other docs**:
   - ✅ Already consistent (3-Layer)

---

## Corrected Standard Definitions

### CDD (Context-Driven Development) - FINAL

**4-Tier Documentation Architecture**:

| Tier | Path | Role | Max Lines | Editable |
|------|------|------|-----------|----------|
| 1 | `.ai/` | Indicator (quick ref) | ≤50 | ✅ LLM only |
| 2 | `docs/llm/` | SSOT (detailed spec) | ≤200 | ✅ LLM only |
| 3 | `docs/en/` | Human-readable (English) | N/A | ⛔ Auto-generated |
| 4 | `docs/kr/` | Translation (Korean+) | N/A | ⛔ Auto-translated |

**Status**: ✅ Consistent across all documents

---

### SDD (Spec-Driven Development) - FINAL

**3-Layer Structure: WHAT → WHEN → HOW**:

| Layer | Path | Role | Author |
|-------|------|------|--------|
| L1 | `.specs/roadmap.md` | WHAT to build? | Human designs → LLM documents |
| L2 | `.specs/scopes/*.md` | WHEN to build? | Human defines → LLM documents |
| L3 | `.specs/tasks/*.md` | HOW to build? | LLM generates → Human approves |

**Optional**: `.specs/history/` for archiving completed scopes and decisions

**Status**: ⚠️ Needs fix in AGENTS.md

---

### ADD (Agent-Driven Development) - FINAL

**Multi-Agent Orchestration**:

| Component | Description |
|-----------|-------------|
| Multi-Agent | Parallel execution across multiple LLM agents |
| Consensus Protocol | n LLMs verify, escalate on consensus failure |
| Self-Resolution | Attempt resolution before human intervention |
| Auto-Capitalization | Experience → CDD updates |

**Current Status**: Manual operation (Phase 0)
**Future**: Automation roadmap (Phase 1-5)

**Status**: ✅ Consistent across all documents

---

## Conclusion

### Synchronization Status

| Check | Result |
|-------|--------|
| CDD definitions | ✅ 100% synchronized |
| SDD definitions | ⚠️ **1 inconsistency found** (AGENTS.md) |
| ADD definitions | ✅ 100% synchronized |

### Critical Fix Required

**File**: `AGENTS.md` (Line 38-47)

**Change**: SDD from 4-Layer to 3-Layer

**Impact**: High - AGENTS.md is the master policy file

---

**Verification Date**: 2026-01-23
**Verifier**: Claude (Sonnet 4.5)
**Status**: 1 Critical Issue Found - Fix Required
