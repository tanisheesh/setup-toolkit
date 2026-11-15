<div align="center">

<sub><b>TANISH'S SETUP TOOLKIT</b> · the standard for every repo by <a href="https://tanisheesh.in">Tanish Poddar</a></sub>

</div>

<h1 align="center">setup-toolkit</h1>

<p align="center">
  <strong>One playbook to standardize every repo: docs, runtime AI guardrails, anti-slop UI, security &amp; testing, GitHub automation, and Vercel/DNS provisioning.</strong>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/PowerShell-7+-5391FE?style=flat-square&logo=powershell&logoColor=white" alt="PowerShell 7+">
  <img src="https://img.shields.io/badge/GitHub_Advanced-CodeQL_%C2%B7_Rulesets-181717?style=flat-square&logo=github&logoColor=white" alt="GitHub">
  <img src="https://img.shields.io/badge/Vercel-000000?style=flat-square&logo=vercel&logoColor=white" alt="Vercel">
  <img src="https://img.shields.io/badge/Render-46E3B7?style=flat-square&logo=render&logoColor=black" alt="Render">
  <img src="https://img.shields.io/badge/GoDaddy_DNS-1BDBDB?style=flat-square&logo=godaddy&logoColor=black" alt="GoDaddy DNS">
  <img src="https://img.shields.io/badge/agent--ready-AGENTS.md-111111?style=flat-square" alt="Agent ready">
</p>

---

## What is this?

Every project I ship gets the same engineering bar: recruiter-friendly docs, runtime `AGENTS.md` / `CLAUDE.md` code-quality & anti-AI-slop UI rules, 4-layer testing, GitHub security scanning + rulesets + AI PR review, tuned Vercel settings, and a live `*.tanisheesh.in` URL.

A coding agent reads `AGENTS.md` and applies the entire standard to any repo, asking only for values it can't infer from the code.

---

## Quick start

Clone next to your projects:

```text
Projects/
  setup-toolkit/     ← this repo
  my-app/            ← the repo to set up
```

Then open your coding agent inside `my-app/` and say:

> Follow `../setup-toolkit/AGENTS.md` for this repo.

The agent audits the codebase, asks for missing values in one turn, generates docs + runtime `AGENTS.md` / `CLAUDE.md`, wires GitHub security & CI workflows, makes atomic emoji commits locally, and (after push) configures GitHub, Vercel, and GoDaddy DNS. **It never pushes without your approval.**

---

## What's inside

| Path | Purpose |
|---|---|
| [`AGENTS.md`](AGENTS.md) | 7-step setup playbook for coding agents |
| [`repo-template/`](repo-template) | Mirror-layout templates for docs, runtime `AGENTS.md`/`CLAUDE.md`, `.coderabbit.yaml`, `.github/` workflows & community files |
| [`stack-templates/`](stack-templates) | Conditional stack configs: `vercel.json` security headers, `render.yaml`, Playwright + `@axe-core/playwright` smoke tests |
| [`guidelines/commit-style.md`](guidelines/commit-style.md) | Mandatory emoji commit format: `<emoji> [#issue] [scope:] <message>` |
| [`guidelines/dev-guidelines.md`](guidelines/dev-guidelines.md) | Engineering standards, reusable component layering, PR rules, and git safety |
| [`guidelines/ui-guidelines.md`](guidelines/ui-guidelines.md) | Anti-AI-slop UI rules, 4-state UI contract, WCAG AA accessibility, and visual checks |
| [`guidelines/security-guidelines.md`](guidelines/security-guidelines.md) | Boundary validation, auth/IDOR, server secrets, headers, SSRF, and LLM safety |
| [`guidelines/testing-guidelines.md`](guidelines/testing-guidelines.md) | 4-layer testing pyramid (unit, integration/API, Playwright E2E + a11y, regression) |
| [`scripts/setup-github-repo.ps1`](scripts/setup-github-repo.ps1) | Metadata, squash-only merge settings, Secret Scanning + Push Protection, `Protect main` ruleset, labels, and secrets |
| [`scripts/setup-vercel-project.ps1`](scripts/setup-vercel-project.ps1) | Auto-detects stack/Node version and configures Vercel security, Fluid compute, region, and docs-ignore builds |
| [`scripts/setup-subdomain.ps1`](scripts/setup-subdomain.ps1) | Adds `<sub>.tanisheesh.in` on Vercel/Render and sets/overwrites the GoDaddy CNAME |

