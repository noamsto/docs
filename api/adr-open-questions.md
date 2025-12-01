# Factify API - Open Design Questions

> ADR-style questions for council review. Each section presents approaches with industry examples, pros/cons, and (where applicable) a suggested direction.

---

## 1. Nested Resource Expansion Pattern

**Context:** The API returns nested objects (e.g., `DocumentResponse.current_version`, `DocumentResponse.created_by`, `DocumentPolicyResponse.policy`). How should related resources be represented?

### Option A: Always Expand (Current)

Always return full nested objects.

```json
{
  "id": "doc_01h2xcejqtf2nbrexx3vqjhp41",
  "title": "Q4 Report",
  "created_by": {
    "id": "user_01h2xcejqtf2nbrexx3vqjhp44",
    "type": "user_account",
    "name": "John Doe"
  },
  "current_version": {
    "id": "ver_01h2xcejqtf2nbrexx3vqjhp45",
    "title": "v2.0",
    "processing_status": "ready",
    "created_at": "2024-01-01T00:00:00Z",
    "created_by": { ... }
  }
}
```

**Used by:** GitHub API, Linear API

| Pros | Cons |
|------|------|
| Simple - no extra parameters | Larger payloads |
| Predictable response shape | N+1 problem on lists (each item fully expanded) |
| Good for SDK generation | Can't optimize for bandwidth |

### Option B: ID Only + `expand` Parameter (Stripe Pattern)

Return IDs by default, expand on request via `?expand[]=current_version&expand[]=created_by`.

```json
// Default
{
  "id": "doc_01h2xcejqtf2nbrexx3vqjhp41",
  "title": "Q4 Report",
  "created_by": "user_01h2xcejqtf2nbrexx3vqjhp44",
  "current_version": "ver_01h2xcejqtf2nbrexx3vqjhp45"
}

// With ?expand[]=created_by
{
  "id": "doc_01h2xcejqtf2nbrexx3vqjhp41",
  "title": "Q4 Report",
  "created_by": {
    "id": "user_01h2xcejqtf2nbrexx3vqjhp44",
    "type": "user_account",
    "name": "John Doe"
  },
  "current_version": "ver_01h2xcejqtf2nbrexx3vqjhp45"
}
```

**Used by:** Stripe, Shopify

| Pros | Cons |
|------|------|
| Minimal payloads by default | Field type changes based on expand (string vs object) |
| Client controls what to fetch | Complex SDK generation |
| Efficient for lists | Requires OpenAPI `x-expandable` extensions |

### Option C: Dual Fields (ID + Object)

Always include both ID field and nullable object field.

```json
{
  "id": "doc_01h2xcejqtf2nbrexx3vqjhp41",
  "title": "Q4 Report",
  "created_by_id": "user_01h2xcejqtf2nbrexx3vqjhp44",
  "created_by": null,
  "current_version_id": "ver_01h2xcejqtf2nbrexx3vqjhp45",
  "current_version": null
}

// With ?expand[]=created_by
{
  "id": "doc_01h2xcejqtf2nbrexx3vqjhp41",
  "title": "Q4 Report",
  "created_by_id": "user_01h2xcejqtf2nbrexx3vqjhp44",
  "created_by": {
    "id": "user_01h2xcejqtf2nbrexx3vqjhp44",
    "type": "user_account",
    "name": "John Doe"
  },
  "current_version_id": "ver_01h2xcejqtf2nbrexx3vqjhp45",
  "current_version": null
}
```

**Used by:** Some internal enterprise APIs

| Pros | Cons |
|------|------|
| Consistent field types | Redundant data when expanded |
| ID always available | More fields to maintain |
| Easy SDK generation | Verbose responses |

### Suggested Approach

**Option C (Dual Fields)** if expecting field growth and high load. Provides:
- Consistent field types (object or null, never string-to-object polymorphism)
- ID always available in dedicated field
- Clean SDK generation
- Client controls expansion without payload bloat

**Option A (Always Expand)** only if confident that nested objects will stay small and load will be moderate.

**Note:** Option B (Stripe pattern) is powerful but adds SDK complexity due to polymorphic field types.

---

## 2. Idempotency Keys

**Context:** Should POST endpoints support idempotency keys to prevent duplicate operations (e.g., creating the same document twice due to network retry)?

### Option A: No Idempotency Keys

Client is responsible for deduplication.

**Used by:** Most simple CRUD APIs

| Pros | Cons |
|------|------|
| Simpler implementation | Risk of duplicate resources on retry |
| No storage overhead | Client must implement retry logic carefully |

### Option B: `Idempotency-Key` Header

Client sends unique key; server stores and returns cached response for duplicates.

```
POST /documents
Idempotency-Key: 550e8400-e29b-41d4-a716-446655440000
Content-Type: multipart/form-data
```

**Used by:** Stripe, Square, Adyen

| Pros | Cons |
|------|------|
| Safe retries | Requires key storage (Redis/DB) |
| Industry standard pattern | Key expiration policy needed |
| Critical for payment-like operations | Implementation complexity |

