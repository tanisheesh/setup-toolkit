<div align="center">

<sub><b>TANISH'S SETUP TOOLKIT</b> · the engineering standard for every repo by <a href="https://tanisheesh.in">Tanish Poddar</a></sub>

</div>

<p align="center">
  <svg xmlns="http://www.w3.org/2000/svg" width="60" height="60" viewBox="0 0 24 24"
       fill="none" stroke="#F59E0B" stroke-width="1.5"
       stroke-linecap="round" stroke-linejoin="round">
    <path d="M12 2L2 7l10 5 10-5-10-5Z"/>
    <path d="M2 17l10 5 10-5"/>
    <path d="M2 12l10 5 10-5"/>
  </svg>
</p>

<h1 align="center">setup-toolkit</h1>

<p align="center">
  <strong>One playbook to standardize, harden, and ship every repository — deep docs, runtime AI guardrails, anti-slop UI, 4-layer testing, GitHub security automation, and multi-host DNS provisioning.</strong>
</p>

<p align="center">
  <a href="https://github.com/tanisheesh/setup-toolkit/actions/workflows/toolkit-ci.yml">
    <img src="https://github.com/tanisheesh/setup-toolkit/actions/workflows/toolkit-ci.yml/badge.svg" alt="Toolkit CI">
  </a>
  <img src="https://img.shields.io/badge/PowerShell-7+-5391FE?style=flat-square&logo=powershell&logoColor=white" alt="PowerShell 7+">
  <img src="https://img.shields.io/badge/CodeQL-JS%2FTS_%C2%B7_Python_%C2%B7_Go-181717?style=flat-square&logo=github&logoColor=white" alt="CodeQL">
  <img src="https://img.shields.io/badge/Renovate-Yantra_[bot]-1A1F6C?style=flat-square&logo=renovate&logoColor=white" alt="Renovate">
  <img src="https://img.shields.io/badge/Vercel-000000?style=flat-square&logo=vercel&logoColor=white" alt="Vercel">
  <img src="https://img.shields.io/badge/Render-46E3B7?style=flat-square&logo=render&logoColor=black" alt="Render">
  <img src="https://img.shields.io/badge/Railway-0B0D0E?style=flat-square&logo=railway&logoColor=white" alt="Railway">
  <img src="https://img.shields.io/badge/GoDaddy_DNS-1BDBDB?style=flat-square&logo=godaddy&logoColor=black" alt="GoDaddy DNS">
  <img src="https://img.shields.io/badge/agent--ready-AGENTS.md-111111?style=flat-square" alt="Agent ready">
</p>

---

## What is this?

