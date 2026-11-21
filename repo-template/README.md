<!--
  ╔══════════════════════════════════════════════════════════════╗
  ║  TANISH'S SETUP TOOLKIT · template · tanisheesh.in            ║
  ║  Keep the author footer at the bottom of the generated file.  ║
  ╚══════════════════════════════════════════════════════════════╝
-->

<!--
  UNIVERSAL README TEMPLATE — Tanish Poddar
  ==========================================
  Instructions (delete this block before publishing):

  1. Replace every {{PLACEHOLDER}} with real values grounded in the code.
  2. For LOGO: use an SVG icon from lucide.dev or heroicons.com,
     pick a color that matches your project vibe, paste inline.
  3. For BADGES: replace each href and img src slug.
     Keep CI + CodeQL + Live Demo + GPL-3.0 + applicable stack badges.
  4. Delete any section that doesn't apply (e.g. Demo if no video yet,
     By the Numbers if no verified numbers, Traction if zero users).
     NEVER include a Quick Start / local install guide here — keep that
     in docs/SETUP.md and end-user API/CLI guides in docs/USAGE.md.
  5. Keep the file crisp (~130-160 rendered lines max).
-->

<p align="center">
  <!-- REPLACE: paste your SVG logo here, keep width/height at 64 -->
  <svg xmlns="http://www.w3.org/2000/svg" width="64" height="64" viewBox="0 0 24 24"
       fill="none" stroke="{{BRAND_COLOR}}" stroke-width="1.5"
       stroke-linecap="round" stroke-linejoin="round">
    <!-- paste icon path(s) from lucide.dev here -->
  </svg>
</p>

<h1 align="center">{{PROJECT_NAME}}</h1>

<p align="center">
  <strong>{{ONE_LINE_DESCRIPTION}}</strong>
</p>

<p align="center">
  <!-- LIVE DEMO — most important link, always first -->
  <a href="{{LIVE_URL}}">
    <img src="https://img.shields.io/badge/live_demo-visit-{{BRAND_COLOR_NO_HASH}}?style=flat-square" alt="Live Demo">
  </a>
  <a href="https://github.com/tanisheesh/{{REPO_NAME}}/actions/workflows/ci.yml">
    <img src="https://github.com/tanisheesh/{{REPO_NAME}}/actions/workflows/ci.yml/badge.svg" alt="CI">
  </a>
  <a href="https://github.com/tanisheesh/{{REPO_NAME}}/actions/workflows/codeql.yml">
    <img src="https://github.com/tanisheesh/{{REPO_NAME}}/actions/workflows/codeql.yml/badge.svg" alt="CodeQL">
  </a>
  <!-- TECH STACK BADGES — pick what applies, delete the rest -->
  <img src="https://img.shields.io/badge/Next.js-black?style=flat-square&logo=next.js" alt="Next.js">
  <img src="https://img.shields.io/badge/TypeScript-3178C6?style=flat-square&logo=typescript&logoColor=white" alt="TypeScript">
  <img src="https://img.shields.io/badge/Python-3776AB?style=flat-square&logo=python&logoColor=white" alt="Python">
  <img src="https://img.shields.io/badge/Go-00ADD8?style=flat-square&logo=go&logoColor=white" alt="Go">
  <img src="https://img.shields.io/badge/Flutter-02569B?style=flat-square&logo=flutter&logoColor=white" alt="Flutter">
  <img src="https://img.shields.io/badge/Node.js-339933?style=flat-square&logo=node.js&logoColor=white" alt="Node.js">
  <img src="https://img.shields.io/badge/React-61DAFB?style=flat-square&logo=react&logoColor=black" alt="React">
  <img src="https://img.shields.io/badge/Expo-000020?style=flat-square&logo=expo&logoColor=white" alt="Expo">
  <img src="https://img.shields.io/badge/Electron-47848F?style=flat-square&logo=electron&logoColor=white" alt="Electron">
  <img src="https://img.shields.io/badge/FastAPI-009688?style=flat-square&logo=fastapi&logoColor=white" alt="FastAPI">
  <img src="https://img.shields.io/badge/PostgreSQL-4169E1?style=flat-square&logo=postgresql&logoColor=white" alt="PostgreSQL">
  <img src="https://img.shields.io/badge/Redis-DC382D?style=flat-square&logo=redis&logoColor=white" alt="Redis">
  <img src="https://img.shields.io/badge/Supabase-3ECF8E?style=flat-square&logo=supabase&logoColor=white" alt="Supabase">
  <img src="https://img.shields.io/badge/AWS-232F3E?style=flat-square&logo=amazon-aws&logoColor=white" alt="AWS">
  <img src="https://img.shields.io/badge/Docker-2496ED?style=flat-square&logo=docker&logoColor=white" alt="Docker">
  <img src="https://img.shields.io/badge/Claude_API-D97757?style=flat-square" alt="Claude API">
  <img src="https://img.shields.io/badge/Groq-F55036?style=flat-square" alt="Groq">
  <!-- License badge: keep GPL-3.0 for public portfolio/OSS repos; omit or adjust for private/client repos -->
  <img src="https://img.shields.io/badge/license-GPL--3.0-{{BRAND_COLOR_NO_HASH}}?style=flat-square" alt="License">
</p>

---

## What is {{PROJECT_NAME}}?

{{2-3 SENTENCES — what problem it solves, who it's for, what makes it
different from the obvious alternative. No bullet points here — write
it like a product pitch, not a feature list.}}

> **Live demo →** [{{LIVE_URL}}]({{LIVE_URL}})
> {{IF CREDENTIALS NEEDED}} Login with `{{demo_email}}` / `{{demo_password}}`

