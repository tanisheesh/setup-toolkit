<!--
  ╔══════════════════════════════════════════════════════════════╗
  ║  TANISH'S SETUP TOOLKIT · template · tanisheesh.in            ║
  ║  Keep the author footer at the bottom of the generated file.  ║
  ╚══════════════════════════════════════════════════════════════╝
-->

# {{PROJECT_NAME}} — Product Requirements Document

| Field | Value |
|---|---|
| **Status** | {{Draft / Final / v1.0 Live}} |
| **Owner** | Tanish Poddar |
| **Live URL** | [{{LIVE_URL}}]({{LIVE_URL}}) |
| **One-liner** | {{Same one-liner as README — what it is in one sentence.}} |

---

## 1. Problem & Quantified Impact

<!--
What breaks or hurts without this product?
Ground the problem in concrete baseline numbers (time wasted, failure rate,
manual steps, cost). 1 short paragraph + Before/After comparison table.
-->

{{...}}

| Dimension | Before (Manual / Baseline) | After (v1 Target) |
|---|---|---|
| {{e.g. Time to complete workflow}} | {{e.g. 15–20 min manual copy-paste}} | {{e.g. < 10s automated end-to-end}} |
| {{e.g. Error / drop-off rate}} | {{e.g. Frequent missed steps / stale data}} | {{e.g. Deterministic validation + zero silent drops}} |
| {{e.g. Operating cost}} | {{e.g. N/A or existing tool cost}} | {{e.g. $0/mo within free-tier quotas}} |

---

## 2. Goals (v1 / MVP)

<!--
What must be true for v1 to be "done"?
Numbered list, each one measurable or testable — never vague like "good UX".
-->

1. {{e.g. GitHub OAuth login — authenticated session ready in <= 2 redirects.}}
2. {{e.g. Sync and persist real repository data with idempotent upserts.}}
3. {{e.g. Generate structured AI summary grounded in measured inputs (< 1,500 output tokens).}}
4. {{e.g. Deployed live at {{LIVE_URL}} passing Playwright smoke + WCAG AA a11y checks.}}

---

## 3. Non-Goals (Explicit Scope Cuts)

<!--
What are you deliberately NOT building in v1, and what trigger would justify building it?
-->

- **{{Feature X}}** — {{why deferred, and exact trigger to revisit}}
- **{{Feature Y}}** — {{why deferred}}
- **{{Feature Z}}** — {{why deferred}}

---

## 4. Users & Personas

**Primary:** {{e.g. Individual engineers using the tool daily in their workflow.}}

**Secondary:** {{e.g. Technical reviewers / recruiters testing the live demo on real or seeded data.}}

---

## 5. User Stories & Acceptance Criteria

<!--
Each story pairs a user flow with concrete Given / When / Then acceptance criteria.
-->

### Story 1 — {{e.g. Core Onboarding / Auth}}
*As a {{user type}}, I want to {{action}} so that {{outcome}}.*
- **Given** {{initial state}}, **When** {{action}}, **Then** {{verifiable outcome + timing/status}}.
- **Given** {{failure/invalid state}}, **When** {{action}}, **Then** {{safe error state / HTTP status}}.

### Story 2 — {{e.g. Primary Workflow}}
*As a {{user type}}, I want to {{action}} so that {{outcome}}.*
- **Given** {{initial state}}, **When** {{action}}, **Then** {{verifiable outcome}}.
- **Given** {{empty or boundary state}}, **When** {{action}}, **Then** {{expected empty/fallback behavior}}.

### Story 3 — {{e.g. Export / Output / Webhook}}
*As a {{user type}}, I want to {{action}} so that {{outcome}}.*
- **Given** {{initial state}}, **When** {{action}}, **Then** {{verifiable outcome}}.

---

## 6. Functional Requirements

### 6.1 {{Feature Area 1 — e.g. Auth & Session}}
- {{Testable requirement with exact field/constraint}}
- {{Testable requirement}}

### 6.2 {{Feature Area 2 — e.g. Core Engine / API}}
- {{Testable requirement}}
- {{Testable requirement}}

### 6.3 {{Feature Area 3 — e.g. UI & States}}
- {{Testable requirement — Loading, Empty, Error, Populated states}}
- {{Testable requirement}}

### 6.4 {{Optional: ML / Geospatial / Hardware Requirements}}
<!-- Include ONLY for ML, computer vision, geospatial, or hardware/digital-twin projects; delete otherwise. -->
- **Data & Reproducibility:** {{e.g. Dataset sources (Sentinel-2 / MODIS / Kaggle), preprocessing seed, model artifact checksum/version}}
- **Hardware / Telemetry (if applicable):** {{e.g. Sensor sampling rate, Kalman filter parameters, serial/LoRa packet loss bounds}}

---

## 7. Edge-Case & Failure Behavior Matrix

