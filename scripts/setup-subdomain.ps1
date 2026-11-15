# ╔══════════════════════════════════════════════════════════════════════╗
# ║  TANISH'S SETUP TOOLKIT                                              ║
# ║  The standard for every repo by Tanish Poddar · tanisheesh.in        ║
# ╚══════════════════════════════════════════════════════════════════════╝
#
# setup-subdomain.ps1
# Adds ONE <subdomain>.tanisheesh.in CNAME in GoDaddy (and attaches the
# custom domain on Vercel or Render automatically when those platforms are used).
#
# Usage:
#   Vercel:
#     .\setup-subdomain.ps1 -Subdomain "<prefix>" -Platform Vercel -VercelProject "<vercel-project-slug>"
#   Render:
#     .\setup-subdomain.ps1 -Subdomain "<prefix>" -Platform Render -RenderHost "<service>.onrender.com"
#   Railway:
#     .\setup-subdomain.ps1 -Subdomain "<prefix>" -Platform Railway -TargetHost "<app>.up.railway.app"
#   GitHub Pages:
#     .\setup-subdomain.ps1 -Subdomain "<prefix>" -Platform GitHubPages
#   Custom (Firebase App Hosting, etc.):
#     .\setup-subdomain.ps1 -Subdomain "<prefix>" -Platform Custom -TargetHost "<cname-target>"

param(
    [Parameter(Mandatory)][string]$Subdomain,
    [Parameter(Mandatory)][ValidateSet("Vercel", "Render", "Railway", "GitHubPages", "Custom")][string]$Platform,
    [string]$VercelProject,
    [string]$RenderHost,
    [string]$TargetHost,
    [string]$Owner        = "tanisheesh",
    [string]$Domain       = "tanisheesh.in",
    [string]$VercelToken  = $env:VERCEL_TOKEN,
    [string]$GoDaddyKey   = $env:GODADDY_KEY,
    [string]$RenderApiKey = $env:RENDER_API_KEY
)

# ── Helpers ───────────────────────────────────────────────────────────────────

function Read-RequiredSecret([string]$prompt, [string]$envName) {
    if ([Console]::IsInputRedirected) {
        throw "Missing $envName in environment (non-interactive shell cannot prompt)."
    }
    return (Read-Host $prompt)
}

function Get-HttpErrorText($errRecord) {
    if ($errRecord.ErrorDetails -and $errRecord.ErrorDetails.Message) {
        return $errRecord.ErrorDetails.Message
    }
    return $errRecord.Exception.Message
}

function Get-VercelCliToken {
    $candidates = @(
        (Join-Path $env:APPDATA "com.vercel.cli\Data\auth.json"),
        (Join-Path $env:LOCALAPPDATA "com.vercel.cli\Data\auth.json")
    )
    foreach ($authPath in $candidates) {
        if ($authPath -and (Test-Path $authPath)) {
            try {
                $tok = (Get-Content $authPath -Raw | ConvertFrom-Json).token
                if ($tok) { return $tok }
            } catch {}
        }
    }
    return $null
}

function Add-GoDaddyCNAME($subdomainName, $target) {
    $gddyExe = "$env:LOCALAPPDATA\Programs\gddy\gddy.exe"
    if ($gddyExe -and (Test-Path $gddyExe)) {
        try {
            $out = & $gddyExe dns set $Domain --type CNAME --name $subdomainName --data $target --ttl 600 2>&1 | Out-String
            if ($LASTEXITCODE -eq 0) {
                Write-Host "    [GoDaddy] CNAME: $subdomainName.$Domain -> $target (via gddy CLI)" -ForegroundColor Green
                return
            }
            if ($out -match "already has conflicting CNAME data") {
                Write-Host "    [GoDaddy] gddy reported CNAME conflict; attempting REST API overwrite..." -ForegroundColor Yellow
            } else {
                Write-Host "    [GoDaddy] gddy CLI failed ($($out.Trim())); falling back to REST API..." -ForegroundColor Yellow
            }
        } catch {
            Write-Host "    [GoDaddy] gddy CLI error: $($_.Exception.Message); falling back to REST API..." -ForegroundColor Yellow
        }
    }

    if (-not $GoDaddyKey) {
        $GoDaddyKey = Read-RequiredSecret "GoDaddy Key (developer.godaddy.com/keys, format KEY:SECRET)" "GODADDY_KEY"
    }

    $uri = "https://api.godaddy.com/v1/domains/$Domain/records/CNAME/$subdomainName"
    $body = ConvertTo-Json @(@{ data = $target; ttl = 600 }) -Compress
    $lastErr = $null

    foreach ($authHeader in @("sso-key $GoDaddyKey", "Bearer $GoDaddyKey")) {
        $headers = @{ "Authorization" = $authHeader; "Content-Type" = "application/json" }
        try {
            Invoke-RestMethod -Method PUT -Uri $uri -Headers $headers -Body $body | Out-Null
            Write-Host "    [GoDaddy] CNAME: $subdomainName.$Domain -> $target" -ForegroundColor Green
            return
        } catch {
            $lastErr = Get-HttpErrorText $_
            if ($authHeader -notlike "Bearer*") { continue }
        }
    }
    Write-Host "    [GoDaddy] ERROR: $lastErr" -ForegroundColor Red
}

