# ╔══════════════════════════════════════════════════════════════════════╗
# ║  TANISH'S SETUP TOOLKIT                                              ║
# ║  The standard for every repo by Tanish Poddar · tanisheesh.in        ║
# ╚══════════════════════════════════════════════════════════════════════╝
#
# setup-subdomain.ps1
# Adds ONE <subdomain>.tanisheesh.in to a Vercel project or Render service
# and creates the matching CNAME record in GoDaddy.
#
# Usage:
#   Vercel:
#     .\setup-subdomain.ps1 -Subdomain "<prefix>" -Platform Vercel -VercelProject "<vercel-project-slug>"
#   Render:
#     .\setup-subdomain.ps1 -Subdomain "<prefix>" -Platform Render -RenderHost "<service>.onrender.com"
#
# Credentials: pass as params, or set env vars VERCEL_TOKEN / GODADDY_KEY / RENDER_API_KEY,
# or it will prompt for the ones needed.
#   Vercel Token       → vercel.com/account/tokens
#   GoDaddy Key+Secret → developer.godaddy.com/keys   (format: KEY:SECRET)
#   Render API Key     → dashboard.render.com/u/<you>/account/api-keys

param(
    [Parameter(Mandatory)][string]$Subdomain,
    [Parameter(Mandatory)][ValidateSet("Vercel", "Render")][string]$Platform,
    [string]$VercelProject,
    [string]$RenderHost,
    [string]$Domain       = "tanisheesh.in",
    [string]$VercelToken  = $env:VERCEL_TOKEN,
    [string]$GoDaddyKey   = $env:GODADDY_KEY,
    [string]$RenderApiKey = $env:RENDER_API_KEY
)

# ── Helpers ───────────────────────────────────────────────────────────────────

function Add-GoDaddyCNAME($subdomain, $target) {
    $uri = "https://api.godaddy.com/v1/domains/$Domain/records/CNAME/$subdomain"
    $body = '[{"data":"' + $target + '","ttl":600}]'
    # Try sso-key format first, then Bearer
    foreach ($authHeader in @("sso-key $GoDaddyKey", "Bearer $GoDaddyKey")) {
        $headers = @{ "Authorization" = $authHeader; "Content-Type" = "application/json" }
        try {
            Invoke-RestMethod -Method PUT -Uri $uri -Headers $headers -Body $body | Out-Null
            Write-Host "    [GoDaddy] CNAME: $subdomain.$Domain → $target" -ForegroundColor Green
            return
        } catch {
            if ($authHeader -notlike "Bearer*") { continue }
            Write-Host "    [GoDaddy] ERROR 401 — check API key permissions at developer.godaddy.com/keys" -ForegroundColor Red
        }
    }
}

function Add-VercelDomain($projectSlug, $subdomain) {
    $fqdn = "$subdomain.$Domain"
    $uri  = "https://api.vercel.com/v9/projects/$projectSlug/domains"
    $headers = @{
        "Authorization" = "Bearer $VercelToken"
        "Content-Type"  = "application/json"
    }
    $body = ConvertTo-Json @{ name = $fqdn }
    try {
        Invoke-RestMethod -Method POST -Uri $uri -Headers $headers -Body $body | Out-Null
        Write-Host "    [Vercel]  Domain added: $fqdn" -ForegroundColor Green
    } catch {
        $err = $_.ErrorDetails.Message | ConvertFrom-Json -ErrorAction SilentlyContinue
        if ($err.error.code -eq "domain_already_in_use" -or $err.error.code -eq "project_domain_already_exists") {
            Write-Host "    [Vercel]  Already exists: $fqdn" -ForegroundColor Yellow
        } else {
            Write-Host "    [Vercel]  ERROR: $($_.Exception.Message)" -ForegroundColor Red
        }
    }
}

function Get-RenderServiceId($onrenderHostname) {
    # Fetch all services and match by service slug in the URL
    $uri = "https://api.render.com/v1/services?limit=50"
    $headers = @{ "Authorization" = "Bearer $RenderApiKey" }
    try {
        $res = Invoke-RestMethod -Method GET -Uri $uri -Headers $headers
        $slug = $onrenderHostname -replace "\.onrender\.com$", ""
        $match = $res | Where-Object { $_.service.slug -eq $slug -or $_.service.name -like "*$slug*" } | Select-Object -First 1
        return $match.service.id
    } catch {
        Write-Host "    [Render]  Could not query services: $($_.Exception.Message)" -ForegroundColor Red
        return $null
    }
}

function Add-RenderDomain($serviceId, $subdomain) {
    $fqdn = "$subdomain.$Domain"
    $uri  = "https://api.render.com/v1/services/$serviceId/custom-domains"
    $headers = @{
        "Authorization" = "Bearer $RenderApiKey"
        "Content-Type"  = "application/json"
    }
    $body = '{"name":"' + $fqdn + '"}'
    try {
        Invoke-RestMethod -Method POST -Uri $uri -Headers $headers -Body $body | Out-Null
        Write-Host "    [Render]  Domain added: $fqdn" -ForegroundColor Green
    } catch {
        $errMsg = $_.ErrorDetails.Message
        if ($errMsg -like "*already*") {
            Write-Host "    [Render]  Already exists: $fqdn" -ForegroundColor Yellow
        } else {
            Write-Host "    [Render]  ERROR: $errMsg" -ForegroundColor Red
        }
    }
}

# ── Validate + credentials ────────────────────────────────────────────────────

if ($Platform -eq "Vercel" -and -not $VercelProject) { throw "-VercelProject is required when -Platform Vercel" }
if ($Platform -eq "Render" -and -not $RenderHost)    { throw "-RenderHost is required when -Platform Render" }

if (-not $GoDaddyKey) { $GoDaddyKey = Read-Host "GoDaddy Key (developer.godaddy.com/keys)" }
if ($Platform -eq "Vercel" -and -not $VercelToken)  { $VercelToken  = Read-Host "Vercel Token   (vercel.com/account/tokens)" }
if ($Platform -eq "Render" -and -not $RenderApiKey) { $RenderApiKey = Read-Host "Render API Key (dashboard.render.com → Account → API Keys)" }

# ── Main ──────────────────────────────────────────────────────────────────────

Write-Host "`n━━━ $Subdomain.$Domain  ($Platform) ━━━" -ForegroundColor Cyan

if ($Platform -eq "Vercel") {
    Add-VercelDomain $VercelProject $Subdomain
    Add-GoDaddyCNAME $Subdomain "cname.vercel-dns.com"
} else {
    $svcId = Get-RenderServiceId $RenderHost
    if ($svcId) {
        Add-RenderDomain $svcId $Subdomain
    } else {
        Write-Host "    [Render]  Service not found via API — add domain manually in Render dashboard." -ForegroundColor Yellow
    }
    Add-GoDaddyCNAME $Subdomain $RenderHost
}

Write-Host "`n━━━ Done ━━━" -ForegroundColor Green
Write-Host "Tanish's Setup Toolkit · tanisheesh.in · github.com/tanisheesh" -ForegroundColor DarkGray
Write-Host "DNS propagation: 2-10 min typically, up to 48h worst case." -ForegroundColor Gray

# ──────────────────────────────────────────────────────────────────────────
#  Tanish Poddar
#  Website   https://tanisheesh.in
#  LinkedIn  https://linkedin.com/in/tanisheesh
#  GitHub    https://github.com/tanisheesh
#  Email     hey@tanisheesh.in
# ──────────────────────────────────────────────────────────────────────────
