<div align="center">

<sub><b>TANISH'S SETUP TOOLKIT</b> · the standard for every repo by <a href="https://tanisheesh.in">Tanish Poddar</a></sub>

</div>

# AGENTS.md — Repo Setup Playbook

> **You are a coding agent.** The user has asked you to set up one of their portfolio repos using this toolkit.
> Read this whole file first, then follow the steps **in order**. Do not skip the "Ask the user" step.

---

## Toolkit layout

`<TOOLKIT>` = the folder containing this file. `<PROJECTS>` = its parent folder.
Resolve both to absolute paths before running anything.

```
<PROJECTS>/
  <TOOLKIT>/                              ← this toolkit (generic, no project data)
    AGENTS.md                             ← you are here
    docs-templates/
      readme.template.md                  → <repo>/README.md
      prd.template.md                     → <repo>/docs/PRD.md
      architecture.template.md            → <repo>/docs/ARCHITECTURE.md
      decisions.template.md               → <repo>/docs/DECISIONS.md
      setup.template.md                   → <repo>/docs/SETUP.md
    guidelines/
      commit-style.md                     ← commit message format (mandatory)
      dev-guidelines.md                   ← coding / git rules (mandatory)
    scripts/
      setup-github-repo.ps1               ← sets GitHub description, homepage, topics
      setup-subdomain.ps1                 ← adds <sub>.tanisheesh.in on Vercel/Render + GoDaddy CNAME
  _project-data/
    CREDENTIALS.env                       ← API tokens. SECRET (see Safety rules)
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

1. **Never print, log, echo, or commit any value from `CREDENTIALS.env`.** Don't `cat` it. Load it only with the snippet in Step 5.
2. **Never copy `CREDENTIALS.env` or `_project-data/` into a repo.** Make sure `.env*` is in the repo's `.gitignore` (except `.env.example`).
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

Also ask: *"Which steps do you want: docs / GitHub metadata / subdomain?"* If the user already said, skip asking.

## Step 3 — Write the docs

For each file in `docs-templates/`, copy it to its target path (see layout above) and fill it:

1. Replace every `{{PLACEHOLDER}}` with real values from Step 1–2.
2. Replace every `{{e.g. ...}}` hint with the repo's real content. Don't leave example text from the template.
3. **Delete all `<!-- ... -->` comments** in the final files (including the toolkit banner at the top).
   **Keep the author footer** (the centered "Tanish Poddar" block with Website / LinkedIn / GitHub / Email badges) at the bottom of every generated file, unchanged.
4. Delete sections that don't apply (e.g. "AI / LLM Design" if there's no LLM, "Traction" if no real numbers).
5. **README:**
   - Pick the logo from lucide.dev and inline its SVG paths. Keep only the stack badges that apply.
   - If `docs/assets/demo.gif` doesn't exist, remove the demo block and tell the user to record one.
   - Keep it short (~120 rendered lines max).
6. **SETUP.md:** the template links `infra/DEPLOY.md`. Instead, write the real deploy steps inline under "Deploy to production" (unless that file exists in the repo).
7. **DECISIONS.md / README "Engineering Decisions":** only real decisions visible in the code (e.g. a queue instead of cron, deterministic scoring instead of LLM). If you can't find the "why", ask the user. Never make one up.
8. If the repo has no `.env.example`, create one: variable **names** only, with empty values and a short comment on where to get each.
9. Make sure `.gitignore` covers `.env`, `.env.local`, `.env.*.local`.

## Step 4 — Commit (follow `guidelines/commit-style.md`)

Format: `<emoji> [#issue] [scope:] <present tense lowercase message>`

Make atomic commits, for example:

```
📚 docs: add prd, architecture, decisions and setup
📚 rewrite readme with standard template
🔨 add .env.example
🔒 gitignore env files
```

Don't push. Show the user `git log --oneline` of your new commits and wait for approval.

## Step 5 — GitHub metadata

Topics: 5–10, lowercase, hyphen-separated (e.g. `nextjs`, `typescript`, `llm`, `developer-tools`). Max 20.

Your shell does not keep env vars between commands, so **load credentials and run the script in the same command**:

```powershell
$cred = "<PROJECTS>\_project-data\CREDENTIALS.env"
Get-Content $cred | Where-Object { $_ -match '^\s*([A-Z_]+)\s*=\s*(.+)$' } |
  ForEach-Object { [Environment]::SetEnvironmentVariable($Matches[1], $Matches[2].Trim(), 'Process') }

& "<TOOLKIT>\scripts\setup-github-repo.ps1" `
  -Repo "<REPO_NAME>" `
  -Description "<ONE_LINE_DESCRIPTION>" `
  -Homepage "<LIVE_URL>" `
  -Topics "topic-1","topic-2","topic-3"
```

Description: ≤ 350 chars, same meaning as the README one-liner. Omit `-Homepage` if there's no live URL.

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

- [ ] `README.md` + `docs/PRD.md`, `ARCHITECTURE.md`, `DECISIONS.md`, `SETUP.md` exist, with no `{{` and no `<!--` left
  (`grep -rn "{{\|<!--" README.md docs/`)
- [ ] Every generated doc ends with the author footer (name, website, LinkedIn, GitHub, email)
- [ ] All README links resolve (docs files, live URL)
- [ ] `.env.example` present, `.gitignore` covers env files, no secrets in the diff (`git diff --cached`)
- [ ] Commits follow `guidelines/commit-style.md`, not pushed yet
- [ ] GitHub script output was all green (or errors reported verbatim)
- [ ] Subdomain script output was all green (or errors reported verbatim). DNS can take 2–10 min.
- [ ] List anything left for the user: demo GIF, traction numbers, unanswered questions

Report failures honestly with the exact error output. Don't mark a step done if it wasn't.

---

<div align="center">

<h3>Tanish Poddar</h3>

<a href="https://tanisheesh.in"><img src="https://img.shields.io/badge/Website-tanisheesh.in-111111?style=flat-square&logo=googlechrome&logoColor=white" alt="Website"></a>
<a href="https://linkedin.com/in/tanisheesh"><img src="https://img.shields.io/badge/LinkedIn-tanisheesh-0A66C2?style=flat-square" alt="LinkedIn"></a>
<a href="https://github.com/tanisheesh"><img src="https://img.shields.io/badge/GitHub-tanisheesh-181717?style=flat-square&logo=github&logoColor=white" alt="GitHub"></a>
<a href="mailto:hey@tanisheesh.in"><img src="https://img.shields.io/badge/Email-hey%40tanisheesh.in-EA4335?style=flat-square&logo=gmail&logoColor=white" alt="Email"></a>

</div>
