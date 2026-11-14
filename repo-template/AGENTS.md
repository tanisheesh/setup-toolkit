<!--
  ╔══════════════════════════════════════════════════════════════╗
  ║  TANISH'S SETUP TOOLKIT · template · tanisheesh.in            ║
  ║  Keep the author footer at the bottom of the generated file.  ║
  ╚══════════════════════════════════════════════════════════════╝

  RUNTIME AGENT CONTRACT
  Goes to: <repo>/AGENTS.md
  How to fill: replace every {{PLACEHOLDER}} with real stack commands
  and paths from this repo, remove inapplicable language subsections,
  then delete these comments.
-->

# {{PROJECT_NAME}} — Agent Development Guidelines

Follow these rules strictly on every file you create or modify in **{{PROJECT_NAME}}**.

---

## 1. File Organization & Architecture

- **File naming:**
  - {{TypeScript/JavaScript: ALWAYS use `kebab-case` (`user-profile.ts`, `use-debounce.ts`), except framework-required files (`page.tsx`, `layout.tsx`, `route.ts`).}}
  - {{Python: ALWAYS use `snake_case` for modules/functions/variables and `PascalCase` for classes.}}
- **File size limit:** Keep files focused and **under 300 lines**. When approaching 300 lines, split into cohesive modules.
- **Layered separation:**
  - `components/ui/` — pure, domain-agnostic UI primitives (`Button`, `Badge`, `Card`, `EmptyState`, `ErrorBanner`). No `fetch()` or business logic inside `ui/`.
  - `components/features/` — domain UI composed from `ui/` primitives.
  - `hooks/` — reusable client hooks.
  - `lib/` / `server/` — pure business logic, validation schemas, DB/API clients.
  - Route handlers / pages stay thin: validate input → call `lib/`/`server/` → return response.
- **Reusability (Rule of Two):** Extract any repeated UI pattern, helper, or fetch logic used 2+ times into a shared primitive/module. Prefer props composition over boolean flag explosion.
- **App Router only (Next.js):** Never add or expand routes in `pages/`. Always use `app/`.

---

## 2. Code Style & Strictness

- **No dead code or debug clutter:** Never leave unused imports, commented-out blocks, or stray `console.log` / `print` statements.
- **Named exports at definition:** Prefer `export async function foo()` / `export function bar()` at definition point. Only use `export default` where the framework requires it (`page.tsx`, `layout.tsx`, `next.config.*`).
- **Control flow & async:** Use `async/await` (no raw `.then()` chains or nested callbacks). Prefer early returns with `if/else` and lookup objects over sprawling `switch` blocks. Use `for...of` for async iteration (`Array.prototype.forEach` does not await).
- **Strict equality:** Always use `===` and `!==` (never `==` / `!=`).
- **Type safety:** NEVER use `@ts-ignore`, `@ts-expect-error`, or `@ts-nocheck`. Avoid `any` — use `unknown` + Zod/type-guard narrowing. Derive types from Zod/Prisma/Pydantic schemas instead of duplicating interfaces.
- **Error handling:** Let pure helpers throw descriptive `Error` instances. Catch explicitly at API, I/O, LLM, and UI boundaries — NEVER leave empty or silent `catch {}` blocks.
- **Directives first:** In Next.js/React files needing `'use client'` or `'use server'`, put the directive on **line 1** before any imports or comments.

---

## 3. UI Craft & Anti-AI-Slop Rules

- **Banned clichés:**
  - No generic purple/indigo/pink linear gradients, neon box-shadow glows, or rainbow badge spam.
  - No cookie-cutter 3-column icon-in-circle marketing grids inside dashboards or utilities.
  - No emoji-prefixed app UI headings (`🚀`, `✨`), hype copy (*"Supercharge..."*), or hardcoded fake stats (`+142%`).
  - No dead buttons (`onClick={() => {}}`) or `window.alert()`.
