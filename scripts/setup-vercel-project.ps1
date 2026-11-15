# ╔══════════════════════════════════════════════════════════════════════╗
# ║  TANISH'S SETUP TOOLKIT                                              ║
# ║  The standard for every repo by Tanish Poddar · tanisheesh.in        ║
# ╚══════════════════════════════════════════════════════════════════════╝
#
# setup-vercel-project.ps1
# Applies project-tailored production & security settings to ONE Vercel
# project via PATCH /v9/projects/{project}:
#   • auto-detects framework & Node version (22.x / 24.x) from -RepoPath
#   • enforces directoryListing=false, protectedSourcemaps=true,
#     gitForkProtection=true, autoExposeSystemEnvs=true
#   • configures serverless region (default bom1), Fluid compute & timeout
#   • optionally ignores docs-only commits (docs/, *.md, .github/)
#
# Usage:
#   .\setup-vercel-project.ps1 -Project "<vercel-project-slug>" -RepoPath "..\my-app"
#   .\setup-vercel-project.ps1 -Project "<vercel-project-slug>" -Region "iad1" -IgnoreDocsOnlyBuilds

param(
    [Parameter(Mandatory)][string]$Project,
    [string]$RepoPath = "",
    [string]$TeamId = $env:VERCEL_TEAM_ID,
    [string]$Framework = "",
    [string]$NodeVersion = "",
    [string]$RootDirectory = "",
    [string]$Region = "bom1",
    [int]$FunctionTimeout = 30,
    [bool]$FluidCompute = $true,
    [switch]$IgnoreDocsOnlyBuilds,
    [string]$VercelToken = $env:VERCEL_TOKEN
)

$ErrorActionPreference = "Stop"

# ── Helpers ───────────────────────────────────────────────────────────────────

function Resolve-VercelToken([string]$explicitToken) {
    if ($explicitToken) { return $explicitToken }
    $paths = @(
        (Join-Path $env:APPDATA "com.vercel.cli\Data\auth.json"),
        (Join-Path $env:LOCALAPPDATA "com.vercel.cli\Data\auth.json")
    )
    foreach ($p in $paths) {
        if ($p -and (Test-Path $p)) {
            try {
                $tok = (Get-Content $p -Raw | ConvertFrom-Json).token
                if ($tok) { return $tok }
            } catch {}
        }
    }
    if ([Console]::IsInputRedirected) {
        throw "Missing VERCEL_TOKEN and no Vercel CLI auth.json found (non-interactive shell)."
    }
    return (Read-Host "Vercel Token (vercel.com/account/tokens)")
}

function Get-VercelApiError($errRecord) {
    $detail = $errRecord.ErrorDetails.Message
    if ($detail) {
        try {
            $parsed = $detail | ConvertFrom-Json -ErrorAction Stop
            if ($parsed.error.message) { return "$($parsed.error.code): $($parsed.error.message)" }
        } catch {}
        return $detail
    }
    return $errRecord.Exception.Message
}

function Get-ProjectStack([string]$path, [string]$rootDir = "") {
    $result = @{
        Framework   = $null
        NodeVersion = $null
    }
    if (-not $path -or -not (Test-Path $path)) { return $result }

    $appPath = if ($rootDir) { Join-Path $path $rootDir } else { $path }
    $inspectPaths = @($appPath, $path) | Select-Object -Unique

    if (Test-Path $appPath) {
        $pkgPath = Join-Path $appPath "package.json"
        if (Test-Path $pkgPath) {
            try {
                $pkg = Get-Content $pkgPath -Raw | ConvertFrom-Json
                $deps = @{}
                foreach ($section in @($pkg.dependencies, $pkg.devDependencies)) {
                    if ($section) {
                        $section.PSObject.Properties | ForEach-Object { $deps[$_.Name] = $_.Value }
                    }
                }
                $isReactRouterFramework = $deps.ContainsKey("@react-router/dev") -or
                    (Test-Path (Join-Path $appPath "react-router.config.ts")) -or
                    (Test-Path (Join-Path $appPath "react-router.config.js"))

                if     ($deps.ContainsKey("next"))             { $result.Framework = "nextjs" }
                elseif ($deps.ContainsKey("astro"))            { $result.Framework = "astro" }
                elseif ($deps.ContainsKey("@sveltejs/kit"))    { $result.Framework = "sveltekit" }
                elseif ($deps.ContainsKey("nuxt"))             { $result.Framework = "nuxtjs" }
                elseif ($deps.ContainsKey("@remix-run/react")) { $result.Framework = "remix" }
                elseif ($isReactRouterFramework)               { $result.Framework = "react-router" }
                elseif ($deps.ContainsKey("vite"))             { $result.Framework = "vite" }
                elseif ($deps.ContainsKey("hono"))             { $result.Framework = "hono" }
                elseif ($deps.ContainsKey("express"))          { $result.Framework = "express" }
            } catch {}
        }
    }

    foreach ($dir in $inspectPaths) {
        if (-not (Test-Path $dir)) { continue }
        foreach ($f in @(".nvmrc", ".node-version")) {
            $vf = Join-Path $dir $f
            if (Test-Path $vf) {
                $raw = (Get-Content $vf -Raw).Trim() -replace '^v', ''
                if ($raw -match '^(\d+)') {
                    $major = "$($Matches[1]).x"
                    if ($major -in @("20.x", "22.x", "24.x", "26.x")) {
                        $result.NodeVersion = $major
                    }
                }
                break
            }
        }
        if ($result.NodeVersion) { break }
    }

    return $result
}

