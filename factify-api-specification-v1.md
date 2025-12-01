# [SPEC] [DRAFT] Factify API v1 - Contract-First Specification

> **Document Purpose:** This specification defines the contract-first design for Factify's public API v1, establishing conventions, patterns, and endpoints for our document platform that replaces PDFs with legally-binding, API-first documents.

```admonish info title="Contract-First Approach"
This API specification serves as the single source of truth. The OpenAPI 3.1 schema, SDK generation, and documentation will all derive from this design. All design decisions are backed by industry research and best practices from leading API platforms.
```

```admonish warning title="Target Audience"
This API is designed for **external developers first** - enterprise IT teams, third-party integrations, and automation platforms. Internal needs must never compromise external developer experience.
```

<-toc->

## 📋 Project Information

### Program Details

- **Program Name:** Factify API v1
- **Project:** Public API for Document Platform
- **Business Groups:** Engineering, Product
- **Product Vision:** Replace PDFs with legally-binding, future-proof, API-first documents
- **Program Manager:** TBD

### 👥 Key Stakeholders

- **Engineering Manager:** TBD
- **API Architect:** Noam Stolero
- **Backend Lead Engineer:** TBD
- **DevEx Lead:** TBD
- **Security Lead:** TBD
- **Product Lead:** TBD

### 📝 Document History

| Version | Author | Date       | Changes                              |
| ------- | ------ | ---------- | ------------------------------------ |
| 1.0     | Noam   | 2025-01-20 | Initial API specification (1-2 week iteration) |

---

# 1. 📖 Overview

## 🎯 Executive Summary

### Story Outline

Factify is building a world-class API to enable enterprises to create, manage, and control access to legally-binding documents that replace PDFs. The API must provide exceptional developer experience, support automation platforms, and scale from pilot customers to enterprise deployments without breaking changes.

### SCQA Framework

| **Situation**    | PDFs are static, lack APIs, have no access control, and aren't workflow-friendly                    |
| ---------------- | ---------------------------------------------------------------------------------------------------- |
| **Complication** | Enterprises need legally-binding documents with APIs, versioning, access control, and AI-readiness   |
| **Question**     | How do we design an API that provides world-class DX while supporting complex enterprise requirements? |
| **Answer**       | Contract-first API with Stripe-inspired patterns, OpenAPI 3.1 spec, Mintlify docs, and Speakeasy SDKs |

### Current State & Gaps

- **Current State:**
  - Mintlify documentation site initialized
  - Core business domain defined (Documents, Versions, Policies, Forms)
  - Design decisions made and validated through brainstorming
  - No API implementation yet (greenfield)

- **Identified Gaps:**
  - Need formal OpenAPI 3.1 specification
  - Need endpoint definitions with request/response schemas
  - Need error handling conventions documented
  - Need pagination and filtering patterns specified
  - Need authentication flow documented

- **Required Changes:**
  - Create comprehensive API specification (this document)
  - Generate OpenAPI 3.1 schema from specification
  - Implement API governance (Vacuum/Spectral linting)
  - Build Mintlify documentation structure
  - Configure Speakeasy SDK generation

## 🎁 What This Project Delivers

### Key Deliverables

1. **Complete API Specification** - This document with all design decisions and rationale
2. **OpenAPI 3.1 Schema** - Machine-readable API contract
3. **Mintlify Developer Portal** - HTTP API Reference + SDK Reference
4. **Generated SDKs** - TypeScript, Python, Go, Java/Kotlin via Speakeasy
5. **API Governance** - Vacuum/Spectral ruleset enforcing design standards

### Minimum Viable API (1-2 week iteration)

| Resource           | Operations                                    |
| ------------------ | --------------------------------------------- |
| **Documents**      | List, Create, Get, Update, Delete, Change access settings |
| **Versions**       | List, Create, Get, Update                     |
| **Entry Pages**    | Get (downloadable PDF)                        |
| **Policies**       | Attach to document, Detach from document      |
| **Form Submissions** | List with time range filtering              |

### Infrastructure & DevOps

- **OpenAPI Tooling:** Speakeasy CLI for SDK generation and validation
- **Documentation:** Mintlify with automatic OpenAPI integration
- **Governance:** Vacuum or Spectral in CI/CD pipeline
- **Versioning:** Git-based source control for spec and generated code

## 📈 Business Benefits

### Strategic Benefits

- **Description:** Enable enterprise customers to build on Factify platform, creating network effects and lock-in through integrations
- **Success Metrics:**
  - 5+ external integrations built in first 6 months
  - 50+ API consumers (organizations using the API)
  - <5 breaking change requests per quarter (well-designed API)

### Developer Experience

- **Description:** World-class developer experience attracts enterprises and reduces support burden
- **Success Metrics:**
  - Time-to-first-API-call <15 minutes
  - SDK downloads >1000/month across all languages
  - <2% error rate on API calls
  - Positive developer feedback (NPS >50)

### Security & Compliance

- **Description:** SOC 2-ready API with audit logging and security controls
- **Success Metrics:**
  - 100% of mutating operations logged for audit
  - Zero security vulnerabilities in authentication/authorization
  - Pass SOC 2 audit for API access controls

### Scalability

- **Description:** API design that scales without breaking changes as usage grows
- **Success Metrics:**
  - Support 100+ organizations without architectural changes
  - Handle 1M+ API calls/day with <200ms p95 latency
  - Zero breaking changes in first year

## 🔐 Authentication & Authorization

**Technology:** API Keys (Phase 1), OAuth 2.0 (Phase 2)

**Phase 1 Approach:**
- API key authentication via `Authorization: Bearer {key}` header
- Prefixed keys: `fac_live_sk_...` (live) and `fac_test_sk_...` (test)
- Key-based rate limiting and quota management
- Keys scoped to organization with role-based permissions

**Phase 2 (Future):**
- OAuth 2.0 authorization code flow for third-party apps
- Scoped access tokens (read, write, admin)
- Same `Authorization: Bearer {token}` header (no breaking changes)

## 🗓️ Milestone Plan