function Add-VercelDomain($projectSlug, $subdomainName) {
    $fqdn = "$subdomainName.$Domain"
    $cliToken = Get-VercelCliToken
    $tokens = @($VercelToken, $cliToken) | Where-Object { $_ } | Select-Object -Unique

    if ($tokens.Count -eq 0) {
        $tokens = @(Read-RequiredSecret "Vercel Token (vercel.com/account/tokens)" "VERCEL_TOKEN")
    }

    $lastErr = $null
    foreach ($tok in $tokens) {
        $uri = "https://api.vercel.com/v9/projects/$projectSlug/domains"
        $headers = @{
            "Authorization" = "Bearer $tok"
            "Content-Type"  = "application/json"
        }
        $body = ConvertTo-Json @{ name = $fqdn }
        try {
            Invoke-RestMethod -Method POST -Uri $uri -Headers $headers -Body $body | Out-Null
            Write-Host "    [Vercel]  Domain added: $fqdn" -ForegroundColor Green
            return
        } catch {
            $rawMsg = Get-HttpErrorText $_
            $lastErr = $rawMsg
            if ($rawMsg) {
                $err = $rawMsg | ConvertFrom-Json -ErrorAction SilentlyContinue
                if ($err.error.code -eq "domain_already_in_use" -or $err.error.code -eq "project_domain_already_exists") {
                    Write-Host "    [Vercel]  Already exists: $fqdn" -ForegroundColor Yellow
                    return
                }
            }
        }
    }
    Write-Host "    [Vercel]  ERROR: Failed to add $fqdn ($lastErr)" -ForegroundColor Red
}

function Get-RenderServiceId($onrenderHostname) {
    $headers = @{ "Authorization" = "Bearer $RenderApiKey" }
    $slug = $onrenderHostname -replace "\.onrender\.com$", ""
    $cursor = $null
    $all = @()

    try {
        do {
            $uri = "https://api.render.com/v1/services?limit=100"
            if ($cursor) { $uri += "&cursor=$([uri]::EscapeDataString($cursor))" }
            $res = Invoke-RestMethod -Method GET -Uri $uri -Headers $headers
            if (-not $res -or $res.Count -eq 0) { break }
            $all += $res
            $cursor = $res[-1].cursor
        } while ($res.Count -eq 100 -and $cursor)

        # Prefer exact slug or exact URL hostname match before wildcard name match
        $exact = $all | Where-Object {
            if ($_.service.slug -eq $slug) { return $true }
            if ($_.service.serviceDetails.url) {
                $parsedUri = $null
                if ([uri]::TryCreate($_.service.serviceDetails.url, [System.UriKind]::Absolute, [ref]$parsedUri)) {
                    return ($parsedUri.Host -eq $onrenderHostname)
                }
            }
            return $false
        } | Select-Object -First 1
        if ($exact) { return $exact.service.id }

        $fuzzy = $all | Where-Object { $_.service.name -like "*$slug*" } | Select-Object -First 1
        return $fuzzy.service.id
    } catch {
        Write-Host "    [Render]  Could not query services: $(Get-HttpErrorText $_)" -ForegroundColor Red
        return $null
    }
}

