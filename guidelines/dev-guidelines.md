<div align="center">

<sub><b>TANISH'S SETUP TOOLKIT</b> · the standard for every repo by <a href="https://tanisheesh.in">Tanish Poddar</a></sub>

</div>

# 📔 Developer Guidelines

Standard engineering, architecture, and git rules for every repo. Follow them unless a repo's own `AGENTS.md` adds stricter project-specific rules.

---

## 1. Definition of Done

A task is `Done` only when **all** of these are true:

1. **Running in production** (or built and ready if it's a library/CLI).
2. **Verified end-to-end** on the real deployment or preview — not just `localhost`.
3. **All checks pass:** formatter, linter, typechecker, build, and automated tests (see [testing-guidelines.md](testing-guidelines.md)).
4. **Peripheral files updated in the same PR:** README, `docs/`, `.env.example`, schemas, and tests that belong to the change.

---

## 2. Change Categories & Review Discipline

| Category | Examples | Minimum Bar |
|---|---|---|
| **Core infra / auth / billing / DB** | Auth flows, webhooks, migrations, API gateways, shared libs | Strict commit style, unit + integration tests, CodeQL + security checklist review |
| **Product features & UI** | App Router pages, reusable components, forms, charts | Anti-slop UI check ([ui-guidelines.md](ui-guidelines.md)), 4 UI states, Playwright/a11y check |
| **Non-core / one-off scripts** | Event microsites, admin utilities, seeders | Clean modular code, no committed secrets, smoke-tested |

- **Peripheral Files Rule:** Keep docs, `.env.example`, and tests in the **same PR** as the code they describe. Never leave documentation "for later."
- **API & App Boundaries:**
  - Prefer dedicated focused services (`api-*`) over turning one legacy `api` monolith into a kitchen sink.
  - **Next.js:** Always use the **App Router (`app/`)**. Never add new features to `pages/` — migrate the route to `app/` first.

---

## 3. Code Style & File Structure

1. **Zero noise:** No dead code, commented-out blocks, unused imports, or stray `console.log` / `print` statements.
2. **File size limit:** Keep files focused and under **~300 lines**. Split growing files into cohesive modules (`components/`, `hooks/`, `lib/`, `server/`).
3. **File naming:**
   - **TypeScript / JavaScript:** `kebab-case` (`user-profile.ts`, `use-debounce.ts`, `auth-guard.tsx`), unless a framework explicitly requires otherwise (`page.tsx`, `layout.tsx`, `route.ts`).
   - **Python:** `snake_case` for files, functions, and variables; `PascalCase` for classes.
4. **TypeScript / JavaScript rules:**
   - Variables and functions in `camelCase`; React components and types/interfaces in `PascalCase`.
   - Use **strict equality** (`===` / `!==`), never loose equality (`==` / `!=`).
   - Prefer `async/await` over raw `.then()` promise chains or nested callbacks.
   - Prefer standalone `function` declarations with **named exports at definition** (`export async function ...`). Only use `export default` where the framework requires it (`page.tsx`, `layout.tsx`, `next.config.*`).
   - Prefer `if/else` early returns and object lookup maps over sprawling `switch` blocks or deep nesting.
   - Use `for...of` for async iteration or early exit; avoid `Array.prototype.forEach()` for async work.
   - **No type-escape hatches:** Never use `@ts-ignore`, `@ts-expect-error`, or `@ts-nocheck`. Avoid `any` — use `unknown` + Zod/type-guard narrowing.
   - **Error handling:** Never swallow errors with empty `catch {}` blocks. Let pure helpers throw descriptive errors; catch at API/I/O/UI boundaries to map to clean HTTP status codes, logs, and user-safe states.
5. **Comments:** Explain *why* (invariants, edge cases, external constraints), never *what*. Keep inline comments concise; use docstrings/JSDoc on exported public modules and complex contracts.

---

## 4. Reusable Component & Module Architecture

Organize code by responsibility so UI, state, and business logic stay decoupled and reusable:

```text
src/
  components/
    ui/            # Pure, domain-agnostic primitives (Button, Badge, Modal, EmptyState, DataTable)
    features/      # Domain components composed from ui/ primitives — no raw fetch() inside JSX
  hooks/           # Reusable client hooks (data fetching, form state, media queries)
  lib/             # Pure business logic, Zod/Pydantic schemas, formatters, DB/API clients
  app/ (or routes) # Thin route handlers & pages: validate input -> call lib/ -> return response
```

- **Rule of Two:** If a UI block, badge map, formatter, or fetch wrapper appears in 2+ places, extract it into a shared component or helper.
- **Props composition over flag soup:** Compose via `children`, slots, and `variant`/`size` maps (`cva` / Tailwind) instead of adding 8 boolean mode flags to one component.
- **Single source of truth for types:** Derive TS types from Zod / Prisma / Drizzle / Pydantic schemas (`z.infer<typeof ...>`) rather than duplicating manual interfaces.

---

## 5. Commits, Branches & Pull Requests

1. **Atomic commits:** Split work into logical, reviewable units following [commit-style.md](commit-style.md). Avoid giant `"update"` commits.
2. **Secrets stay out of Git:** Never commit `.env*` files. Every new env var goes into `.env.example` with an empty value and source comment.
3. **`main` is always deployable:** Do larger features/refactors on `feat/`, `fix/`, `refactor/`, `docs/`, `chore/`, or `test/` branches and merge via PR.
4. **PR hygiene:** Use plain-English **past-tense** PR titles (no emojis/issue hashes in PR titles), check off the PR template, and ensure CI + CodeQL + Dependency Review + tests pass before merging.

---

## 6. Git & Production Safety

> ⚠️ **No force-push or `git reset --hard` on `main`.** Use feature branches/forks for history rewrites.

> ⚠️ **Rollbacks:** When rolling back on Vercel, Render, or any host, immediately record the rollback reason and target SHA in a commit or PR so the next push does not silently re-ship the broken build.

---

<div align="center">

<h3>Tanish Poddar</h3>

<a href="https://tanisheesh.in"><img src="https://img.shields.io/badge/Website-tanisheesh.in-111111?style=flat-square&logo=googlechrome&logoColor=white" alt="Website"></a>
<a href="https://linkedin.com/in/tanisheesh"><img src="https://img.shields.io/badge/LinkedIn-tanisheesh-0A66C2?style=flat-square" alt="LinkedIn"></a>
<a href="https://github.com/tanisheesh"><img src="https://img.shields.io/badge/GitHub-tanisheesh-181717?style=flat-square&logo=github&logoColor=white" alt="GitHub"></a>
<a href="mailto:hi@tanisheesh.in"><img src="https://img.shields.io/badge/Email-hi%40tanisheesh.in-EA4335?style=flat-square&logo=gmail&logoColor=white" alt="Email"></a>

</div>
