<div align="center">

<sub><b>TANISH'S SETUP TOOLKIT</b> · the standard for every repo by <a href="https://tanisheesh.in">Tanish Poddar</a></sub>

</div>

# 📔 Developer Guidelines

Standard rules for every repo. Follow them unless the repo's own docs say otherwise.

## Definition of Done

A task is `Done` only when it is:

1. Running in production (live URL works)
2. Tested on the real deployment, not just locally
3. Documented. README / `docs/` are updated if behaviour, setup, or env vars changed

## Commits

1. Split work into meaningful atomic commits, one unit of logic each. Avoid giant "update" commits.
2. Commit messages follow [commit-style.md](commit-style.md).
3. Never commit secrets. `.env*` files stay gitignored; ship a `.env.example` with variable names only.

## Code Style

1. Run the project's formatter/linter before pushing (if the project has one).
2. No dead code, debug logs, or changes unrelated to the task.
3. Follow the existing file structure and code patterns of the repo.
4. TypeScript/JavaScript:
   - File names in `kebab-case` unless a framework convention requires otherwise.
   - Variables and functions in `camelCase`.
   - Next.js: use the App Router (`app/`). Don't add new code to the `pages/` directory; migrate the page first.
5. Python: `snake_case` for files, functions, and variables; `PascalCase` for classes.

## Branches & Pull Requests

1. `main` is always deployable. Do larger work on a branch and merge via PR.
2. Keep docs and example files in the same PR as the code they describe.
3. Before merging: build passes, linter passes, feature works on the preview deployment.

## Git Safety

> ⚠️ **No force-push or `git reset --hard` on `main`.** Free to do so on your own feature branches.

> ⚠️ **Rollbacks:** when rolling back on Vercel / Render / any host, note it in the commit or PR so the next deploy doesn't silently re-ship the broken version.

---

<div align="center">

<h3>Tanish Poddar</h3>

<a href="https://tanisheesh.in"><img src="https://img.shields.io/badge/Website-tanisheesh.in-111111?style=flat-square&logo=googlechrome&logoColor=white" alt="Website"></a>
<a href="https://linkedin.com/in/tanisheesh"><img src="https://img.shields.io/badge/LinkedIn-tanisheesh-0A66C2?style=flat-square" alt="LinkedIn"></a>
<a href="https://github.com/tanisheesh"><img src="https://img.shields.io/badge/GitHub-tanisheesh-181717?style=flat-square&logo=github&logoColor=white" alt="GitHub"></a>
<a href="mailto:hi@tanisheesh.in"><img src="https://img.shields.io/badge/Email-hey%40tanisheesh.in-EA4335?style=flat-square&logo=gmail&logoColor=white" alt="Email"></a>

</div>
