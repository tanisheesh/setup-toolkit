<div align="center">

<sub><b>TANISH'S SETUP TOOLKIT</b> · the standard for every repo by <a href="https://tanisheesh.in">Tanish Poddar</a></sub>

</div>

<h1 align="center">setup-toolkit</h1>

<p align="center">
  <strong>One playbook to set up every repo the same way: docs, commit style, GitHub metadata, and a custom subdomain.</strong>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/PowerShell-7+-5391FE?style=flat-square&logo=powershell&logoColor=white" alt="PowerShell 7+">
  <img src="https://img.shields.io/badge/Vercel-000000?style=flat-square&logo=vercel&logoColor=white" alt="Vercel">
  <img src="https://img.shields.io/badge/Render-46E3B7?style=flat-square&logo=render&logoColor=black" alt="Render">
  <img src="https://img.shields.io/badge/GoDaddy_DNS-1BDBDB?style=flat-square&logo=godaddy&logoColor=black" alt="GoDaddy DNS">
  <img src="https://img.shields.io/badge/agent--ready-AGENTS.md-111111?style=flat-square" alt="Agent ready">
</p>

---

## What is this?

Every project I ship gets the same treatment: a recruiter-friendly README, a PRD, architecture and decision docs, consistent commits, proper GitHub metadata, and a live `*.tanisheesh.in` URL. This toolkit holds that standard in one place. A coding agent reads `AGENTS.md` and applies all of it to any repo, asking me only for what it can't work out from the code.

---

## Quick start

Clone it next to your projects:

```
Projects/
  setup-toolkit/     ← this repo
  _project-data/     ← your private credentials (never committed)
  my-app/            ← the repo to set up
```

Then open your coding agent inside `my-app/` and say:

> Follow `../setup-toolkit/AGENTS.md` for this repo.

The agent reads the code, asks for the subdomain and other missing values, writes the docs, commits them in the standard style, sets the GitHub metadata, and points the subdomain. It reports back with a checklist. **It never pushes without your approval.**

---

## What's inside

| Path | Purpose |
|---|---|
| [`AGENTS.md`](AGENTS.md) | Step-by-step playbook for the coding agent: order of steps, what to ask, safety rules, done-checklist |
| [`docs-templates/`](docs-templates) | `readme`, `prd`, `architecture`, `decisions`, `setup` templates → become `README.md` + `docs/*.md` |
| [`guidelines/commit-style.md`](guidelines/commit-style.md) | Emoji commit format: `<emoji> [#issue] [scope:] <message>` |
| [`guidelines/dev-guidelines.md`](guidelines/dev-guidelines.md) | Definition of done, naming conventions, PR and git-safety rules |
| [`scripts/setup-github-repo.ps1`](scripts/setup-github-repo.ps1) | Sets a repo's description, homepage and topics |
| [`scripts/setup-subdomain.ps1`](scripts/setup-subdomain.ps1) | Adds `<sub>.tanisheesh.in` to Vercel/Render and creates the GoDaddy CNAME |

---

## Credentials

Scripts read tokens from environment variables. Keep them in `_project-data/CREDENTIALS.env`, **outside** this repo:

```env
GITHUB_TOKEN=     # github.com/settings/tokens → classic, `repo` scope
VERCEL_TOKEN=     # vercel.com/account/tokens
RENDER_API_KEY=   # dashboard.render.com → Account → API Keys
GODADDY_KEY=      # developer.godaddy.com/keys → format KEY:SECRET
```

`.gitignore` blocks `.env*` files and `_project-data/`, so they can't be committed here by accident.

---

## Running the scripts manually

```powershell
.\scripts\setup-github-repo.ps1 -Repo "my-app" `
  -Description "One-line pitch" -Homepage "https://myapp.tanisheesh.in" `
  -Topics "nextjs","typescript","ai"

.\scripts\setup-subdomain.ps1 -Subdomain "myapp" -Platform Vercel -VercelProject "my-app"
.\scripts\setup-subdomain.ps1 -Subdomain "myapp" -Platform Render -RenderHost "my-app.onrender.com"
```

A missing token makes the script prompt for it. DNS usually propagates in 2–10 minutes.

---

<div align="center">

<h3>Tanish Poddar</h3>

<a href="https://tanisheesh.in"><img src="https://img.shields.io/badge/Website-tanisheesh.in-111111?style=flat-square&logo=googlechrome&logoColor=white" alt="Website"></a>
<a href="https://linkedin.com/in/tanisheesh"><img src="https://img.shields.io/badge/LinkedIn-tanisheesh-0A66C2?style=flat-square" alt="LinkedIn"></a>
<a href="https://github.com/tanisheesh"><img src="https://img.shields.io/badge/GitHub-tanisheesh-181717?style=flat-square&logo=github&logoColor=white" alt="GitHub"></a>
<a href="mailto:hey@tanisheesh.in"><img src="https://img.shields.io/badge/Email-hey%40tanisheesh.in-EA4335?style=flat-square&logo=gmail&logoColor=white" alt="Email"></a>

</div>
