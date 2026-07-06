# Presenter prerequisites — Windows equivalent of the Brewfile.
# Requires Node.js (https://nodejs.org). Run: .\setup.ps1

npm install -g @marp-team/marp-cli        # render workshop/slides.md
npm install -g @anthropic-ai/claude-code  # Claude Code CLI (needs Pro/Max or an API key)

# rtk has no Windows package manager entry — install one of two ways:
#   1. Pre-built binary: https://github.com/rtk-ai/rtk/releases (put rtk.exe on PATH)
#   2. With Rust installed: cargo install rtk
if (-not (Get-Command rtk -ErrorAction SilentlyContinue)) {
    Write-Host "rtk not found - install from https://github.com/rtk-ai/rtk/releases, then run: rtk trust"
} else {
    Write-Host "rtk found - remember to run 'rtk trust' once inside this repo"
}

# pwsh (PowerShell 7) runs the token/context status line (.claude/statusline.ps1) —
# legacy Windows PowerShell 5.1 may be locked to AllSigned and refuse to run it.
if (-not (Get-Command pwsh -ErrorAction SilentlyContinue)) {
    Write-Host "pwsh not found - required for the status-line demo. Install: winget install --id Microsoft.PowerShell"
}
