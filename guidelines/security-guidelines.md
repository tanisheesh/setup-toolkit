<div align="center">

<sub><b>TANISH'S SETUP TOOLKIT</b> · the standard for every repo by <a href="https://tanisheesh.in">Tanish Poddar</a></sub>

</div>

# 🔒 Security Guidelines

Security is built into every PR — not bolted on before launch. Every repo must satisfy these baseline controls.

---

## 1. Input Validation & Data Access

- **Validate at every boundary:** Parse all API request bodies, query params, route params, form actions, and webhook payloads with **Zod** (TS) or **Pydantic** (Python) before touching business logic or the database.
- **No mass assignment:** Explicitly pick allowed fields when inserting or updating DB records — never pass raw `req.json()` directly to `prisma.*.create({ data })` or SQL builders.
- **Parameterized queries only:** Never interpolate user input into SQL, shell commands (`exec`), or regexes without escaping/allowlisting.

---

## 2. Authentication, Authorization & IDOR Prevention

- **Verify both identity AND ownership:** Checking `if (!session)` is never enough. Every resource read/update/delete must verify ownership or role (`where: { id, userId: session.userId }`).
- **Fail closed:** Auth middleware and permission checks must default to `401` / `403`, never allow-by-default if config is missing.
- **Webhook verification:** Verify signatures using HMAC-SHA256 + constant-time comparison (`crypto.timingSafeEqual`) against the **raw request body** before parsing JSON. Never skip verification when a secret is unset in production.
- **Token storage:** Never store long-lived OAuth provider tokens or API keys in plaintext if avoidable; encrypt sensitive tokens at rest (e.g. AES-256-GCM) and never echo them back to clients.

---

## 3. Secrets & Environment Hygiene

- **Strict client/server separation:** Never prefix secret keys, DB URLs, or LLM tokens with `NEXT_PUBLIC_` or `VITE_`. Access them strictly in server modules/routes.
- **Startup env validation:** Validate required env vars at boot (Zod env schema / `@t3-oss/env-nextjs` / Pydantic `BaseSettings`) so misconfigured deploys fail loudly instead of crashing mid-request.
- **Zero secrets in Git or logs:**
  - `.gitignore` must cover `.env`, `.env.local`, `.env.*.local`, `*.pem`, `*.key`.
  - Never log `Authorization` headers, cookies, API keys, or full request bodies containing credentials/PII.
  - Enable GitHub Secret Scanning + Push Protection + Gitleaks CI.

---

## 4. Network, Rate Limiting & HTTP Hardening

- **SSRF protection:** If the backend fetches user-supplied URLs, enforce `https://` only, block private/loopback/link-local IP ranges (`127.0.0.1`, `10.*`, `169.254.*`, `::1`), and disable unsafe redirects.
- **Rate limiting:** Protect auth, AI/LLM, email, webhook, and expensive compute endpoints (e.g. Upstash Ratelimit / sliding window / per-user + IP limits) to prevent abuse and surprise API bills.
- **XSS & HTML safety:** Never use `dangerouslySetInnerHTML`, `eval()`, `new Function()`, or unescaped HTML templates on untrusted content. Sanitize markdown/HTML explicitly (e.g. DOMPurify) and enforce safe URL schemes (`http:`, `https:`, `mailto:`).
- **Security headers:** Configure in `next.config.*` or `vercel.json`:
  - `X-Content-Type-Options: nosniff`
  - `X-Frame-Options: DENY`
  - `Referrer-Policy: strict-origin-when-cross-origin`
  - `Permissions-Policy: camera=(), microphone=(), geolocation=()`
  - `Strict-Transport-Security: max-age=63072000; includeSubDomains; preload`
  - Content Security Policy (`Content-Security-Policy`) as tight as the framework allows.

---

## 5. AI / LLM Safety

- **Prompt-injection defense:** Separate system instructions from untrusted user/repo/web text using explicit structural delimiters; never instruct the model to blindly execute extracted commands or trust fetched content as instructions.
- **Spend & latency caps:** Always enforce `max_tokens`, request timeouts (e.g. 20–30s), and bounded retries.
- **Structured output validation:** Validate every LLM JSON response against a Zod/Pydantic schema before saving or rendering, with graceful degradation if the provider fails.

---

## 6. Automated Security Gates (Every Repo)

- **CodeQL (`codeql.yml`):** Semantic SAST on PRs, `main`, and weekly schedule (`security-extended,security-and-quality`).
- **Dependency Review (`dependency-review.yml`):** Blocks PRs introducing high/critical CVEs or GPL-incompatible licenses.
- **Gitleaks (`secret-scan.yml`) + GitHub Push Protection:** Catches leaked credentials in PRs and blocks secret pushes.
- **Automated Patching + Weekly Maintenance Report:** Renovate dependency/OSV patching + security alert digest.

---

<div align="center">

<h3>Tanish Poddar</h3>

<a href="https://tanisheesh.in"><img src="https://img.shields.io/badge/Website-tanisheesh.in-111111?style=flat-square&logo=googlechrome&logoColor=white" alt="Website"></a>
<a href="https://linkedin.com/in/tanisheesh"><img src="https://img.shields.io/badge/LinkedIn-tanisheesh-0A66C2?style=flat-square" alt="LinkedIn"></a>
<a href="https://github.com/tanisheesh"><img src="https://img.shields.io/badge/GitHub-tanisheesh-181717?style=flat-square&logo=github&logoColor=white" alt="GitHub"></a>
<a href="mailto:hi@tanisheesh.in"><img src="https://img.shields.io/badge/Email-hi%40tanisheesh.in-EA4335?style=flat-square&logo=gmail&logoColor=white" alt="Email"></a>

</div>
