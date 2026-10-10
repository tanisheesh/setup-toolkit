<!--
  ╔══════════════════════════════════════════════════════════════╗
  ║  TANISH'S SETUP TOOLKIT · template · tanisheesh.in            ║
  ║  Keep the author footer at the bottom of the generated file.  ║
  ╚══════════════════════════════════════════════════════════════╝
-->

# {{PROJECT_NAME}} — Architecture

<!--
Companion to PRD.md.
PRD says WHAT the system does. This says HOW.
Audience: an engineer who needs to understand the system well
enough to build it, debug it, or extend it.
No marketing language here — be precise.
-->

---

## 1. Stack

<!--
One line per layer. Be specific about versions where it matters.
-->

| Layer | Tech |
|---|---|
| Framework | {{e.g. Next.js 16 (App Router, TypeScript)}} |
| Auth | {{e.g. Clerk / Auth.js v5 with GitHub OAuth}} |
| Database | {{e.g. Supabase Postgres (managed) / Neon Postgres (serverless)}} |
| ORM | {{e.g. Prisma / asyncpg / Drizzle}} |
| Queue | {{e.g. BullMQ + Redis}} |
| AI | {{e.g. Anthropic Claude API / Groq (Llama 3.3-70B)}} |
| Styling | {{e.g. Tailwind CSS 4}} |
| Charts | {{e.g. Recharts / Plotly}} |
| Hosting | {{e.g. Vercel / Railway / Render}} |

---

## 2. Components

<!--
What are the major pieces of the system?
One paragraph per component — what it is, what it does, what it doesn't do.
-->

```
src/
  {{component_1}}/    {{one-line description}}
  {{component_2}}/    {{one-line description}}
  {{component_3}}/    {{one-line description}}
  {{component_4}}/    {{one-line description}}
  {{component_5}}/    {{one-line description}}
```

### {{Component 1 — e.g. Webhook Receiver}}