---

## Demo

<!-- Generated with `/brag` -> `brag-output/brag.mp4` (or terminal GIF).
     Recommended: drag-and-drop `brag.mp4` into GitHub's editor to get a native
     inline player URL (`https://github.com/user-attachments/assets/...`) without
     bloating Git, or embed a compact `docs/assets/demo.mp4`. Delete if no demo yet. -->

{{VIDEO_OR_GIF_EMBED}}

---

## What you get

<!-- Keep this tight — 3 to 5 features max, each one line -->

- **{{FEATURE_1}}** — {{what it does and why it matters}}
- **{{FEATURE_2}}** — {{what it does and why it matters}}
- **{{FEATURE_3}}** — {{what it does and why it matters}}
- **{{FEATURE_4}}** — {{what it does and why it matters}}

---

## By the numbers

<!-- Strictly real, verifiable numbers from code, configs, tests, or benchmarks.
     Delete rows you haven't measured; delete the whole section if none exist. -->

| Metric | Value | Source |
|---|---|---|
| {{e.g. API timeout / latency budget}} | {{e.g. < 250ms p95 / 30s LLM hard cap}} | {{e.g. `vercel.json` / benchmark}} |
| {{e.g. Rate limit}} | {{e.g. 30 req/min per user}} | {{e.g. `src/lib/ratelimit.ts`}} |
| {{e.g. Automated test suite}} | {{e.g. 42 unit + 8 Playwright E2E + a11y checks}} | {{e.g. `tests/`}} |
| {{e.g. Payload / token cap}} | {{e.g. 4,000 input / 1,500 output tokens max}} | {{e.g. `src/lib/ai.ts`}} |

---

## Stack

<!-- One line per layer — label on the left, tech + exact version on the right -->

| Layer | Tech |
|---|---|
| Frontend | {{e.g. Next.js 16 · Tailwind CSS 4 · Recharts}} |
| Backend | {{e.g. Node.js 22 · Express · BullMQ}} |
| Database | {{e.g. PostgreSQL · Prisma · TimescaleDB}} |
| Auth | {{e.g. Clerk · Auth.js v5 · Supabase Auth}} |
| AI | {{e.g. Claude API · Groq · Llama 3.3-70B}} |
| Infra | {{e.g. Vercel (bom1) · Render · Upstash Redis · Docker}} |

---

## Engineering Decisions

<!-- THIS SECTION IS YOUR INTERVIEW DIFFERENTIATOR.
     Write 3-5 real decisions you made and why, citing concrete tradeoffs.
     Format: bold question → 1-2 sentence answer. -->

**Why {{TECH_A}} over {{TECH_B}}?**
{{Honest reason — latency numbers, monthly cost, constraints, tradeoffs.}}

**Why {{DESIGN_DECISION}}?**
{{e.g. "Burnout score is calculated deterministically, not by AI — so every score is auditable and traceable to raw commit data."}}

**Why {{ARCHITECTURE_CHOICE}}?**
{{e.g. "Z-score anomaly detection runs before the LLM — the model receives only structured findings (< 800 tokens), never raw telemetry."}}

**What would you improve next?**
{{Honest answer — shows self-awareness and clear threshold for change.}}

---

## Traction

<!-- Only include this section if you have real numbers.
     Leave it out rather than showing zeros. -->

| Metric | Value |
|---|---|
| {{e.g. Signed-up users}} | {{number}} |
| {{e.g. PyPI downloads}} | {{number}} |
| {{e.g. PRs reviewed}} | {{number}} |
| {{e.g. Messages/day}} | {{number}} |

---

## Docs

| Document | Description |
|---|---|
| [PRD](docs/PRD.md) | Product requirements — quantified impact, acceptance criteria, edge cases, unit economics |
| [Architecture](docs/ARCHITECTURE.md) | System topology (Mermaid), API contracts, schema/indexes, caching, scale ceilings |
| [Decisions](docs/DECISIONS.md) | Technical ADRs — comparison matrices, tradeoffs, and reversal triggers |
| [Usage](docs/USAGE.md) | End-user CLI / SDK / API reference and examples *(keep only if applicable)* |
| [Setup](docs/SETUP.md) | Local dev onboarding, env var matrix, seed data, and troubleshooting |
| [Deploy](docs/DEPLOY.md) | Production topology, zero-downtime migrations, smoke checks, and incident runbooks |
| [Contributing](CONTRIBUTING.md) | Branching, emoji commit style, and PR checklist |
| [Changelog](CHANGELOG.md) | Release history mapped to commit history |
| [Security](SECURITY.md) | Vulnerability reporting policy and security scope |

---

<div align="center">

<h3>Tanish Poddar</h3>

<a href="https://tanisheesh.in"><img src="https://img.shields.io/badge/Website-tanisheesh.in-111111?style=flat-square&logo=googlechrome&logoColor=white" alt="Website"></a>
<a href="https://linkedin.com/in/tanisheesh"><img src="https://img.shields.io/badge/LinkedIn-tanisheesh-0A66C2?style=flat-square" alt="LinkedIn"></a>
<a href="https://github.com/tanisheesh"><img src="https://img.shields.io/badge/GitHub-tanisheesh-181717?style=flat-square&logo=github&logoColor=white" alt="GitHub"></a>
<a href="mailto:hi@tanisheesh.in"><img src="https://img.shields.io/badge/Email-hi%40tanisheesh.in-EA4335?style=flat-square&logo=gmail&logoColor=white" alt="Email"></a>

</div>
