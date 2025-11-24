---
title: Factify API Design
sub_title: Contract-First API for the Future of Documents
author: Factify Team
date: 2025-01-20
theme:
  name: catppuccin-mocha
---

# Factify API Design 🚀

**Brainstorming Session Overview**

**Date:** 2025-01-20

**Goal:** Design a world-class, contract-first API

<!-- alignment: center -->

**Let's replace the PDF!**

<!-- end_slide -->

# What is Factify? 🤔

<!-- alignment: center -->

> **"Replace the PDF"**

<!-- alignment: left -->

A platform for **legally-binding, future-proof, API-first documents** with:

- 🔒 Access control capabilities
- 🔌 Built-in APIs per document
- 🤖 AI-ready architecture
- ♿ Accessible & media-agnostic
- 🔄 Workflow-friendly

<!-- pause -->

**Mission:** Create the document platform for a Star Trek future reality

<!-- end_slide -->

# Target Users 👥

**Primary:** Organizations & Enterprises

**API Consumers:**
- 🏢 Enterprise IT teams
- 🔗 Third-party integrations (DocuSign, Salesforce, Slack)
- ⚡ Automation platforms (Zapier, Make, n8n)

<!-- pause -->

**Philosophy:**

<!-- alignment: center -->

*"Don't let internal needs hinder what we expose to clients"*

<!-- end_slide -->

# Core Domain Model 📦

**1. Documents** - PDF replacements with access control
   - Access levels: `organization`, `restricted`, `authenticated`, `public`

**2. Versions** - Document revision tracking (legal requirement)

**3. Entry Page** - Cover/summary page (downloadable as PDF)

**4. Policies** - Governance rules
   - Access control + compliance + workflow + content

**5. Form Submissions** - Lead capture gates that unlock document access

<!-- end_slide -->

# Design Decision #1 🏗️
## Resource Structure

**✅ Chosen: Flat Structure with Query Filtering**

```
GET  /v1/documents
POST /v1/documents
GET  /v1/documents/{id}

GET  /v1/versions?document_id={id}
GET  /v1/form-submissions?form_id={id}
```

**Why:**
- ✨ Simpler URLs, easier for automation
- 💳 Follows Stripe/GitHub patterns
- 📈 Query params scale better than nesting

<!-- end_slide -->

# Design Decision #2 🔐
## Authentication

**✅ Chosen: API Key in Header (Phase 1)**

```http
Authorization: Bearer fac_live_sk_1a2b3c4d5e...
```

**Key Format:**
- Live: `fac_live_sk_...`
- Test: `fac_test_sk_...`

**Benefits:**
- 🎫 Standard Bearer token format
- 🔄 Easy OAuth 2.0 addition later (same header)
- 🏷️ Environment identification built-in

<!-- pause -->

**Future:** Add OAuth 2.0 without breaking changes

<!-- end_slide -->

# Design Decision #3 📍
## Versioning

**✅ Chosen: URL Path Versioning**

```
/v1/documents
/v1/versions
/v1/form-submissions
```

**Why:**
- ✨ Clear, cacheable, easy to test
- 🌐 Most common for public APIs
- 👨‍💻 Developer-friendly

<!-- end_slide -->

# Design Decision #4 📄
## Pagination

**✅ Chosen: Cursor-Based Pagination**

```
GET /v1/documents?limit=50&starting_after=doc_abc123
```

**Response:**
```json
{
  "data": [...],
  "has_more": true,
  "next_cursor": "doc_xyz789"
}
```

**Why:**
- 🚀 Better performance at scale
- 🎯 No skipped records during real-time updates
- 💳 Stripe's proven approach

<!-- end_slide -->

# Design Decision #5 ❌
## Error Format

**✅ Chosen: Stripe-Style Errors**

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

**Why:**
- ✅ Proven at massive scale
- 🎯 Excellent for validation errors (`param` field)
- 🔄 Consistent with other design choices

<!-- end_slide -->

# Design Decision #6 🔍
## Query Parameters

**✅ Chosen: Simple Suffixes (Primary)**

```
?created_gte=1234567890&created_lte=1234599999
```

**Fallback: Stripe Brackets (for nested objects)**

```
?metadata[author]=john&metadata[department]=sales
```

**Why:**
- ✨ Clean URLs for 90% of use cases
- 🚪 Escape hatch for complexity when needed
- 🔒 No breaking changes when adding nested filtering