{{What it does. What triggers it. What it produces. What it explicitly does NOT do.
e.g. "Receives GitHub PR events, verifies HMAC signature, enqueues a job, returns 200.
Does not perform any review work inline — that happens in the worker."}}

### {{Component 2}}

{{...}}

### {{Component 3}}

{{...}}

---

## 3. Data Flow

<!--
Walk through the main happy path end-to-end, numbered steps.
This is the most important section for understanding the system quickly.
-->

```
{{Draw an ASCII diagram of the main flow}}

Example:

[Browser] --GitHub OAuth--> [Auth] --token in session-->
    [User clicks Sync] --> POST /api/sync
        --> Octokit pulls commits/PRs from GitHub
        --> normalize + upsert into Postgres
        --> burnout module recomputes score
    [Dashboard renders] <-- reads from DB
```

1. {{Step 1 — what triggers the flow}}
2. {{Step 2}}
3. {{Step 3}}
4. {{Step 4}}
5. {{Step 5 — what the user sees at the end}}

---

## 4. Database Schema

<!--
List your models/tables with key columns.
Don't copy-paste the full schema — describe the shape and relationships.
Call out indexes on hot query paths.
-->

- `{{Model 1}}` — {{key columns and what they store}}
- `{{Model 2}}` — {{key columns and what they store}}
- `{{Model 3}}` — {{key columns and what they store}}
- `{{Model 4}}` — {{key columns and what they store}}

**Indexes:** `{{table(col1, col2)}}` — {{why this index exists / what query it serves}}

---

## 5. AI / LLM Design

<!--
Include this section if your project uses an LLM.
This is where interviewers look to see if you understand prompt engineering
and LLM failure modes.
-->

### Input

{{What goes into the model — structured JSON, raw text, diffs?
Be explicit. e.g. "Structured JSON of commit titles and PR states — never raw diffs or code."}}

### System prompt strategy

{{What does the system prompt instruct the model to do?
What does it explicitly forbid? e.g. "Restricted to 3 finding categories only.
Instructed not to invent issues to appear thorough."}}

### Response schema

```jsonc
{
  // Paste your expected JSON schema here
  "{{field}}": "{{type}}",
  "{{field}}": [{ "{{key}}": "{{type}}" }]
}
```

### Validation

{{How do you handle a malformed response?
e.g. "Validated against Zod schema before writing to DB.
One retry on malformed output, then graceful error — attempt is still saved."}}

### Failure handling

{{What happens when the AI provider is down or slow?
e.g. "Groq call has 30s timeout. On failure, insights panel degrades to
raw statistics — the feature is 'unformatted', not 'broken'."}}

---

## 6. API Routes

<!--
List your main routes with method and one-line description.
Not every route — just the ones that matter for understanding the system.
-->

| Method | Route | Description |
|---|---|---|
| `POST` | `{{/api/sync}}` | {{e.g. Triggers GitHub pull + burnout recompute for signed-in user}} |
| `POST` | `{{/api/evaluate}}` | {{e.g. Calls Claude to score an interview answer, saves result}} |
| `GET` | `{{/api/repos}}` | {{e.g. Lists synced/available repos for the user}} |
| `POST` | `{{/webhooks/github}}` | {{e.g. Receives PR events, verifies HMAC, enqueues review job}} |

---

## 7. Security

<!--
Concrete decisions, not vague claims.
"Secure" means nothing. "AES-256-GCM with random 12-byte IV, key in env var" means something.
-->

- **{{Secrets}}:** {{e.g. All API keys in env vars only — .env.local gitignored, production in Vercel encrypted env vars. Never logged.}}
- **{{Auth tokens}}:** {{e.g. GitHub access tokens encrypted with AES-256-GCM before DB storage. PrismaAdapter plaintext copy nullified immediately after OAuth.}}
- **{{Webhook verification}}:** {{e.g. HMAC-SHA256 with timingSafeEqual — mandatory, not optional. Returns 401 before touching payload on mismatch.}}
- **{{API key exposure}}:** {{e.g. LLM API key accessed only in server routes — no NEXT_PUBLIC_ prefix, never reaches the browser.}}
- **{{Input validation}}:** {{e.g. All user inputs validated with Zod at the API boundary before any DB write.}}

---

## 8. Error Handling & Reliability

<!--
How does the system behave when things go wrong?
Cover the main failure modes.
-->

| Failure | Behaviour |
|---|---|
| {{e.g. LLM API down}} | {{e.g. 3 retries with exponential backoff, then dead-letter with log entry}} |
| {{e.g. Email send fails}} | {{e.g. Isolated try/catch — email failure cannot mark job failed or trigger retry}} |
| {{e.g. DB write fails}} | {{e.g. Job retried — upsert is idempotent so retry is safe}} |
| {{e.g. Invalid webhook}} | {{e.g. 401 returned immediately — job never enqueued}} |

---

## 9. Deployment

<!--
How does it run in production?
Just the facts — what services, what triggers deploys, what runs migrations.
-->

1. {{e.g. Vercel project linked to GitHub repo — auto-deploy on push to main.}}
2. {{e.g. Neon Postgres — pooled connection string for serverless compatibility.}}
3. {{e.g. prisma migrate deploy runs as part of Vercel build step.}}
4. {{e.g. Env vars set in Vercel project dashboard — DATABASE_URL, GITHUB_ID, GROQ_API_KEY, etc.}}

---

## 10. Explicit Scope Cuts

<!--
What did you decide NOT to build, and why?
Carried over from PRD but recorded here so it's not rediscovered mid-build.
-->

- **{{Feature}}** — {{e.g. "Jira/Linear integration deferred to v2 — GitHub-only keeps the data model simple and ships faster."}}
- **{{Feature}}** — {{...}}
- **{{Feature}}** — {{...}}

---

<div align="center">

<h3>Tanish Poddar</h3>

<a href="https://tanisheesh.in"><img src="https://img.shields.io/badge/Website-tanisheesh.in-111111?style=flat-square&logo=googlechrome&logoColor=white" alt="Website"></a>
<a href="https://linkedin.com/in/tanisheesh"><img src="https://img.shields.io/badge/LinkedIn-tanisheesh-0A66C2?style=flat-square" alt="LinkedIn"></a>
<a href="https://github.com/tanisheesh"><img src="https://img.shields.io/badge/GitHub-tanisheesh-181717?style=flat-square&logo=github&logoColor=white" alt="GitHub"></a>
<a href="mailto:hey@tanisheesh.in"><img src="https://img.shields.io/badge/Email-hey%40tanisheesh.in-EA4335?style=flat-square&logo=gmail&logoColor=white" alt="Email"></a>

</div>
