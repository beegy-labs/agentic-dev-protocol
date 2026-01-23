# CDD (Context-Driven Development) Standard

> **Version**: 1.0 | **Last Updated**: 2026-01-23
> **Based on**: my-girok reference implementation

---

## Purpose

CDD establishes a 4-tier documentation architecture optimized for LLM consumption and human readability.

**Core Principle**: Single Source of Truth (SSOT) → Compiled Artifacts

---

## 4-Tier Architecture

| Tier | Path | Role | Max Lines | Editable | Generated |
|------|------|------|-----------|----------|-----------|
| **Tier 1** | `.ai/` | Indicator (quick ref) | ≤50 | ✅ LLM only | Manual |
| **Tier 2** | `docs/llm/` | SSOT (detailed spec) | ≤200 | ✅ LLM only | Manual |
| **Tier 3** | `docs/en/` | Human-readable (English) | N/A | ⛔ No | Auto |
| **Tier 4** | `docs/kr/` | Translation (Korean+) | N/A | ⛔ No | Auto |

---

## Tier 1: .ai/ (Indicators)

**Purpose**: Token-optimized quick reference for LLM

**Characteristics**:
- ≤50 lines per file
- Table format preferred over prose
- Links to Tier 2 for details
- Read first for any task

**Structure**:

```
.ai/
├── README.md                   # Navigation hub
├── rules.md                    # Core DO/DON'T rules (CRITICAL)
├── best-practices.md           # Best practices checklist
├── architecture.md             # System patterns
│
├── services/                   # Service indicators
│   ├── {service}.md           # ≤50 lines, links to docs/llm/services/
│   └── ...
│
├── packages/                   # Package indicators
│   ├── {package}.md           # ≤50 lines, links to docs/llm/packages/
│   └── ...
│
└── apps/                       # App indicators
    ├── {app}.md               # ≤50 lines, links to docs/llm/apps/
    └── ...
```

**Example** (`.ai/services/auth-service.md`):

```markdown
# auth-service

> Indicator (≤50 lines) | Port: 3002 | **Details**: `docs/llm/services/auth-service.md`

## Overview
Authentication service using JWT + OAuth 2.0

## Key Endpoints
| Endpoint | Method | Purpose |
|----------|--------|---------|
| `/login` | POST | Email/password login |
| `/oauth/google` | GET | Google OAuth |

## Tech Stack
- NestJS 11.1
- Passport (JWT, Google, Local)
- PostgreSQL (sessions)

## Quick Patterns
- All routes use `@UseGuards(JwtAuthGuard)`
- Session lifetime: 7 days
- Refresh tokens: 30 days

**Full Spec**: `docs/llm/services/auth-service.md`
```

---

## Tier 2: docs/llm/ (SSOT)

**Purpose**: Detailed specifications and patterns

**Characteristics**:
- ≤200 lines per file (split if larger)
- Self-contained but cross-referenced
- Machine-readable structure (tables, YAML)
- Source of truth for generation

**Structure**:

```
docs/llm/
├── README.md                   # Navigation and task mapping
│
├── policies/                   # Policy definitions
│   ├── cdd.md                 # CDD policy
│   ├── sdd.md                 # SDD policy
│   ├── add.md                 # ADD policy
│   ├── database.md            # Database patterns
│   ├── testing.md             # Testing standards
│   └── ...
│
├── services/                   # Service full specs
│   ├── {service}.md           # ≤200 lines, detailed patterns
│   └── ...
│
├── packages/                   # Package documentation
│   ├── {package}.md
│   └── ...
│
├── apps/                       # Application specs
│   ├── {app}.md
│   └── ...
│
├── guides/                     # Implementation guides
│   ├── grpc.md                # gRPC patterns
│   ├── graphql.md             # GraphQL patterns
│   └── ...
│
├── components/                 # UI component specs
│   ├── {component}.md
│   └── ...
│
└── agents/                     # Service-specific agent guides
    ├── README.md              # Agent guide overview
    ├── _template.md           # Template for new guides
    └── {service}.md           # Service-specific patterns
```

