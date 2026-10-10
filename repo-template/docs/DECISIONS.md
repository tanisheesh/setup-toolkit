<!--
  ╔══════════════════════════════════════════════════════════════╗
  ║  TANISH'S SETUP TOOLKIT · template · tanisheesh.in            ║
  ║  Keep the author footer at the bottom of the generated file.  ║
  ╚══════════════════════════════════════════════════════════════╝
-->

# Engineering Decisions — {{PROJECT_NAME}}

<!-- PURPOSE OF THIS FILE
     This is not user documentation. This is for technical interviewers
     and senior engineers who want to understand WHY the system is built
     the way it is. Every entry should answer a question an interviewer
     might ask. If you can't explain the tradeoff, the decision doesn't
     belong here yet.
-->

---

## Decision 1 — {{SHORT TITLE e.g. "Why BullMQ over a simple cron job"}}

**Context:** {{1-2 sentences — what problem were you solving, what were the options?}}

**Decision:** {{What you chose.}}

**Reason:** {{Why. Be specific — performance numbers, cost, constraints, failure modes you wanted to avoid.}}

**Tradeoff:** {{What you gave up by making this choice. Every real decision has a cost.}}

---

## Decision 2 — {{SHORT TITLE}}

**Context:** {{...}}

**Decision:** {{...}}

**Reason:** {{...}}

**Tradeoff:** {{...}}

---

## Decision 3 — {{SHORT TITLE}}

**Context:** {{...}}

**Decision:** {{...}}

**Reason:** {{...}}

**Tradeoff:** {{...}}

---

## Decision 4 — {{SHORT TITLE}}

**Context:** {{...}}

**Decision:** {{...}}

**Reason:** {{...}}

**Tradeoff:** {{...}}

---

## What I'd do differently in v2

<!-- Honest self-reflection. Shows maturity. Interviewers respect this. -->

- **{{Thing 1}}** — {{why you'd change it}}
- **{{Thing 2}}** — {{why you'd change it}}
- **{{Thing 3}}** — {{why you'd change it}}

---

## Explicit non-decisions (deferred to v2)

<!-- Things you consciously chose NOT to build in v1, and why. -->

| Feature | Why deferred |
|---|---|
| {{e.g. Multi-tenant support}} | {{e.g. Single-user scope sufficient for MVP; would require per-user rate limiting and billing}} |
| {{e.g. Real-time sync via webhooks}} | {{e.g. On-demand sync is simpler to reason about; real-time adds complexity without clear user benefit at this scale}} |

---

<div align="center">

<h3>Tanish Poddar</h3>

<a href="https://tanisheesh.in"><img src="https://img.shields.io/badge/Website-tanisheesh.in-111111?style=flat-square&logo=googlechrome&logoColor=white" alt="Website"></a>
<a href="https://linkedin.com/in/tanisheesh"><img src="https://img.shields.io/badge/LinkedIn-tanisheesh-0A66C2?style=flat-square" alt="LinkedIn"></a>
<a href="https://github.com/tanisheesh"><img src="https://img.shields.io/badge/GitHub-tanisheesh-181717?style=flat-square&logo=github&logoColor=white" alt="GitHub"></a>
<a href="mailto:hey@tanisheesh.in"><img src="https://img.shields.io/badge/Email-hey%40tanisheesh.in-EA4335?style=flat-square&logo=gmail&logoColor=white" alt="Email"></a>

</div>