- **Design discipline:** Stick to the repo's CSS variables / Tailwind tokens (1 brand accent + clean neutrals + `1px` borders), consistent `lucide-react` icons, and `tabular-nums` on numeric columns/metrics.
- **Mandatory 4 states:** Every async view/list/table must handle **Loading** (layout-matched skeleton), **Empty** (actionable CTA), **Error** (clear retry banner), and **Populated**.
- **Accessibility & responsiveness:** Semantic HTML (`<button>`, `<label>`, `<main>`), visible `focus-visible` rings, WCAG AA contrast, zero horizontal scroll at `375px` and `1280px`.

---

## 4. Security Rules

- **Boundary validation:** Validate every API body, query, param, server action, and webhook payload with Zod/Pydantic before touching DB or business logic. Explicitly pick fields on DB writes (no mass assignment).
- **Auth + IDOR protection:** Always check both authentication **and** resource ownership/role (`where: { id, userId }`), failing closed (`401`/`403`).
- **Secrets isolation:** Never expose server keys via `NEXT_PUBLIC_` or `VITE_`. Never commit `.env*` files; document new vars in `.env.example` with empty values. Never log tokens, cookies, or credentials.
- **Webhooks & SSRF:** Verify webhook HMAC-SHA256 signatures with `crypto.timingSafeEqual` over the raw body. Validate external URLs against SSRF (HTTPS only, block private/loopback/link-local IPs).
- **LLM safety (if applicable):** Delimit untrusted user/external input from system prompts, enforce `max_tokens` + timeouts, and validate JSON responses with Zod/Pydantic with graceful fallback.

---

## 5. Testing & Verification

- **No work is complete without tests:**
  - New pure helpers/validators → unit tests (happy path + null/empty/boundary cases).
  - New API routes/handlers → integration tests covering `200`/`400`/`401`/`403`/`404` and error handling.
  - Bugfixes → regression test reproducing the bug before fixing.
  - UI changes → verify mobile (`375px`) & desktop (`1280px`), zero console/page errors, and Playwright + `@axe-core/playwright` checks when configured.
- **Never bypass checks:** Never delete tests, add `.skip`, or weaken lint/TS rules to force green CI.

### Verification Commands (Run Before Finishing)

```bash
{{LINT_CMD}}        # e.g. npm run lint / ruff check .
{{TYPECHECK_CMD}}   # e.g. npm run typecheck
{{BUILD_CMD}}       # e.g. npm run build / python -m compileall -q .
{{TEST_CMD}}        # e.g. npm test / pytest -q
```

---

## 6. Git & Commit Rules

- **Atomic commits:** `<emoji> [#issue] [scope:] <present tense lowercase message>` (see `CONTRIBUTING.md`).
- **PRs:** Use plain-English **past-tense** PR titles, fill the PR template, and include docs / `.env.example` / tests in the same PR.
- **Safety:** Never force-push or run `git reset --hard` on `main`. Record any production rollback SHA and reason in a commit or PR.

---

<div align="center">

<h3>Tanish Poddar</h3>

<a href="https://tanisheesh.in"><img src="https://img.shields.io/badge/Website-tanisheesh.in-111111?style=flat-square&logo=googlechrome&logoColor=white" alt="Website"></a>
<a href="https://linkedin.com/in/tanisheesh"><img src="https://img.shields.io/badge/LinkedIn-tanisheesh-0A66C2?style=flat-square" alt="LinkedIn"></a>
<a href="https://github.com/tanisheesh"><img src="https://img.shields.io/badge/GitHub-tanisheesh-181717?style=flat-square&logo=github&logoColor=white" alt="GitHub"></a>
<a href="mailto:hi@tanisheesh.in"><img src="https://img.shields.io/badge/Email-hi%40tanisheesh.in-EA4335?style=flat-square&logo=gmail&logoColor=white" alt="Email"></a>

</div>
