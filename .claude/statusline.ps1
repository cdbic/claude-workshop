# Run via `pwsh`, not the legacy `powershell.exe` — this machine's Windows PowerShell 5.1
# is locked to AllSigned and refuses to load an unsigned local script; pwsh (PowerShell 7)
# defaults to RemoteSigned, which allows it. See .claude/settings.json's statusLine command.
$data = $input | Out-String | ConvertFrom-Json

$model = $data.model.display_name
$dir = Split-Path $data.workspace.current_dir -Leaf

$pct = 0
if ($null -ne $data.context_window.used_percentage) {
    $pct = [math]::Round($data.context_window.used_percentage)
}
$barWidth = 10
$filled = [math]::Floor($pct * $barWidth / 100)
$bar = ('#' * $filled) + ('.' * ($barWidth - $filled))

$cost = 0
if ($null -ne $data.cost.total_cost_usd) { $cost = $data.cost.total_cost_usd }
$costFmt = '$' + ("{0:F2}" -f $cost)

function Format-ResetIn($epochSeconds) {
    if (-not $epochSeconds) { return $null }
    $span = [DateTimeOffset]::FromUnixTimeSeconds($epochSeconds).LocalDateTime - (Get-Date)
    if ($span.TotalSeconds -le 0) { return "now" }
    if ($span.TotalDays -ge 1) { return "{0}d{1}h" -f [int]$span.TotalDays, $span.Hours }
    if ($span.TotalHours -ge 1) { return "{0}h{1}m" -f [int]$span.TotalHours, $span.Minutes }
    return "{0}m" -f [int]$span.TotalMinutes
}

$fiveH = $data.rate_limits.five_hour.used_percentage
$sevenD = $data.rate_limits.seven_day.used_percentage
$fiveHReset = Format-ResetIn $data.rate_limits.five_hour.resets_at
$sevenDReset = Format-ResetIn $data.rate_limits.seven_day.resets_at
$sessionStr = if ($null -ne $fiveH) { "session $([math]::Round(100 - $fiveH))% left (resets ${fiveHReset})" } else { "session n/a" }
$weekStr = if ($null -ne $sevenD) { "week $([math]::Round(100 - $sevenD))% left (resets ${sevenDReset})" } else { "week n/a" }

# Cumulative tokens burned this session: statusline JSON only gives the last
# API call's usage, so sum every assistant turn's usage block from the transcript instead.
$tokensBurned = 0
$transcriptPath = $data.transcript_path
if ($transcriptPath -and (Test-Path $transcriptPath)) {
    Get-Content $transcriptPath | ForEach-Object {
        if ($_.Trim()) {
            try {
                $usage = ($_ | ConvertFrom-Json).message.usage
                if ($usage) {
                    $tokensBurned += [int]$usage.input_tokens + [int]$usage.output_tokens `
                        + [int]$usage.cache_creation_input_tokens + [int]$usage.cache_read_input_tokens
                }
            } catch {}
        }
    }
}

$tokensFmt = if ($tokensBurned -ge 1000000) { "{0:N2}M" -f ($tokensBurned / 1000000) }
    elseif ($tokensBurned -ge 1000) { "{0:N2}k" -f ($tokensBurned / 1000) }
    else { "$tokensBurned" }

Write-Host "[$model] $dir | ctx $bar $pct% | $costFmt"
Write-Host "$sessionStr | $weekStr | $tokensFmt tokens"
