<!--
  ╔══════════════════════════════════════════════════════════════╗
  ║  TANISH'S SETUP TOOLKIT · template · tanisheesh.in            ║
  ║  Keep the author footer at the bottom of the generated file.  ║
  ╚══════════════════════════════════════════════════════════════╝

  DEPLOY GUIDE TEMPLATE
  Goes to: <repo>/docs/DEPLOY.md
  Audience: you in 6 months, or anyone operating production.
  Keep only the hosting platform section(s) this project actually uses
  (Vercel / Render / Docker), replace {{PLACEHOLDERS}}, then delete comments.
-->

# Deploying {{PROJECT_NAME}}

> **Live:** [{{LIVE_URL}}]({{LIVE_URL}}) · **Host:** {{Vercel / Render / Docker}} · **Auto-deploy:** on push to `main`

For local development, see [SETUP.md](SETUP.md).

---

## 1. Production Topology & Resource Limits

| Component | Host / Service | Region & Runtime | Configured Limits / Quotas |
|---|---|---|---|
| {{Web app}} | {{Vercel}} | {{e.g. `bom1` · Node 22.x · Fluid}} | {{e.g. 30s function timeout · sourcemaps protected}} |
| {{API / worker}} | {{Render}} | {{e.g. Singapore · Python 3.12}} | {{e.g. Free tier sleeps after 15m idle (~30s cold start)}} |
| {{Database}} | {{Neon / Supabase}} | {{e.g. ap-south-1 / us-east-1}} | {{e.g. Pooled connection URL · max 100 conns}} |
| {{Cache / ratelimit}} | {{Upstash Redis}} | {{e.g. Global / ap-south-1}} | {{e.g. 500K cmds/mo}} |
| DNS & TLS | GoDaddy → Host | `{{SUBDOMAIN}}.tanisheesh.in` | CNAME + automatic Let's Encrypt / Vercel SSL |

---

## 2. Production Environment Variables

Configure all secrets in the host dashboard (encrypted at rest; never commit). Full key list is in [`.env.example`](../.env.example).

| Variable | Required | Host Location | Rotation / Sensitivity |
|---|---|---|---|
| `{{DATABASE_URL}}` | ✅ | {{Vercel → Settings → Env Vars (Production & Preview)}} | High — use pooled URL in serverless |
| `{{API_KEY}}` | ✅ | {{Vercel → Production Env Vars}} | High — server-only, never `NEXT_PUBLIC_` |
| `{{OPTIONAL_VAR}}` | ❌ | {{...}} | Low |

> Changing an env var does **not** update running deployments — trigger a redeploy after editing env vars.

---

## 3. First-Time Deploy

### Option A: Vercel

