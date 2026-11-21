<!--
  ╔══════════════════════════════════════════════════════════════╗
  ║  TANISH'S SETUP TOOLKIT · template · tanisheesh.in            ║
  ║  Keep the author footer at the bottom of the generated file.  ║
  ╚══════════════════════════════════════════════════════════════╝
-->

# Engineering Decisions — {{PROJECT_NAME}}

<!-- PURPOSE OF THIS FILE
     Architecture Decision Records (ADRs) for senior engineers and interviewers.
     Every entry must reflect a real decision in the codebase, with concrete
     option comparisons, quantitative reasoning, tradeoffs, and reversal triggers.
-->

---

## ADR-01 — {{SHORT TITLE e.g. "Deterministic scoring before LLM summarization"}}

**Context:** {{1-2 sentences — what problem or constraint forced a choice?}}

### Options Considered

| Option | Latency | Monthly Cost | Ops Complexity | Verdict |
|---|---|---|---|---|
| **{{Chosen Option}}** | {{e.g. < 50ms / 2s}} | {{e.g. $0 / ~$X}} | {{e.g. Low}} | ✅ **Chosen** |
| {{Alternative A}} | {{e.g. 5–10s}} | {{e.g. ~$Y}} | {{e.g. Medium}} | ❌ Rejected |
| {{Alternative B}} | {{e.g. < 20ms}} | {{e.g. $Z}} | {{e.g. High}} | ❌ Rejected |

**Decision & Reason:** {{Why the chosen option won — cite real constraints, numbers, failure modes avoided.}}

**Tradeoff Accepted:** {{What you explicitly gave up.}}

**Reversal Trigger:** {{e.g. "Revisit when daily volume exceeds 10,000 jobs or p95 exceeds 5s — migrate to async BullMQ worker."}}

---

## ADR-02 — {{SHORT TITLE}}

**Context:** {{...}}

### Options Considered

| Option | Latency | Monthly Cost | Ops Complexity | Verdict |
|---|---|---|---|---|
| **{{Chosen Option}}** | {{...}} | {{...}} | {{...}} | ✅ **Chosen** |
| {{Alternative A}} | {{...}} | {{...}} | {{...}} | ❌ Rejected |

**Decision & Reason:** {{...}}

**Tradeoff Accepted:** {{...}}

**Reversal Trigger:** {{...}}

---

## ADR-03 — {{SHORT TITLE}}

**Context:** {{...}}

### Options Considered

| Option | Latency | Monthly Cost | Ops Complexity | Verdict |
|---|---|---|---|---|
| **{{Chosen Option}}** | {{...}} | {{...}} | {{...}} | ✅ **Chosen** |
| {{Alternative A}} | {{...}} | {{...}} | {{...}} | ❌ Rejected |

**Decision & Reason:** {{...}}

**Tradeoff Accepted:** {{...}}

**Reversal Trigger:** {{...}}

---

## What I'd improve next

- **{{Thing 1}}** — {{concrete reason + what unlocks it}}
- **{{Thing 2}}** — {{concrete reason + what unlocks it}}
- **{{Thing 3}}** — {{concrete reason + what unlocks it}}

---

## Explicit Non-Decisions (Deferred)

| Feature | Why Deferred | Trigger to Build |
|---|---|---|
| {{e.g. Multi-tenant teams/billing}} | {{e.g. Single-user scope ships faster without RBAC/Stripe overhead}} | {{e.g. > 100 active weekly org requests}} |
| {{e.g. Real-time WebSocket stream}} | {{e.g. Polling / on-demand refresh suffices for current latency budget}} | {{e.g. Sub-second collaborative edits needed}} |

---

<div align="center">

<h3>Tanish Poddar</h3>

<a href="https://tanisheesh.in"><img src="https://img.shields.io/badge/Website-tanisheesh.in-111111?style=flat-square&logo=googlechrome&logoColor=white" alt="Website"></a>
<a href="https://linkedin.com/in/tanisheesh"><img src="https://img.shields.io/badge/LinkedIn-tanisheesh-0A66C2?style=flat-square" alt="LinkedIn"></a>
<a href="https://github.com/tanisheesh"><img src="https://img.shields.io/badge/GitHub-tanisheesh-181717?style=flat-square&logo=github&logoColor=white" alt="GitHub"></a>
<a href="mailto:hi@tanisheesh.in"><img src="https://img.shields.io/badge/Email-hi%40tanisheesh.in-EA4335?style=flat-square&logo=gmail&logoColor=white" alt="Email"></a>

</div>
