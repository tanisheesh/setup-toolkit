<div align="center">

<sub><b>TANISH'S SETUP TOOLKIT</b> · the standard for every repo by <a href="https://tanisheesh.in">Tanish Poddar</a></sub>

</div>

# AGENTS.md — Repo Setup Playbook

> **You are a coding agent.** The user has asked you to set up one of their portfolio repos using this toolkit.
> Read this whole file first, then follow the steps **in order**. Do not skip the "Ask the user" step.

---

## Toolkit layout

`<TOOLKIT>` = the folder containing this file. Resolve it to an absolute path before running anything.

```
<projects folder>/
  <TOOLKIT>/                              ← this toolkit (generic, no project data)
    AGENTS.md                             ← you are here (setup playbook)
    repo-template/                        ← mirrors a repo's layout: each file goes to the same path in <repo>
      AGENTS.md                           → <repo>/AGENTS.md (runtime code/UI/security/test rules)
      README.md                           → <repo>/README.md
      CONTRIBUTING.md                     → <repo>/CONTRIBUTING.md
      SECURITY.md                         → <repo>/SECURITY.md
      CODE_OF_CONDUCT.md                  → <repo>/CODE_OF_CONDUCT.md
      CHANGELOG.md                        → <repo>/CHANGELOG.md
      .editorconfig                       → <repo>/.editorconfig
      .coderabbit.yaml                    → <repo>/.coderabbit.yaml
      docs/
        PRD.md  ARCHITECTURE.md  DECISIONS.md  SETUP.md  DEPLOY.md
        USAGE.md                          ← only if repo exposes a CLI, SDK/package, or public API
      .github/
        CODEOWNERS
        labeler.yml
        PULL_REQUEST_TEMPLATE.md
        ISSUE_TEMPLATE/  bug_report.yml  feature_request.yml  config.yml
        FUNDING.yml                       ← only if the user has an active sponsor platform
        renovate.json                     ← weekly dependency + OSV security update rules
        workflows/
          ci.yml                          ← lint / format / typecheck / build / unit+E2E test
          codeql.yml                      ← SAST scanning (JS/TS + Python, free on public repos)
          dependency-review.yml           ← PR vulnerability & license gate
          secret-scan.yml                 ← Gitleaks secret detection
          labeler.yml                     ← auto-labels PRs by path
          release.yml                     ← tag-based GitHub Release notes
          ai-review.yml                   ← optional BYOK AI PR reviewer (disabled unless ENABLE_AI_REVIEW=true)
          renovate.yml                    ← runs Renovate with custom bot user (BOT_TOKEN)
          dependency-auto-merge.yml       ← merges Renovate PRs once CI is green
          maintenance-report.yml          ← emails a weekly report (Deps + CodeQL + Secrets + CI)
    stack-templates/                      ← conditional templates (copy only what matches the stack)
      vercel.json                         → <repo>/vercel.json (security headers)
      render.yaml                         → <repo>/render.yaml (Render blueprint)
      playwright.config.ts                → <repo>/playwright.config.ts
      smoke.spec.ts                       → <repo>/tests/e2e/smoke.spec.ts (E2E + a11y + overflow)
    guidelines/
      commit-style.md                     ← commit message format (mandatory)
      dev-guidelines.md                   ← engineering, reusability & git rules (mandatory)
      ui-guidelines.md                    ← anti-AI-slop UI & a11y rules (mandatory for UI)
      security-guidelines.md              ← app/API/LLM security rules (mandatory)
      testing-guidelines.md               ← 4-layer testing pyramid (mandatory)
    scripts/
      setup-github-repo.ps1               ← GitHub metadata, ruleset, labels, security, secrets
      setup-vercel-project.ps1            ← Vercel project runtime, security & region optimization
      setup-subdomain.ps1                 ← adds <sub>.tanisheesh.in on Vercel/Render + GoDaddy CNAME
    .env                                  ← real API tokens. SECRET, gitignored (see Safety rules)
    .env.example                          ← key names only
  <repo>/                                 ← the repo you are setting up
```

Fixed values (same for every repo):

