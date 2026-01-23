# SDD Directory Structure Standard

> **Based on**: my-girok reference implementation
> **Version**: 1.0

---

## Standard Structure (Monorepo)

```
.specs/
├── README.md                                   # Navigation and overview
│
└── apps/                                       # Applications
    └── {app-name}/                             # Per-application
        │
        ├── roadmap.md                          # L1: WHAT to build
        │                                       # - Feature list
        │                                       # - Priorities (P0, P1, P2)
        │                                       # - Dependencies
        │                                       # - Status tracking
        │
        ├── scopes/                             # L2: WHEN to build
        │   ├── {year}-scope{N}.md             # e.g., 2026-scope1.md
        │   └── {year}-Q{N}.md                 # Alternative: 2026-Q1.md
        │                                       # - Work period
        │                                       # - Selected roadmap items
        │                                       # - Completion target
        │
        ├── tasks/                              # L3: HOW to build
        │   ├── {year}-scope{N}.md             # Matches scope filename
        │   └── {auxiliary}.md                  # e.g., common-patterns-review.md
        │                                       # - CDD references
        │                                       # - Step-by-step plan
        │                                       # - Phases (Parallel/Sequential)
        │                                       # - Dependencies
        │
        ├── diagrams/ (optional)                # Architecture diagrams
        │   └── {scope}-architecture.md
        │
        ├── history/                            # Completed archives
        │   ├── scopes/                         # Archived scope files
        │   │   └── {year}-Q{N}.md
        │   └── decisions/                      # Decision records
        │       └── YYYY-MM-DD-{topic}.md
        │
        └── {feature-spec}.md (optional)        # Detailed feature specs
```

---

## Real Example: my-girok

```
my-girok/.specs/
├── README.md
│
└── apps/
    └── web-admin/
        ├── roadmap.md
        │
        ├── scopes/
        │   └── 2026-scope1.md
        │
        ├── tasks/
        │   ├── 2026-scope1.md
        │   └── common-patterns-review.md
        │
        ├── diagrams/
        │   └── 2026-scope1-architecture.md
        │
        ├── history/
        │   ├── scopes/
        │   │   └── 2025-Q4.md
        │   └── decisions/
        │       └── 2026-01-21-menu-structure-priority.md
        │
        └── menu-structure.md
```

---

## File Naming Conventions

### Scope Files

**Format**: `{year}-scope{N}.md` or `{year}-Q{N}.md`

**Examples**:
- `2026-scope1.md` ✅
- `2026-Q1.md` ✅
- `2026-january.md` ⛔ (not standard)

---

### Task Files

**Format**: Must match corresponding scope file

**Examples**:
- Scope: `2026-scope1.md` → Tasks: `2026-scope1.md` ✅
- Scope: `2026-Q1.md` → Tasks: `2026-Q1.md` ✅

---

### History Files

**Scopes**: Use original filename
- `history/scopes/2025-Q4.md`

**Decisions**: `YYYY-MM-DD-{topic}.md`
- `2026-01-21-menu-structure-priority.md` ✅
- `decision-about-menu.md` ⛔

---

## Alternative: Single App Structure

For non-monorepo projects:

```
.specs/
├── README.md
├── roadmap.md                  # Root level
├── scopes/
│   └── 2026-Q1.md
├── tasks/
│   └── 2026-Q1.md
└── history/
    ├── scopes/
    └── decisions/
```

**When to use**: Single application projects only

---

## Services (Optional)

For service-focused monorepos:

```
.specs/
├── apps/
│   └── {app}/
│
└── services/                   # Backend services
    └── {service-name}/
        ├── roadmap.md
        ├── scopes/
        └── tasks/
```

**When to use**: Backend services need separate roadmaps from apps

---

## Validation

### Required Files (Monorepo)

```
.specs/
├── README.md                                   ✅ Required
└── apps/{app}/
    ├── roadmap.md                              ✅ Required
    ├── scopes/                                 ✅ Required (directory)
    └── tasks/                                  ✅ Required (directory)
```

### Optional Files

```
.specs/apps/{app}/
├── diagrams/                                   ⭕ Optional
├── history/                                    ⭕ Recommended
└── {feature-spec}.md                           ⭕ Optional
```

---

## Migration Guide

### From Flat Structure

**Before**:
```
.specs/
├── roadmap.md
├── scope1.md
└── tasks1.md
```

**After** (Monorepo):
```
.specs/
└── apps/my-app/
    ├── roadmap.md
    ├── scopes/
    │   └── 2026-scope1.md
    └── tasks/
        └── 2026-scope1.md
```

**Steps**:
1. Create `.specs/apps/{app}/`
2. Move `roadmap.md` → `apps/{app}/roadmap.md`
3. Create `apps/{app}/scopes/`
4. Move/rename scope files to standard naming
5. Create `apps/{app}/tasks/`
6. Move/rename task files to match scope names

---

**Version**: 1.0
**Last Updated**: 2026-01-23
