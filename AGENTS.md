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
    AGENTS.md                             ← you are here
    repo-template/                        ← mirrors a repo's layout: each file goes to the same path in <repo>
      README.md                           → <repo>/README.md
      CONTRIBUTING.md                     → <repo>/CONTRIBUTING.md
      SECURITY.md                         → <repo>/SECURITY.md
      CODE_OF_CONDUCT.md                  → <repo>/CODE_OF_CONDUCT.md
      CHANGELOG.md                        → <repo>/CHANGELOG.md
      .editorconfig                       → <repo>/.editorconfig
      docs/
        PRD.md  ARCHITECTURE.md  DECISIONS.md  SETUP.md  DEPLOY.md
      .github/
        PULL_REQUEST_TEMPLATE.md
        ISSUE_TEMPLATE/  bug_report.yml  feature_request.yml  config.yml
        FUNDING.yml                       ← only if the user has an active sponsor platform
        dependabot.yml                    ← weekly dependency updates
        workflows/
          ci.yml                          ← lint / typecheck / build / test (auto-detects stack)
          dependabot-auto-merge.yml       ← merges Dependabot PRs once CI is green
          maintenance-report.yml          ← emails a weekly report
    guidelines/
      commit-style.md                     ← commit message format (mandatory)
      dev-guidelines.md                   ← coding / git rules (mandatory)
    scripts/
      setup-github-repo.ps1               ← sets GitHub description, homepage, topics
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
4. **Don't overwrite existing docs blindly.** If `README.md` or `docs/*.md` already exist, merge useful existing content into the template structure. Never throw content away silently.
5. **Commit locally. Do not push** until the user approves.
6. **No force-push, no `git reset --hard` on `main`.**
7. **DNS changes need explicit user confirmation.** `setup-subdomain.ps1` overwrites any existing CNAME with the same name.

---

## Step 1 — Understand the repo

Read before writing anything:

- `package.json` / `pyproject.toml` / `requirements.txt` / `go.mod` etc. → stack + versions
- Framework config (`next.config.*`, `vercel.json`, `render.yaml`, `Dockerfile`, `docker-compose.yml`) → hosting + infra
- DB schema (`prisma/schema.prisma`, migrations, SQL files) → data model
- API routes / handlers → main endpoints
- `.env.example` or `process.env.*` / `os.environ` usages → required env vars
- Any LLM calls → provider, model, prompts, response validation
- Existing README / docs → content to preserve
- `git log --oneline -30` → what was built and when

## Step 2 — Collect values, then ask the user

Fill this table. Auto-detect what you can; **ask the user for everything still blank, in a single message.**

| Value | How to find it |
|---|---|
| `REPO_NAME` | git remote URL / folder name |
| `PROJECT_NAME` | display name (README title / package name), confirm with user |
| `ONE_LINE_DESCRIPTION` | draft from code, confirm with user |
| `LIVE_URL` | existing README / `vercel.json` / user. Usually `https://<sub>.tanisheesh.in` |
| `PLATFORM` | `Vercel` or `Render` (or none if not deployed) |
| `SUBDOMAIN` | prefix before `.tanisheesh.in`. **Always ask, never guess** |
| `VERCEL_PROJECT` | Vercel project slug (if Vercel). **Ask** |
| `RENDER_HOST` | `<service>.onrender.com` (if Render). **Ask** |
| `BRAND_COLOR` | hex. Take it from the app's theme/tailwind config if present, else ask |
| Demo credentials | only if the live app needs login. Ask |
| Traction numbers | **ask**. Leave the section out if there are none |
| Sponsor platform | **ask** (GitHub Sponsors / Buy Me a Coffee / Ko-fi / none) for `FUNDING.yml` |

Also ask: *"Which steps do you want: docs / GitHub metadata / subdomain?"* If the user already said, skip asking.

## Step 3 — Write the docs

Copy each file from `repo-template/` to the **same relative path** in the repo, then fill it. (Each template also explains itself in its top comment, so it can be used by hand without this playbook.)