---

## GitHub automation & self-maintenance

Every repo set up with `repo-template/` gets:

- **Security scanning on every push & PR:**
  - `codeql.yml` — CodeQL SAST (`security-extended,security-and-quality`) for JS/TS and Python (free on public repos)
  - `secret-scan.yml` — Gitleaks secret detection across git history and PR diffs
  - `dependency-review.yml` — Blocks PRs introducing high/critical CVEs or GPL-incompatible licenses
  - GitHub Secret Scanning + Push Protection + Dependabot Alerts enabled via `setup-github-repo.ps1`
- **AI PR review:** `.coderabbit.yaml` reads the repo's `AGENTS.md` / `CLAUDE.md` directly (free on public repos), with optional local pre-PR checks via `coderabbit review --agent` and `ai-review.yml` BYOK fallback for private repos
- **Quality & release automation:** `ci.yml` (lint, format, typecheck, build, unit/integration, Playwright E2E + artifact upload), `labeler.yml`, `release.yml`, and `CODEOWNERS`
- **Weekly maintenance loop (IST):**

| When (IST) | What happens |
|---|---|
| Monday 06:00 | Dependabot opens grouped minor/patch PRs and individual major PRs |
| Monday 10:45 | Weekly scheduled CodeQL scan runs on `main` |
| On each PR | `ci.yml`, `codeql.yml`, `secret-scan.yml`, `dependency-review.yml`, and `labeler.yml` run |
| CI passes | `dependabot-auto-merge.yml` squash-merges Dependabot PRs automatically |
| CI fails | PR stays open with `needs-review` label and comment |
| Monday 10:00 | `maintenance-report.yml` emails Dependabot, CodeQL, Secret Scanning, and `main` CI summary |

---

## Credentials & manual scripts

Copy `.env.example` to `.env` in this folder (gitignored), fill in the keys you use, and load `.env` into your PowerShell session before running scripts manually:

```powershell
Get-Content .\.env | Where-Object { $_ -match '^\s*([A-Z_]+)\s*=\s*(.+)$' } |
  ForEach-Object { [Environment]::SetEnvironmentVariable($Matches[1], $Matches[2].Trim(), 'Process') }

.\scripts\setup-github-repo.ps1 -Repo "my-app" `
  -Description "One-line pitch" -Homepage "https://myapp.tanisheesh.in" `
  -Topics "nextjs","typescript","ai"

.\scripts\setup-vercel-project.ps1 -Project "my-app" -RepoPath "..\my-app" -Region "bom1" -IgnoreDocsOnlyBuilds
.\scripts\setup-subdomain.ps1 -Subdomain "myapp" -Platform Vercel -VercelProject "my-app"
.\scripts\setup-subdomain.ps1 -Subdomain "myapp" -Platform Render -RenderHost "my-app.onrender.com"
```

---

<div align="center">

<h3>Tanish Poddar</h3>

<a href="https://tanisheesh.in"><img src="https://img.shields.io/badge/Website-tanisheesh.in-111111?style=flat-square&logo=googlechrome&logoColor=white" alt="Website"></a>
<a href="https://linkedin.com/in/tanisheesh"><img src="https://img.shields.io/badge/LinkedIn-tanisheesh-0A66C2?style=flat-square" alt="LinkedIn"></a>
<a href="https://github.com/tanisheesh"><img src="https://img.shields.io/badge/GitHub-tanisheesh-181717?style=flat-square&logo=github&logoColor=white" alt="GitHub"></a>
<a href="mailto:hi@tanisheesh.in"><img src="https://img.shields.io/badge/Email-hi%40tanisheesh.in-EA4335?style=flat-square&logo=gmail&logoColor=white" alt="Email"></a>

</div>
