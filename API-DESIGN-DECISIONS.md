# Factify API v1 - Refined Design Decisions

> **Last Updated:** 2025-01-24
> **Status:** Final for v1 Implementation

This document captures all refined API design decisions with real-world company examples backing each choice.

---

## Table of Contents

1. [Resource Structure & Endpoints](#resource-structure--endpoints)
2. [Response Schema Design](#response-schema-design)
3. [Nested Objects & Relations](#nested-objects--relations)
4. [Access Control on Creation](#access-control-on-creation)
5. [File Upload Patterns](#file-upload-patterns)
6. [Bulk Operations](#bulk-operations)
7. [Processing Status](#processing-status)
8. [Field Visibility & Permissions](#field-visibility--permissions)

---

## Resource Structure & Endpoints

### Decision: Versions as Separate Resource

**Approach:** Versions are first-class resources with both flat and nested access patterns.

```
GET  /v1/versions?document_id=doc_123    # Flat access
GET  /v1/documents/doc_123/versions      # Convenience nested access
POST /v1/versions                        # Create new version
GET  /v1/versions/ver_456                # Get specific version
```

### Real-World Examples

| Company | Pattern | Rationale |
|---------|---------|-----------|
| **Google Drive** | `/files/{id}/revisions` | Versions as separate resource |
| **Dropbox** | `/files/list_revisions` | Explicit version API |
| **GitHub** | `/repos/{owner}/{repo}/commits` | Commits as first-class resources |
| **Confluence** | `/content/{id}/version` | Page versions accessible separately |

### Why This Wins

✅ **Explicit > Implicit** - Developers know exactly how to create versions
✅ **Query flexibility** - Can list versions across multiple documents
✅ **Future-proof** - Easy to add version comparison, restore, diffs
✅ **Common pattern** - Matches industry leaders

### Alternative Considered

❌ **Implicit versioning** - `POST /documents/{id}` auto-creates versions
**Rejected because:** Not obvious, harder to query, limits future features

---

## Response Schema Design

### Decision: Single Schema for All Contexts

**Approach:** One predictable schema, omit/null sensitive fields based on permissions.

```typescript
// Always the same shape
interface Document {
  id: string;
  title: string;
  access_level: string;
  internal_notes: string | null;  // null for non-admins
  // ... other fields
}
```

### Real-World Examples

| Company | Pattern | Example |
|---------|---------|---------|
| **Stripe** | Single schema, omit sensitive fields | Payment methods redact card details |
| **GitHub** | Single schema, null for private data | Repo shows `null` for private fork sources |
| **Slack** | Single schema, permission-based fields | Messages omit `user_profile` for restricted users |
| **Twilio** | Single schema, redact sensitive data | Phone numbers show last 4 digits only |

### Why This Wins

✅ **Predictable** - Same TypeScript type everywhere
✅ **Cacheable** - Same URL = same structure
✅ **Testable** - Fewer combinations to test
✅ **SDK-friendly** - Clean generated code

### Anti-Pattern Rejected

❌ **oneOf in success responses**

```yaml
# BAD - Don't do this
responses:
  '200':
    schema:
      oneOf:
        - $ref: '#/DocumentFull'      # Admin version
        - $ref: '#/DocumentLimited'   # User version
```

**Problems:**
- TypeScript unions are painful
- Can't know structure until runtime
- SDK generation produces messy code
- Testing explosion

**When oneOf IS okay:**
- Error responses (different error types)
- Webhook events (document.created vs document.deleted)
- Content negotiation (JSON vs PDF)

---

## Nested Objects & Relations

### Decision: Inline Critical Data, Reference IDs Otherwise

**Pattern:**

```json
{
  "id": "doc_123",
  "title": "Q4 Report",

  "current_version": {
    // INLINE - Always needed
    "id": "ver_456",
    "version_number": 3,
    "content": "...",
    "created_at": 1234567890
  },

  "policy_ids": ["pol_789", "pol_012"],  // Just IDs
  "created_by": "user_999"               // Just ID
}
```

### Real-World Examples

| Company | Inlines | References as IDs | Expand Support |
|---------|---------|-------------------|----------------|
| **Stripe** | `payment_method.card` | `customer`, `subscription` | ✅ `expand[]` |
| **GitHub** | `commit.author` | `repository`, `organization` | ❌ Separate requests |
| **Shopify** | `order.line_items` | `customer`, `products` | ✅ `fields` param |
| **Twilio** | `message.error_code` | `account_sid` | ❌ Separate requests |

### Decision Matrix

| Relationship | Inline? | Reasoning |
|--------------|---------|-----------|
| `current_version` | ✅ YES | Always displayed together |
| `policy_ids` | ❌ NO | Rarely needed, can be large |
| `created_by` | ❌ NO | User data may be complex |
| `metadata` | ✅ YES | User-defined, always relevant |

### Future: Stripe-Style Expand

```
GET /documents/doc_123?expand[]=policies&expand[]=created_by

{
  "id": "doc_123",
  "policies": [
    {"id": "pol_789", "name": "GDPR", "rules": {...}},
    {"id": "pol_012", "name": "SOC2", "rules": {...}}
  ],
  "created_by": {
    "id": "user_999",
    "name": "John Doe",
    "email": "john@example.com"
  }
}
```

---

## Access Control on Creation

### Decision: Allow with Safe Default

**Approach:** Accept `access_level` on creation, default to `private`.

```json
POST /documents
{
  "title": "Q4 Report",
  "content": "...",
  "access_level": "organization"  // Optional, defaults to "private"
}
```

### Real-World Examples

| Company | Default | Explicit Choice on Creation? |
|---------|---------|------------------------------|
| **GitHub** | Private | ✅ YES - Repos require public/private choice |
| **AWS S3** | Private | ✅ YES - Buckets require ACL specification |
| **Google Drive** | Private | ❌ NO - Files start private, change later |
| **Dropbox** | Private | ❌ NO - Files start in your folder |
| **Stripe** | N/A | ✅ YES - Customers can have metadata on creation |

### Why We Allow It

✅ **Developer API** - Not consumer-facing, users are technical
✅ **One request** - Faster workflow
✅ **Clear default** - `private` prevents accidents
✅ **Matches industry** - GitHub and AWS do this

### Safeguards

1. **Safe default**: `private` (most restrictive)
2. **Documentation warning**: "⚠️ Setting `public` makes document immediately accessible"
3. **Audit logging**: Always log access level on creation
4. **Future**: Consider confirmation header for `public` access

```http
POST /documents
X-Confirm-Public-Access: true
{"access_level": "public"}
```

---

## File Upload Patterns

### Decision: Multipart Upload for V1

**Pattern:**

```http
POST /documents
Content-Type: multipart/form-data

--boundary
Content-Disposition: form-data; name="file"; filename="report.pdf"
Content-Type: application/pdf

[binary PDF data]
--boundary
Content-Disposition: form-data; name="metadata"
Content-Type: application/json

{
  "title": "Q4 Report",
  "description": "Annual report",
  "access_level": "private",
  "policy_ids": ["pol_123"]
}
--boundary--
```

### Real-World Examples

| Company | Single File Upload | Bulk Upload |
|---------|-------------------|-------------|
| **Google Drive** | Multipart upload with metadata | Resumable upload protocol |
| **Dropbox** | Simple upload | `upload_session/start`, `append_v2`, `finish` |
| **AWS S3** | PUT with headers | Multipart upload API (chunked) |
| **Cloudflare Images** | Multipart form-data | Direct Upload URLs (presigned) |

### Response Includes Processing Status

```json
{
  "id": "doc_123",
  "title": "Q4 Report",
  "processing_status": "pending",  // ← Key field
  "current_version": {
    "id": "ver_456",
    "version_number": 1,
    "processing_status": "pending"
  }
}
```

**Processing states:**
- `pending` - Queued for processing
- `processing` - Currently being processed
- `ready` - Available
- `failed` - Processing error

---

## Bulk Operations

### Decision: Defer to V2 with Async Job Pattern

**V1:** Single document creation only

**V2 Pattern** (when we add it):

```json
POST /documents/bulk-upload-jobs
{
  "documents": [
    {"title": "Doc 1", "access_level": "private"},
    {"title": "Doc 2", "access_level": "private"}
  ]
}

Response:
{
  "job_id": "job_789",
  "status": "awaiting_uploads",
  "uploads": [
    {
      "document_id": "doc_123",
      "upload_url": "https://upload.factify.com/...",
      "expires_at": 1234567890
    }
  ]
}
```

### Real-World Examples

| Company | Pattern | Details |
|---------|---------|---------|
| **Dropbox** | Upload sessions | `start` → `append_v2` → `finish` |
| **Google Drive** | Resumable uploads | Chunked upload with progress |
| **AWS S3** | Multipart upload | Parallel chunk uploads |
| **Cloudflare** | Direct Upload URLs | Presigned URLs for client-side upload |

### Why Defer to V2

✅ **Complexity** - Async jobs, progress tracking, partial failures
✅ **Edge cases** - Timeout handling, resumability
✅ **V1 use case** - Single uploads cover 90% of MVP needs
✅ **Pattern exists** - Well-understood async job pattern available

---

## Processing Status

### Decision: Immediate Response with Status Field

**Key insight:** Entry page available immediately, full document async.

```json
// Create returns immediately
POST /documents
Response: 201 Created

{
  "id": "doc_123",
  "processing_status": "pending",
  "current_version": {
    "processing_status": "pending"
  }
}

// Entry page works immediately
GET /documents/doc_123/entry-page
→ Returns metadata even if processing_status="pending"

// Poll for completion
GET /documents/doc_123
{
  "processing_status": "ready",  // ← Changed
  "current_version": {
    "processing_status": "ready",
    "content_url": "https://...",
    "page_count": 12
  }
}
```

### Real-World Examples

| Company | Async Processing Pattern |
|---------|--------------------------|
| **Stripe** | Webhooks + status polling for disputes |
| **Twilio** | Status callbacks for SMS delivery |
| **SendGrid** | Webhook events for email delivery |
| **Cloudinary** | Eager transformations with webhooks |

---

## Field Visibility & Permissions

### Decision: Single Schema, Omit Sensitive Fields

**Pattern:**

```typescript
// OpenAPI documents full schema
interface Document {
  id: string;
  title: string;
  access_level: string;
  internal_notes: string | null;  // Marked as admin-only in docs
  audit_log?: AuditEntry[];       // Optional, admin-only
}

// Backend decides what to include
function serializeDocument(doc: Document, user: User) {
  const response = {
    id: doc.id,
    title: doc.title,
    access_level: doc.access_level
  };

  if (user.isAdmin()) {
    response.internal_notes = doc.internal_notes;
    response.audit_log = doc.audit_log;
  }

  return response;
}
```

### Real-World Examples

| Company | Pattern | Example |
|---------|---------|---------|
| **Stripe** | Omit fields | Redact card CVV, show last 4 only |
| **GitHub** | Null for private | Private fork sources show `null` |
| **Slack** | Permission-based | Private channels omit member lists |
| **Twilio** | Partial masking | Phone numbers: +1 (XXX) XXX-1234 |

### Documentation Approach

```yaml
Document:
  properties:
    internal_notes:
      type: [string, "null"]
      description: |
        Internal notes visible to admins only.
        Returns `null` for non-admin users.
```

---

## Object Type Discriminator

### Decision: Use `object` Field (Not `type`)

**Pattern:** All resources and collections include an `object` field for structural type discrimination.

```json
// Resources
{
  "object": "document",
  "id": "doc_123",
  "type": "contract"        // ← Semantic field available
}

// Collections
{
  "object": "list",
  "data": [...]
}

// Errors
{
  "error": {
    "object": "error",
    "type": "validation_error"  // ← Semantic field available
  }
}
```

### Why `object` Instead of `type`

**Problem:** `type` is one of the most natural field names for domain modeling. Using it as a structural discriminator reserves it, forcing awkward alternatives throughout the API.

**Collision Examples from Factify:**

```json
// Bad: If we used "type" as structural discriminator
{
  "type": "document",              // ← Structural
  "document_type": "contract",     // ← Forced awkward name
  "id": "doc_123"
}

// Good: With "object" as structural discriminator
{
  "object": "document",            // ← Structural
  "type": "contract",              // ← Clean semantic field
  "id": "doc_123"
}
```

**More collision scenarios:**

```json
// Policies with retention types
{
  "object": "policy",
  "type": "retention",             // ← Natural
  "retention_days": 2555
}

// Form submissions by type
{
  "object": "form_submission",
  "type": "contact",               // ← Natural
  "submitted_at": 1234567890
}

// Events/webhooks
{
  "object": "event",
  "type": "document.created",      // ← Natural event type
  "data": {...}
}
```

**If we'd used `type` as structural field:**
```json
// Forced to use prefixed names everywhere
{
  "type": "policy",
  "policy_type": "retention",      // ← Verbose
  "policy_status": "active",       // ← More prefixes
  "policy_classification": "..."   // ← Even more prefixes
}
```

### Real-World Examples

| Company | Pattern | Reasoning |
|---------|---------|-----------|
| **Stripe** | `object` field | Avoids collision with semantic `type` fields (card type, account type, event type) |
| **JSON:API** | `type` field | Standardized, but forces prefixes for domain types |
| **GraphQL** | `__typename` | Double underscore signals structural vs semantic |
| **GitHub** | No type field | Relies on endpoint context |
| **Twilio** | No type field | Simpler but harder for generic handlers |

### Stripe's Specific Use Cases

**Payment Methods:**
```json
{
  "object": "payment_method",
  "type": "card"              // ← Semantic: card vs bank_account vs wallet
}
```

**Accounts:**
```json
{
  "object": "account",
  "type": "express"           // ← Semantic: standard vs express vs custom
}
```

**Events:**
```json
{
  "object": "event",
  "type": "charge.succeeded"  // ← Semantic: event classification
}
```

**Disputes:**
```json
{
  "object": "dispute",
  "type": "fraudulent"        // ← Semantic: fraudulent vs product_not_received
}
```

### Benefits

✅ **Preserves `type` for domain modeling** - No need for `document_type`, `policy_type`, `form_type`
✅ **Consistent everywhere** - Same pattern for resources, lists, errors
✅ **Familiar to Stripe developers** - Large developer audience knows this pattern
✅ **Clean field names** - `type`, `status`, `classification` without prefixes
✅ **Easy discrimination** - Generic handlers can check `object` field

### Future Use Cases

```typescript
// Filter documents by type
GET /documents?type=contract
GET /documents?type=invoice
GET /documents?type=policy

// If "type" was structural, we'd need:
GET /documents?document_type=contract  // ← Awkward
```

### Alternative Considered

❌ **Using `type` as structural discriminator**

**Rejected because:**
- Reserves most natural field name for classification
- Forces verbose prefixed names (`document_type`, `policy_type`)
- Creates inconsistency (sometimes `type`, sometimes `*_type`)
- Makes query parameters awkward (`?document_type=...`)

### When Clients Use This

```typescript
// Generic handler
function handle(response: any) {
  if (response.object === "list") {
    return response.data.map(handleResource);
  }
  return handleResource(response);
}

// Type-based filtering remains clean
const contracts = await client.documents.list({ type: "contract" });
```

---

## Summary Table

| Decision | Pattern | Backed By |
|----------|---------|-----------|
| Versions | Separate resource | Google Drive, Dropbox, GitHub |
| Response schemas | Single schema | Stripe, GitHub, Slack, Twilio |
| Nested objects | Inline current_version, IDs otherwise | Stripe (expand[]), Shopify |
| Access on creation | Allow with safe default | GitHub, AWS S3 |
| File upload | Multipart form-data | Google Drive, Cloudflare |
| Bulk operations | Defer to V2 with async jobs | Dropbox, AWS S3, Cloudflare |
| Processing status | Immediate response + status field | Stripe, Twilio, SendGrid |
| Field visibility | Omit based on permissions | Stripe, GitHub, Slack |
| **Type discriminator** | **`object` field (not `type`)** | **Stripe** |
| Content storage | URLs not inline | Stripe (file.url), GitHub, Dropbox, AWS S3 |

---

## Next Steps

1. ✅ Update OpenAPI specification with refined decisions
2. ✅ Update API design brainstorm document
3. ✅ Update formal specification document
4. ⏳ Implement refined endpoints
5. ⏳ Update Mintlify documentation
6. ⏳ Generate SDKs with Speakeasy
