#!/usr/bin/env bash
# ~/.dotfiles/install.sh -- Coder runs this on every workspace start.
# Public repo: tools + generic config only. Personal/secret config lives on
# the NAS at /hdd_nas/dev_config and is symlinked in below.
set -uo pipefail
BIN="$HOME/.local/bin"; mkdir -p "$BIN" ~/.claude
grep -q '.local/bin' ~/.bashrc 2>/dev/null || echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
export PATH="$BIN:$PATH"
have(){ command -v "$1" >/dev/null 2>&1; }

# --- cluster tools (pinned, direct binaries, no sudo) ---
have kubectl  || { curl -sLo /tmp/k https://dl.k8s.io/release/v1.34.7/bin/linux/amd64/kubectl; install -m0755 /tmp/k "$BIN/kubectl"; }
have kubeseal || { curl -sL https://github.com/bitnami-labs/sealed-secrets/releases/download/v0.36.6/kubeseal-0.36.6-linux-amd64.tar.gz | tar xz -C /tmp kubeseal; install -m0755 /tmp/kubeseal "$BIN/kubeseal"; }
have helm     || { HV=$(curl -fsSL https://api.github.com/repos/helm/helm/releases/latest | grep -oP '"tag_name":\s*"\K[^"]+'); curl -fsSL "https://get.helm.sh/helm-${HV}-linux-amd64.tar.gz" | tar xz -C /tmp; install -m0755 /tmp/linux-amd64/helm "$BIN/helm"; }
have gh       || { GV=$(curl -fsSL https://api.github.com/repos/cli/cli/releases/latest | grep -oP '"tag_name":\s*"v\K[^"]+'); curl -fsSLo /tmp/gh.tgz "https://github.com/cli/cli/releases/download/v${GV}/gh_${GV}_linux_amd64.tar.gz"; tar xzf /tmp/gh.tgz -C /tmp; install -m0755 "/tmp/gh_${GV}_linux_amd64/bin/gh" "$BIN/gh"; }

# --- python (uv) + Claude Code (official installers; from astral.sh / claude.ai) ---
have uv     || curl -LsSf https://astral.sh/uv/install.sh | sh
have claude || curl -fsSL https://claude.ai/install.sh | bash

# --- node (for the Next.js frontend) via nvm, no sudo ---
if ! have node; then
  export NVM_DIR="$HOME/.nvm"; mkdir -p "$NVM_DIR"
  curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
  . "$NVM_DIR/nvm.sh"; nvm install --lts >/dev/null 2>&1 || true
  corepack enable 2>/dev/null || true
fi

# --- personal / secret config from the NAS (kept OUT of this public repo) ---
PRIV=/hdd_nas/dev_config
[ -f "$PRIV/CLAUDE.md" ]     && ln -sf "$PRIV/CLAUDE.md"     ~/.claude/CLAUDE.md
[ -f "$PRIV/settings.json" ] && ln -sf "$PRIV/settings.json" ~/.claude/settings.json
[ -d "$PRIV/claude-rules" ]  && ln -sfn "$PRIV/claude-rules" ~/.claude/rules
[ -f "$PRIV/.gitconfig" ]    && cp "$PRIV/.gitconfig" ~/.gitconfig

# --- generic git config fallback (public-safe) ---
git config --global init.defaultBranch main
git config --global --get user.name  >/dev/null 2>&1 || git config --global user.name  "David-Antolick"
git config --global --get user.email >/dev/null 2>&1 || git config --global user.email "dantolick19@gmail.com"

echo "dotfiles ready. Run 'claude' and log in once (auth persists in the home volume)."