1. [vercel.com/new](https://vercel.com/new) → import `tanisheesh/{{REPO_NAME}}`.
2. Framework preset: `{{Next.js / Vite}}` · Root directory: `{{./ or apps/web}}`.
3. Add env vars from Section 2 and deploy.
4. Apply production & security settings via toolkit:
   ```powershell
   ..\setup-toolkit\scripts\setup-vercel-project.ps1 -Project "{{VERCEL_PROJECT}}" -RepoPath . -Region "{{VERCEL_REGION}}" -IgnoreDocsOnlyBuilds
   ```

### Option B: Render

1. [dashboard.render.com](https://dashboard.render.com) → New → Web Service (or import `render.yaml`) → `tanisheesh/{{REPO_NAME}}`.
2. Build command: `{{e.g. pip install -r requirements.txt}}`
3. Start command: `{{e.g. uvicorn app.main:app --host 0.0.0.0 --port $PORT}}`
4. Health check path: `{{/api/health}}` · Add env vars from Section 2 → Deploy.

### Option C: Docker (Self-Host)

```bash
docker build -t {{REPO_NAME}} .
docker run -d --restart unless-stopped -p {{PORT}}:{{PORT}} --env-file .env {{REPO_NAME}}
```

---

## 4. Zero-Downtime Migrations & Backups

```bash
{{e.g. npx prisma migrate deploy}}
```

- **When migrations run:** {{e.g. During Vercel build (`prisma migrate deploy`) or pre-deploy step}}.
- **Safety rule:** Always use expand-and-contract for breaking schema changes (add nullable column → backfill → switch reads/writes → drop old column in a later deploy) so previous versions don't crash mid-rollout.
- **Backups / PITR:** {{e.g. Neon instant branching / Supabase daily backups — restore before reverting destructive schema changes}}.

---

## 5. Custom Domain & Security Headers

`{{SUBDOMAIN}}.tanisheesh.in` is wired via:

```powershell
..\setup-toolkit\scripts\setup-subdomain.ps1 -Subdomain "{{SUBDOMAIN}}" -Platform {{Vercel|Render}} {{-VercelProject "<slug>" | -RenderHost "<svc>.onrender.com"}}
```

- **Manual DNS fallback:** Add `{{SUBDOMAIN}}.tanisheesh.in` in the host dashboard, then set GoDaddy CNAME `{{SUBDOMAIN}}` → `{{cname.vercel-dns.com | <svc>.onrender.com}}` (TTL 600s; propagation 2–10 min).
- **Security headers (`vercel.json`):** Enforce `X-Content-Type-Options: nosniff`, `X-Frame-Options: DENY`, `Referrer-Policy`, `Permissions-Policy`, and `Strict-Transport-Security`.

---

## 6. Post-Deploy Smoke Verification

Run immediately after production deploys:

```bash
# 1. Health endpoint must return 200
curl -fsS {{LIVE_URL}}/api/health

# 2. Verify security headers are active
curl -sI {{LIVE_URL}} | grep -iE "x-frame-options|x-content-type-options|strict-transport-security|referrer-policy"

# 3. Verify protected endpoint fails closed (401/403) without auth
curl -s -o /dev/null -w "%{http_code}\n" {{LIVE_URL}}/api/{{protected_route}}
```

- [ ] `{{LIVE_URL}}` loads on mobile (`375px`) and desktop (`1280px`) with zero console errors
- [ ] Core end-to-end flow works on live production data

---

## 7. Rollback Procedure

| Layer | Rollback Action |
|---|---|
| **Vercel** | Dashboard → Deployments → last known good deploy → **Promote to Production** (or `vercel rollback`) |
| **Render** | Service → Events → last good deploy → **Rollback** |
| **Database** | Forward-only migrations; if data-corrupting, restore from Neon branch / PITR snapshot |

> Always note any manual rollback (target SHA + reason) in a commit or PR so the next push to `main` does not silently re-deploy the broken commit.

---

## 8. Incident & Quota Runbooks

| Incident | Immediate Action |
|---|---|
| **LLM provider `429` / `503` spike** | Verify rate-limiter thresholds; enable degraded non-LLM fallback mode or switch backup model env var & redeploy |
| **DB connection exhaustion** | Confirm `DATABASE_URL` uses pooled endpoint (`-pooler` / port `6543`); inspect slow queries missing indexes |
| **Suspected secret leak** | Revoke/rotate leaked key immediately at provider → update host env var → redeploy → verify Gitleaks + Secret Scanning clear |
| **Webhook signature failures (`401`)** | Re-copy webhook signing secret in host env vars, redeploy, and verify raw-body middleware isn't pre-parsing JSON |

---

## 9. Monitoring & Automated Maintenance

- **Logs & Errors:** {{Vercel Logs / Render Logs / Sentry}}
- **Uptime:** {{e.g. Health check on `/api/health`}}
- **Automated Hygiene:** Renovate (`Yantra [bot]`), CodeQL, Gitleaks, and weekly Maintenance Report run via `.github/workflows/`.

---

<div align="center">

<h3>Tanish Poddar</h3>

<a href="https://tanisheesh.in"><img src="https://img.shields.io/badge/Website-tanisheesh.in-111111?style=flat-square&logo=googlechrome&logoColor=white" alt="Website"></a>
<a href="https://linkedin.com/in/tanisheesh"><img src="https://img.shields.io/badge/LinkedIn-tanisheesh-0A66C2?style=flat-square" alt="LinkedIn"></a>
<a href="https://github.com/tanisheesh"><img src="https://img.shields.io/badge/GitHub-tanisheesh-181717?style=flat-square&logo=github&logoColor=white" alt="GitHub"></a>
<a href="mailto:hi@tanisheesh.in"><img src="https://img.shields.io/badge/Email-hi%40tanisheesh.in-EA4335?style=flat-square&logo=gmail&logoColor=white" alt="Email"></a>

</div>
