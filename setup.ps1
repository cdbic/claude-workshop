# Presenter prerequisites — Windows equivalent of the Brewfile.
# Requires Node.js (https://nodejs.org). Run: .\setup.ps1

npm install -g @marp-team/marp-cli        # render workshop/slides.md
npm install -g @anthropic-ai/claude-code  # Claude Code CLI (needs Pro/Max or an API key)
pip install anthropic                     # token-counter demo, see workshop/token-demo.md
# ant CLI (token demo option B): pre-built Windows binaries exist —
#   https://github.com/anthropics/anthropic-cli/releases (ant_<ver>_windows_amd64.zip, put ant.exe on PATH)
#   or with Go installed: go install github.com/anthropics/anthropic-cli/cmd/ant@latest

# rtk has no Windows package manager entry — install one of two ways:
#   1. Pre-built binary: https://github.com/rtk-ai/rtk/releases (put rtk.exe on PATH)
#   2. With Rust installed: cargo install rtk
if (-not (Get-Command rtk -ErrorAction SilentlyContinue)) {
    Write-Host "rtk not found - install from https://github.com/rtk-ai/rtk/releases, then run: rtk trust"
} else {
    Write-Host "rtk found - remember to run 'rtk trust' once inside this repo"
}