| Milestone                     | Target  | Key Features                              | Status      |
| ----------------------------- | ------- | ----------------------------------------- | ----------- |
| **Spec Complete**             | Week 1  | This document, OpenAPI schema             | In Progress |
| **Docs + SDK Setup**          | Week 1  | Mintlify structure, Speakeasy config      | Pending     |
| **Core Endpoints (MVP)**      | Week 2  | Documents, Versions CRUD                  | Pending     |
| **Access Control**            | Week 2  | Policies, Forms, Entry Pages              | Pending     |
| **Governance + CI/CD**        | Week 2  | Vacuum/Spectral, automated validation     | Pending     |
| **Beta Launch**               | Week 2  | First external API consumers              | Pending     |

## 🧪 Testing Strategy

### Testing Layers

#### API Contract Testing
- **Scope:** OpenAPI schema validation against implementation
- **Tools:** Speakeasy validation, Prism mock server
- **When:** Pre-commit hook and CI/CD pipeline

#### Integration Testing
- **Scope:** End-to-end API flows with real database
- **Approach:** Automated test suite covering happy paths and error cases
- **Coverage:** >80% of endpoints, all error codes documented

#### SDK Testing
- **Scope:** Generated SDKs work correctly in target languages
- **Approach:** Speakeasy-generated test suites + custom integration tests
- **Languages:** TypeScript, Python, Go, Java/Kotlin

#### Documentation Testing
- **Scope:** All code examples in docs are valid and run successfully
- **Tools:** Mintlify link validation, manual smoke testing
- **When:** Before documentation releases

## 📊 Instrumentation & Observability

### Metrics to Capture

- **API Usage:** Requests per endpoint, success rate, error rate
- **Performance:** Latency percentiles (p50, p95, p99) per endpoint
- **Authentication:** API key usage, failed auth attempts, rate limit hits
- **Business:** Documents created, versions created, form submissions

### Audit Requirements

- **All mutating operations** (POST, PUT, PATCH, DELETE) logged with:
  - Timestamp
  - API key/user identity
  - Endpoint and operation
  - Request parameters (excluding sensitive data)
  - Response status
  - IP address

### Error Tracking

- **All 5xx errors** tracked with:
  - Stack trace
  - Request context
  - Frequency and distribution
  - Alerting for spike in error rate

---

# 2. 🎯 API Design Principles

## Core Principles

### 1. External-First Mindset

**Principle:** Design for external developers, not internal convenience.

**Why:** Internal needs change frequently. External contracts must be stable. Designing for external use forces better abstraction and long-term thinking.

**Examples:**
- ✅ Expose business concepts (documents, versions) not database tables
- ✅ Hide implementation details (database IDs, internal status codes)
- ✅ Provide convenience endpoints even if they map to same backend logic
- ❌ Expose internal service boundaries in API structure
- ❌ Leak database schema through API field names

### 2. Stripe-Inspired Patterns

**Principle:** Follow proven conventions from the gold standard in API design.

**Why:** Stripe's API is beloved by developers. Following their patterns reduces cognitive load for developers already familiar with well-designed APIs.

**Patterns adopted:**
- Flat resource structure with query filtering
- Cursor-based pagination
- Structured error responses with field-level detail
- Prefixed resource IDs and API keys
- Idempotency via request IDs
- Expandable relationships

### 3. Design for Growth

**Principle:** Make decisions that enable scaling without breaking changes.

**Why:** Breaking changes destroy developer trust and create migration burden. Good API design anticipates growth.

**Decisions:**
- Cursor pagination (scales better than offset)
- Opaque cursors (internal format can evolve)
- Hybrid date formats (accept multiple, return consistent)
- Query parameter fallbacks (simple + complex filtering)
- Versioning in URL path (clear migration path)

### 4. Optimize for Common Case

**Principle:** Make the 90% case trivial, the 10% case possible.

**Why:** Most API usage follows simple patterns. Optimize for simplicity while providing escape hatches for complexity.

**Examples:**
- Simple suffix query params (`?created_gte=...`) for 90% case
- Bracket notation (`?metadata[key]=value`) for complex filtering
- Embedded current version in document response (no extra call needed)
- Separate versions endpoint for version-specific operations

### 5. Fail-Fast with Clarity

**Principle:** Return errors immediately with actionable information.

**Why:** Silent failures and vague errors waste developer time. Clear, immediate errors enable rapid debugging.

**Error guidelines:**
- Return errors synchronously (no "processing" state for simple operations)
- Include field name that caused validation error
- Provide error code for programmatic handling
- Use standard HTTP status codes correctly
- Never leak sensitive data in error messages

---

# 3. 🏗️ Architecture Decisions

## ADR-001: Resource Structure - Flat vs Nested

### Decision

**Flat resource structure with query-based filtering and hybrid convenience endpoints.**

### Context

REST APIs can structure resources in three ways:
1. **Deeply nested:** `/v1/documents/{id}/versions/{vid}/...`
2. **Completely flat:** `/v1/versions/{id}` with query params
3. **Hybrid:** Both flat access and nested convenience

### Alternatives Considered

| Approach      | Pros                                   | Cons                                |
| ------------- | -------------------------------------- | ----------------------------------- |
| Deeply nested | Clear hierarchy, RESTful purity        | Long URLs, hard to query across resources, SDK bloat |
| Completely flat | Simple, flexible querying              | Less obvious relationships         |
| Hybrid        | Best of both, more endpoints to maintain | Slight redundancy                  |

### Decision Rationale

**Chosen: Hybrid approach with flat primary + nested convenience**

```
# Primary access (flat)
GET /v1/documents/{id}
GET /v1/versions/{id}
GET /v1/versions?document_id={id}

# Convenience (nested)
GET /v1/documents/{id}/versions
```

**Industry precedent:**
- **Stripe:** Primarily flat (`/v1/charges`, `/v1/customers`) with query filtering
- **GitHub:** Hybrid (`/repos/{owner}/{repo}` but also `/repos/{owner}/{repo}/commits`)
- **Twilio:** Nested for scoping (`/Accounts/{id}/Messages`)

**Why hybrid for Factify:**
- Documents and versions are first-class resources (warrant flat access)
- But `/documents/{id}/versions` is a common pattern (warrant convenience)
- Query filtering (`?document_id=...`) enables cross-document version queries
- Automation tools (Zapier, Make) prefer flat structures

### Consequences

- **Positive:** Maximum flexibility for API consumers
- **Positive:** SDKs can provide both styles
- **Negative:** Slightly more endpoints to document and maintain
- **Mitigation:** OpenAPI schema generation prevents inconsistency

---

## ADR-002: Pagination Strategy

### Decision

**Cursor-based pagination with opaque cursors.**