### Suggested Approach

**Option B** - Document creation is a significant operation. Idempotency keys prevent duplicate documents from network issues. Implement with 24-hour key expiration.

---

## 3. Response Envelope

**Context:** Should single-object responses be wrapped in a `data` envelope?

### Option A: Direct Object (Current)

```json
{
  "id": "doc_01h2xcejqtf2nbrexx3vqjhp41",
  "title": "Q4 Report"
}
```

**Used by:** GitHub, Stripe (mostly)

| Pros | Cons |
|------|------|
| Cleaner responses | Harder to add metadata later |
| Direct access to fields | Inconsistent with list responses |

### Option B: Data Envelope

```json
{
  "data": {
    "id": "doc_01h2xcejqtf2nbrexx3vqjhp41",
    "title": "Q4 Report"
  }
}
```

**Used by:** JSON:API spec, some GraphQL implementations

| Pros | Cons |
|------|------|
| Room for metadata (request_id, etc.) | Extra nesting |
| Consistent wrapper | More verbose |
| Easier to extend | Over-engineering for simple API |

### Suggested Approach

**Option A (Direct Object)** - Keep it simple. If metadata is needed later, use headers (e.g., `X-Request-Id`). List responses already have structure via `items` + `pagination`.

---

## 4. Request ID in Responses

**Context:** Should responses include a unique request ID for debugging and support?

### Option A: No Request ID

No tracking identifier in responses.

| Pros | Cons |
|------|------|
| Simpler responses | Harder to debug issues |
| | Support requests lack correlation |

### Option B: `X-Request-Id` Header

Return request ID in response header.

```
HTTP/1.1 200 OK
X-Request-Id: req_01h2xcejqtf2nbrexx3vqjhp46
Content-Type: application/json
```

**Used by:** Stripe, Heroku, Cloudflare

| Pros | Cons |
|------|------|
| Doesn't pollute response body | Clients must read headers |
| Industry standard | |
| Essential for support | |

### Option C: In Response Body

Include in every response body.

```json
{
  "id": "doc_01h2xcejqtf2nbrexx3vqjhp41",
  "title": "Q4 Report",
  "_request_id": "req_01h2xcejqtf2nbrexx3vqjhp46"
}
```

**Used by:** Some APIs (often combined with envelope)

| Pros | Cons |
|------|------|
| Always visible | Pollutes response schema |
| Easy to log | Underscore prefix is awkward |

### Suggested Approach

**Option B (Header)** - Use `X-Request-Id` header. Clean separation, industry standard, doesn't affect schema.

---

## 5. Delete Operations

**Context:** The API currently only supports `DELETE /documents/{document_id}/policies/{policy_id}`. Should documents and versions be deletable?

### Option A: No Delete for Documents/Versions

Documents and versions are immutable records.

