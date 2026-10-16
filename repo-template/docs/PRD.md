<!--
  ╔══════════════════════════════════════════════════════════════╗
  ║  TANISH'S SETUP TOOLKIT · template · tanisheesh.in            ║
  ║  Keep the author footer at the bottom of the generated file.  ║
  ╚══════════════════════════════════════════════════════════════╝
-->

# {{PROJECT_NAME}} — Product Requirements Document

**Status:** {{Draft / Final}}
**Owner:** Tanish Poddar
**One-liner:** {{Same one-liner as README — what it is in one sentence.}}

---

## 1. Problem

<!--
What breaks or hurts without this product?
Be specific — numbers help ("developers spend 30 min/day doing X manually").
1 short paragraph, no bullets.
-->

{{...}}

---

## 2. Goals (v1 / MVP)

<!--
What must be true for v1 to be "done"?
Numbered list, each one testable — not vague like "good UX".
-->

1. {{e.g. GitHub OAuth login — no separate signup flow.}}
2. {{e.g. Pull real data for repos the user selects.}}
3. {{e.g. Generate AI summary grounded in actual data, not filler.}}
4. {{e.g. Deployed with a working live demo URL.}}

---

## 3. Non-Goals (explicit scope cuts)

<!--
What are you deliberately NOT building in v1?
This section is as important as Goals — it shows you can scope.
Call out things someone might expect and explain why they're deferred.
-->

- **{{Feature X}}** — {{why deferred, what would trigger building it}}
- **{{Feature Y}}** — {{why deferred}}
- **{{Feature Z}}** — {{why deferred}}

---

## 4. Users

<!--
Who uses this? 1-3 types max. Be specific.
-->

**Primary:** {{e.g. Individual developers who want their standups written from real commit data.}}

**Secondary:** {{e.g. Recruiters evaluating this as a portfolio piece — it needs to work live on their own data.}}

---

## 5. User Stories

<!--
Each story = one thing a user can do end-to-end.
Format: As a [user type], [action], [outcome/why it matters].
5-8 stories covers most MVPs.
-->

1. *As a {{user type}},* {{action}} so that {{outcome}}.
2. *As a {{user type}},* {{action}} so that {{outcome}}.
3. *As a {{user type}},* {{action}} so that {{outcome}}.
4. *As a {{user type}},* {{action}} so that {{outcome}}.
5. *As a {{user type}},* {{action}} so that {{outcome}}.

---

## 6. Functional Requirements

<!--
Group by feature area. Each requirement is one testable behaviour.
Write what the system must DO, not how it does it (that's ARCHITECTURE.md).
-->

### 6.1 {{Feature Area — e.g. Auth}}

- {{Requirement 1}}
- {{Requirement 2}}

### 6.2 {{Feature Area — e.g. Data Sync}}

- {{Requirement 1}}
- {{Requirement 2}}

### 6.3 {{Feature Area — e.g. AI Generation}}

- {{Requirement 1}}
- {{Requirement 2}}

### 6.4 {{Feature Area — e.g. Dashboard}}

- {{Requirement 1}}
- {{Requirement 2}}

---

## 7. Non-Functional Requirements

<!--
Performance, security, cost, reliability.
Each one should be measurable or at least verifiable.
-->

- **Latency:** {{e.g. Webhook ack < 2s; end-to-end review < 5 min for a typical PR.}}
- **Security:** {{e.g. API keys in env vars only, never committed. Webhook signature verification mandatory.}}
- **Cost:** {{e.g. Single oversized input must not blow up API spend — hard token cap with graceful fallback.}}
- **Reliability:** {{e.g. No job silently lost — every task either completes, retries, or lands in dead-letter with a log entry.}}
- **Accessibility:** {{e.g. Mobile-friendly — primary share channel is WhatsApp.}}

---

## 8. Success Metrics

<!--
How do you know v1 is working?
Be honest — "50 signups" is a real metric, "good feedback" is not.
-->

| Metric | Target |
|---|---|
| {{e.g. Live demo reliability}} | {{e.g. First-time login → populated dashboard in < 10s}} |
| {{e.g. Real user signups}} | {{e.g. 50+ from SRM batch share}} |
| {{e.g. Caught real bugs}} | {{e.g. At least 1 real bug caught during own development}} |

---

## 9. Risks & Open Questions

<!--
What could go wrong? What haven't you decided yet?
Be honest — hiding risks here means they become surprises later.
-->

- **{{Risk 1}}** — {{e.g. GitHub API rate limits (5000 req/hr). Mitigated by GraphQL batch queries.}}
- **{{Risk 2}}** — {{e.g. AI provider rate limits on free tier. Mitigated by on-demand calls only, not per-page-load.}}
- **{{Open question}}** — {{e.g. Should severity ≥ blocker eventually gate merges via GitHub Check Runs?}}

---

## 10. v2 Candidates

<!--
Things you want to build but deliberately cut from v1.
Not a commitment — just context so future-you knows what was considered.
-->

- {{Feature}} — {{why it's v2 and not v1}}
- {{Feature}} — {{why it's v2 and not v1}}
- {{Feature}} — {{why it's v2 and not v1}}

---

<div align="center">

<h3>Tanish Poddar</h3>

<a href="https://tanisheesh.in"><img src="https://img.shields.io/badge/Website-tanisheesh.in-111111?style=flat-square&logo=googlechrome&logoColor=white" alt="Website"></a>
<a href="https://linkedin.com/in/tanisheesh"><img src="https://img.shields.io/badge/LinkedIn-tanisheesh-0A66C2?style=flat-square" alt="LinkedIn"></a>
<a href="https://github.com/tanisheesh"><img src="https://img.shields.io/badge/GitHub-tanisheesh-181717?style=flat-square&logo=github&logoColor=white" alt="GitHub"></a>
<a href="mailto:hi@tanisheesh.in"><img src="https://img.shields.io/badge/Email-hey%40tanisheesh.in-EA4335?style=flat-square&logo=gmail&logoColor=white" alt="Email"></a>

</div>