### Context

Three main pagination approaches:
1. **Offset-based:** `?page=2&limit=50` or `?offset=50&limit=50`
2. **Page-number:** `?page=5&per_page=20`
3. **Cursor-based:** `?cursor={opaque}&limit=50`

### Alternatives Considered

| Approach         | Pros                            | Cons                                     |
| ---------------- | ------------------------------- | ---------------------------------------- |
| Offset           | Simple, allows page jumping     | Poor performance at scale, skips records during creation |
| Page number      | Most intuitive                  | Same issues as offset, worse for APIs   |
| Cursor           | Best performance, consistent    | Can't jump to arbitrary page, less intuitive |

### Decision Rationale

**Chosen: Cursor-based with opaque cursors**

**Request:**
```
GET /v1/documents?limit=50&cursor=eyJpZCI6ImRvY19hYmMiLCJ0cyI6MTIzNH0
```

**Response:**
```json
{
  "object": "list",
  "data": [...],
  "has_more": true,
  "next_cursor": "eyJpZCI6ImRvY194eXoiLCJ0cyI6MTI0MH0"
}
```

**Industry precedent:**
- **Stripe:** Cursor-based with `starting_after` parameter
- **GitHub:** Cursor-based with `Link` headers
- **Slack:** Cursor-based with opaque cursors
- **Facebook Graph API:** Cursor-based pagination

**Why cursor for Factify:**
- **Scalability:** "Design for growth" principle - performs well at any scale
- **Consistency:** No skipped/duplicate records when data changes during pagination
- **Real-time friendly:** Works correctly with frequent document creation
- **SOC 2:** Reliable audit log pagination without gaps

**Why opaque cursors:**
- **Flexibility:** Can change cursor format (timestamp-based, composite key, etc.) without breaking API
- **Security:** Clients can't manipulate cursors to access unauthorized data
- **Future-proof:** Can optimize cursor implementation as data model evolves

### Consequences

- **Positive:** Scales to millions of documents without performance degradation
- **Positive:** Consistent results during active document creation
- **Positive:** Internal cursor format can evolve without API changes
- **Negative:** Can't jump to arbitrary page (acceptable tradeoff)
- **Mitigation:** Provide filtering to narrow results instead of deep pagination

---

## ADR-003: CRUD Verb Naming - "Get" vs "Retrieve"

### Decision

**Use "Get" in endpoint operations and SDK methods. Use "Retrieve" in documentation prose.**

### Context

APIs must decide between "Get", "Retrieve", "Fetch" or other verbs for read operations. This affects:
- OpenAPI operation IDs
- SDK method names
- Documentation language
- Developer expectations

### Alternatives Considered

| Verb       | Usage Prevalence | Examples                          |
| ---------- | ---------------- | --------------------------------- |
| Get        | Most common      | GitHub, AWS, Google, Kubernetes   |
| Retrieve   | Less common      | Square, Plaid                     |
| Fetch      | Rare in REST     | Twilio (inconsistent)             |
| Read       | Database-focused | CRUD acronym, too implementation-focused |

### Decision Rationale

**Chosen: "Get" for operations, "Retrieve" for prose**

**OpenAPI operation IDs:**
```yaml
paths:
  /v1/documents/{id}:
    get:
      operationId: getDocument
      summary: Retrieves a document by ID
```

**SDK methods:**
```typescript
client.documents.get(id)  // Method name
```

**Documentation:**
```markdown
## Retrieve a Document

Retrieves the details of an existing document.
```

**Industry precedent:**

**"Get" dominant:**
- **GitHub:** `GET /repos/{owner}/{repo}` → "Get a repository"
- **AWS:** `GetObject`, `GetBucket`, `GetFunction` (consistent "Get" prefix)
- **Google Cloud:** `GetProject`, `GetInstance`
- **Kubernetes:** `get pod`, `get service`

**"Retrieve" in prose:**
- **Stripe:** Endpoint is `GET /v1/customers/{id}`, docs say "Retrieves a customer"
- Balances technical accuracy ("get") with natural language ("retrieve")

**Why this hybrid approach:**
- **"Get" in code:** Shorter, matches HTTP verb, muscle memory from other APIs
- **"Retrieve" in docs:** More formal, clearer for non-native English speakers
- **Consistency:** Follow Stripe's proven pattern

### Consequences

- **Positive:** SDK methods are concise (`get()` not `retrieve()`)
- **Positive:** Documentation reads naturally
- **Positive:** Aligns with developer expectations from other APIs
- **Negative:** Slight inconsistency between code and prose (acceptable)

---

## ADR-004: Document and Version Endpoints - Separate Resources

### Decision

**Documents and Versions are separate first-class resources with both flat and nested access patterns.**

### Context

Versions could be modeled three ways:
1. **Separate resource:** `/v1/versions/{id}` + `/v1/documents/{id}/versions`
2. **Nested only:** `/v1/documents/{id}/versions/{vid}` (no flat access)
3. **Embedded:** `/v1/documents/{id}?version=2` (no separate endpoint)

### Alternatives Considered

| Approach         | DX Impact                               | Implementation                    |
| ---------------- | --------------------------------------- | --------------------------------- |
| Separate (hybrid) | Most flexible, slight redundancy       | More endpoints, clear separation  |
| Nested only      | Clear hierarchy, limited querying      | Simpler, less flexibility         |
| Embedded         | Simplest, no version operations        | Easy, but very limited            |

### Decision Rationale

**Chosen: Separate resources with hybrid access**

**Endpoints:**
```
# Documents
GET    /v1/documents
POST   /v1/documents
GET    /v1/documents/{id}
PATCH  /v1/documents/{id}
DELETE /v1/documents/{id}

# Versions (flat access)
GET    /v1/versions/{id}
GET    /v1/versions?document_id={id}
POST   /v1/versions
PATCH  /v1/versions/{id}

# Versions (nested convenience)
GET    /v1/documents/{id}/versions
```

**Document response includes current version inline:**
```json
{
  "id": "doc_abc123",
  "title": "Q4 Report",
  "current_version": {
    "id": "ver_xyz789",
    "version_number": 3,
    "content": "..."
  },
  "created_at": 1234567890
}
```

**Industry precedent:**
- **GitHub:** Repos and commits are separate (`/repos/.../commits/{sha}`)
- **Dropbox:** Files and revisions are separate resources
- **Google Docs:** Revisions accessible via separate API