| Key | Value |
|---|---|
| GitHub owner | `tanisheesh` |
| Root domain | `tanisheesh.in` |
| Author | Tanish Poddar |

---

## Safety rules (non-negotiable)

1. **Never print, log, echo, or commit any value from `<TOOLKIT>/.env`.** Don't `cat` it. Load it only with the snippet in Step 5.
2. **Never copy `<TOOLKIT>/.env` into a repo.** Make sure `.env*` is in the repo's `.gitignore` (except `.env.example`).
3. **Never invent facts in docs.** Every claim (stack, features, numbers, decisions) must come from the code, config, git history, or the user. If unknown, ask or leave the section out.
4. **Don't overwrite existing docs blindly.** If `README.md`, `AGENTS.md`, or `docs/*.md` already exist, merge useful existing content into the template structure. Never throw content away silently.
5. **Commit locally. Do not push** until the user approves.
6. **No force-push, no `git reset --hard` on `main`.**
7. **DNS changes need explicit user confirmation.** `setup-subdomain.ps1` overwrites any existing CNAME with the same name.

---

## Step 1 — Understand & audit the repo

Read before writing anything:

- `package.json` / `pyproject.toml` / `requirements.txt` / `go.mod` etc. → stack, scripts, test runner, linter
- Framework config (`next.config.*`, `vercel.json`, `render.yaml`, `Dockerfile`, `docker-compose.yml`) → hosting + infra + security headers
- DB schema (`prisma/schema.prisma`, Drizzle, migrations, SQL files) → data model + indexes
- API routes / handlers + UI components → check for:
  - **Code quality:** file sizes > 300 lines, `pages/` vs `app/`, dead code, `@ts-ignore`, empty `catch {}`
  - **Reusability:** duplicated UI/fetch blocks that belong in `components/ui/`, `hooks/`, or `lib/`
  - **UI slop (if frontend exists):** generic gradients/glows, emoji headings, fake stats, missing loading/empty/error states, broken mobile layout
  - **Security:** missing Zod/Pydantic validation, missing ownership/IDOR checks, `NEXT_PUBLIC_` secret leaks, unverified webhooks
  - **Testing:** existing unit/integration/E2E tests and gaps
- `.env.example` or `process.env.*` / `os.environ` usages → required env vars
- Any LLM calls → provider, model, prompts, response validation
- Existing `README.md` / `AGENTS.md` / docs → content to preserve
- `git log --oneline -30` → what was built and when

Note concrete code/security/UI/test issues you discover — report them clearly or fix high-signal gaps if the user asked for hardening.

## Step 2 — Collect values, then ask the user

Fill this table. Auto-detect what you can; **ask the user for everything still blank, in a single message.**

| Value | How to find it |
|---|---|
| `REPO_NAME` | git remote URL / folder name |
| `REPO_PROFILE` | `Portfolio` (public OSS/demo) · `Private Product` · `Client Website` · `OSS Package / CLI` |
| `PROJECT_NAME` | display name (README title / package name), confirm with user |
| `ONE_LINE_DESCRIPTION` | draft from code, confirm with user |
| `LIVE_URL` | existing README / `vercel.json` / `render.yaml` / user (or `N/A` if CLI/library/private) |
| `PLATFORM` | `Vercel` · `Render` · `Railway` · `GitHubPages` · `Custom` (Firebase/Streamlit) · or none |
| `SUBDOMAIN` | prefix before `.tanisheesh.in` (skip for client custom domains or undeployed). **Always ask, never guess** |
| `VERCEL_PROJECT` | Vercel project slug (if Vercel). **Ask** |
| `VERCEL_REGION` | `bom1` (default India) or co-located DB region (e.g. `iad1` / `sin1`) |
| `RENDER_HOST` | `<service>.onrender.com` (if Render). **Ask** |
| `TARGET_HOST` | `<id>.up.railway.app` / custom CNAME target (if Railway or Custom). **Ask** |
| `BRAND_COLOR` | hex. Take it from the app's theme/tailwind config if present, else ask |
| Demo credentials | only if the live app needs login. Ask |
| Traction numbers | **ask**. Leave the section out if there are none |
| Sponsor platform | **ask** (GitHub Sponsors / Buy Me a Coffee / Ko-fi / none) for `FUNDING.yml` |
| Strict ruleset? | default is PR-enforced with admin bypass; ask if user wants strict PR-only (`-StrictRuleset`) |