**Example** (docs/llm/services/auth-service.md - first 50 lines):

```markdown
# auth-service - Full Specification

> Tier 2: SSOT | Port: 3002 | **Indicator**: `.ai/services/auth-service.md`

## Service Overview

JWT-based authentication with OAuth 2.0 support.

## Architecture

| Layer | Implementation | Purpose |
|-------|----------------|---------|
| Controller | `AuthController` | HTTP endpoints |
| Service | `AuthService` | Business logic |
| Strategy | Passport strategies | Auth mechanisms |
| Guard | `JwtAuthGuard` | Route protection |

## API Endpoints

### POST /login

**Request**:
```typescript
interface LoginRequest {
  email: string;        // Required: Valid email
  password: string;     // Required: Min 8 chars
}
```

**Response**:
```typescript
interface LoginResponse {
  accessToken: string;  // JWT, expires in 7 days
  refreshToken: string; // Expires in 30 days
  user: {
    id: string;
    email: string;
    role: UserRole;
  };
}
```

... (continues to ≤200 lines)
```

---

## Tier 3: docs/en/ (Generated)

**Purpose**: Human-readable English documentation

**Characteristics**:
- Generated from Tier 1 + Tier 2
- Narrative format with examples
- **NEVER manually edited**
- Overwritten on each build

**Generation**:

```bash
npm run docs:generate

# Process:
# 1. Read .ai/ + docs/llm/
# 2. LLM generates human-friendly prose
# 3. Write to docs/en/
```

**Structure**:

```
docs/en/
├── README.md
├── policies/
├── services/
├── guides/
└── ...
```

---

## Tier 4: docs/kr/ (Translated)

**Purpose**: Korean (or other language) translation

**Characteristics**:
- Translated from `docs/en/`
- **NEVER manually edited**
- Overwritten on translation build

**Generation**:

```bash
npm run docs:translate

# Process:
# 1. Read docs/en/
# 2. LLM translates to Korean
# 3. Write to docs/kr/
```

---

## Data Flow

```
Developer → .ai/ + docs/llm/ (SSOT)
               ↓
          Git Commit
               ↓
          CI/CD Trigger
               ↓
     LLM Compiler (docs:generate)
               ↓
          docs/en/ (English)
               ↓
     Translation CI (docs:translate)
               ↓
          docs/kr/ (Korean)
```

---

## Core Rules

### 1. Edit Permission

| Tier | Editable By | Edited How |
|------|-------------|------------|
| Tier 1 (`.ai/`) | ✅ LLM only | Human directs → LLM writes |
| Tier 2 (`docs/llm/`) | ✅ LLM only | Human directs → LLM writes |
| Tier 3 (`docs/en/`) | ⛔ No one | Auto-generated |
| Tier 4 (`docs/kr/`) | ⛔ No one | Auto-translated |

**Violation**: Manual edits to Tier 3/4 will be overwritten

---

### 2. Line Limits

| Tier | Max Lines | Action if Exceeded |
|------|-----------|-------------------|
| Tier 1 | 50 | Split into multiple files or move details to Tier 2 |
| Tier 2 | 200 | Split into multiple files |
| Tier 3/4 | N/A | No limit |

---

### 3. Weekly Cleanup

**Frequency**: Once per week

**Tasks**:
- Remove legacy/outdated content
- Verify cross-references
- Check for broken links
- Confirm ≤50/200 line limits

---

### 4. Post-Task Updates

**Rule**: After completing any task, update relevant CDD

**Example**:
1. Task: "Implement authentication middleware"
2. Complete: auth-middleware.ts created
3. Update: `.ai/architecture.md` + `docs/llm/guides/middleware.md`
4. Reason: Future tasks reference new pattern

---

### 5. Cross-Referencing