**Why separate for Factify:**
- **Legal requirement:** Versions are core to "legally-binding" promise
- **First-class lifecycle:** Versions have their own metadata, queries, operations
- **Cross-document queries:** "Show me all versions created today" (impossible with nested-only)
- **Caching:** Separate resources = separate cache keys
- **SDK ergonomics:** Clear, predictable methods

**Why hybrid access:**
- **Convenience:** `/documents/{id}/versions` is intuitive for "all versions of this document"
- **Flexibility:** Direct version access for specific operations
- **Common case optimized:** Current version embedded in document (no extra call)

### Consequences

- **Positive:** Versions can be queried, filtered, analyzed independently
- **Positive:** Both simple and complex workflows supported
- **Positive:** Clear SDK methods: `client.versions.get()`, `client.documents.versions.list()`
- **Negative:** More endpoints to document
- **Mitigation:** OpenAPI generation ensures consistency

---

## ADR-005: Query Parameter Conventions

### Decision

**Simple suffix notation (`_gte`, `_lte`) as primary pattern. Stripe-style bracket notation (`[key]`) for nested object filtering.**

### Context

Query parameter naming affects:
- URL readability
- Automation tool compatibility
- Filter complexity support
- Developer mental model

### Alternatives Considered

| Convention           | Example                                 | Pros                 | Cons                    |
| -------------------- | --------------------------------------- | -------------------- | ----------------------- |
| Simple suffixes      | `?created_gte=123&created_lte=456`      | Clean, no encoding   | Can't handle deep nesting |
| Stripe brackets      | `?metadata[author]=john`                | Handles nested objects | Brackets need encoding sometimes |
| RHS colon            | `?created=gte:123`                      | Zalando standard     | Colons sometimes need encoding |
| Single filter param  | `?filter=created:gte:123,created:lte:456` | Single param       | Complex parsing, poor DX |

### Decision Rationale

**Chosen: Simple suffixes primary, brackets fallback**

**Simple suffix (90% case):**
```
GET /v1/documents?created_gte=1234567890&created_lte=1234599999&limit=50
GET /v1/form-submissions?form_id=form_123&submitted_gte=1234567890
```

**Bracket notation (complex filtering):**
```
GET /v1/documents?metadata[author]=john&metadata[department]=sales
GET /v1/versions?properties[reviewed]=true&properties[approved_by]=user_123
```

**Supported operators:**
- `_gte` - Greater than or equal
- `_lte` - Less than or equal
- `_gt` - Greater than
- `_lt` - Less than
- `_ne` - Not equal
- `[key]` - Nested object access

**Industry precedent:**
- **Stripe:** Bracket notation throughout
- **GitHub:** Simple params + some comma-separated values
- **Twilio:** Simple params only
- **Slack:** Mix of simple and nested

**Why hybrid approach for Factify:**
- **Optimize common case:** Time filtering, simple fields = simple suffixes
- **Escape hatch:** Complex metadata queries = bracket notation
- **No breaking changes:** Can add bracket support later without affecting existing code
- **Automation-friendly:** Simple params work in all tools (Zapier, Make, n8n)

### Consequences

- **Positive:** Clean URLs for 90% of queries
- **Positive:** Complexity supported when needed
- **Positive:** No vendor lock-in to specific query language
- **Negative:** Two patterns to document
- **Mitigation:** Clear examples in docs, SDK helpers abstract complexity

---

## ADR-006: Field Naming Convention

### Decision

**Use `snake_case` for all JSON fields in API requests and responses.**

### Context

JSON field naming affects:
- API consistency
- SDK language conventions
- Database schema alignment
- Developer expectations

### Alternatives Considered

| Convention  | Example                         | Used By                  |
| ----------- | ------------------------------- | ------------------------ |
| snake_case  | `created_at`, `document_title`  | Stripe, GitHub, Twilio   |
| camelCase   | `createdAt`, `documentTitle`    | JavaScript APIs (rare)   |
| PascalCase  | `CreatedAt`, `DocumentTitle`    | .NET/C# APIs             |

### Decision Rationale

**Chosen: snake_case**

**Example API response:**
```json
{
  "id": "doc_abc123",
  "object": "document",
  "title": "Q4 Financial Report",
  "created_at": 1234567890,
  "updated_at": 1234567899,
  "access_level": "organization",
  "current_version": {
    "id": "ver_xyz789",
    "version_number": 3,
    "created_at": 1234567895
  }
}
```

**Industry precedent:**
- **Stripe:** Consistent snake_case throughout
- **GitHub:** snake_case for all REST API fields
- **Twilio:** snake_case convention
- **AWS:** snake_case in JSON APIs

**Why snake_case for Factify:**
- **REST API standard:** Overwhelming majority of REST APIs use snake_case
- **Database alignment:** PostgreSQL conventions use snake_case
- **Python SDK:** Native snake_case (one of primary target languages)
- **Go SDK:** Conventional (Go tools convert automatically)
- **Multi-language SDKs:** Speakeasy converts to language-specific conventions:
  - Python: `created_at` (native)
  - TypeScript: `createdAt` (converted)
  - Go: `CreatedAt` (converted)
  - Java: `createdAt` (converted)

### Consequences

- **Positive:** Consistent with REST API standards
- **Positive:** Speakeasy SDKs convert to idiomatic naming per language
- **Positive:** Database schema maps cleanly to API fields
- **Positive:** Familiar to developers from Stripe, GitHub, etc.
- **Negative:** None significant

---

## ADR-007: Date and Time Format

### Decision

**Accept both ISO 8601 and Unix timestamps in requests. Return Unix timestamps (seconds) in responses.**

### Context

Date/time handling affects:
- Developer convenience (different languages prefer different formats)
- Timezone complexity
- Parsing performance
- Human readability

### Alternatives Considered

| Format              | Request                  | Response                | Pros                    | Cons                   |
| ------------------- | ------------------------ | ----------------------- | ----------------------- | ---------------------- |
| Unix only           | `1234567890`             | `1234567890`            | Simple, fast            | Not human-readable     |
| ISO 8601 only       | `2025-01-15T10:30:00Z`   | `2025-01-15T10:30:00Z`  | Human-readable          | Verbose, parsing overhead |
| Hybrid (our choice) | Both accepted            | Unix timestamp          | Flexible input, consistent output | Slightly more complex validation |

### Decision Rationale

