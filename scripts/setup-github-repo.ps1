# ╔══════════════════════════════════════════════════════════════════════╗
# ║  TANISH'S SETUP TOOLKIT                                              ║
# ║  The standard for every repo by Tanish Poddar · tanisheesh.in        ║
# ╚══════════════════════════════════════════════════════════════════════╝
#
# setup-github-repo.ps1
# Sets up ONE GitHub repo:
#   • description, homepage URL, topics
#   • Dependabot alerts + security updates + private vulnerability reporting
#   • email secrets for the weekly maintenance report (MAIL_USERNAME,
#     MAIL_PASSWORD, ALERTS_TOKEN), only those present as env vars
#     (needs the GitHub CLI `gh`)
# Requires a GitHub PAT with `repo` scope.
# Get one at: github.com/settings/tokens → Generate new token (classic) → check `repo`
#
# Usage:
#   .\setup-github-repo.ps1 -Repo "<repo-name>" `
#       -Description "<one-line description>" `
#       -Homepage "https://<subdomain>.tanisheesh.in" `
#       -Topics "nextjs","typescript","ai"
#
# Token: pass -GitHubToken, or set $env:GITHUB_TOKEN, or it will prompt.
# Skip parts with -SkipSecurity / -SkipSecrets.

param(
    [Parameter(Mandatory)][string]$Repo,
    [Parameter(Mandatory)][string]$Description,
    [string]$Homepage = "",
    [string[]]$Topics = @(),
    [string]$Owner = "tanisheesh",
    [string]$GitHubToken = $env:GITHUB_TOKEN,
    [switch]$SkipSecurity,
    [switch]$SkipSecrets
)

# ── Functions ─────────────────────────────────────────────────────────────────

function Get-Headers {
    @{
        "Authorization" = "Bearer $GitHubToken"
        "Accept"        = "application/vnd.github+json"
        "Content-Type"  = "application/json"
    }
}

function Update-RepoMeta($repo, $homepage, $description) {
    $uri = "https://api.github.com/repos/$Owner/$([uri]::EscapeDataString($repo))"
    $body = @{ description = $description }
    if ($homepage -ne "") { $body.homepage = $homepage }
    try {
        Invoke-RestMethod -Method PATCH -Uri $uri -Headers (Get-Headers) -Body ($body | ConvertTo-Json) | Out-Null
        Write-Host "    [Meta]   Description + homepage set" -ForegroundColor Green
    } catch {
        Write-Host "    [Meta]   ERROR: $($_.Exception.Message)" -ForegroundColor Red
    }
}

function Update-RepoTopics($repo, $topics) {
    $uri = "https://api.github.com/repos/$Owner/$([uri]::EscapeDataString($repo))/topics"
    $body = @{ names = @($topics) } | ConvertTo-Json
    try {
        Invoke-RestMethod -Method PUT -Uri $uri -Headers (Get-Headers) -Body $body | Out-Null
        Write-Host "    [Topics] $($topics -join ', ')" -ForegroundColor Green
    } catch {
        Write-Host "    [Topics] ERROR: $($_.Exception.Message)" -ForegroundColor Red
    }
}

function Enable-RepoSecurity($repo) {
    # Dependabot alerts, Dependabot security-fix PRs, private vulnerability reporting (used by SECURITY.md)
    $base = "https://api.github.com/repos/$Owner/$([uri]::EscapeDataString($repo))"
    $features = [ordered]@{
        "vulnerability-alerts"           = "Dependabot alerts"
        "automated-security-fixes"       = "Dependabot security updates"
        "private-vulnerability-reporting" = "Private vulnerability reporting"
    }
    foreach ($path in $features.Keys) {
        try {
            Invoke-RestMethod -Method PUT -Uri "$base/$path" -Headers (Get-Headers) | Out-Null
            Write-Host "    [Security] $($features[$path]) enabled" -ForegroundColor Green
        } catch {
            Write-Host "    [Security] $($features[$path]) ERROR: $($_.Exception.Message)" -ForegroundColor Red
        }
    }
}

function Set-RepoSecrets($repo) {
    # Secrets for .github/workflows/maintenance-report.yml (weekly email).
    # Values come from env vars (the toolkit's .env) and are piped via stdin, never printed.
    if (-not (Get-Command gh -ErrorAction SilentlyContinue)) {
        Write-Host "    [Secrets] Skipped: GitHub CLI (gh) not installed" -ForegroundColor Yellow
        return
    }
    $env:GH_TOKEN = $GitHubToken
    foreach ($name in "MAIL_USERNAME", "MAIL_PASSWORD", "ALERTS_TOKEN") {
        $value = [Environment]::GetEnvironmentVariable($name)
        if (-not $value) {
            Write-Host "    [Secrets] $name not in env, skipped" -ForegroundColor Yellow
            continue
        }
        $value | gh secret set $name -R "$Owner/$repo" 2>&1 | Out-Null
        if ($LASTEXITCODE -eq 0) {
            Write-Host "    [Secrets] $name set" -ForegroundColor Green
        } else {
            Write-Host "    [Secrets] $name ERROR (gh exit $LASTEXITCODE)" -ForegroundColor Red
        }
    }
}

# ── Main ──────────────────────────────────────────────────────────────────────

if (-not $GitHubToken) { $GitHubToken = Read-Host "GitHub PAT (github.com/settings/tokens → repo scope)" }

Write-Host "`n━━━ $Owner/$Repo ━━━`n" -ForegroundColor Cyan

Update-RepoMeta $Repo $Homepage $Description
if ($Topics.Count -gt 0) { Update-RepoTopics $Repo $Topics }
if (-not $SkipSecurity) { Enable-RepoSecurity $Repo }
if (-not $SkipSecrets)  { Set-RepoSecrets $Repo }

Write-Host "`n━━━ Done ━━━" -ForegroundColor Green
Write-Host "Tanish's Setup Toolkit · tanisheesh.in · github.com/tanisheesh" -ForegroundColor DarkGray

# ──────────────────────────────────────────────────────────────────────────
#  Tanish Poddar
#  Website   https://tanisheesh.in
#  LinkedIn  https://linkedin.com/in/tanisheesh
#  GitHub    https://github.com/tanisheesh
#  Email     hi@tanisheesh.in
# ──────────────────────────────────────────────────────────────────────────
