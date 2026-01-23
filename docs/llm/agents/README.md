# Service-Specific Agent Guidelines

> **Path**: `docs/llm/agents/` | **Role**: Service-specific LLM agent guidelines

## Purpose

This directory contains **service-specific agent guidelines** for individual projects.

**Not in this directory**: Agent-specific optimizations (Claude vs Gemini). Those go in agent entry files (CLAUDE.md, GEMINI.md).

---

## Structure

```
docs/llm/agents/
├── README.md              # This file
├── _template.md           # Template for creating new service guides
└── {service-name}.md      # Service-specific guidelines
```

---

## When to Create Service Guides

Create a service guide when:

- ✅ Service has unique patterns or constraints
- ✅ Service requires specific error handling
- ✅ Service has domain-specific rules
- ✅ Service has compliance requirements

Do NOT create when:

- ⛔ Service follows standard patterns (covered in `.ai/architecture.md`)
- ⛔ Information duplicates Tier 1 (`.ai/services/{service}.md`)

---

## Template Usage

```bash
# Copy template for new service
cp docs/llm/agents/_template.md docs/llm/agents/auth-service.md

# Edit with service-specific content
# Keep ≤200 lines (Tier 2 max)
```

---

## 2026 Best Practices

Based on [LLM-optimized documentation standards](https://gitbook.com/docs/publishing-documentation/llm-ready-docs):

### Content Structure

- ✅ Use tables for structured data
- ✅ Use bullet points for lists
- ✅ Use numbered lists for processes
- ✅ Keep paragraphs ≤3 sentences
- ✅ Use explicit headings (no vague titles)

### Code Examples

```typescript
// ✅ GOOD: Explicit, annotated
interface UserCreateRequest {
  email: string;        // Required: Valid email format
  name: string;         // Required: 2-100 chars
  role?: UserRole;      // Optional: Defaults to 'user'
}

// ⛔ BAD: Implicit, no context
interface UserCreateRequest {
  email: string;
  name: string;
  role?: UserRole;
}
```

### API Documentation

| Field | Type | Required | Description | Example |
|-------|------|----------|-------------|---------|
| `email` | string | ✅ Yes | Valid email format | `user@example.com` |
| `name` | string | ✅ Yes | 2-100 characters | `John Doe` |
| `role` | UserRole | ⛔ No | Defaults to 'user' | `admin` |

---

## Integration with Agent Entry Files

Service guides are **compiled into agent entry files** (CLAUDE.md, GEMINI.md):

```
CLAUDE.md = llm-dev-protocol/AGENTS.md
          + docs/llm/agents/auth-service.md
          + docs/llm/agents/personal-service.md
          + .ai/project-config.md
```

**Token Efficiency**: LLM reads CLAUDE.md once, gets all information.

---

## Validation

Service guides must pass:

```yaml
Structure:
  - [ ] ≤200 lines (Tier 2 max)
  - [ ] Uses tables/lists (not long prose)
  - [ ] Has explicit headings
  - [ ] Links to Tier 1 (`.ai/services/{service}.md`)

Content:
  - [ ] Focuses on HOW (patterns, constraints)
  - [ ] Includes code examples with annotations
  - [ ] Documents error handling patterns
  - [ ] Lists compliance requirements (if any)

References:
  - [ ] Cross-references related services
  - [ ] Links to policies (`docs/llm/policies/`)
  - [ ] Links to guides (`docs/llm/guides/`)
```

---

## Example Services

| Service | Guide | Focus |
|---------|-------|-------|
| auth-service | `auth-service.md` | OAuth flows, JWT handling |
| analytics-service | `analytics-service.md` | ClickHouse patterns, metrics |
| notification-service | `notification-service.md` | Message queue patterns |

---

## Best Practices (2026)

### 1. Hierarchical Context

Structure information in layers:

```
L1: Service Overview (1-2 sentences)
  L2: Core Patterns (table format)
    L3: Implementation Details (code examples)
      L4: Edge Cases (warnings/notes)
```

### 2. Predictable Patterns

Use consistent structure across all service guides:

```markdown
## {Service} Overview
## Core Patterns
## API Contracts
## Error Handling
## Compliance Requirements
## Testing Patterns
```

### 3. Model Context Protocol (MCP)

Document service interfaces using [MCP standards](https://www.ruh.ai/blogs/ai-agent-protocols-2026-complete-guide):

```typescript
// MCP-compatible service interface
interface ServiceContext {
  tools: Tool[];           // Available operations
  resources: Resource[];   // Data sources
  prompts: Prompt[];       // Predefined workflows
}
```

### 4. Audit Trails

Include logging patterns ([Enterprise AI requirements](https://kanerika.com/blogs/ai-agent-orchestration/)):

```typescript
// Required: Structured logging with trace IDs
logger.info('operation_started', {
  traceId,
  userId,
  operation: 'user.create',
  metadata: { email }
});
```

---

## Sources

- [GitBook LLM-ready Documentation](https://gitbook.com/docs/publishing-documentation/llm-ready-docs)
- [AI Agent Protocols 2026](https://www.ruh.ai/blogs/ai-agent-protocols-2026-complete-guide)
- [AI Agent Orchestration Best Practices](https://kanerika.com/blogs/ai-agent-orchestration/)
- [Optimizing Docs for LLMs](https://dev.to/joshtom/optimizing-technical-documentations-for-llms-4bcd)

---

**Next**: See [_template.md](_template.md) to create your first service guide
