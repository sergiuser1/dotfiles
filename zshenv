export ZDOTDIR="$HOME"/.config/zsh

# Zscaler TLS interception fix for Python/az data-plane calls (App Insights, Log Analytics)
export REQUESTS_CA_BUNDLE=/etc/ssl/certs/ca-certificates.crt

# Local secrets
[ -f "$HOME/.env" ] && source "$HOME/.env"

export CLEARING_COPILOT_ROOT="$HOME/git/clearing.copilot"