1. Replace every `{{PLACEHOLDER}}` with real values from Step 1–2.
2. Replace every `{{e.g. ...}}` hint with the repo's real content. Don't leave example text from the template.
3. **Delete all `<!-- ... -->` comments** in the final files (including the toolkit banner at the top).
   **Keep the author footer** (the centered "Tanish Poddar" block with Website / LinkedIn / GitHub / Email badges) at the bottom of every generated file, unchanged.
4. Delete sections that don't apply (e.g. "AI / LLM Design" if there's no LLM, "Traction" if no real numbers).
5. **README:**
   - Pick the logo from lucide.dev and inline its SVG paths. Keep only the stack badges that apply.
   - Keep it short (~120 rendered lines max). In the Docs table, keep only rows for files that exist.
6. **docs/DEPLOY.md:** keep only the platform section(s) the repo actually uses (Vercel / Render / Docker).
7. **DECISIONS.md / README "Engineering Decisions":** only real decisions visible in the code (e.g. a queue instead of cron, deterministic scoring instead of LLM). If you can't find the "why", ask the user. Never make one up.
8. **CHANGELOG.md:** build the first entry from `git log --oneline` using the emoji → section map in its comment. Use version `1.0.0` and today's date unless tags exist.
9. **CONTRIBUTING.md / SECURITY.md / CODE_OF_CONDUCT.md:** fill placeholders (project name, live URL, real install/check commands from `package.json` / `pyproject.toml`). Keep the scope list in SECURITY.md honest for this repo.
10. If the repo has no `.env.example`, create one: variable **names** only, with empty values and a short comment on where to get each.
11. Make sure `.gitignore` covers `.env`, `.env.local`, `.env.*.local`.

## Step 3b — GitHub automation files

These work as-is; only adjust what's listed:

| File | Adjust |
|---|---|
| `.github/PULL_REQUEST_TEMPLATE.md`, `ISSUE_TEMPLATE/*` | nothing |
| `.github/workflows/ci.yml` | `CI_DIRS` if the code isn't at the root (e.g. `". backend frontend"`). Add placeholder `env:` values if the build reads env vars at build time. |
| `.github/dependabot.yml` | uncomment the ecosystems this repo uses (`npm` / `pip` or `uv` / `docker`), one block per folder with a manifest. Keep `github-actions`. |
| `.github/workflows/dependabot-auto-merge.yml` | nothing (`AUTO_MERGE_MAJOR: "true"` merges every update that passes CI) |
| `.github/workflows/maintenance-report.yml` | nothing. Email secrets are set by `setup-github-repo.ps1` in Step 5 |
| `.github/FUNDING.yml` | **ask the user** which sponsor platform is active. If none, don't copy it |

**Before committing, make CI pass locally:** run the same lint/typecheck/build/test commands `ci.yml` would run. If a check fails on the existing code, tell the user. Don't "fix" it by deleting the check.

**Don't add a `LICENSE` file.** The user manages licensing (always GPL-3.0).

## Step 4 — Commit (follow `guidelines/commit-style.md`)

Format: `<emoji> [#issue] [scope:] <present tense lowercase message>`

Make atomic commits, for example:

```
📚 docs: add prd, architecture, decisions, setup and deploy
📚 rewrite readme with standard template
📚 add contributing, security, code of conduct and changelog
🔨 add pr and issue templates, editorconfig
👷 add ci, dependabot, auto-merge and weekly maintenance report
🔨 add .env.example
🔒 gitignore env files
```

Don't push. Show the user `git log --oneline` of your new commits and wait for approval.

## Step 5 — GitHub metadata

Topics: 5–10, lowercase, hyphen-separated (e.g. `nextjs`, `typescript`, `llm`, `developer-tools`). Max 20.

Your shell does not keep env vars between commands, so **load credentials and run the script in the same command**:

