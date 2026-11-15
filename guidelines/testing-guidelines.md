<div align="center">

<sub><b>TANISH'S SETUP TOOLKIT</b> · the standard for every repo by <a href="https://tanisheesh.in">Tanish Poddar</a></sub>

</div>

# 🧪 Testing Guidelines

"It compiled" and "I clicked it once locally" are not tests. Every non-trivial repo needs automated tests across the full stack so CI and automated dependency merging can protect `main` with confidence.

---

## 1. The 4-Layer Testing Standard

| Layer | Recommended Tools | What to Cover |
|---|---|---|
| **1. Unit Tests** | `vitest` / `bun test` (JS/TS) · `pytest` (Python) · `go test -race` (Go) · `flutter test` (Dart) | Pure functions, scoring/calculations, parsers, formatters, Zod/Pydantic schemas, boundary & null/empty cases |
| **2. Integration & API Tests** | `vitest` + handler/supertest tests · `pytest` + `httpx` / `TestClient` · `httptest` (Go) | Success (`200`/`201`), validation failures (`400`/`422`), unauthenticated (`401`), cross-user IDOR (`403`), missing resource (`404`), idempotent retries, mocked LLM/webhook failures |
| **3. E2E, Visual & A11y Smoke** | `Playwright` + `@axe-core/playwright` (Web) · `flutter test` widget/integration tests (Mobile) · CLI subprocess tests (`aegis-shell`) | Core user journeys against the built app, **0 `console.error`**, **0 uncaught `pageerror`**, **0 5xx responses**, horizontal overflow check at `375px` & `1280px`, WCAG AA accessibility scan |
| **4. Static & Build Gates** | `eslint` / `biome` · `tsc --noEmit` · `ruff` / `mypy` · `go vet` · `flutter analyze` | Zero warnings/errors before any test suite runs |

---

## 2. Non-Negotiable Rules

1. **Every new module or API route ships with tests** in the same PR — happy path + at least 2 failure/edge cases.
2. **Every bugfix ships with a regression test** that fails before the fix and passes after it.
3. **Test behavior, not implementation details:** Assert HTTP contracts, DOM accessibility roles (`getByRole`, `getByLabel`), and outputs — avoid brittle CSS selector chains or mocking the module under test.
4. **Deterministic & isolated:** Mock external third-party HTTP/LLM APIs (`msw`, `respx`, `vi.fn()`) so CI never flakes on rate limits or spends paid tokens. Use unique test fixtures/cleanups so tests never depend on execution order.
5. **Never fake a pass:** Never skip failing tests (`test.skip`), weaken assertions, or delete CI checks to make a build green.

---

## 3. Recommended `package.json` / `pyproject.toml` Scripts

CI (`ci.yml`) auto-detects and runs these scripts in order if present:

### Node / TypeScript / Bun
```json
{
  "scripts": {
    "lint": "eslint .",
    "format:check": "prettier --check .",
    "typecheck": "tsc --noEmit",
    "build": "next build",
    "test": "vitest run",
    "test:e2e": "playwright test"
  }
}
```

### Python
- Configure `ruff` in `pyproject.toml` (`[tool.ruff]`).
- Place tests under `tests/` (`test_*.py`) for automatic `pytest` discovery.
- Add `mypy` or `pyright` when typing public APIs/services.

### Go & Flutter/Dart
- **Go:** Run `go vet ./...`, `go test -race ./...`, and `go build ./...`.
- **Flutter/Dart:** Run `flutter analyze` and `flutter test` (widget + unit tests under `test/`).

---

## 4. Playwright Smoke Baseline

Starter templates live in `stack-templates/playwright.config.ts` and `stack-templates/smoke.spec.ts`. Every web app should include at least:
- Route load checks for primary public/demo pages (status < 400).
- Zero console errors, uncaught exceptions, or failed 5xx requests.
- Desktop (`1280x800`) and mobile (`375x812`) layout check (`document.documentElement.scrollWidth <= window.innerWidth`).
- `@axe-core/playwright` scan reporting zero `critical` or `serious` violations.

---

<div align="center">

<h3>Tanish Poddar</h3>

<a href="https://tanisheesh.in"><img src="https://img.shields.io/badge/Website-tanisheesh.in-111111?style=flat-square&logo=googlechrome&logoColor=white" alt="Website"></a>
<a href="https://linkedin.com/in/tanisheesh"><img src="https://img.shields.io/badge/LinkedIn-tanisheesh-0A66C2?style=flat-square" alt="LinkedIn"></a>
<a href="https://github.com/tanisheesh"><img src="https://img.shields.io/badge/GitHub-tanisheesh-181717?style=flat-square&logo=github&logoColor=white" alt="GitHub"></a>
<a href="mailto:hi@tanisheesh.in"><img src="https://img.shields.io/badge/Email-hi%40tanisheesh.in-EA4335?style=flat-square&logo=gmail&logoColor=white" alt="Email"></a>

</div>