<!-- end_slide -->

# Design Decision #7 🔤
## Field Naming

**✅ Chosen: snake_case**

```json
{
  "id": "doc_123",
  "created_at": 1234567890,
  "document_title": "Q4 Report"
}
```

**Why:**
- 🌐 REST API standard (Stripe, GitHub, Twilio)
- 🐍 Matches Python/database conventions
- 🔄 Speakeasy converts to camelCase in JS/TS SDKs automatically

<!-- end_slide -->

# Design Decision #8 🕐
## Date/Time Format

**✅ Chosen: Hybrid Approach**

**Accept in requests:** ISO 8601 OR Unix timestamp
```
?created_gte=2025-01-15T10:30:00Z
?created_gte=1234567890
```

**Return in responses:** Unix timestamp (seconds)
```json
{
  "created_at": 1234567890,
  "updated_at": 1234567899
}
```

<!-- pause -->

**Why:** Maximum flexibility for developers, consistency in responses

<!-- end_slide -->

# Design Decision #9 🔑
## API Key Format

**✅ Chosen: Prefixed (Stripe-Style)**

**Format:**
```
fac_live_sk_1a2b3c4d5e6f...
fac_test_sk_1a2b3c4d5e6f...
```

**Benefits:**
- 🏷️ Instant environment identification
- 🔍 Security scanning (visible in logs)
- 🔮 Future-proof (can add publishable keys)

<!-- end_slide -->

# Core Design Principles 🎯

**1. Flat resource structure**
   - Simple URLs, query-based filtering

**2. Stripe-inspired patterns**
   - Proven conventions, excellent DX

**3. Design for growth**
   - Scalable without breaking changes

**4. External-first mindset**
   - API designed for external developers

**5. SOC 2 ready**
   - Audit logging, secure errors, access controls

<!-- end_slide -->

# Technical Stack 🛠️

| Component              | Technology                        |
| ---------------------- | --------------------------------- |
| **Design & Spec**      | OpenAPI 3.1 (source of truth)     |
| **Governance**         | Vacuum or Spectral (CI/CD)        |
| **Documentation**      | Mintlify (MDX, polished UI)       |
| **SDK Generation**     | Speakeasy (TS, Python, Go, Java)  |
| **Observability**      | TBD (Datadog + Moesif suggested)  |

<!-- end_slide -->

# Timeline & Requirements ⏰

**Timeline:** 1-2 weeks for first iteration

**Minimum Requirements:**

| Feature            | Operations                              |
| ------------------ | --------------------------------------- |
| 📄 **Documents**   | List, create, retrieve, update, access  |
| 📝 **Versions**    | Create, retrieve, update, list by doc   |
| 📋 **Entry Page**  | Retrieve as downloadable PDF            |
| 📜 **Policies**    | Attach/detach to documents              |
| 📊 **Form Subs**   | Retrieve by form ID with time filtering |

**Deliverable:** HTTP API Reference + SDK Reference in Mintlify

<!-- end_slide -->

# Scale & Compliance 📊

**Scale:** Unknown/flexible - designed for growth

**Compliance:** SOC 2 Requirements
- 📝 Audit logging required
- 🔒 Security controls
- 📦 Data retention policies
- 🛡️ Secure error messages

<!-- end_slide -->

# What's Next? 🚀

**1. Complete design presentation**
   - Architecture, endpoints, examples

**2. Create OpenAPI 3.1 specification**
   - Contract-first approach

**3. Set up Mintlify documentation**
   - Structure + initial pages

**4. Configure Speakeasy SDK generation**
   - TypeScript, Python, Go, Java

**5. Implement governance (Vacuum/Spectral)**
   - Linting rules in CI/CD

<!-- end_slide -->

# Questions? 🙋

<!-- alignment: center -->

**Let's build the API that replaces PDFs!** 🚀

<!-- alignment: left -->

**Next Steps:**
- Continue with detailed design sections
- Define exact endpoint specifications
- Create OpenAPI schema
- Set up documentation structure

<!-- end_slide -->

# Refined Decisions (2025-01-24) 🎯

## Response Schema Design ✅

**Decision:** Single schema for all contexts (no `oneOf`)

**Industry Examples:**
- **Stripe:** Same Payment Method schema, redacts sensitive card data
- **GitHub:** Same Repo schema, shows `null` for private fork sources
- **Slack:** Same Message schema, omits user_profile for restricted users