**Chosen: Hybrid - accept both, return Unix**

**Request examples (both valid):**
```
GET /v1/documents?created_gte=1234567890
GET /v1/documents?created_gte=2025-01-15T10:30:00Z
GET /v1/form-submissions?submitted_gte=1234567890&submitted_lte=2025-01-20T23:59:59Z
```

**Response format (always Unix):**
```json
{
  "id": "doc_abc123",
  "created_at": 1234567890,
  "updated_at": 1234567899,
  "published_at": null
}
```

**Timestamp precision:** Seconds (not milliseconds) for simplicity

**Industry precedent:**
- **Stripe:** Unix timestamps throughout (seconds)
- **GitHub:** ISO 8601 strings throughout
- **Slack:** Unix timestamps (seconds)
- **Twitter API:** Unix timestamps (seconds)

**Why hybrid for Factify:**
- **Flexibility:** Developers can use whatever format their language/tools prefer
- **JavaScript-friendly:** JS developers can pass `Date` objects or timestamps
- **Python-friendly:** Python developers can use `datetime` objects or timestamps
- **Timezone-safe:** Unix timestamps are inherently UTC, no timezone confusion
- **Math-friendly:** Easy to calculate differences, ranges, etc.
- **Consistent output:** Responses always predictable

### Consequences

- **Positive:** Maximum developer convenience
- **Positive:** No timezone bugs
- **Positive:** Consistent, predictable responses
- **Negative:** API must validate and parse two formats
- **Mitigation:** OpenAPI schema enforces correct validation

---

## ADR-008: Error Response Format

### Decision

**Use Stripe-style structured error responses with field-level detail.**

### Context

Error responses must:
- Be machine-parseable for retry logic
- Provide human-readable messages
- Indicate which field caused validation errors
- Support internationalization
- Not leak sensitive data

### Alternatives Considered

| Format               | Example                             | Used By           | Pros                      | Cons                    |
| -------------------- | ----------------------------------- | ----------------- | ------------------------- | ----------------------- |
| RFC 7807 (Problem Details) | Standard, formal               | Some enterprise APIs | IETF standard, machine-readable | Verbose, less common  |
| Stripe-style         | Clear, field-specific               | Stripe            | Excellent DX, proven      | Not a standard          |
| GitHub-style         | Simple errors array                 | GitHub            | Simple                    | Less structured         |
| Custom minimal       | {error, code}                       | Various           | Simplest                  | Limited detail          |

### Decision Rationale

**Chosen: Stripe-style errors**

**Error response structure:**
```json
{
  "error": {
    "type": "invalid_request_error",
    "message": "Document title cannot be empty",
    "param": "title",
    "code": "missing_required_field"
  }
}
```

**Error types:**
- `invalid_request_error` - Client error (4xx)
- `authentication_error` - Invalid API key
- `authorization_error` - Valid key, insufficient permissions
- `not_found_error` - Resource doesn't exist
- `rate_limit_error` - Too many requests
- `api_error` - Server error (5xx)

**HTTP status code mapping:**
```
400 - invalid_request_error (validation failed)
401 - authentication_error (missing/invalid API key)
403 - authorization_error (valid key, no permission)
404 - not_found_error (resource not found)
429 - rate_limit_error (too many requests)
500 - api_error (server error)
502/503/504 - api_error (server unavailable)
```

**Validation error example:**
```json
{
  "error": {
    "type": "invalid_request_error",
    "message": "Invalid request parameters",
    "code": "validation_error",
    "param": "access_level",
    "errors": [
      {
        "param": "access_level",
        "message": "Must be one of: organization, restricted, authenticated, public",
        "code": "invalid_enum_value"
      }
    ]
  }
}
```

**Industry precedent:**
- **Stripe:** This exact format, beloved by developers
- **Square:** Similar structure
- **Plaid:** Similar field-level detail

**Why Stripe-style for Factify:**
- **Proven at scale:** Stripe processes billions in payments with this format
- **Field-level detail:** `param` field shows exactly what failed (critical for validation)
- **Machine-parseable:** `code` field enables programmatic error handling
- **Human-readable:** `message` field for developers and logs
- **Consistent with design:** We're following Stripe patterns throughout

### Consequences

- **Positive:** Excellent developer experience
- **Positive:** Easy to debug validation errors
- **Positive:** SDK error types map cleanly
- **Positive:** Familiar to developers who use Stripe
- **Negative:** Not an official standard (acceptable - better DX trumps formality)

---

## ADR-009: API Key Format and Security

### Decision

**Prefixed API keys with environment and purpose indicators: `fac_{env}_{purpose}_...`**

### Context

API keys need to be:
- Easily identifiable in logs
- Distinguishable by environment (test vs live)
- Scannable for security tools
- Difficult to guess or brute force

### Alternatives Considered

| Format                  | Example                          | Pros                        | Cons                  |
| ----------------------- | -------------------------------- | --------------------------- | --------------------- |
| Prefixed (Stripe-style) | `fac_live_sk_1a2b3c4d5e...`      | Self-documenting, scannable | Longer keys           |
| Simple UUID             | `550e8400-e29b-41d4-a716...`     | Short, random               | Can't distinguish test/live |
| JWT                     | `eyJhbGc...`                     | Self-contained              | Reveals metadata, heavy |

### Decision Rationale

**Chosen: Prefixed Stripe-style keys**

**Format:**
```
fac_live_sk_1a2b3c4d5e6f7g8h9i0j1k2l3m4n5o6p7
fac_test_sk_9z8y7x6w5v4u3t2s1r0q9p8o7n6m5l4k3
```

**Prefix breakdown:**
- `fac` - Factify identifier (for security scanners)
- `live` or `test` - Environment
- `sk` - Secret key (future: `pk` for publishable keys if needed)
- Random string - Cryptographically secure random data

**Key properties:**
- Length: 48 characters total
- Entropy: 256+ bits of randomness
- Character set: Base62 (alphanumeric, no special chars)

**Industry precedent:**
- **Stripe:** `sk_live_...`, `sk_test_...`, `pk_live_...`, `pk_test_...`
- **Twilio:** `SK...` format
- **GitHub:** `ghp_...`, `gho_...` (different prefixes per type)
- **OpenAI:** `sk-...` format