Also ask: *"Which steps should I run: docs & runtime AGENTS.md / GitHub metadata & scanning / Vercel settings / subdomain?"* If the user already said, skip asking.

### Repo Profiles (Adjust Standards by Type)

- **Portfolio (default public):** `GPL-3.0` badge allowed, `*.tanisheesh.in`, full docs + promo demo + CodeQL/Gitleaks.
- **Private Product:** Omit `GPL-3.0` badge; keep internal architecture/runbooks sharp; note CodeQL/Dependency Review skip unless GHAS is enabled; never expose stealth URLs/secrets.
- **Client Website:** Preserve client branding, custom client domain, and client license/copyright (do not force `GPL-3.0` or `*.tanisheesh.in`).
- **OSS Package / CLI:** Include `docs/USAGE.md` with install, flags/SDK signatures, and release workflow; omit UI-only sections if no frontend exists.

## Step 3 — Write the docs & runtime coding contract

Copy each file from `repo-template/` to the **same relative path** in the repo, then fill it (merging any useful facts from existing docs per Safety rule 4).

1. Replace every `{{PLACEHOLDER}}` with real values from Step 1–2.
2. Replace every `{{e.g. ...}}` hint with the repo's real content. Don't leave example text from the template.
3. **Delete all `<!-- ... -->` comments** in the final Markdown files (including the toolkit banner at the top).
   **Keep the author footer** (the centered "Tanish Poddar" block with Website / LinkedIn / GitHub / Email badges) at the bottom of every generated Markdown file, unchanged.
4. Delete sections that don't apply (e.g. "AI / LLM Design" if there's no LLM, "Traction" if no real numbers, "Demo" if no promo video exists yet).
5. **Ground every number in reality:** Extract concrete limits, timeouts, rate limits, schema constraints, token caps, test counts, and measured timings directly from code/configs/tests. Never invent fake benchmarks or user numbers; drop or ask about anything unverified.
6. **`AGENTS.md` (runtime):**
   - Keep `AGENTS.md` tailored to this repo's real stack (e.g. remove Python lines if pure TS, or TS/UI lines if pure Python CLI), and fill the exact `Verification Commands` (`lint`, `typecheck`, `build`, `test`) from `package.json` / `pyproject.toml`. (Do not create a separate `CLAUDE.md` in target repos — `AGENTS.md` is the single runtime contract.)
7. **README:**
   - Pick the logo from lucide.dev and inline its SVG paths. Keep only the stack badges that apply (including CI/CodeQL badges).
   - Keep it crisp and showcase-oriented (~130–160 rendered lines max; **no Quick Start / install walkthrough in `README.md`** — keep setup in `docs/SETUP.md` and end-user usage in `docs/USAGE.md`).
   - If the project has a UI / product demo, optionally generate a launch video with `/brag` (`brag-output/brag.mp4`) and embed it under **Demo** (recommended: drag-and-drop into GitHub to get a `user-attachments` inline video URL without bloating Git; or store a compact `< 5MB` `docs/assets/demo.mp4`). Otherwise drop the **Demo** section cleanly.
   - In the Docs table, keep only rows for files that exist.
8. **`docs/` depth (PRD, ARCHITECTURE, DECISIONS, SETUP, DEPLOY, optional USAGE):**
   - `PRD.md`: include quantified before/after baseline, Given/When/Then acceptance criteria, edge-case matrix, and unit economics/quota math.
   - `ARCHITECTURE.md`: include Mermaid diagrams (`flowchart`, `sequenceDiagram`, `erDiagram`), full API contracts, DB schema/indexes, caching/idempotency, LLM internals (if any), and 10x/100x scale ceilings.
   - `DECISIONS.md`: include side-by-side comparison tables and explicit reversal trigger thresholds.
   - `SETUP.md` & `DEPLOY.md`: include full env matrix, seed/test commands, troubleshooting matrix, live `curl` verification checks, zero-downtime migration notes, and incident playbooks.
   - `USAGE.md`: include **only** when the repo ships a CLI, SDK/library, or public API; delete it for standard web apps.