**Why:**
- 💎 Predictable TypeScript types
- 🎯 Clean SDK generation
- ✅ Easier testing
- 🔄 Better caching

<!-- end_slide -->

# Nested Objects & Relations 🔗

**Decision:** Inline current_version, reference IDs otherwise

```json
{
  "id": "doc_123",
  "current_version": { /* inline */ },
  "policy_ids": ["pol_789"],
  "created_by": "user_999"
}
```

**Industry Examples:**
- **Stripe:** `expand[]=customer`, `expand[]=subscription`
- **Shopify:** Inlines order.line_items, references customer
- **GitHub:** Inlines commit.author, references repository

**Future:** Add `expand[]` parameter (Stripe pattern)

<!-- end_slide -->

# Access Control on Creation 🔐

**Decision:** Allow `access_level` on creation, default to `private`

```json
POST /documents
{
  "access_level": "organization"  // Optional, defaults to "private"
}
```

**Industry Examples:**
- **GitHub:** ✅ Repos require public/private choice on creation
- **AWS S3:** ✅ Buckets require ACL specification upfront
- **Google Drive:** ❌ Files start private, change later

**Why:** Developer API (not consumer), matches GitHub/AWS

<!-- end_slide -->

# File Upload Pattern 📤

**Decision:** Multipart upload for V1

```http
POST /documents
Content-Type: multipart/form-data

--boundary
Content-Disposition: form-data; name="file"
[PDF binary]
--boundary
Content-Disposition: form-data; name="metadata"
{"title": "Q4 Report"}
```

**Industry Examples:**
- **Google Drive:** Multipart upload with metadata
- **Cloudflare Images:** Multipart form-data
- **AWS S3:** PUT with headers

<!-- end_slide -->

# Bulk Operations 📦

**Decision:** Defer to V2 with async job pattern

**V1:** Single document creation only

**V2 Pattern:**
```json
POST /documents/bulk-upload-jobs
→ Returns job_id + presigned URLs
→ Client uploads in parallel
→ Poll GET /jobs/{id} for completion
```

**Industry Examples:**
- **Dropbox:** upload_session/start, append_v2, finish
- **AWS S3:** Multipart upload API
- **Cloudflare:** Direct Upload URLs (presigned)

<!-- end_slide -->

# Processing Status ⏳

**Decision:** Immediate response with status field

```json
{
  "id": "doc_123",
  "processing_status": "pending",  // → "ready"
  "current_version": {
    "processing_status": "pending"
  }
}
```

**Entry page available immediately!**

**Industry Examples:**
- **Stripe:** Webhooks + polling for disputes
- **Twilio:** Status callbacks for SMS delivery
- **SendGrid:** Webhook events for email delivery

<!-- end_slide -->

# Field Visibility 👁️

**Decision:** Single schema, omit sensitive fields server-side

```typescript
// Same Document type everywhere
// Backend decides what to include
if (user.isAdmin()) {
  response.internal_notes = doc.internal_notes;
}
```

**Industry Examples:**
- **Stripe:** Redacts CVV, shows last 4 digits
- **GitHub:** Private data shows as `null`
- **Slack:** Private channels omit member lists

<!-- end_slide -->

# Updated Summary 📊

| Decision | Pattern | Industry Backing |
|----------|---------|------------------|
| **Response schemas** | Single schema | Stripe, GitHub, Slack |
| **Nested objects** | Inline + IDs | Stripe (expand[]) |
| **Access on create** | Allow with default | GitHub, AWS S3 |
| **File upload** | Multipart | Google Drive, Cloudflare |
| **Bulk operations** | V2: Async jobs | Dropbox, AWS, Cloudflare |
| **Processing** | Status field | Stripe, Twilio, SendGrid |
| **Field visibility** | Omit server-side | Stripe, GitHub, Slack |

<!-- end_slide -->

# Implementation Status ✅

**Completed:**
- ✅ API design decisions documented
- ✅ OpenAPI 3.1 base structure
- ✅ Document & Version schemas
- ✅ All endpoint definitions
- ✅ Real-world company examples

**Next:**
- 🔄 Refine OpenAPI with decisions
- 📦 Bundle for Mintlify
- 🛠️ Configure Speakeasy SDKs
- 🔍 Set up API governance

<!-- end_slide -->