function Add-RenderDomain($serviceId, $subdomainName) {
    $fqdn = "$subdomainName.$Domain"
    $uri  = "https://api.render.com/v1/services/$serviceId/custom-domains"
    $headers = @{
        "Authorization" = "Bearer $RenderApiKey"
        "Content-Type"  = "application/json"
    }
    $body = ConvertTo-Json @{ name = $fqdn }
    try {
        Invoke-RestMethod -Method POST -Uri $uri -Headers $headers -Body $body | Out-Null
        Write-Host "    [Render]  Domain added: $fqdn" -ForegroundColor Green
        return $true
    } catch {
        $errMsg = Get-HttpErrorText $_
        if ($errMsg -like "*already*") {
            Write-Host "    [Render]  Already exists: $fqdn" -ForegroundColor Yellow
            return $true
        }
        Write-Host "    [Render]  ERROR: $errMsg" -ForegroundColor Red
        return $false
    }
}

# ── Validate + credentials ────────────────────────────────────────────────────

if ($Platform -eq "Vercel" -and -not $VercelProject) { throw "-VercelProject is required when -Platform Vercel" }
if ($Platform -eq "Render" -and -not $RenderHost)    { throw "-RenderHost is required when -Platform Render" }
if ($Platform -eq "Railway" -and -not $TargetHost)   { throw "-TargetHost is required when -Platform Railway (e.g. <id>.up.railway.app)" }
if ($Platform -eq "Custom" -and -not $TargetHost)    { throw "-TargetHost is required when -Platform Custom" }
if ($Platform -eq "GitHubPages" -and -not $TargetHost) { $TargetHost = "$Owner.github.io" }

$gddyCliPath = "$env:LOCALAPPDATA\Programs\gddy\gddy.exe"
if (-not $GoDaddyKey -and -not (Test-Path $gddyCliPath)) {
    $GoDaddyKey = Read-RequiredSecret "GoDaddy Key (developer.godaddy.com/keys, format KEY:SECRET)" "GODADDY_KEY"
}
if ($Platform -eq "Vercel" -and -not $VercelToken -and -not (Get-VercelCliToken)) {
    $VercelToken = Read-RequiredSecret "Vercel Token (vercel.com/account/tokens)" "VERCEL_TOKEN"
}
if ($Platform -eq "Render" -and -not $RenderApiKey) {
    $RenderApiKey = Read-RequiredSecret "Render API Key (dashboard.render.com -> Account -> API Keys)" "RENDER_API_KEY"
}

# ── Main ──────────────────────────────────────────────────────────────────────

Write-Host "`n━━━ $Subdomain.$Domain  ($Platform) ━━━" -ForegroundColor Cyan

if ($Platform -eq "Vercel") {
    Add-VercelDomain $VercelProject $Subdomain
    Add-GoDaddyCNAME $Subdomain "cname.vercel-dns.com"
} elseif ($Platform -eq "Render") {
    $svcId = Get-RenderServiceId $RenderHost
    if ($svcId) {
        $ok = Add-RenderDomain $svcId $Subdomain
        if ($ok) {
            Add-GoDaddyCNAME $Subdomain $RenderHost
        } else {
            Write-Host "    [GoDaddy] Skipped CNAME because Render domain step failed." -ForegroundColor Yellow
        }
    } else {
        Write-Host "    [Render]  Service '$RenderHost' not found via API — skipping GoDaddy CNAME. Add domain in Render dashboard first." -ForegroundColor Yellow
    }
} else {
    Add-GoDaddyCNAME $Subdomain $TargetHost
    if ($Platform -eq "Railway") {
        Write-Host "    [Railway] Remember to also add '$Subdomain.$Domain' under Railway Service -> Settings -> Networking -> Custom Domain." -ForegroundColor Yellow
    } elseif ($Platform -eq "GitHubPages") {
        Write-Host "    [Pages]   Remember to set Custom domain = '$Subdomain.$Domain' in GitHub Repo -> Settings -> Pages (or commit a CNAME file)." -ForegroundColor Yellow
    } else {
        Write-Host "    [Custom]  Remember to bind '$Subdomain.$Domain' in the target host dashboard." -ForegroundColor Yellow
    }
}

Write-Host "`n━━━ Done ━━━" -ForegroundColor Green
Write-Host "Tanish's Setup Toolkit · tanisheesh.in · github.com/tanisheesh" -ForegroundColor DarkGray
Write-Host "DNS propagation: 2-10 min typically, up to 48h worst case." -ForegroundColor Gray

# ──────────────────────────────────────────────────────────────────────────
#  Tanish Poddar
#  Website   https://tanisheesh.in
#  LinkedIn  https://linkedin.com/in/tanisheesh
#  GitHub    https://github.com/tanisheesh
#  Email     hi@tanisheesh.in
# ──────────────────────────────────────────────────────────────────────────