**Tier 1 → Tier 2**:
```markdown
# .ai/services/auth-service.md

**Full Spec**: `docs/llm/services/auth-service.md`
```

**Tier 2 → Tier 1**:
```markdown
# docs/llm/services/auth-service.md

**Indicator**: `.ai/services/auth-service.md`
```

---

## Token Efficiency

### Loading Strategy

| Task Type | Load | Skip |
|-----------|------|------|
| **Start New Task** | `.ai/rules.md`, `.ai/architecture.md`, relevant `.ai/services/` | Everything else |
| **Need Details** | Relevant `docs/llm/` file | Other Tier 2 docs |
| **Policy Question** | `docs/llm/policies/` | Services, guides |

**Benefit**: Minimize token usage, maximize context relevance

---

### Table > Prose

**Good** (Tier 1):
```markdown
## API Endpoints
| Endpoint | Method | Auth |
|----------|--------|------|
| `/login` | POST | No |
| `/me` | GET | Yes |
```

**Bad**:
```markdown
The service has a login endpoint that uses POST method and doesn't require authentication. There's also a /me endpoint that requires authentication...
```

---

## Integration with SDD

SDD tasks reference CDD:

```markdown
# .specs/apps/web-admin/tasks/2026-scope1.md

## CDD References

| Document | Purpose |
|----------|---------|
| `.ai/rules.md` | Core rules |
| `.ai/architecture.md` | Patterns |
| `docs/llm/services/mail-service.md` | mail-service details |
```

**Flow**:
1. Agent reads task file
2. Task file lists CDD references
3. Agent reads those CDD files
4. Agent implements following patterns

---

## Validation Checklist

### Structure

```yaml
Required:
  - [ ] .ai/README.md exists
  - [ ] .ai/rules.md exists
  - [ ] .ai/best-practices.md exists
  - [ ] .ai/architecture.md exists
  - [ ] docs/llm/README.md exists
  - [ ] docs/llm/policies/ directory exists

Generated (don't manually edit):
  - [ ] docs/en/ exists (if using generation)
  - [ ] docs/kr/ exists (if using translation)
```

### Content

```yaml
Tier 1 (.ai/):
  - [ ] All files ≤50 lines
  - [ ] Uses tables over prose
  - [ ] Links to Tier 2 for details

Tier 2 (docs/llm/):
  - [ ] All files ≤200 lines
  - [ ] Self-contained
  - [ ] Cross-referenced
  - [ ] Has back-link to Tier 1 (if applicable)
```

---

## Best Practices (2026)

### 1. Hierarchical Information

Structure content in layers:

```markdown
## L1: Quick Overview (1-2 sentences)
Brief description

## L2: Core Patterns (table)
| Pattern | Usage |
|---------|-------|
| A | ... |

## L3: Implementation (code)
\```typescript
// Detailed example
\```

## L4: Edge Cases (notes)
- Warning: ...
```

---

### 2. Explicit Descriptions

**Good**:
```markdown
## Authentication Flow: OAuth 2.0 with PKCE
```

**Bad**:
```markdown
## Authentication
```

---

### 3. Annotated Code

**Good**:
```typescript
interface UserCreateRequest {
  email: string;        // Required: Valid email (RFC 5322)
  name: string;         // Required: 2-100 chars, UTF-8
  role?: UserRole;      // Optional: Defaults to 'user'
}
```

**Bad**:
```typescript
interface UserCreateRequest {
  email: string;
  name: string;
  role?: UserRole;
}
```

---

## Reference Implementation

**Project**: my-girok

**Structure**:
- `.ai/`: 20+ indicator files
- `docs/llm/`: 50+ SSOT documents
- `docs/en/`: Auto-generated (future)
- `docs/kr/`: Auto-translated (future)

**Status**: ✅ Tier 1-2 operational, Tier 3-4 planned

---

**Standard Version**: 1.0
**Last Updated**: 2026-01-23
**Reference**: my-girok/.ai/, my-girok/docs/llm/