**Why prefixed keys for Factify:**
- **Security scanning:** Tools can detect `fac_live_sk_` in code/logs
- **Environment safety:** Developers immediately see test vs live
- **Audit logging:** Keys in logs show which environment/type
- **Future-proof:** Can add new prefixes (`fac_live_pk_` for publishable keys)

### Consequences

- **Positive:** Keys self-documenting in logs and errors
- **Positive:** Security scanners can detect Factify keys
- **Positive:** Test vs live immediately visible
- **Positive:** Can extend with new key types without breaking existing keys
- **Negative:** Keys are slightly longer (acceptable for DX benefit)

---

## ADR-010: Idempotency

### Decision

**Support idempotency keys via `Idempotency-Key` header for all mutating operations (POST, PATCH, DELETE).**

### Context

Network failures and retries can cause duplicate operations. Idempotency ensures retried requests don't create duplicate resources.

### Decision Rationale

**Idempotency header:**
```http
POST /v1/documents
Idempotency-Key: 550e8400-e29b-41d4-a716-446655440000
Content-Type: application/json

{
  "title": "Q4 Report"
}
```

**Behavior:**
- Server stores idempotency key + response for 24 hours
- Retried request with same key returns cached response
- Different request body with same key returns error

**Industry precedent:**
- **Stripe:** `Idempotency-Key` header (optional but recommended)
- **Square:** `Idempotency-Key` header
- **Plaid:** Request IDs for idempotency

**Why for Factify:**
- **Reliability:** Network issues won't create duplicate documents
- **Enterprise-critical:** Legal documents must not duplicate
- **SOC 2:** Audit trail requires idempotency
- **Standard pattern:** Developers expect this from modern APIs

### Consequences

- **Positive:** Prevents duplicate resource creation
- **Positive:** Safe retry logic for clients
- **Positive:** SOC 2 compliance requirement
- **Negative:** Requires server-side storage of keys
- **Mitigation:** 24-hour TTL, automatic cleanup

---

# 4. 📋 Endpoint Specifications

## Base URL

**Production:** `https://api.factify.com`
**Sandbox:** `https://api-sandbox.factify.com`

All endpoints are prefixed with `/v1/`.

## Common Request Headers

```http
Authorization: Bearer {api_key}
Content-Type: application/json
Idempotency-Key: {uuid}  (optional, recommended for POST/PATCH/DELETE)
```

## Common Response Headers

```http
Content-Type: application/json
X-Request-ID: {uuid}
X-RateLimit-Limit: 1000
X-RateLimit-Remaining: 999
X-RateLimit-Reset: 1234567890
```

---

## Documents Resource

Documents are the core resource in Factify - legally-binding, versioned, access-controlled replacements for PDFs.

### Object Schema

```json
{
  "id": "doc_abc123",
  "object": "document",
  "title": "Q4 Financial Report",
  "description": "Annual financial report for Q4 2024",
  "access_level": "organization",
  "current_version": {
    "id": "ver_xyz789",
    "version_number": 3,
    "created_at": 1234567895
  },
  "metadata": {
    "department": "finance",
    "author": "john@example.com"
  },
  "created_at": 1234567890,
  "updated_at": 1234567899,
  "published_at": 1234567895
}
```

### List Documents

**Endpoint:** `GET /v1/documents`

**Description:** Retrieves a list of documents with cursor-based pagination.

**Query Parameters:**
- `limit` (integer, optional): Number of results (1-100, default: 50)
- `cursor` (string, optional): Opaque pagination cursor
- `access_level` (string, optional): Filter by access level
- `created_gte` (integer/ISO 8601, optional): Created on or after
- `created_lte` (integer/ISO 8601, optional): Created on or before
- `metadata[key]` (string, optional): Filter by metadata

**Example Request:**
```http
GET /v1/documents?limit=50&access_level=organization&created_gte=1234567890
Authorization: Bearer fac_live_sk_...
```

**Example Response:**
```json
{
  "object": "list",
  "data": [
    {
      "id": "doc_abc123",
      "object": "document",
      "title": "Q4 Report",
      "access_level": "organization",
      "created_at": 1234567890
    }
  ],
  "has_more": true,
  "next_cursor": "eyJpZCI6ImRvY194eXoiLCJ0cyI6MTIzNH0"
}
```

### Create Document

**Endpoint:** `POST /v1/documents`

**Description:** Creates a new document with an initial version.

**Request Body:**
```json
{
  "title": "Q4 Financial Report",
  "description": "Annual financial report",
  "access_level": "organization",
  "content": "Document content here...",
  "metadata": {
    "department": "finance"
  }
}
```

**Example Response:**
```json
{
  "id": "doc_abc123",
  "object": "document",
  "title": "Q4 Financial Report",
  "access_level": "organization",
  "current_version": {
    "id": "ver_xyz789",
    "version_number": 1,
    "created_at": 1234567890
  },
  "created_at": 1234567890,
  "updated_at": 1234567890
}
```

**Errors:**
- `400` - Validation error (missing required fields)
- `401` - Authentication error
- `403` - Authorization error (insufficient permissions)
- `429` - Rate limit exceeded

### Get Document

**Endpoint:** `GET /v1/documents/{id}`

**Description:** Retrieves a document by ID, including current version data.

**Example Request:**
```http
GET /v1/documents/doc_abc123
Authorization: Bearer fac_live_sk_...
```

**Example Response:**
```json
{
  "id": "doc_abc123",
  "object": "document",
  "title": "Q4 Financial Report",
  "description": "Annual financial report",
  "access_level": "organization",
  "current_version": {
    "id": "ver_xyz789",
    "version_number": 3,
    "content": "Document content...",
    "created_at": 1234567895
  },
  "metadata": {},
  "created_at": 1234567890,
  "updated_at": 1234567899
}
```

**Errors:**
- `404` - Document not found
- `401` - Authentication error
- `403` - Authorization error

### Update Document

**Endpoint:** `PATCH /v1/documents/{id}`

**Description:** Updates document metadata. Does not create new version.

**Request Body (partial update):**
```json
{
  "title": "Q4 Financial Report (Updated)",
  "description": "Updated description",
  "metadata": {
    "reviewed": "true"
  }
}
```

**Example Response:**
```json
{
  "id": "doc_abc123",
  "object": "document",
  "title": "Q4 Financial Report (Updated)",
  "updated_at": 1234567900
}
```

### Update Document Access Level

**Endpoint:** `PATCH /v1/documents/{id}/access`