```powershell
$cred = "<TOOLKIT>\.env"
Get-Content $cred | Where-Object { $_ -match '^\s*([A-Z_]+)\s*=\s*(.+)$' } |
  ForEach-Object { [Environment]::SetEnvironmentVariable($Matches[1], $Matches[2].Trim(), 'Process') }

& "<TOOLKIT>\scripts\setup-github-repo.ps1" `
  -Repo "<REPO_NAME>" `
  -Description "<ONE_LINE_DESCRIPTION>" `
  -Homepage "<LIVE_URL>" `
  -Topics "topic-1","topic-2","topic-3"
```

Description: ≤ 350 chars, same meaning as the README one-liner. Omit `-Homepage` if there's no live URL.

The script also enables Dependabot alerts, Dependabot security updates and private vulnerability reporting. It then sets the `MAIL_USERNAME`, `MAIL_PASSWORD` and `ALERTS_TOKEN` repo secrets for the weekly email report, using whichever of them are filled in `<TOOLKIT>/.env` (needs `gh`). If the mail secrets are missing, tell the user the report will only appear on the Actions Summary page until they add them.

Run this **after** the user has pushed, since the repo must exist on GitHub.

## Step 6 — Subdomain (only if deployed AND user confirmed the values)

Load credentials exactly as in Step 5 (same command), then run **one** of:

```powershell
# Vercel
& "<TOOLKIT>\scripts\setup-subdomain.ps1" -Subdomain "<SUBDOMAIN>" -Platform Vercel -VercelProject "<VERCEL_PROJECT>"

# Render
& "<TOOLKIT>\scripts\setup-subdomain.ps1" -Subdomain "<SUBDOMAIN>" -Platform Render -RenderHost "<RENDER_HOST>"
```

If a credential is missing from the file, the script will try to prompt and hang in a non-interactive shell. **Stop and tell the user which key is missing** instead.

## Step 7 — Verify and report

Check, then report to the user as a checklist:

- [ ] `README.md`, `CONTRIBUTING.md`, `SECURITY.md`, `CODE_OF_CONDUCT.md`, `CHANGELOG.md` and `docs/PRD.md`, `ARCHITECTURE.md`, `DECISIONS.md`, `SETUP.md`, `DEPLOY.md` exist, with no `{{` and no `<!--` left
  (`grep -rn "{{\|<!--" *.md docs/`)
- [ ] Every generated doc ends with the author footer (name, website, LinkedIn, GitHub, email)
- [ ] `.github/` has the PR template, issue forms, `dependabot.yml` (right ecosystems uncommented) and the 3 workflows; `.editorconfig` at root
- [ ] CI commands pass locally (or failures reported to the user)
- [ ] After push: CI is green on GitHub, and a manual run of "Maintenance report" (Actions → Run workflow) succeeds
- [ ] All README links resolve (docs files, live URL)
- [ ] `.env.example` present, `.gitignore` covers env files, no secrets in the diff (`git diff --cached`)
- [ ] Commits follow `guidelines/commit-style.md`, not pushed yet
- [ ] GitHub script output was all green (or errors reported verbatim)
- [ ] Subdomain script output was all green (or errors reported verbatim). DNS can take 2–10 min.
- [ ] List anything left for the user: traction numbers, sponsor platform, missing mail secrets, unanswered questions

Report failures honestly with the exact error output. Don't mark a step done if it wasn't.

---

<div align="center">

<h3>Tanish Poddar</h3>

<a href="https://tanisheesh.in"><img src="https://img.shields.io/badge/Website-tanisheesh.in-111111?style=flat-square&logo=googlechrome&logoColor=white" alt="Website"></a>
<a href="https://linkedin.com/in/tanisheesh"><img src="https://img.shields.io/badge/LinkedIn-tanisheesh-0A66C2?style=flat-square" alt="LinkedIn"></a>
<a href="https://github.com/tanisheesh"><img src="https://img.shields.io/badge/GitHub-tanisheesh-181717?style=flat-square&logo=github&logoColor=white" alt="GitHub"></a>
<a href="mailto:hey@tanisheesh.in"><img src="https://img.shields.io/badge/Email-hey%40tanisheesh.in-EA4335?style=flat-square&logo=gmail&logoColor=white" alt="Email"></a>

</div>