9. **CHANGELOG.md:** build the first entry from `git log --oneline` using the emoji → section map in its comment. Use version `1.0.0` and today's date unless tags exist.
10. **CONTRIBUTING.md / SECURITY.md / CODE_OF_CONDUCT.md:** fill placeholders (`project name`, `live URL`, real install/check commands, `.env` vs `.env.local`).
11. If the repo has no `.env.example`, create one: variable **names** only, with empty values and a short comment on where to get each.
12. Make sure `.gitignore` covers `.env`, `.env.local`, `.env.*.local`, and `brag-output/` (unless keeping raw `/brag` assets intentionally).

## Step 3b — GitHub automation & stack templates

### `repo-template/.github/` & `.coderabbit.yaml`

| File | Adjust |
|---|---|
| `.coderabbit.yaml`, `.github/CODEOWNERS`, `PULL_REQUEST_TEMPLATE.md`, `ISSUE_TEMPLATE/*` | nothing (remove irrelevant `path_instructions` only if needed) |
| `.github/labeler.yml` | adjust folder globs if repo uses non-standard dirs (e.g. `apps/web/**`, `apps/api/**`) |
| `.github/workflows/ci.yml` | `CI_DIRS: "auto"` auto-discovers Node/Bun/pnpm, Python, Go, Flutter, and monorepo subdirs (`backend`, `frontend`, `sdk`, `proxy-go`, etc.). Override `CI_DIRS` only if needed, and add dummy build-time `env:` values if the build requires them |
| `.github/workflows/codeql.yml`, `dependency-review.yml`, `secret-scan.yml`, `labeler.yml`, `release.yml`, `ai-review.yml` | auto-run on public repos; on private repos `setup-github-repo.ps1` sets `ENABLE_CODEQL` / `ENABLE_DEPENDENCY_REVIEW` if GHAS is enabled (otherwise report that they are unavailable). For org-owned repos, add `GITLEAKS_LICENSE` secret for `secret-scan.yml` |
| `.github/renovate.json`, `.github/workflows/renovate.yml` | nothing (auto-detects Node/Python/Docker/Actions; runs via `BOT_TOKEN` custom bot user). Remove any legacy `.github/dependabot.yml` or `.github/workflows/dependabot-auto-merge.yml` if present |
| `.github/workflows/dependency-auto-merge.yml` | nothing (`AUTO_MERGE_MAJOR: "true"` merges every update that passes CI) |
| `.github/workflows/maintenance-report.yml` | nothing. Email + alert secrets are set by `setup-github-repo.ps1` |
| `.github/FUNDING.yml` | **ask the user** which sponsor platform is active. If none, don't copy it |

Keep any repo-specific custom workflows (e.g. `bench.yml`, `release-sdk*.yml`) untouched unless they use deprecated Node 20 actions.

### `stack-templates/` (Conditional)

- **Vercel app without `vercel.json` or security headers in `next.config.*`:** copy `stack-templates/vercel.json` to `<repo>/vercel.json` (merge if `vercel.json` already exists).
- **Render service without `render.yaml`:** optionally copy and fill `stack-templates/render.yaml` if the user manages infra via Blueprint.
- **Web frontend without E2E tests:** propose/add `stack-templates/playwright.config.ts` → `<repo>/playwright.config.ts` and `stack-templates/smoke.spec.ts` → `<repo>/tests/e2e/smoke.spec.ts` (replacing `webServer.command` and checking dependencies `@playwright/test` + `@axe-core/playwright`).

**Before committing, make CI pass locally:** run the exact lint, format, typecheck, build, and test commands `ci.yml` would run. If `coderabbit` CLI is installed locally (`coderabbit --version`), optionally run `coderabbit review --agent --uncommitted` (or `--base main`) before opening a PR. If an existing check fails, report it honestly — never "fix" it by deleting tests or checks.

**Don't add a `LICENSE` file.** The user manages licensing (always GPL-3.0).

## Step 4 — Commit (follow `guidelines/commit-style.md`)