**Description:** Changes document access level. This is a separate endpoint to emphasize security implications.

**Request Body:**
```json
{
  "access_level": "public"
}
```

**Allowed values:**
- `organization` - Only organization members
- `restricted` - Specific users/groups (requires additional access controls)
- `authenticated` - Any authenticated user
- `public` - Anyone with the link

**Example Response:**
```json
{
  "id": "doc_abc123",
  "access_level": "public",
  "updated_at": 1234567900
}
```

### Delete Document

**Endpoint:** `DELETE /v1/documents/{id}`

**Description:** Soft-deletes a document. All versions are retained for compliance but marked deleted.

**Example Request:**
```http
DELETE /v1/documents/doc_abc123
Authorization: Bearer fac_live_sk_...
Idempotency-Key: 550e8400-e29b-41d4-a716-446655440000
```

**Example Response:**
```json
{
  "id": "doc_abc123",
  "object": "document",
  "deleted": true
}
```

---

## Versions Resource

Versions track document revisions for legal and compliance requirements.

### Object Schema

```json
{
  "id": "ver_xyz789",
  "object": "version",
  "document_id": "doc_abc123",
  "version_number": 3,
  "content": "Document content for this version...",
  "change_summary": "Updated financial figures",
  "created_by": "user_123",
  "metadata": {},
  "created_at": 1234567895
}
```

### List Versions

**Endpoint:** `GET /v1/versions?document_id={id}` (flat)
**Endpoint:** `GET /v1/documents/{id}/versions` (nested convenience)

**Description:** Retrieves all versions for a document.

**Query Parameters:**
- `document_id` (string, required for flat endpoint): Filter by document
- `limit` (integer, optional): Number of results
- `cursor` (string, optional): Pagination cursor
- `created_gte` (integer/ISO 8601, optional): Filter by creation time

**Example Request:**
```http
GET /v1/versions?document_id=doc_abc123&limit=50
Authorization: Bearer fac_live_sk_...
```

**Example Response:**
```json
{
  "object": "list",
  "data": [
    {
      "id": "ver_xyz789",
      "object": "version",
      "document_id": "doc_abc123",
      "version_number": 3,
      "created_at": 1234567895
    },
    {
      "id": "ver_def456",
      "version_number": 2,
      "created_at": 1234567892
    }
  ],
  "has_more": false
}
```

### Create Version

**Endpoint:** `POST /v1/versions`

**Description:** Creates a new version of a document.

**Request Body:**
```json
{
  "document_id": "doc_abc123",
  "content": "Updated content...",
  "change_summary": "Updated Q4 figures based on final audit"
}
```

**Example Response:**
```json
{
  "id": "ver_new123",
  "object": "version",
  "document_id": "doc_abc123",
  "version_number": 4,
  "content": "Updated content...",
  "change_summary": "Updated Q4 figures based on final audit",
  "created_at": 1234567900
}
```

### Get Version

**Endpoint:** `GET /v1/versions/{id}`

**Description:** Retrieves a specific version by ID.

**Example Request:**
```http
GET /v1/versions/ver_xyz789
Authorization: Bearer fac_live_sk_...
```

**Example Response:**
```json
{
  "id": "ver_xyz789",
  "object": "version",
  "document_id": "doc_abc123",
  "version_number": 3,
  "content": "Full document content...",
  "change_summary": "Updated financial figures",
  "created_at": 1234567895
}
```

### Update Version

**Endpoint:** `PATCH /v1/versions/{id}`

**Description:** Updates version metadata only (not content - content is immutable).

**Request Body:**
```json
{
  "change_summary": "Updated summary",
  "metadata": {
    "reviewed_by": "user_456"
  }
}
```

---

## Entry Pages Resource

Entry pages are downloadable cover pages/summaries for documents.

### Get Entry Page

**Endpoint:** `GET /v1/documents/{id}/entry-page`

**Description:** Retrieves the entry page for a document as a downloadable PDF.

**Query Parameters:**
- `format` (string, optional): Output format (default: `pdf`)
  - `pdf` - PDF file
  - `json` - JSON metadata about entry page

**Example Request:**
```http
GET /v1/documents/doc_abc123/entry-page
Authorization: Bearer fac_live_sk_...
Accept: application/pdf
```

**Example Response (PDF):**
```http
HTTP/1.1 200 OK
Content-Type: application/pdf
Content-Disposition: attachment; filename="doc_abc123_entry_page.pdf"
Content-Length: 524288

<PDF binary data>
```

**Example Request (JSON):**
```http
GET /v1/documents/doc_abc123/entry-page?format=json
Authorization: Bearer fac_live_sk_...
```

**Example Response (JSON):**
```json
{
  "id": "doc_abc123",
  "title": "Q4 Financial Report",
  "description": "Annual financial report",
  "page_count": 24,
  "entry_page_url": "https://api.factify.com/v1/documents/doc_abc123/entry-page",
  "preview_image_url": "https://cdn.factify.com/previews/doc_abc123.png"
}
```

---

## Policies Resource

Policies define governance rules for documents (access control, compliance, workflow, content).

### Attach Policy to Document

**Endpoint:** `POST /v1/documents/{id}/policies`

**Description:** Attaches a policy to a document.

**Request Body:**
```json
{
  "policy_id": "pol_abc123"
}
```

**Example Response:**
```json
{
  "document_id": "doc_abc123",
  "policy_id": "pol_abc123",
  "attached_at": 1234567900
}
```

### Detach Policy from Document

**Endpoint:** `DELETE /v1/documents/{id}/policies/{policy_id}`

**Description:** Detaches a policy from a document.

**Example Request:**
```http
DELETE /v1/documents/doc_abc123/policies/pol_abc123
Authorization: Bearer fac_live_sk_...
```

**Example Response:**
```json
{
  "document_id": "doc_abc123",
  "policy_id": "pol_abc123",
  "detached": true
}
```

### List Document Policies

**Endpoint:** `GET /v1/documents/{id}/policies`

**Description:** Lists all policies attached to a document.

**Example Response:**
```json
{
  "object": "list",
  "data": [
    {
      "policy_id": "pol_abc123",
      "policy_name": "GDPR Compliance",
      "attached_at": 1234567890
    }
  ]
}
```

---

## Form Submissions Resource

Form submissions track lead capture data from document access forms.

### List Form Submissions

**Endpoint:** `GET /v1/form-submissions?form_id={id}`

