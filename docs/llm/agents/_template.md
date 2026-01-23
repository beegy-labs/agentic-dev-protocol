# {Service Name} Service - Agent Guide

> **Service**: {service-name} | **Port**: {port} | **Max Lines**: 200 (Tier 2)

## Service Overview

{1-2 sentence description of what this service does}

**Tier 1 Reference**: `.ai/services/{service-name}.md` (quick ref, ≤50 lines)

---

## Core Patterns

| Pattern | Description | Example |
|---------|-------------|---------|
| {Pattern 1} | {What it solves} | `{code snippet}` |
| {Pattern 2} | {What it solves} | `{code snippet}` |

---

## API Contracts

### Key Endpoints

| Endpoint | Method | Purpose | Auth Required |
|----------|--------|---------|---------------|
| `/api/v1/{resource}` | GET | {description} | ✅ Yes |
| `/api/v1/{resource}` | POST | {description} | ✅ Yes |

### Request/Response Format

```typescript
// Request
interface {Resource}CreateRequest {
  field1: string;    // Required: {description}
  field2?: number;   // Optional: {description}, defaults to {value}
}

// Response
interface {Resource}Response {
  id: string;        // UUID v4
  field1: string;    // Same as request
  createdAt: Date;   // ISO 8601 format
}
```

---

## Error Handling

### Standard Errors

| Error Code | Scenario | Resolution |
|------------|----------|------------|
| 400 | {scenario} | {how to fix} |
| 401 | {scenario} | {how to fix} |
| 403 | {scenario} | {how to fix} |
| 500 | {scenario} | {how to fix} |

### Error Response Format

```typescript
interface ErrorResponse {
  error: {
    code: string;        // Machine-readable error code
    message: string;     // Human-readable message
    details?: object;    // Additional context
    traceId: string;     // For debugging (required)
  };
}
```

### Retry Logic

```typescript
// ✅ REQUIRED: Exponential backoff for external calls
const retryConfig = {
  maxRetries: 3,
  baseDelay: 1000,      // 1s, 2s, 4s
  maxDelay: 10000,
  retryOn: [502, 503, 504]
};
```

---

## Compliance Requirements

### {Compliance Standard 1} (e.g., GDPR, HIPAA)

| Requirement | Implementation | Validation |
|-------------|----------------|------------|
| {Requirement} | {How it's implemented} | {How to verify} |

### Audit Trail

```typescript
// ✅ REQUIRED: Log all sensitive operations
logger.audit('sensitive_operation', {
  traceId: context.traceId,
  userId: context.userId,
  operation: '{operation}',
  resource: '{resource}',
  metadata: {
    // Include relevant context
  }
});
```

---

## Testing Patterns

### Unit Tests

```typescript
describe('{Service}', () => {
  it('should {expected behavior}', async () => {
    // Arrange
    const input = { /* ... */ };

    // Act
    const result = await service.{method}(input);

    // Assert
    expect(result).toMatchObject({
      // Expected output
    });
  });
});
```

### Integration Tests

```typescript
// Test external dependencies
it('should handle {external service} failure', async () => {
  // Mock external service failure
  mockExternalService.mockRejectedValue(new Error('Service unavailable'));

  // Verify graceful degradation
  await expect(service.{method}()).rejects.toThrow('{expected error}');
});
```

### Coverage Requirements

- ✅ Unit tests: ≥80% coverage
- ✅ Integration tests: Critical paths
- ✅ E2E tests: Happy path + major error scenarios

---

## Performance Considerations

### Caching Strategy

| Resource | TTL | Invalidation Trigger |
|----------|-----|---------------------|
| {Resource 1} | {duration} | {event} |
| {Resource 2} | {duration} | {event} |

### Database Queries

```typescript
// ✅ GOOD: Use indexes, limit results
const users = await db.user.findMany({
  where: { active: true },
  select: { id: true, email: true },  // Only needed fields
  take: 100,                           // Pagination
  orderBy: { createdAt: 'desc' }
});

// ⛔ BAD: N+1 queries
for (const user of users) {
  const profile = await db.profile.findUnique({ where: { userId: user.id } });
}
```

### Monitoring Metrics

```typescript
// Track performance metrics
metrics.histogram('operation_duration_ms', duration, {
  operation: '{operation}',
  service: '{service-name}'
});

metrics.increment('operation_count', 1, {
  operation: '{operation}',
  status: 'success|failure'
});
```

---

## Related Services

| Service | Dependency Type | Integration Point |
|---------|----------------|-------------------|
| {Service 1} | Upstream | {how data flows} |
| {Service 2} | Downstream | {how data flows} |

---

## Common Pitfalls

### Pitfall 1: {Description}

**Problem**: {What goes wrong}

**Solution**:
```typescript
// ✅ CORRECT
{code example}

// ⛔ INCORRECT
{code example}
```

### Pitfall 2: {Description}

**Problem**: {What goes wrong}

**Solution**: {How to fix}

---

## References

| Resource | Link |
|----------|------|
| Tier 1 Indicator | `.ai/services/{service-name}.md` |
| Architecture | `docs/llm/policies/architecture.md` |
| Testing Policy | `docs/llm/policies/testing.md` |
| API Standards | `docs/llm/guides/api-standards.md` |

---

## Changelog

| Date | Change | Author |
|------|--------|--------|
| YYYY-MM-DD | Initial creation | LLM |
| YYYY-MM-DD | {description} | LLM |

---

**Token Efficiency**: This guide is compiled into CLAUDE.md/GEMINI.md - no duplicate reads needed.

**Validation**: Run `npm run validate:docs` to check compliance with Tier 2 standards.