Format: `<emoji> [#issue] [scope:] <present tense lowercase message>`

Make atomic commits, for example:

```
📚 docs: add prd, architecture, decisions, setup and deploy
📚 rewrite readme with standard template
📚 add runtime agents.md, contributing, security, code of conduct and changelog
🔨 add pr, issue templates, codeowners, coderabbit and editorconfig
👷 add ci, codeql, secret-scan, dependency-review, labeler, renovate and maintenance report
🧪 add playwright smoke and a11y baseline
🔨 add .env.example and security headers config
🔒 gitignore env files
```

Don't push. Show the user `git log --oneline` of your new commits and wait for approval.

## Step 5 — GitHub metadata, security & rulesets

**High-Intent Topics (8–12 tags, max 20):** Pick topics that bring actual users, developers, and traffic — **NEVER** use generic stack spam (`nextjs`, `react`, `typescript`, `javascript`, `tailwindcss`, `html`, `css`, `nodejs`, `python`, `frontend`, `backend`, `fullstack`, `web-app`, `website`, `portfolio`, `project`, `ai`).

Build topics from **4 buckets** and verify exact GitHub `curated` / `featured` spelling via `gh api "search/topics?q=<keyword>"` first:

1. **Exact Problem / Use-Case (3–4):** what users search to solve a problem (`api-monitoring`, `llm-observability`, `image-forensics`, `digital-twin`, `ai-code-review`, `mock-interview`, `flood-forecasting`).
2. **GitHub Curated Discovery Hubs (2–3):** high-traffic curated pages (`self-hosted`, `developer-tools`, `code-quality`, `code-review`, `ai-agent`, `agentic-ai`, `generative-ai`, `claude-code`, `devsecops`, `computer-vision`, `automation`).
3. **Delivery Form / Buyer Intent (1–2):** how people consume it (`cli-tool`, `python-sdk`, `npm-package`, `github-app`, `telegram-bot`, `desktop-app`, `mobile-app`, `local-first`, `repository-template`).
4. **Specialized Engine / Protocol ONLY (1–2):** niche searchable tech (`opentelemetry`, `esp32`, `lorawan`, `mediapipe`, `lightgbm`, `sentinel-2`, `webgl`, `cadquery`, `mcp`, `playwright`).

Your shell does not keep env vars between commands, so **load credentials and run the script in the same command**:

```powershell
$cred = "<TOOLKIT>\.env"
Get-Content $cred | Where-Object { $_ -match '^\s*([A-Z_]+)\s*=\s*(.+)$' } |
  ForEach-Object { [Environment]::SetEnvironmentVariable($Matches[1], $Matches[2].Trim(), 'Process') }

& "<TOOLKIT>\scripts\setup-github-repo.ps1" `
  -Repo "<REPO_NAME>" `
  -Description "<ONE_LINE_DESCRIPTION>" `
  -Homepage "<LIVE_URL>" `
  -Topics "problem-tag","use-case","curated-hub","delivery-form","niche-engine"
```

Add `-StrictRuleset` if the user wants strict PR-only merges without admin bypass. Omit `-Homepage` if there's no live URL.