| Pros | Cons |
|------|------|
| Audit trail preserved | Storage grows forever |
| Legal compliance (can't destroy evidence) | No way to remove mistakes |
| Simpler | |

### Option B: Soft Delete (Archive)

Add `DELETE /documents/{document_id}` that sets `archived: true`.

```json
{
  "id": "doc_01h2xcejqtf2nbrexx3vqjhp41",
  "archived": true,
  "archived_at": "2024-01-15T10:30:00Z"
}
```

**Used by:** Linear, Notion, most SaaS

| Pros | Cons |
|------|------|
| Recoverable | More complex queries |
| Audit trail preserved | Need `include_archived` param |
| User can "delete" | |

### Option C: Hard Delete

Permanently remove the resource.

| Pros | Cons |
|------|------|
| Clean storage | No recovery |
| Simple | Legal/compliance risk |
| | Breaks references |

### Suggested Approach

**Option A or B** depending on business requirements. For legally-binding documents, Option A (no delete) may be required for compliance. If delete is needed, Option B (soft delete) preserves audit trail.

---

## 6. Webhook Events

**Context:** Should the API support webhooks for async notifications (e.g., document processing complete)?

### Option A: No Webhooks (Current)

Clients poll for status changes.

| Pros | Cons |
|------|------|
| Simpler | Inefficient polling |
| No webhook infrastructure | Poor UX for long operations |

### Option B: Webhooks

Subscribe to events like `document.processing.completed`, `document.created`.

```json
POST /webhooks
{
  "url": "https://example.com/webhook",
  "events": ["document.processing.completed"]
}
```

**Used by:** Stripe, GitHub, Twilio

| Pros | Cons |
|------|------|
| Real-time notifications | Webhook infrastructure needed |
| Efficient | Retry logic, signing |
| Essential for async operations | Endpoint management |

### Suggested Approach

**Option B** - Given that document processing is async (`processing_status`), webhooks are important for good DX. Consider for v1.1 or v2.

---

## 7. API Versioning Strategy

**Context:** Currently using URL path versioning (`/v1/`). Is this the long-term strategy?

### Option A: URL Path (Current)

```
https://api.factify.com/v1/documents
https://api.factify.com/v2/documents
```

**Used by:** Stripe, Twilio, GitHub

| Pros | Cons |
|------|------|
| Explicit and clear | URL changes between versions |
| Easy to route | Can't mix versions in one request |
| Cache-friendly | |

### Option B: Header Versioning

```
GET /documents
API-Version: 2024-01-15
```

**Used by:** Stripe (date-based), Microsoft Graph

| Pros | Cons |
|------|------|
| Clean URLs | Hidden version |
| Date-based is flexible | Harder to test |

### Suggested Approach

**Option A (URL Path)** - Already implemented, industry standard, stick with it.

---

## 8. Batch Operations

**Context:** Should the API support bulk create/update/delete operations?

### Option A: No Batch Operations (Current)

One resource per request.

**Used by:** Most REST APIs by default

| Pros | Cons |
|------|------|
| Simple implementation | N requests for N resources |
| Clear error handling | Slow for bulk imports |
| Easy to understand | More network overhead |

### Option B: Batch Endpoint

Dedicated endpoint for bulk operations.

```
POST /documents/batch
{
  "operations": [
    { "method": "create", "data": { "title": "Doc 1", ... } },
    { "method": "create", "data": { "title": "Doc 2", ... } }
  ]
}
```

Response with per-operation status:
```json
{
  "results": [
    { "success": true, "data": { "id": "doc_..." } },
    { "success": false, "error": { "type": "invalid_request_error", ... } }
  ]
}
```

**Used by:** Google APIs, Facebook Graph API

| Pros | Cons |
|------|------|
| Single request for many operations | Complex error handling |
| Efficient for bulk imports | All-or-nothing vs partial success decision |
| Reduced latency | Larger request payloads |

### Option C: Array in Request Body

Accept array of resources on create endpoints.

```
POST /documents
[
  { "title": "Doc 1", ... },
  { "title": "Doc 2", ... }
]
```

**Used by:** Some simpler APIs

| Pros | Cons |
|------|------|
| Minimal API change | Only works for create |
| Intuitive | Breaks single-resource response pattern |

### Suggested Approach

**Option A** for v1. Batch operations add complexity. Consider Option B for v1.1 if customers need bulk import capabilities.

---

## 9. Field Selection (Sparse Fieldsets)

**Context:** Should clients be able to request only specific fields via `?fields=id,title`?

### Option A: No Field Selection (Current)

Always return all fields.

**Used by:** Most REST APIs

| Pros | Cons |
|------|------|
| Simple | Larger payloads than needed |
| Predictable responses | Can't optimize for mobile/bandwidth |
| Good for caching | |

### Option B: `fields` Parameter

Allow clients to specify which fields to return.

```
GET /documents?fields=id,title,created_at
```

```json
{
  "items": [
    { "id": "doc_...", "title": "Q4 Report", "created_at": "2024-01-01T00:00:00Z" }
  ],
  "pagination": { ... }
}
```

**Used by:** Google APIs, Facebook Graph API, JSON:API spec

| Pros | Cons |
|------|------|
| Bandwidth efficient | Complex response schema (fields vary) |
| Client controls payload size | SDK generation harder |
| Good for mobile apps | Cache invalidation complexity |

### Option C: Predefined Views

Offer named response profiles.

```
GET /documents?view=minimal  // id, title only
GET /documents?view=full     // all fields (default)
```

**Used by:** Some enterprise APIs

| Pros | Cons |
|------|------|
| Simpler than arbitrary fields | Less flexible |
| Predictable response shapes | Must anticipate use cases |
| Easy to document | |

### Suggested Approach

**Option A** for v1. Factify's resources are not large (Document has ~9 fields). If bandwidth becomes a concern, consider Option C (predefined views) as a simpler alternative to arbitrary field selection.

---

## Summary Table

| # | Question | Options | Suggested |
|---|----------|---------|-----------|
| 1 | Nested Resource Expansion | A: Always expand, B: expand param, C: dual fields | C (Dual fields) if high load expected |
| 2 | Idempotency Keys | A: None, B: Header | B (Header) |
| 3 | Response Envelope | A: Direct, B: Wrapped | A (Direct) |
| 4 | Request ID | A: None, B: Header, C: Body | B (Header) |
| 5 | Delete Operations | A: None, B: Soft, C: Hard | A or B (business decision) |
| 6 | Webhooks | A: None, B: Webhooks | B (v1.1/v2) |
| 7 | API Versioning | A: URL path, B: Header | A (URL path) |
| 8 | Batch Operations | A: None, B: Batch endpoint, C: Array body | A (v1), B (v1.1 if needed) |
| 9 | Field Selection | A: None, B: fields param, C: views | A (v1) |

---

## Next Steps

1. Council reviews and decides on each question
2. Document decisions in ADR format
3. Update OpenAPI spec accordingly
4. Prioritize implementation (idempotency keys and request ID are low-effort, high-value)
