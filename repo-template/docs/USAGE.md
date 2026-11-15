<!--
  ╔══════════════════════════════════════════════════════════════╗
  ║  TANISH'S SETUP TOOLKIT · template · tanisheesh.in            ║
  ║  Keep the author footer at the bottom of the generated file.  ║
  ╚══════════════════════════════════════════════════════════════╝

  END-USER USAGE / API REFERENCE TEMPLATE (CONDITIONAL)
  Goes to: <repo>/docs/USAGE.md
  Include ONLY when the project ships a CLI, SDK/library, or public API.
  Delete this file for standard end-user web apps.
  Keep only sections matching your delivery surface (CLI / SDK / HTTP API).
-->

# Using {{PROJECT_NAME}}

Complete reference for installing, authenticating, and integrating **{{PROJECT_NAME}}**.

---

## 1. Installation / Entrypoint

```bash
# CLI / SDK install (or Base URL for HTTP API)
{{e.g. pip install pkg-name / npm install pkg-name / Base URL: https://api.example.com}}
```

---

## 2. Authentication

{{How callers authenticate — API key header `Authorization: Bearer <token>`, OAuth token, or "No auth required for public endpoints". Include exact header/env var name.}}

---

## 3. Commands / SDK Methods / API Endpoints

| Command / Endpoint / Method | Inputs / Flags | Defaults & Constraints | Output / Status |
|---|---|---|---|
| `{{cmd_or_endpoint_1}}` | `{{flags / body params}}` | {{e.g. `--limit 20` (max 100), timeout 30s}} | `{{200 JSON / exit 0}}` |
| `{{cmd_or_endpoint_2}}` | `{{flags / body params}}` | {{e.g. Required `id` (UUID)}} | `{{201 JSON / exit 0}}` |
| `{{cmd_or_endpoint_3}}` | `{{flags / body params}}` | {{...}} | `{{...}}` |

---

## 4. End-to-End Examples

### {{Example 1 — Basic Flow}}

```bash
{{Copy-pasteable command / curl / SDK snippet}}
```

Expected output:

```json
{
  "{{example_key}}": "{{example_value}}"
}
```

### {{Example 2 — Advanced / Filtering / Error Handling}}

```bash
{{Copy-pasteable command / curl / SDK snippet}}
```

---

## 5. Rate Limits, Pagination & Quotas

- **Rate limit:** {{e.g. `30 req/min` per key/IP; returns `429` with `Retry-After` header}}.
- **Pagination:** {{e.g. Cursor-based (`?cursor=<token>&limit=20`, max `50`)}}.
- **Payload & timeout limits:** {{e.g. Max body `1MB`; request timeout `30s`}}.

---

## 6. Error Reference

| Code / Exit Status | Meaning | How to Fix |
|---|---|---|
| `400` / `422` | Schema validation failed | Check `details` array for missing/invalid fields |
| `401` | Missing or invalid credentials / webhook signature | Verify token or HMAC header |
| `403` | Authenticated user lacks ownership/permission | Confirm resource belongs to active account |
| `429` | Rate limit exceeded | Honor `Retry-After` header with exponential backoff |
| `500` / `503` | Transient upstream/server failure | Safe to retry idempotent requests |

---

## 7. Configuration Reference

| Option / Env Var | Default | Description |
|---|---|---|
| `{{CONFIG_OPTION_1}}` | `{{default}}` | {{what it controls}} |
| `{{CONFIG_OPTION_2}}` | `{{default}}` | {{what it controls}} |

---

<div align="center">

<h3>Tanish Poddar</h3>

<a href="https://tanisheesh.in"><img src="https://img.shields.io/badge/Website-tanisheesh.in-111111?style=flat-square&logo=googlechrome&logoColor=white" alt="Website"></a>
<a href="https://linkedin.com/in/tanisheesh"><img src="https://img.shields.io/badge/LinkedIn-tanisheesh-0A66C2?style=flat-square" alt="LinkedIn"></a>
<a href="https://github.com/tanisheesh"><img src="https://img.shields.io/badge/GitHub-tanisheesh-181717?style=flat-square&logo=github&logoColor=white" alt="GitHub"></a>
<a href="mailto:hi@tanisheesh.in"><img src="https://img.shields.io/badge/Email-hi%40tanisheesh.in-EA4335?style=flat-square&logo=gmail&logoColor=white" alt="Email"></a>

</div>