Every project I ship — across TypeScript, Next.js, Python, Go, Flutter, and multi-service monorepos — shares one engineering standard: code-grounded docs (`PRD`, `ARCHITECTURE` with Mermaid diagrams, quantitative `DECISIONS`, `SETUP`, `DEPLOY`, optional `USAGE`), a strict runtime `AGENTS.md` contract, automated SAST + secret scanning, custom-branded dependency maintenance via [**Yantra [bot]**](https://github.com/tanisheesh-bot), and live deployment wiring under `*.tanisheesh.in`.

A coding agent reads [`AGENTS.md`](AGENTS.md), audits the target codebase, asks only for what cannot be inferred from code, commits atomically in standard emoji style, and — after approval — configures GitHub, Vercel, and GoDaddy DNS.

---

## How to run it on a repo

Clone `setup-toolkit` alongside your project folders:

```text
Projects/
  setup-toolkit/     ← this toolkit
  my-app/            ← target repo
```

Open your coding agent inside `my-app/` and say:

> Follow `../setup-toolkit/AGENTS.md` for this repo.

### Repo Profiles & Modes

[`AGENTS.md`](AGENTS.md) adapts automatically based on repo type and whether the repo already has an earlier toolkit setup:

| Mode / Profile | How it behaves |
|---|---|
| **Fresh Setup** | Audits code, drafts all docs + runtime `AGENTS.md`, wires `.github/` automation, applies conditional `stack-templates/`, and commits locally without pushing |
| **Upgrade Mode (v1 → v2)** | Preserves existing custom `README.md` / `docs/` while adding runtime `AGENTS.md`, `.coderabbit.yaml`, CodeQL, Gitleaks, Dependency Review, and Renovate (`Yantra [bot]`) |
| **Portfolio / OSS / CLI** | `GPL-3.0` badge, `*.tanisheesh.in` URL, `/brag` launch demo video slot, and `docs/USAGE.md` (when CLI/SDK/API) |
| **Private / Client Repo** | Drops `GPL-3.0` & `*.tanisheesh.in` assumptions, preserves client branding/domains, and handles private-repo scan gates cleanly |

---

## What's inside

| Path | Purpose |
|---|---|
| [`AGENTS.md`](AGENTS.md) | 7-step setup & v1→v2 upgrade playbook, safety rules, and verification checklist |
| [`repo-template/`](repo-template) | 1:1 target repo mirror: runtime `AGENTS.md`, `README.md`, deep `docs/`, `.coderabbit.yaml`, `.editorconfig`, community files, and `.github/` |
| [`stack-templates/`](stack-templates) | Conditional configs: `vercel.json` security headers, `render.yaml`, `playwright.config.ts` + `smoke.spec.ts` (E2E + WCAG AA a11y + viewport checks) |
| [`guidelines/commit-style.md`](guidelines/commit-style.md) | Emoji commit format: `<emoji> [#issue] [scope:] <present tense lowercase message>` |
| [`guidelines/dev-guidelines.md`](guidelines/dev-guidelines.md) | Engineering standards, reusable component layering (`ui/` vs `features/` vs `lib/`), PR rules, and git safety |
| [`guidelines/ui-guidelines.md`](guidelines/ui-guidelines.md) | Anti-AI-slop UI rules, mandatory 4-state UI contract, WCAG AA accessibility, and visual checks |
| [`guidelines/security-guidelines.md`](guidelines/security-guidelines.md) | Zod/Pydantic boundary validation, Auth/IDOR guards, server-only secrets, HMAC webhooks, SSRF, and LLM safety |
| [`guidelines/testing-guidelines.md`](guidelines/testing-guidelines.md) | 4-layer testing pyramid across Web/Playwright, Node/TS, Python, Go, Flutter/Dart, and CLIs |
| [`scripts/setup-github-repo.ps1`](scripts/setup-github-repo.ps1) | Sets metadata, squash-only merge rules, Secret Scanning + Push Protection, `Protect main` ruleset, labels, Secrets/Vars, and `Yantra [bot]` collaborator invite/accept |
| [`scripts/setup-vercel-project.ps1`](scripts/setup-vercel-project.ps1) | Auto-detects framework & Node version (incl. monorepo `RootDirectory`) and sets Vercel security, region (`bom1`), Fluid compute, and docs-ignore builds |
| [`scripts/setup-subdomain.ps1`](scripts/setup-subdomain.ps1) | Wires `<sub>.tanisheesh.in` on **Vercel**, **Render**, **Railway**, **GitHub Pages**, or **Custom** targets via host APIs + GoDaddy CNAME |

---

## Automated Quality, Security & Maintenance Loop

Every repo configured with [`repo-template/`](repo-template) gets:

- **Universal CI (`ci.yml`):** `CI_DIRS: "auto"` discovers single apps and monorepos (`backend/`, `frontend/`, `sdk/`, `collector/`, `proxy-go/`, `mobile/`, `electron/`, etc.) across **Node / pnpm (`v6` cache) / Bun**, **Python (`uv` / `ruff` / `mypy` / `pytest`)**, **Go (`go vet` / `go test -race` / `go build`)**, **Flutter/Dart (`flutter analyze` / `flutter test`)**, **Playwright E2E**, and **static HTML**.
- **Security Scanning:** `codeql.yml` (JS/TS, Python, Go), `secret-scan.yml` (Gitleaks v3), `dependency-review.yml` (high/critical CVEs + GPL-compatible license gate), plus GitHub Secret Scanning + Push Protection.
- **AI Review & Launch Demos:** `.coderabbit.yaml` enforces `AGENTS.md` + anti-slop rules on PRs (with optional `ai-review.yml` BYOK fallback for private repos and local `coderabbit review --agent` support), plus `/brag` launch video embedding under `README.md`'s `## Demo` section.
- **Custom-Branded Dependency Maintenance (`Yantra [bot]`):** Uses [`@tanisheesh-bot`](https://github.com/tanisheesh-bot) (`BOT_TOKEN`) + `.github/renovate.json` so PRs, commits, and the Contributors list display a cohesive avatar and `Yantra [bot]` identity instead of `dependabot[bot]`:

| When (IST) | What happens |
|---|---|
| Monday 06:00 | `renovate.yml` runs as `Yantra [bot]`, opening grouped minor/patch PRs (with 3-day release cooldown) and individual `major` + OSV security PRs |
| Monday 10:45 | Weekly scheduled CodeQL scan runs on `main` |
| On each PR | `ci.yml`, `codeql.yml`, `secret-scan.yml`, `dependency-review.yml`, and `labeler.yml` run |
| CI passes | `dependency-auto-merge.yml` squash-merges verified PRs as `Yantra [bot]` automatically |
| CI fails | PR stays open with `needs-review` label and comment |
| Monday 10:00 | `maintenance-report.yml` emails merged/open PRs, Dependabot alerts, CodeQL alerts, Secret Scanning alerts, and `main` CI health |

---

## Credentials & Manual Scripts

Copy [`.env.example`](.env.example) to `.env` (gitignored), fill in the tokens you use (`GITHUB_TOKEN`, `BOT_TOKEN`, `VERCEL_TOKEN`, `RENDER_API_KEY`, `GODADDY_KEY`, `MAIL_USERNAME`, `MAIL_PASSWORD`, `ALERTS_TOKEN`), and load `.env` into your PowerShell session before running scripts manually:

```powershell
Get-Content .\.env | Where-Object { $_ -match '^\s*([A-Z_]+)\s*=\s*(.+)$' } |
  ForEach-Object { [Environment]::SetEnvironmentVariable($Matches[1], $Matches[2].Trim(), 'Process') }

.\scripts\setup-github-repo.ps1 -Repo "my-app" `
  -Description "One-line pitch" -Homepage "https://myapp.tanisheesh.in" `
  -Topics "api-monitoring","llm-observability","opentelemetry","self-hosted","developer-tools","python-sdk"

.\scripts\setup-vercel-project.ps1 -Project "my-app" -RepoPath "..\my-app" -Region "bom1" -IgnoreDocsOnlyBuilds
.\scripts\setup-subdomain.ps1 -Subdomain "myapp" -Platform Vercel -VercelProject "my-app"
.\scripts\setup-subdomain.ps1 -Subdomain "myapp" -Platform Render -RenderHost "my-app.onrender.com"
.\scripts\setup-subdomain.ps1 -Subdomain "myapp" -Platform Railway -TargetHost "my-app.up.railway.app"
.\scripts\setup-subdomain.ps1 -Subdomain "myapp" -Platform GitHubPages
```

---

<div align="center">

<h3>Tanish Poddar</h3>

<a href="https://tanisheesh.in"><img src="https://img.shields.io/badge/Website-tanisheesh.in-111111?style=flat-square&logo=googlechrome&logoColor=white" alt="Website"></a>
<a href="https://linkedin.com/in/tanisheesh"><img src="https://img.shields.io/badge/LinkedIn-tanisheesh-0A66C2?style=flat-square" alt="LinkedIn"></a>
<a href="https://github.com/tanisheesh"><img src="https://img.shields.io/badge/GitHub-tanisheesh-181717?style=flat-square&logo=github&logoColor=white" alt="GitHub"></a>
<a href="mailto:hi@tanisheesh.in"><img src="https://img.shields.io/badge/Email-hi%40tanisheesh.in-EA4335?style=flat-square&logo=gmail&logoColor=white" alt="Email"></a>

</div>