The script configures:
- Description, homepage, topics, squash-only merge, auto-delete head branches, wiki off
- Dependabot alerts, private vulnerability reporting, Secret Scanning + Push Protection (and disables `dependabot[bot]` PRs when `BOT_TOKEN` is set so Renovate's custom bot handles updates cleanly)
- `"Protect main"` branch ruleset (`ci` required, linear history, no force-push/deletion)
- Standard labels + `MAIL_USERNAME`, `MAIL_PASSWORD`, `ALERTS_TOKEN`, `BOT_TOKEN`, `BOT_USERNAME` (plus optional `REPORT_EMAIL` / AI keys if filled in `.env`) and auto-invites/accepts the bot collaborator

Run this **after** the user has pushed, since the repo must exist on GitHub.

## Step 6 — Vercel settings & Subdomain (only if deployed AND user confirmed values)

Load credentials exactly as in Step 5, then run:

```powershell
# If deployed on Vercel — optimize runtime, security & region settings
& "<TOOLKIT>\scripts\setup-vercel-project.ps1" `
  -Project "<VERCEL_PROJECT>" `
  -RepoPath "<REPO_PATH>" `
  -Region "<VERCEL_REGION>" `
  -IgnoreDocsOnlyBuilds

# Subdomain CNAME wiring (Vercel / Render / Railway / GitHubPages / Custom)
& "<TOOLKIT>\scripts\setup-subdomain.ps1" -Subdomain "<SUBDOMAIN>" -Platform Vercel -VercelProject "<VERCEL_PROJECT>"
# OR
& "<TOOLKIT>\scripts\setup-subdomain.ps1" -Subdomain "<SUBDOMAIN>" -Platform Render -RenderHost "<RENDER_HOST>"
# OR
& "<TOOLKIT>\scripts\setup-subdomain.ps1" -Subdomain "<SUBDOMAIN>" -Platform Railway -TargetHost "<RAILWAY_HOST>"
# OR
& "<TOOLKIT>\scripts\setup-subdomain.ps1" -Subdomain "<SUBDOMAIN>" -Platform GitHubPages
# OR
& "<TOOLKIT>\scripts\setup-subdomain.ps1" -Subdomain "<SUBDOMAIN>" -Platform Custom -TargetHost "<CUSTOM_TARGET>"
```

If a credential is missing (and no local CLI fallback exists), **stop and tell the user which key is missing** instead of hanging.

## Step 7 — Verify and report

Check, then report to the user as a checklist:

- [ ] `README.md`, `AGENTS.md`, `CONTRIBUTING.md`, `SECURITY.md`, `CODE_OF_CONDUCT.md`, `CHANGELOG.md` and `docs/PRD.md`, `ARCHITECTURE.md`, `DECISIONS.md`, `SETUP.md`, `DEPLOY.md` (plus `USAGE.md` if CLI/SDK/API) exist, with no `{{` and no `<!--` left
  (`grep -rn "{{\|<!--" *.md docs/`)
- [ ] Every generated Markdown doc ends with the author footer (name, website, LinkedIn, GitHub, email)
- [ ] `.coderabbit.yaml`, `.editorconfig`, `.github/CODEOWNERS`, `labeler.yml`, PR/issue templates, `renovate.json`, and workflows (`ci`, `codeql`, `dependency-review`, `secret-scan`, `labeler`, `release`, `renovate`, `dependency-auto-merge`, `maintenance-report`) are configured
- [ ] CI + test + security checks pass locally (or failures reported honestly to the user)
- [ ] After push: CI, CodeQL, and Secret Scan are green on GitHub, and a manual run of "Maintenance report" succeeds
- [ ] All README links resolve (docs files, live URL)
- [ ] `.env.example` present, `.gitignore` covers env files, no secrets in `git diff --cached`
- [ ] Commits follow `guidelines/commit-style.md`, not pushed yet
- [ ] `setup-github-repo.ps1`, `setup-vercel-project.ps1` (if Vercel), and `setup-subdomain.ps1` output reported verbatim
- [ ] List anything left for the user: CodeRabbit app install (if first repo), traction numbers, sponsor platform, missing mail/alert secrets, or code/UI/test gaps discovered in Step 1

Report failures honestly with the exact error output. Don't mark a step done if it wasn't.

---

<div align="center">

<h3>Tanish Poddar</h3>

<a href="https://tanisheesh.in"><img src="https://img.shields.io/badge/Website-tanisheesh.in-111111?style=flat-square&logo=googlechrome&logoColor=white" alt="Website"></a>
<a href="https://linkedin.com/in/tanisheesh"><img src="https://img.shields.io/badge/LinkedIn-tanisheesh-0A66C2?style=flat-square" alt="LinkedIn"></a>
<a href="https://github.com/tanisheesh"><img src="https://img.shields.io/badge/GitHub-tanisheesh-181717?style=flat-square&logo=github&logoColor=white" alt="GitHub"></a>
<a href="mailto:hi@tanisheesh.in"><img src="https://img.shields.io/badge/Email-hi%40tanisheesh.in-EA4335?style=flat-square&logo=gmail&logoColor=white" alt="Email"></a>

</div>
