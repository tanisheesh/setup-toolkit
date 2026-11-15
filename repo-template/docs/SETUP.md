<!--
  ╔══════════════════════════════════════════════════════════════╗
  ║  TANISH'S SETUP TOOLKIT · template · tanisheesh.in            ║
  ║  Keep the author footer at the bottom of the generated file.  ║
  ╚══════════════════════════════════════════════════════════════╝
-->

# Local Setup — {{PROJECT_NAME}}

> **Just want to try it?** Use the live deployment at [{{LIVE_URL}}]({{LIVE_URL}}) — zero setup needed.
> This guide covers running **{{PROJECT_NAME}}** locally, seeding test data, running the full test suite, and fixing common local issues.

---

## Prerequisites & Versions

- {{e.g. Node.js 22.x (matches `.nvmrc`) + npm / pnpm / bun}}
- {{e.g. Python 3.12+ + `uv`}}
- {{e.g. Docker + Docker Compose (for local Postgres/Redis if not using hosted dev DB)}}

---

## 1. Clone & Install

```bash
git clone https://github.com/tanisheesh/{{REPO_NAME}}
cd {{REPO_NAME}}
{{e.g. npm ci / bun install --frozen-lockfile / uv sync --all-extras}}
```

---

## 2. Environment Variables

Copy `.env.example` to `.env` (or `.env.local` for Next.js) and populate required keys:

```bash
cp .env.example .env   # or .env.local for Next.js
```

| Variable | Type / Format | Required | Scope | Local Default / Source |
|---|---|---|---|---|
| `{{DATABASE_URL}}` | `postgresql://...` | ✅ | Server-only | {{e.g. Local Docker or Neon dev branch}} |
| `{{AUTH_SECRET}}` | 32-byte random hex/base64 | ✅ | Server-only | `openssl rand -base64 32` |
| `{{LLM_API_KEY}}` | API token string | ✅ | Server-only | {{e.g. console.anthropic.com / console.groq.com}} |
| `{{NEXT_PUBLIC_APP_URL}}` | Origin URL | ❌ | Public | `http://localhost:{{PORT}}` |

> Never commit `.env` or `.env.local`, and never expose server secrets with `NEXT_PUBLIC_` / `VITE_`.

---

## 3. Local Infrastructure, Migrations & Seed Data

```bash
# 1. Start local backing services (if using Docker Compose)
{{e.g. docker compose up -d postgres redis}}

# 2. Apply schema migrations
{{e.g. npx prisma migrate dev}}

# 3. Seed realistic dev/demo fixtures (optional)
{{e.g. npm run db:seed / python scripts/seed.py}}
```

---

## 4. Run Locally

```bash
{{e.g. npm run dev / bun run dev / uvicorn app.main:app --reload --port 8000}}
```

App runs at `http://localhost:{{PORT}}` (health check: `GET http://localhost:{{PORT}}/api/health`).

---

## 5. Run Verification & Full Test Suite

Run the exact same checks CI enforces before committing:

```bash
{{LINT_CMD}}        # e.g. npm run lint / ruff check .
{{TYPECHECK_CMD}}   # e.g. npm run typecheck / mypy .
{{BUILD_CMD}}       # e.g. npm run build / python -m compileall -q .
{{TEST_CMD}}        # e.g. npm test / pytest -q
{{E2E_CMD}}         # e.g. npx playwright test (375px + 1280px + axe-core a11y)
```

*(If `coderabbit` CLI is installed: `coderabbit review --agent --uncommitted`)*

---

## 6. Known Local-Only Limitations

- {{e.g. Inbound GitHub/Stripe webhooks require a public tunnel (`ngrok http {{PORT}}` or `stripe listen`).}}
- {{e.g. Production-only security headers in `vercel.json` apply at the edge, not `next dev`.}}

---

## 7. Troubleshooting

| Symptom / Exact Error | Root Cause | Fix |
|---|---|---|
| `ECONNREFUSED 127.0.0.1:5432` | Local DB container not started or wrong port | Run `docker compose up -d` and verify `DATABASE_URL` |
| `PrismaClientInitializationError` / schema mismatch | Generated client out of sync with migrations | Run `npx prisma generate && npx prisma migrate dev` |
| OAuth `redirect_uri_mismatch` | Callback URL doesn't match `localhost:{{PORT}}` | Add `http://localhost:{{PORT}}/api/auth/callback/...` in OAuth app |
| Webhook returns `401` locally | Secret mismatch or body parsed before HMAC check | Verify raw body is hashed and `WEBHOOK_SECRET` matches tunnel CLI |
| Playwright fails on missing browser | First run without browser binaries installed | Run `npx playwright install --with-deps` |

---

## 8. Deploy to Production

See [DEPLOY.md](DEPLOY.md) for production hosting, custom domain wiring, smoke checks, and rollback steps.

---

<div align="center">

<h3>Tanish Poddar</h3>

<a href="https://tanisheesh.in"><img src="https://img.shields.io/badge/Website-tanisheesh.in-111111?style=flat-square&logo=googlechrome&logoColor=white" alt="Website"></a>
<a href="https://linkedin.com/in/tanisheesh"><img src="https://img.shields.io/badge/LinkedIn-tanisheesh-0A66C2?style=flat-square" alt="LinkedIn"></a>
<a href="https://github.com/tanisheesh"><img src="https://img.shields.io/badge/GitHub-tanisheesh-181717?style=flat-square&logo=github&logoColor=white" alt="GitHub"></a>
<a href="mailto:hi@tanisheesh.in"><img src="https://img.shields.io/badge/Email-hi%40tanisheesh.in-EA4335?style=flat-square&logo=gmail&logoColor=white" alt="Email"></a>

</div>
