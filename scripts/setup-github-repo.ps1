# ╔══════════════════════════════════════════════════════════════════════╗
# ║  TANISH'S SETUP TOOLKIT                                              ║
# ║  The standard for every repo by Tanish Poddar · tanisheesh.in        ║
# ╚══════════════════════════════════════════════════════════════════════╝
#
# setup-github-repo.ps1
# Configures ONE GitHub repo:
#   • description, homepage URL, topics
#   • clean merge settings (squash-only, auto-delete branches, no wiki)
#   • Dependabot alerts + security updates + private vulnerability reporting
#   • Secret scanning + push protection (where supported by repo tier)
#   • Branch ruleset on default branch (ci required, no force-push/deletion)
#   • Standard repository labels (security, docs, tests, frontend, backend, etc.)
#   • Actions secrets (MAIL_USERNAME, MAIL_PASSWORD, ALERTS_TOKEN, optional AI keys)
#
# Usage:
#   .\setup-github-repo.ps1 -Repo "<repo-name>" `
#       -Description "<one-line description>" `
#       -Homepage "https://<subdomain>.tanisheesh.in" `
#       -Topics "nextjs","typescript","ai"

param(
    [Parameter(Mandatory)][string]$Repo,
    [Parameter(Mandatory)][string]$Description,
    [string]$Homepage = "",
    [string[]]$Topics = @(),
    [string]$Owner = "tanisheesh",
    [string]$GitHubToken = $env:GITHUB_TOKEN,
    [switch]$StrictRuleset,
    [switch]$SkipRepoSettings,
    [switch]$SkipSecurity,
    [switch]$SkipRuleset,
    [switch]$SkipLabels,
    [switch]$SkipSecrets
)

$ErrorActionPreference = "Stop"

# ── Helpers ───────────────────────────────────────────────────────────────────

function Get-Headers {
    @{
        "Authorization"        = "Bearer $GitHubToken"
        "Accept"               = "application/vnd.github+json"
        "X-GitHub-Api-Version" = "2022-11-28"
        "Content-Type"         = "application/json"
    }
}

function Get-ApiErrorMessage($errRecord) {
    $detail = $errRecord.ErrorDetails.Message
    if ($detail) {
        try {
            $parsed = $detail | ConvertFrom-Json -ErrorAction Stop
            if ($parsed.message) { return $parsed.message }
        } catch {}
        return $detail
    }
    return $errRecord.Exception.Message
}

