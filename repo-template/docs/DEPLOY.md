<!--
  ╔══════════════════════════════════════════════════════════════╗
  ║  TANISH'S SETUP TOOLKIT · template · tanisheesh.in            ║
  ║  Keep the author footer at the bottom of the generated file.  ║
  ╚══════════════════════════════════════════════════════════════╝

  DEPLOY GUIDE TEMPLATE
  Goes to: <repo>/docs/DEPLOY.md
  Audience: you in 6 months, or anyone self-hosting. Facts only, no marketing.
  How to fill: keep the platform section(s) this project actually uses
  (Vercel / Render / Docker), delete the rest, replace {{PLACEHOLDERS}},
  then delete these comments.
-->

# Deploying {{PROJECT_NAME}}

> **Live:** [{{LIVE_URL}}]({{LIVE_URL}}) · **Host:** {{Vercel / Render / Railway / AWS}} · **Auto-deploy:** on push to `main`

For local development, see [SETUP.md](SETUP.md).

---

## 1. Architecture in production

| Piece | Runs on | Notes |
|---|---|---|
| {{Web app}} | {{Vercel}} | {{e.g. Next.js, serverless functions in region bom1}} |
| {{API / worker}} | {{Render}} | {{e.g. FastAPI web service, free tier sleeps after 15 min}} |
| {{Database}} | {{Neon / Supabase}} | {{e.g. Postgres, pooled connection string}} |
| {{Cache / queue}} | {{Upstash Redis}} | {{...}} |
| DNS | GoDaddy | `{{SUBDOMAIN}}.tanisheesh.in` → CNAME to host |

---

## 2. Environment variables

Set these in the host dashboard (never commit them). Names and sources are in [`.env.example`](../.env.example).

| Variable | Required | Where it's set |
|---|---|---|
| `{{DATABASE_URL}}` | ✅ | {{Vercel → Project → Settings → Environment Variables}} |
| `{{API_KEY}}` | ✅ | {{...}} |
| `{{OPTIONAL_VAR}}` | ❌ | {{...}} |

> After changing an env var, **redeploy**. Running deployments don't pick up new values.

---

## 3. First-time deploy

### Option A: Vercel

1. [vercel.com/new](https://vercel.com/new) → import `tanisheesh/{{REPO_NAME}}`
2. Framework preset: {{Next.js}} · Root directory: `{{./ or apps/web}}`
3. Add the env vars from section 2
4. Deploy. Every push to `main` now deploys to production, and every PR gets a preview URL.

### Option B: Render

1. [dashboard.render.com](https://dashboard.render.com) → New → {{Web Service}} → connect `tanisheesh/{{REPO_NAME}}`
2. Build command: `{{e.g. pip install -r requirements.txt}}`
3. Start command: `{{e.g. uvicorn app.main:app --host 0.0.0.0 --port $PORT}}`
4. Add the env vars from section 2, then deploy

### Option C: Docker (self-host)

```bash
docker build -t {{REPO_NAME}} .
docker run -d -p {{PORT}}:{{PORT}} --env-file .env {{REPO_NAME}}
```

---

## 4. Database migrations

```bash
{{e.g. npx prisma migrate deploy}}
```

{{When does this run? e.g. "Automatically in the Vercel build step via `postinstall`" or "Manually before each deploy that changes the schema".}}

---

## 5. Custom domain

`{{SUBDOMAIN}}.tanisheesh.in` is wired with the setup toolkit:

```powershell
.\scripts\setup-subdomain.ps1 -Subdomain "{{SUBDOMAIN}}" -Platform {{Vercel|Render}} {{-VercelProject "<slug>" | -RenderHost "<svc>.onrender.com"}}
```

Manual fallback: add the domain in the host dashboard, then create a GoDaddy CNAME `{{SUBDOMAIN}}` → `{{cname.vercel-dns.com | <svc>.onrender.com}}`. HTTPS certificates are issued automatically once DNS resolves (2–10 min).

---

## 6. Verify a deploy

- [ ] `{{LIVE_URL}}` loads with no console errors
- [ ] {{e.g. Login works end-to-end}}
- [ ] {{e.g. `GET /api/health` returns 200}}
- [ ] {{e.g. Core flow: create → view → delete works on production data}}

---

## 7. Rollback

| Host | How |
|---|---|
| Vercel | Dashboard → Deployments → pick the last good one → **Promote to Production** (or `vercel rollback`) |
| Render | Service → Events → last good deploy → **Rollback** |
| Database | {{e.g. Migrations are forward-only. Restore from Neon branch / point-in-time backup}} |

After rolling back, note it in a commit or PR so the next push doesn't silently re-ship the broken version.

---

## 8. Monitoring & logs

- **Logs:** {{Vercel → Project → Logs / Render → Service → Logs}}
- **Errors:** {{e.g. Sentry project link, or "none yet"}}
- **Uptime:** {{e.g. UptimeRobot on /api/health, or "none yet"}}
- **Dependencies:** Dependabot opens weekly update PRs and a maintenance report is emailed every week (see `.github/workflows/`)

---

## Known production limitations

- {{e.g. Render free tier cold-starts in ~30s after inactivity}}
- {{e.g. Groq free tier: 30 req/min, so heavy use may rate-limit}}

---

<div align="center">

<h3>Tanish Poddar</h3>

<a href="https://tanisheesh.in"><img src="https://img.shields.io/badge/Website-tanisheesh.in-111111?style=flat-square&logo=googlechrome&logoColor=white" alt="Website"></a>
<a href="https://linkedin.com/in/tanisheesh"><img src="https://img.shields.io/badge/LinkedIn-tanisheesh-0A66C2?style=flat-square" alt="LinkedIn"></a>
<a href="https://github.com/tanisheesh"><img src="https://img.shields.io/badge/GitHub-tanisheesh-181717?style=flat-square&logo=github&logoColor=white" alt="GitHub"></a>
<a href="mailto:hi@tanisheesh.in"><img src="https://img.shields.io/badge/Email-hey%40tanisheesh.in-EA4335?style=flat-square&logo=gmail&logoColor=white" alt="Email"></a>

</div>