# ── Main ──────────────────────────────────────────────────────────────────────

$VercelToken = Resolve-VercelToken $VercelToken
$detected = Get-ProjectStack $RepoPath $RootDirectory

$resolvedFramework = if ($Framework) { $Framework } elseif ($detected.Framework) { $detected.Framework } else { $null }
$resolvedNode      = if ($NodeVersion) { $NodeVersion } elseif ($detected.NodeVersion) { $detected.NodeVersion } else { "22.x" }

$query = if ($TeamId) { "?teamId=$([uri]::EscapeDataString($TeamId))" } else { "" }
$uri = "https://api.vercel.com/v9/projects/$([uri]::EscapeDataString($Project))$query"
$headers = @{
    "Authorization" = "Bearer $VercelToken"
    "Content-Type"  = "application/json"
}

Write-Host "`n━━━ Vercel Project: $Project ━━━`n" -ForegroundColor Cyan

$basePayload = @{
    nodeVersion              = $resolvedNode
    directoryListing         = $false
    autoExposeSystemEnvs     = $true
    gitForkProtection        = $true
    protectedSourcemaps      = $true
    serverlessFunctionRegion = $Region
    gitComments              = @{
        onPullRequest = $true
        onCommit      = $false
    }
}

if ($resolvedFramework) { $basePayload.framework = $resolvedFramework }
if ($RootDirectory)     { $basePayload.rootDirectory = $RootDirectory }
if ($IgnoreDocsOnlyBuilds) {
    $basePayload.commandForIgnoringBuildStep = '[ -n "$VERCEL_GIT_PREVIOUS_SHA" ] && git diff --quiet "$VERCEL_GIT_PREVIOUS_SHA" HEAD -- . '':!docs'' '':!*.md'' '':!.github'''
}

$fullPayload = $basePayload.Clone()
$fullPayload.Remove("serverlessFunctionRegion")
$fullPayload.resourceConfig = @{
    fluid                  = $FluidCompute
    functionDefaultRegions = @($Region)
    functionDefaultTimeout = $FunctionTimeout
}

$applied = $false
try {
    $res = Invoke-RestMethod -Method PATCH -Uri $uri -Headers $headers -Body ($fullPayload | ConvertTo-Json -Depth 6)
    Write-Host "    [Vercel] Full production + security settings applied" -ForegroundColor Green
    $applied = $true
} catch {
    $errMsg = Get-VercelApiError $_
    Write-Host "    [Vercel] Advanced/Pro fields skipped ($errMsg) — applying baseline settings..." -ForegroundColor Yellow
    try {
        $res = Invoke-RestMethod -Method PATCH -Uri $uri -Headers $headers -Body ($basePayload | ConvertTo-Json -Depth 6)
        Write-Host "    [Vercel] Baseline production + security settings applied" -ForegroundColor Green
        $applied = $true
    } catch {
        Write-Host "    [Vercel] ERROR: $(Get-VercelApiError $_)" -ForegroundColor Red
    }
}

if (-not $applied) {
    exit 1
}

if ($applied -and $res) {
    $outRegion = if ($res.resourceConfig.functionDefaultRegions) { $res.resourceConfig.functionDefaultRegions -join ", " } else { $res.serverlessFunctionRegion }
    Write-Host "    • framework:            $($res.framework)" -ForegroundColor Gray
    Write-Host "    • nodeVersion:          $($res.nodeVersion)" -ForegroundColor Gray
    Write-Host "    • region:               $outRegion" -ForegroundColor Gray
    Write-Host "    • directoryListing:     $($res.directoryListing)" -ForegroundColor Gray
    Write-Host "    • gitForkProtection:    $($res.gitForkProtection)" -ForegroundColor Gray
    Write-Host "    • protectedSourcemaps:  $($res.protectedSourcemaps)" -ForegroundColor Gray
    if ($res.commandForIgnoringBuildStep) {
        Write-Host "    • ignoreBuildStep:      $($res.commandForIgnoringBuildStep)" -ForegroundColor Gray
    }
}

Write-Host "`n━━━ Done ━━━" -ForegroundColor Green
Write-Host "Tanish's Setup Toolkit · tanisheesh.in · github.com/tanisheesh" -ForegroundColor DarkGray

# ──────────────────────────────────────────────────────────────────────────
#  Tanish Poddar
#  Website   https://tanisheesh.in
#  LinkedIn  https://linkedin.com/in/tanisheesh
#  GitHub    https://github.com/tanisheesh
#  Email     hi@tanisheesh.in
# ──────────────────────────────────────────────────────────────────────────