function Set-SecretStdin([string]$name, [string]$value, [string]$targetRepo) {
    $psi = [System.Diagnostics.ProcessStartInfo]::new()
    $psi.FileName = "gh"
    $psi.Arguments = "secret set $name -R `"$targetRepo`""
    $psi.RedirectStandardInput = $true
    $psi.RedirectStandardOutput = $true
    $psi.RedirectStandardError = $true
    $psi.UseShellExecute = $false
    $psi.Environment["GH_TOKEN"] = $GitHubToken

    $proc = [System.Diagnostics.Process]::Start($psi)
    $bytes = [System.Text.Encoding]::UTF8.GetBytes($value)
    $proc.StandardInput.BaseStream.Write($bytes, 0, $bytes.Length)
    $proc.StandardInput.Close()
    $proc.WaitForExit()
    return $proc.ExitCode
}

# ── Repo Actions ──────────────────────────────────────────────────────────────

function Update-RepoMeta($repoName, $homepageUrl, $desc) {
    $uri = "https://api.github.com/repos/$Owner/$([uri]::EscapeDataString($repoName))"
    $body = @{ description = $desc }
    if ($homepageUrl -ne "") { $body.homepage = $homepageUrl }

    if (-not $SkipRepoSettings) {
        $body.allow_squash_merge = $true
        $body.allow_merge_commit = $false
        $body.allow_rebase_merge = $false
        $body.delete_branch_on_merge = $true
        $body.allow_auto_merge = $true
        $body.allow_update_branch = $true
        $body.has_wiki = $false
    }

    try {
        Invoke-RestMethod -Method PATCH -Uri $uri -Headers (Get-Headers) -Body ($body | ConvertTo-Json -Depth 5) | Out-Null
        if ($SkipRepoSettings) {
            Write-Host "    [Meta]     Description + homepage set" -ForegroundColor Green
        } else {
            Write-Host "    [Meta]     Description, homepage + merge settings updated" -ForegroundColor Green
        }
    } catch {
        Write-Host "    [Meta]     ERROR: $(Get-ApiErrorMessage $_)" -ForegroundColor Red
    }
}

function Update-RepoTopics($repoName, $topicList) {
    $uri = "https://api.github.com/repos/$Owner/$([uri]::EscapeDataString($repoName))/topics"
    $body = @{ names = @($topicList) } | ConvertTo-Json
    try {
        Invoke-RestMethod -Method PUT -Uri $uri -Headers (Get-Headers) -Body $body | Out-Null
        Write-Host "    [Topics]   $($topicList -join ', ')" -ForegroundColor Green
    } catch {
        Write-Host "    [Topics]   ERROR: $(Get-ApiErrorMessage $_)" -ForegroundColor Red
    }
}

function Enable-RepoSecurity($repoName) {
    $base = "https://api.github.com/repos/$Owner/$([uri]::EscapeDataString($repoName))"
    $features = [ordered]@{
        "vulnerability-alerts"            = "Dependabot alerts"
        "automated-security-fixes"        = "Dependabot security updates"
        "private-vulnerability-reporting" = "Private vulnerability reporting"
    }
    foreach ($path in $features.Keys) {
        try {
            Invoke-RestMethod -Method PUT -Uri "$base/$path" -Headers (Get-Headers) | Out-Null
            Write-Host "    [Security] $($features[$path]) enabled" -ForegroundColor Green
        } catch {
            Write-Host "    [Security] $($features[$path]) ERROR: $(Get-ApiErrorMessage $_)" -ForegroundColor Red
        }
    }

    # Secret scanning + push protection (available on all public repos)
    $secPayloads = @(
        @{
            Label = "Secret scanning + push protection + AI detection"
            Body  = @{
                security_and_analysis = @{
                    secret_scanning                 = @{ status = "enabled" }
                    secret_scanning_push_protection = @{ status = "enabled" }
                    secret_scanning_ai_detection    = @{ status = "enabled" }
                }
            }
        },
        @{
            Label = "Secret scanning + push protection"
            Body  = @{
                security_and_analysis = @{
                    secret_scanning                 = @{ status = "enabled" }
                    secret_scanning_push_protection = @{ status = "enabled" }
                }
            }
        }
    )

    $secApplied = $false
    foreach ($attempt in $secPayloads) {
        try {
            Invoke-RestMethod -Method PATCH -Uri $base -Headers (Get-Headers) -Body ($attempt.Body | ConvertTo-Json -Depth 6) | Out-Null
            Write-Host "    [Security] $($attempt.Label) enabled" -ForegroundColor Green
            $secApplied = $true
            break
        } catch {}
    }
    if (-not $secApplied) {
        Write-Host "    [Security] Secret scanning not available for this repo tier (skipped)" -ForegroundColor Yellow
    }
}

function Sync-RepoRuleset($repoName) {
    $base = "https://api.github.com/repos/$Owner/$([uri]::EscapeDataString($repoName))/rulesets"
    $rulesetName = "Protect main"

    $bypassActors = @()
    if (-not $StrictRuleset) {
        # RepositoryRole actor_id 5 = Repository Admin
        $bypassActors = @(
            @{
                actor_id    = 5
                actor_type  = "RepositoryRole"
                bypass_mode = "always"
            }
        )
    }

    $payload = @{
        name          = $rulesetName
        target        = "branch"
        enforcement   = "active"
        bypass_actors = $bypassActors
        conditions    = @{
            ref_name = @{
                include = @("~DEFAULT_BRANCH")
                exclude = @()
            }
        }
        rules         = @(
            @{ type = "deletion" },
            @{ type = "non_fast_forward" },
            @{ type = "required_linear_history" },
            @{
                type       = "pull_request"
                parameters = @{
                    allowed_merge_methods            = @("squash")
                    dismiss_stale_reviews_on_push    = $true
                    require_code_owner_review        = $false
                    require_last_push_approval       = $false
                    required_approving_review_count  = 0
                    required_review_thread_resolution = $false
                }
            },
            @{
                type       = "required_status_checks"
                parameters = @{
                    do_not_enforce_on_create             = $false
                    strict_required_status_checks_policy = $false
                    required_status_checks               = @(
                        @{ context = "ci" }
                    )
                }
            }
        )
    }

    try {
        $existing = Invoke-RestMethod -Method GET -Uri $base -Headers (Get-Headers)
        $match = $existing | Where-Object { $_.name -eq $rulesetName } | Select-Object -First 1
        $json = $payload | ConvertTo-Json -Depth 10

        if ($match) {
            Invoke-RestMethod -Method PUT -Uri "$base/$($match.id)" -Headers (Get-Headers) -Body $json | Out-Null
            Write-Host "    [Ruleset]  Updated '$rulesetName' (CI required, squash-only, no force-push)" -ForegroundColor Green
        } else {
            Invoke-RestMethod -Method POST -Uri $base -Headers (Get-Headers) -Body $json | Out-Null
            Write-Host "    [Ruleset]  Created '$rulesetName' (CI required, squash-only, no force-push)" -ForegroundColor Green
        }
    } catch {
        Write-Host "    [Ruleset]  Skipped/WARN: $(Get-ApiErrorMessage $_)" -ForegroundColor Yellow
    }
}

function Sync-RepoLabels($repoName) {
    $base = "https://api.github.com/repos/$Owner/$([uri]::EscapeDataString($repoName))/labels"
    $labels = @(
        @{ name = "bug";          color = "D73A4A"; description = "Something isn't working" },
        @{ name = "enhancement";  color = "A2EEEF"; description = "New feature or improvement" },
        @{ name = "security";     color = "B60205"; description = "Security fix or hardening" },
        @{ name = "needs-review"; color = "D93F0B"; description = "Needs manual review" },
        @{ name = "dependencies"; color = "0366D6"; description = "Pull requests that update a dependency file" },
        @{ name = "docs";         color = "0075CA"; description = "Documentation updates" },
        @{ name = "tests";        color = "0E8A16"; description = "Unit, integration, or E2E tests" },
        @{ name = "ci";           color = "EDEDED"; description = "GitHub Actions or CI changes" },
        @{ name = "frontend";     color = "FBCA04"; description = "UI components and client code" },
        @{ name = "backend";      color = "5319E7"; description = "APIs, database, and server logic" }
    )

    $createdOrUpdated = 0
    foreach ($lbl in $labels) {
        $body = $lbl | ConvertTo-Json
        try {
            Invoke-RestMethod -Method POST -Uri $base -Headers (Get-Headers) -Body $body | Out-Null
            $createdOrUpdated++
        } catch {
            $status = $_.Exception.Response.StatusCode.value__
            if ($status -eq 422) {
                try {
                    Invoke-RestMethod -Method PATCH -Uri "$base/$([uri]::EscapeDataString($lbl.name))" -Headers (Get-Headers) -Body $body | Out-Null
                    $createdOrUpdated++
                } catch {}
            }
        }
    }
    Write-Host "    [Labels]   Synced $createdOrUpdated standard labels" -ForegroundColor Green
}

function Set-RepoSecrets($repoName) {
    if (-not (Get-Command gh -ErrorAction SilentlyContinue)) {
        Write-Host "    [Secrets]  Skipped: GitHub CLI (gh) not installed" -ForegroundColor Yellow
        return
    }

    $secretNames = @(
        "MAIL_USERNAME",
        "MAIL_PASSWORD",
        "ALERTS_TOKEN",
        "GEMINI_API_KEY",
        "ANTHROPIC_API_KEY",
        "OPENAI_API_KEY"
    )
    $optionalAi = @("GEMINI_API_KEY", "ANTHROPIC_API_KEY", "OPENAI_API_KEY")

    foreach ($name in $secretNames) {
        $value = [Environment]::GetEnvironmentVariable($name)
        if (-not $value) {
            if ($name -notin $optionalAi) {
                Write-Host "    [Secrets]  $name not in env, skipped" -ForegroundColor Yellow
            }
            continue
        }
        $code = Set-SecretStdin -name $name -value $value -targetRepo "$Owner/$repoName"
        if ($code -eq 0) {
            Write-Host "    [Secrets]  $name set" -ForegroundColor Green
        } else {
            Write-Host "    [Secrets]  $name ERROR (gh exit $code)" -ForegroundColor Red
        }
    }

    $mailUser = [Environment]::GetEnvironmentVariable("MAIL_USERNAME")
    $reportEmail = [Environment]::GetEnvironmentVariable("REPORT_EMAIL")
    if (-not $reportEmail -and $mailUser) {
        $reportEmail = if ($Owner -eq "tanisheesh") { "hi@tanisheesh.in" } else { $mailUser }
    }
    if ($reportEmail) {
        $env:GH_TOKEN = $GitHubToken
        gh variable set REPORT_EMAIL -b $reportEmail -R "$Owner/$repoName" 2>&1 | Out-Null
        if ($LASTEXITCODE -eq 0) {
            Write-Host "    [Vars]     REPORT_EMAIL set ($reportEmail)" -ForegroundColor Green
        }
    } elseif ($mailUser) {
        Write-Host "    [Vars]     REPORT_EMAIL not set; maintenance-report emails skipped until REPORT_EMAIL is set" -ForegroundColor Yellow
    }
}

function Sync-PrivateScanVars($repoName) {
    $uri = "https://api.github.com/repos/$Owner/$([uri]::EscapeDataString($repoName))"
    try {
        $info = Invoke-RestMethod -Method GET -Uri $uri -Headers (Get-Headers)
        if ($info.private -eq $true) {
            $ghasEnabled = ($info.security_and_analysis.advanced_security.status -eq "enabled") -or
                           ($info.security_and_analysis.code_security.status -eq "enabled")
            if ($ghasEnabled -and (Get-Command gh -ErrorAction SilentlyContinue)) {
                $env:GH_TOKEN = $GitHubToken
                gh variable set ENABLE_CODEQL -b "true" -R "$Owner/$repoName" 2>&1 | Out-Null
                gh variable set ENABLE_DEPENDENCY_REVIEW -b "true" -R "$Owner/$repoName" 2>&1 | Out-Null
                Write-Host "    [Vars]     Private repo with GHAS: ENABLE_CODEQL + ENABLE_DEPENDENCY_REVIEW set" -ForegroundColor Green
            } else {
                Write-Host "    [Security] Private repo without GHAS: CodeQL & Dependency Review workflows are unavailable and will skip" -ForegroundColor Yellow
            }
        }
    } catch {
        Write-Host "    [Security] Could not inspect repo visibility/GHAS status: $(Get-ApiErrorMessage $_)" -ForegroundColor Yellow
    }
}

function Read-RequiredSecret([string]$prompt, [string]$envName) {
    if ([Console]::IsInputRedirected) {
        throw "Missing $envName in environment (non-interactive shell cannot prompt)."
    }
    return (Read-Host $prompt)
}

# ── Main ──────────────────────────────────────────────────────────────────────

if (-not $GitHubToken) { $GitHubToken = Read-RequiredSecret "GitHub PAT (github.com/settings/tokens -> repo scope)" "GITHUB_TOKEN" }

Write-Host "`n━━━ $Owner/$Repo ━━━`n" -ForegroundColor Cyan

Update-RepoMeta $Repo $Homepage $Description
if ($Topics.Count -gt 0) { Update-RepoTopics $Repo $Topics }
if (-not $SkipSecurity)  { Enable-RepoSecurity $Repo; Sync-PrivateScanVars $Repo }
if (-not $SkipRuleset)   { Sync-RepoRuleset $Repo }
if (-not $SkipLabels)    { Sync-RepoLabels $Repo }
if (-not $SkipSecrets)   { Set-RepoSecrets $Repo }

Write-Host "`n━━━ Done ━━━" -ForegroundColor Green
Write-Host "Tanish's Setup Toolkit · tanisheesh.in · github.com/tanisheesh" -ForegroundColor DarkGray

# ──────────────────────────────────────────────────────────────────────────
#  Tanish Poddar
#  Website   https://tanisheesh.in
#  LinkedIn  https://linkedin.com/in/tanisheesh
#  GitHub    https://github.com/tanisheesh
#  Email     hi@tanisheesh.in
# ──────────────────────────────────────────────────────────────────────────
