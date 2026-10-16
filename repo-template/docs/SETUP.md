<!--
  ╔══════════════════════════════════════════════════════════════╗
  ║  TANISH'S SETUP TOOLKIT · template · tanisheesh.in            ║
  ║  Keep the author footer at the bottom of the generated file.  ║
  ╚══════════════════════════════════════════════════════════════╝
-->

# Local Setup — {{PROJECT_NAME}}

> **Just want to try it?** Use the live demo at [{{LIVE_URL}}]({{LIVE_URL}}) — no setup needed.
> This guide is for running {{PROJECT_NAME}} locally or self-hosting it.

---

## Prerequisites

- {{e.g. Node.js 20+}}
- {{e.g. Python 3.11+}}
- {{e.g. Docker + Docker Compose}}
- {{e.g. A GitHub account (for OAuth)}}

---

## 1. Clone and install

```bash
git clone https://github.com/tanisheesh/{{REPO_NAME}}
cd {{REPO_NAME}}
{{e.g. npm install / pip install -e . / docker-compose up --build}}
```

---

## 2. Environment variables

Copy `.env.example` to `.env.local` and fill in the values:

```bash
cp .env.example .env.local
```

| Variable | Where to get it |
|---|---|
| `{{VAR_1}}` | {{e.g. GitHub → Settings → Developer settings → OAuth Apps}} |
| `{{VAR_2}}` | {{e.g. console.anthropic.com → API Keys}} |
| `{{VAR_3}}` | {{e.g. Your Supabase project → Settings → API}} |
| `{{VAR_4}}` | {{e.g. Railway → your Redis service → Connect}} |

---

## 3. Database setup

```bash
{{e.g. npx prisma migrate dev}}
{{e.g. docker-compose up timescaledb -d && python scripts/migrate.py}}
{{e.g. supabase db push}}
```

---

## 4. Run locally

```bash
{{e.g. npm run dev}}
{{e.g. docker-compose up --build}}
{{e.g. uvicorn app.main:app --reload}}
```

{{PROJECT_NAME}} will be running at `http://localhost:{{PORT}}`.

---

## 5. Deploy to production

See [DEPLOY.md](DEPLOY.md) for production deployment, custom domain and rollback steps.

---

## Known local-only limitations

<!-- Honest list of things that don't work locally vs production -->

- {{e.g. GitHub webhooks require a public URL — use ngrok for local testing}}
- {{e.g. Supabase Realtime requires the hosted Supabase instance, not local}}

---

<div align="center">

<h3>Tanish Poddar</h3>

<a href="https://tanisheesh.in"><img src="https://img.shields.io/badge/Website-tanisheesh.in-111111?style=flat-square&logo=googlechrome&logoColor=white" alt="Website"></a>
<a href="https://linkedin.com/in/tanisheesh"><img src="https://img.shields.io/badge/LinkedIn-tanisheesh-0A66C2?style=flat-square" alt="LinkedIn"></a>
<a href="https://github.com/tanisheesh"><img src="https://img.shields.io/badge/GitHub-tanisheesh-181717?style=flat-square&logo=github&logoColor=white" alt="GitHub"></a>
<a href="mailto:hi@tanisheesh.in"><img src="https://img.shields.io/badge/Email-hey%40tanisheesh.in-EA4335?style=flat-square&logo=gmail&logoColor=white" alt="Email"></a>

</div>