| Scenario | Expected System Behavior | User Feedback / Status |
|---|---|---|
| Empty / first-time state | {{e.g. Render guided empty state with sample action; zero fake data}} | {{UI CTA}} |
| Invalid or oversized input | {{e.g. Reject at Zod/Pydantic boundary before DB write}} | `400` / inline field error |
| Unauthenticated / wrong owner (IDOR) | {{e.g. Fail closed before loading resource}} | `401` / `403` |
| Duplicate submit / retry | {{e.g. Idempotent upsert / debounced submit lock}} | Single record persisted |
| Upstream API / LLM timeout or 429 | {{e.g. Bounded timeout + retry/degrade to raw stats}} | Calm retry banner / partial view |
| Mobile viewport (`375px`) | {{e.g. Responsive stack layout, zero horizontal overflow}} | Usable >= 40px touch targets |

---

## 8. Non-Functional Requirements & Budgets

- **Latency:** {{e.g. API routes < 300ms p95 (non-LLM); LLM streaming/response timeout capped at 30s.}}
- **Security:** {{e.g. Zod validation on 100% of inputs, server-only secrets, HMAC-SHA256 `timingSafeEqual` webhooks, HTTP security headers.}}
- **Cost & Spend Ceiling:** {{e.g. Hard input/output token cap (`max_tokens`), per-user rate limit (`X req/min`).}}
- **Reliability:** {{e.g. Zero silent job drops; idempotent writes; health endpoint `GET /api/health` returning `200`.}}
- **Accessibility:** {{e.g. WCAG 2.1 AA contrast, keyboard navigation, zero critical/serious `@axe-core/playwright` violations.}}

---

## 9. Unit Economics & Quota Budget

<!--
Compute actual resource & API budget from configured providers/limits.
Delete rows that don't apply.
-->

| Resource | Free-Tier / Plan Limit | Estimated Usage per 1,000 Actions | Headroom / Scaling Note |
|---|---|---|---|
| Compute ({{Vercel / Render}}) | {{e.g. 100 GB-hrs / 750 hrs}} | {{e.g. ~0.2 GB-hrs}} | {{e.g. Docs-only builds ignored}} |
| Database ({{Neon / Supabase}}) | {{e.g. 500 MB storage · 100 connections}} | {{e.g. ~2 MB}} | {{e.g. Pooled connection string}} |
| LLM ({{Claude / Groq / Gemini}}) | {{e.g. 30 req/min or $X credit}} | {{e.g. ~800K tokens (~$X)}} | {{e.g. Cached + on-demand only}} |
| Cache / Rate Limit ({{Upstash}}) | {{e.g. 500K commands/mo}} | {{e.g. ~4K commands}} | {{e.g. TTL-bounded keys}} |

---

## 10. Success Metrics & Instrumentation

| Metric | Target | How Measured |
|---|---|---|
| {{e.g. End-to-end activation latency}} | {{e.g. Login → populated view < 10s}} | {{e.g. Route timing logs / Playwright smoke}} |
| {{e.g. Reliability}} | {{e.g. >= 99% non-5xx on core routes}} | {{e.g. Host logs + uptime monitor}} |
| {{e.g. Quality / Regression}} | {{e.g. 0 critical/high CodeQL or a11y issues}} | {{e.g. CI + CodeQL + Playwright gates}} |

---

## 11. Risks, Assumptions & Open Questions

| Item | Impact | Mitigation / Status |
|---|---|---|
| **{{Risk 1 — e.g. Upstream rate limits}}** | {{e.g. High}} | {{e.g. Cached responses + per-user rate limiter + backoff}} |
| **{{Risk 2 — e.g. Cold starts on free tier}}** | {{e.g. Medium}} | {{e.g. Health ping / graceful loading skeleton}} |
| **{{Open question}}** | {{e.g. Low}} | {{e.g. Deferred until v2 demand}} |

---

## 12. v2 Candidates

- **{{Candidate 1}}** — {{why deferred from v1, expected scope}}
- **{{Candidate 2}}** — {{why deferred from v1, expected scope}}

---

<div align="center">

<h3>Tanish Poddar</h3>

<a href="https://tanisheesh.in"><img src="https://img.shields.io/badge/Website-tanisheesh.in-111111?style=flat-square&logo=googlechrome&logoColor=white" alt="Website"></a>
<a href="https://linkedin.com/in/tanisheesh"><img src="https://img.shields.io/badge/LinkedIn-tanisheesh-0A66C2?style=flat-square" alt="LinkedIn"></a>
<a href="https://github.com/tanisheesh"><img src="https://img.shields.io/badge/GitHub-tanisheesh-181717?style=flat-square&logo=github&logoColor=white" alt="GitHub"></a>
<a href="mailto:hi@tanisheesh.in"><img src="https://img.shields.io/badge/Email-hi%40tanisheesh.in-EA4335?style=flat-square&logo=gmail&logoColor=white" alt="Email"></a>

</div>