**Description:** Retrieves form submissions for a specific form with optional time filtering.

**Query Parameters:**
- `form_id` (string, required): Form identifier
- `submitted_gte` (integer/ISO 8601, optional): Submitted on or after
- `submitted_lte` (integer/ISO 8601, optional): Submitted on or before
- `limit` (integer, optional): Number of results
- `cursor` (string, optional): Pagination cursor

**Example Request:**
```http
GET /v1/form-submissions?form_id=form_123&submitted_gte=1234567890&limit=100
Authorization: Bearer fac_live_sk_...
```

**Example Response:**
```json
{
  "object": "list",
  "data": [
    {
      "id": "sub_abc123",
      "form_id": "form_123",
      "document_id": "doc_xyz",
      "submitted_by": {
        "email": "john@example.com",
        "name": "John Doe",
        "company": "Acme Corp"
      },
      "submitted_at": 1234567890,
      "ip_address": "192.0.2.1"
    }
  ],
  "has_more": false
}
```

---

# 5. 🔒 Security & Compliance

## SOC 2 Requirements

### Audit Logging

**All mutating operations logged:**
- Timestamp (Unix)
- API key ID (not full key)
- Organization ID
- User ID (if applicable)
- Endpoint and HTTP method
- Request ID (for tracing)
- Response status code
- IP address
- User agent

**Log retention:** 1 year minimum

**Log format (JSON):**
```json
{
  "timestamp": 1234567890,
  "request_id": "req_abc123",
  "api_key_id": "fac_live_sk_abc",
  "method": "POST",
  "path": "/v1/documents",
  "status": 201,
  "ip": "192.0.2.1",
  "user_agent": "factify-sdk-python/1.0.0"
}
```

### Rate Limiting

**Default limits:**
- 1000 requests per minute per API key
- 100 requests per minute for resource creation (POST)
- 10 requests per minute for sensitive operations (access changes)

**Headers:**
```http
X-RateLimit-Limit: 1000
X-RateLimit-Remaining: 999
X-RateLimit-Reset: 1234567890
```

**Rate limit error:**
```json
{
  "error": {
    "type": "rate_limit_error",
    "message": "Too many requests. Retry after 30 seconds.",
    "code": "rate_limit_exceeded",
    "retry_after": 30
  }
}
```

### Data Protection

**Sensitive data handling:**
- API keys encrypted at rest
- TLS 1.3 required for all connections
- No sensitive data in logs (PII redacted)
- Document content encrypted at rest
- Secure key rotation supported

---

# 6. 📊 Success Metrics

## API Health Metrics

| Metric                  | Target       | Measurement             |
| ----------------------- | ------------ | ----------------------- |
| **Availability**        | 99.9%        | Uptime monitoring       |
| **P95 Latency**         | <200ms       | Per-endpoint tracking   |
| **Error Rate**          | <1%          | 5xx errors / total      |
| **Time to First Call**  | <15 min      | Developer onboarding    |
| **SDK Adoption**        | >50%         | SDK vs direct API calls |

## Developer Experience Metrics

| Metric                    | Target        | Measurement                |
| ------------------------- | ------------- | -------------------------- |
| **Documentation Score**   | >90%          | User feedback surveys      |
| **API Support Tickets**   | <10/week      | Support ticket volume      |
| **Integration Time**      | <1 day        | Time from key to first integration |
| **Breaking Changes**      | 0 in year 1   | API version tracking       |

## Business Impact Metrics

| Metric                   | Target         | Measurement                    |
| ------------------------ | -------------- | ------------------------------ |
| **External Integrations** | 5+ in 6mo     | Unique integrations live       |
| **API-Driven Documents**  | >10K/month    | Documents created via API      |
| **Enterprise Adoption**   | 50+ orgs      | Organizations using API        |
| **Revenue via API**       | 30% of total  | Revenue attributed to API usage |

---

# 7. 🚀 Next Steps

## Immediate Actions (Week 1)

1. **Finalize this specification** - Review and approval from stakeholders
2. **Generate OpenAPI 3.1 schema** - Convert spec to machine-readable format
3. **Set up Mintlify structure** - Create documentation site structure
4. **Configure Speakeasy** - Set up SDK generation for 4 languages
5. **Create governance ruleset** - Define Vacuum/Spectral rules

## Implementation (Week 2)

1. **Implement core endpoints** - Documents and Versions CRUD
2. **Build access control** - Policies, Forms, Entry Pages
3. **Set up CI/CD** - Automated schema validation and SDK generation
4. **Write integration tests** - Cover happy paths and error cases
5. **Beta launch** - First external API consumers

## Post-Launch (Month 2+)

1. **Gather feedback** - Developer surveys and usage analytics
2. **Iterate on DX** - Improve based on real-world usage
3. **Add OAuth 2.0** - Phase 2 authentication
4. **Expand endpoints** - Additional features based on demand
5. **Build ecosystem** - Zapier/Make integrations, community SDKs

---

# 8. 📚 Appendix

## Related Documents

- [Brainstorming Presentation](./api-design-brainstorm.md) - Design decision overview
- OpenAPI 3.1 Schema - TBD
- Mintlify Documentation - TBD
- Speakeasy Configuration - TBD

## Industry Research References

**API Design:**
- [Stripe API Documentation](https://stripe.com/docs/api)
- [GitHub REST API](https://docs.github.com/en/rest)
- [Twilio API](https://www.twilio.com/docs/usage/api)
- [Zalando API Guidelines](https://opensource.zalando.com/restful-api-guidelines/)
- [Microsoft REST API Guidelines](https://github.com/microsoft/api-guidelines)

**OpenAPI & Tooling:**
- [OpenAPI 3.1 Specification](https://spec.openapis.org/oas/v3.1.0)
- [Speakeasy Documentation](https://docs.speakeasy.com/)
- [Mintlify Documentation](https://mintlify.com/docs)
- [Vacuum Linter](https://quobix.com/vacuum/)
- [Spectral Linter](https://stoplight.io/open-source/spectral)

## Glossary

- **ADR:** Architecture Decision Record
- **DX:** Developer Experience
- **OpenAPI:** Standard specification for REST APIs
- **SDK:** Software Development Kit
- **SOC 2:** Security compliance framework
- **Cursor:** Opaque pagination token
- **Idempotency:** Property where operation can be repeated safely
- **Rate Limiting:** Throttling API requests per time period
