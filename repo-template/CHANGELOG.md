<!--
  ╔══════════════════════════════════════════════════════════════╗
  ║  TANISH'S SETUP TOOLKIT · template · tanisheesh.in            ║
  ║  Keep the author footer at the bottom of the generated file.  ║
  ╚══════════════════════════════════════════════════════════════╝

  CHANGELOG TEMPLATE
  Goes to: <repo>/CHANGELOG.md
  How to fill:
    - Newest version on top. Work in progress goes under [Unreleased].
    - Sections map 1:1 to commit emojis, so you can build an entry from
      `git log --oneline <last-tag>..HEAD`:
        ✨ → Added     🎊 → Improved    🐛 → Fixed      🔒 → Security
        ♻️ → Changed   💀 → Removed     👆 → Dependencies
      (🔨 chore, 🎨 formatting, 🧪 tests, 👷 CI are usually left out.)
    - Only include sections that have entries.
    - Versions follow semver: MAJOR (breaking) . MINOR (feature) . PATCH (fix)
    - Delete these comments and the example entry once you add a real one.
-->

# Changelog

All notable changes to **{{PROJECT_NAME}}** are documented here.

---

## [Unreleased]

### ✨ Added
- {{New feature, written for users, not developers}}

### 🐛 Fixed
- {{Bug that users would have noticed}}

---

## [{{1.0.0}}] — {{YYYY-MM-DD}}

### ✨ Added
- {{e.g. GitHub OAuth login}}
- {{e.g. AI-generated weekly summary}}

### 🎊 Improved
- {{e.g. Dashboard loads 2x faster with server-side caching}}

### 🐛 Fixed
- {{e.g. Sync no longer fails for repos with no commits}}

### 🔒 Security
- {{e.g. Webhook signatures are now verified with a timing-safe compare}}

### 👆 Dependencies
- {{e.g. Next.js 15 → 16}}

---

[Unreleased]: https://github.com/tanisheesh/{{REPO_NAME}}/compare/v{{1.0.0}}...HEAD
[{{1.0.0}}]: https://github.com/tanisheesh/{{REPO_NAME}}/releases/tag/v{{1.0.0}}

---

<div align="center">

<h3>Tanish Poddar</h3>

<a href="https://tanisheesh.in"><img src="https://img.shields.io/badge/Website-tanisheesh.in-111111?style=flat-square&logo=googlechrome&logoColor=white" alt="Website"></a>
<a href="https://linkedin.com/in/tanisheesh"><img src="https://img.shields.io/badge/LinkedIn-tanisheesh-0A66C2?style=flat-square" alt="LinkedIn"></a>
<a href="https://github.com/tanisheesh"><img src="https://img.shields.io/badge/GitHub-tanisheesh-181717?style=flat-square&logo=github&logoColor=white" alt="GitHub"></a>
<a href="mailto:hey@tanisheesh.in"><img src="https://img.shields.io/badge/Email-hey%40tanisheesh.in-EA4335?style=flat-square&logo=gmail&logoColor=white" alt="Email"></a>

</div>
