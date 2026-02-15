#!/usr/bin/env bash
set -euo pipefail

TMUX_DIR="$(cd "$(dirname "$0")" && pwd)"

# ── Helpers ────────────────────────────────────────────────────────
info()  { printf "\033[1;34m[info]\033[0m  %s\n" "$1"; }
ok()    { printf "\033[1;32m[ok]\033[0m    %s\n" "$1"; }
warn()  { printf "\033[1;33m[warn]\033[0m  %s\n" "$1"; }
err()   { printf "\033[1;31m[error]\033[0m %s\n" "$1"; exit 1; }

OS="$(uname -s)"

# ── Check dependencies ─────────────────────────────────────────────
check_dep() {
    if ! command -v "$1" &>/dev/null; then
        return 1
    fi
    return 0
}

info "Checking dependencies..."

if ! check_dep tmux; then
    err "tmux is not installed. Install it first:
    macOS:  brew install tmux
    Ubuntu: sudo apt install tmux
    Fedora: sudo dnf install tmux"
fi

if ! check_dep fzf; then
    warn "fzf is not installed (needed for sessionizer). Install it:
    macOS:  brew install fzf
    Ubuntu: sudo apt install fzf
    Fedora: sudo dnf install fzf"
fi

if ! check_dep git; then
    err "git is not installed."
fi

ok "Dependencies look good (tmux $(tmux -V | cut -d' ' -f2))"

# ── Symlink tmux config ───────────────────────────────────────────
CONFIG_DIR="$HOME/.config/tmux"

if [ "$TMUX_DIR" != "$CONFIG_DIR" ]; then
    info "Linking config to $CONFIG_DIR..."

    if [ -e "$CONFIG_DIR" ] && [ ! -L "$CONFIG_DIR" ]; then
        warn "$CONFIG_DIR already exists and is not a symlink. Backing up to ${CONFIG_DIR}.bak"
        mv "$CONFIG_DIR" "${CONFIG_DIR}.bak"
    fi

    mkdir -p "$(dirname "$CONFIG_DIR")"
    ln -sfn "$TMUX_DIR" "$CONFIG_DIR"
    ok "Symlinked $TMUX_DIR -> $CONFIG_DIR"
else
    ok "Repo is already at $CONFIG_DIR"
fi

# ── Install TPM ───────────────────────────────────────────────────
TPM_DIR="$CONFIG_DIR/plugins/tpm"

if [ -d "$TPM_DIR" ]; then
    ok "TPM already installed"
else
    info "Cloning TPM..."
    git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
    ok "TPM installed"
fi

# ── Install sessionizer ───────────────────────────────────────────
BIN_DIR="$HOME/.local/bin"
mkdir -p "$BIN_DIR"

SESSIONIZER_SRC="$TMUX_DIR/scripts/tmux-sessionizer"
SESSIONIZER_DST="$BIN_DIR/tmux-sessionizer"

if [ -L "$SESSIONIZER_DST" ] || [ -e "$SESSIONIZER_DST" ]; then
    rm -f "$SESSIONIZER_DST"
fi

ln -s "$SESSIONIZER_SRC" "$SESSIONIZER_DST"
ok "Sessionizer linked to $SESSIONIZER_DST"

# ── Verify ~/.local/bin is in PATH ─────────────────────────────────
if ! echo "$PATH" | tr ':' '\n' | grep -qx "$BIN_DIR"; then
    warn "$BIN_DIR is not in your PATH. Add this to your shell profile:
    export PATH=\"\$HOME/.local/bin:\$PATH\""
fi

# ── Install clipboard tool on Linux ────────────────────────────────
if [ "$OS" = "Linux" ]; then
    if ! check_dep xclip && ! check_dep xsel && ! check_dep wl-copy; then
        warn "No clipboard tool found. tmux-yank needs one of: xclip, xsel, wl-copy
    X11:     sudo apt install xclip
    Wayland: sudo apt install wl-clipboard"
    fi
fi

# ── Done ──────────────────────────────────────────────────────────
echo ""
ok "Setup complete!"
echo ""
info "Next steps:"
echo "  1. Start tmux:        tmux"
echo "  2. Install plugins:   prefix + I  (capital I)"
echo "  3. Sessionizer:       prefix + f"
echo ""
