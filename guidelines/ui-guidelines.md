<div align="center">

<sub><b>TANISH'S SETUP TOOLKIT</b> · the standard for every repo by <a href="https://tanisheesh.in">Tanish Poddar</a></sub>

</div>

# 🎨 UI Craft & Anti-AI-Slop Guidelines

Portfolio apps are judged in the first **5 seconds**. Generic AI-generated UI instantly signals low craft. Every frontend in this workspace must follow these rules.

---

## 1. Explicitly Banned ("AI Slop" Checklist)

Never ship any of these unless the product brand explicitly calls for it:

### Visual & Color Clichés
- Generic **purple / indigo / cyan-to-pink linear gradients** on dark backgrounds, hero text, or buttons.
- Neon glow box-shadows (`shadow-[0_0_25px_rgba(139,92,246,0.5)]`) or gratuitous glassmorphism stacked on busy gradients.
- Rainbow badge walls or random pastel background colors on every card/avatar/tag.
- Giant `rounded-3xl` cards with heavy drop shadows (`shadow-2xl`) and huge empty padding inside dense data tools.

### Layout & Component Clichés
- Cookie-cutter "SaaS Landing Page" **3-column icon-in-tinted-circle feature grid** dropped inside a dashboard or utility tool.
- Unnecessary full-viewport marketing hero banners blocking access to the actual app workspace.
- Fake decorative status dots (`● Live`) or faux macOS window traffic-light headers around random cards.

### Copy & Data Clichés
- Emoji-prefixed UI headings (`🚀 Get Started`, `✨ AI Insights`, `🔥 Trending`) — keep app UI typography clean; reserve emojis only for deliberate semantic status or user content.
- Empty hype copy (*"Supercharge your productivity"*, *"Unleash next-gen AI magic"*, *"Revolutionize..."*).
- Hardcoded fake metrics (`+142% growth`, `99.99% uptime`, `John Doe / acme@example.com` dummy cards) shown as real telemetry.
- Dead buttons (`onClick={() => {}}`), non-working toggles, or `window.alert()` / `window.confirm()` dialogs.

---

## 2. Required Design Craft

### Intentional Tokens (Theme First)
Define surfaces, borders, text hierarchy, and a **single primary accent** in CSS variables / Tailwind `@theme` before writing screens:
- **Surfaces:** 2–3 subtle neutral levels (canvas, card/panel, elevated/popover) with crisp `1px` borders instead of heavy shadows.
- **Typography:** Clear scale — 1 primary sans/display font + 1 monospace font for code/IDs/metrics. Always use `tabular-nums` on numbers, tables, timers, and counters.
- **Iconography:** One consistent icon library (e.g. `lucide-react`) with unified stroke weight (`1.5` or `1.75`). Never mix icon packs.

### Mandatory 4-State UI Contract
Every async view, list, table, or detail panel **must** explicitly handle all 4 states:
1. **Loading:** Layout-matched skeleton preserving container height (prevent CLS / layout jump).
2. **Empty:** Domain-specific explanation + clear primary action button (never a blank white box).
3. **Error:** Calm, actionable error banner with retry button (never raw stack traces or silent failure).
4. **Populated:** Crisp spacing, scannable hierarchy, explicit truncation/overflow handling (`truncate`, `min-w-0`).

### Component Reusability
- Build shared primitives once in `components/ui/` (`Button`, `Input`, `Badge`, `Card`, `Dialog`, `EmptyState`, `ErrorBanner`, `DataTable`).
- Feature components in `components/features/` compose `ui/` primitives rather than repeating 40-line Tailwind utility strings across pages.
- Form controls use accessible labels, inline validation errors, disabled submit states while pending, and toast/inline feedback on completion.

---

## 3. Accessibility & Responsiveness

- **Semantic HTML:** `<button>` for actions, `<a href>` for navigation, `<label htmlFor>` for inputs, `<main>`/`<nav>`/`<header>` landmarks. Never attach `onClick` to a `<div>` without role/keyboard handling.
- **Keyboard & Focus:** Every interactive element must be reachable via `Tab` and show a clear `focus-visible` ring. Modals/drawers must support `Escape` and focus return.
- **Contrast:** Text and interactive controls must meet **WCAG 2.1 AA** (≥ 4.5:1 normal text, ≥ 3:1 large text/UI icons).
- **Viewports:** Zero horizontal scroll (`scrollWidth <= innerWidth`) and usable touch targets (≥ 40px) at both **mobile (`375px`)** and **desktop (`1280px`)**.

---

## 4. Visual Verification Loop

Before marking any UI task complete:
1. Run the Playwright smoke + `@axe-core/playwright` check (`375px` and `1280px`).
2. Confirm **0 console errors**, **0 uncaught page errors**, **0 broken images**, and **0 accessibility violations**.
3. If browser/screenshot tooling is available, visually inspect rendered screenshots for alignment, contrast, truncation, and AI-slop regression.

---

<div align="center">

<h3>Tanish Poddar</h3>

<a href="https://tanisheesh.in"><img src="https://img.shields.io/badge/Website-tanisheesh.in-111111?style=flat-square&logo=googlechrome&logoColor=white" alt="Website"></a>
<a href="https://linkedin.com/in/tanisheesh"><img src="https://img.shields.io/badge/LinkedIn-tanisheesh-0A66C2?style=flat-square" alt="LinkedIn"></a>
<a href="https://github.com/tanisheesh"><img src="https://img.shields.io/badge/GitHub-tanisheesh-181717?style=flat-square&logo=github&logoColor=white" alt="GitHub"></a>
<a href="mailto:hi@tanisheesh.in"><img src="https://img.shields.io/badge/Email-hi%40tanisheesh.in-EA4335?style=flat-square&logo=gmail&logoColor=white" alt="Email"></a>

</div>
