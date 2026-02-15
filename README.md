# tmux config

Project-based tmux setup with session-per-project workflow. Works on macOS and Linux.

## Installation

```bash
# Clone to the XDG config location
git clone <your-repo-url> ~/.config/tmux

# Run setup (installs TPM, links sessionizer)
~/.config/tmux/setup.sh
```

If cloned elsewhere, the setup script will symlink to `~/.config/tmux` automatically.

After setup, open tmux and press `prefix + I` to install plugins.

## Project workflow

The core idea: **one tmux session per project**.

- `prefix + f` — opens fzf with directories under `~/Developer/`. Pick one and a session is created (or switched to if it exists). The session is named after the directory.
- `prefix + s` — list all sessions. Use this to jump between projects.
- `prefix + S` — create a named session manually.
- `prefix + d` — detach from current session (session stays alive in background).
- `tmux attach -t <name>` — reattach to a session from outside tmux.

## Keybindings

Prefix is `Ctrl-b` (default).

### Sessions

| Binding | Action |
|---|---|
| `prefix + f` | Sessionizer — fuzzy-find project, create/switch session |
| `prefix + s` | List sessions |
| `prefix + S` | Create new named session |
| `prefix + $` | Rename current session |
| `prefix + d` | Detach |

### Windows

| Binding | Action |
|---|---|
| `prefix + c` | New window (inherits current path) |
| `prefix + ,` | Rename window |
| `prefix + &` | Close window |
| `Alt+Shift+H` | Previous window |
| `Alt+Shift+L` | Next window |
| `prefix + <n>` | Jump to window n (1-9) |

### Panes

| Binding | Action |
|---|---|
| `prefix + \|` | Split horizontally |
| `prefix + -` | Split vertically |
| `prefix + h/j/k/l` | Navigate panes (vi-style) |
| `prefix + H/J/K/L` | Resize panes |
| `prefix + x` | Close pane |
| `prefix + z` | Toggle pane zoom (fullscreen) |

### Copy mode (vi)

| Binding | Action |
|---|---|
| `prefix + [` | Enter copy mode |
| `v` | Begin selection |
| `Ctrl-v` | Toggle rectangle selection |
| `y` | Yank to system clipboard |
| `q` | Exit copy mode |

### Other

| Binding | Action |
|---|---|
| `prefix + r` | Reload config |
| `prefix + I` | Install TPM plugins |
| `prefix + U` | Update TPM plugins |

## Plugins

Managed by [TPM](https://github.com/tmux-plugins/tpm):

- **tmux-sensible** — sensible default settings
- **tmux-yank** — cross-platform clipboard support (pbcopy/xclip/wl-copy)
- **rose-pine/tmux** — status bar theme (main variant)

## Repo structure

```
~/.config/tmux/
├── tmux.conf              # Main config
├── setup.sh               # Portable installer (macOS + Linux)
├── scripts/
│   └── tmux-sessionizer   # fzf session switcher
├── plugins/               # TPM plugins (git-ignored)
│   └── tpm/
└── README.md
```

## Dependencies

| Tool | Required | Install |
|---|---|---|
| tmux | Yes | `brew install tmux` / `apt install tmux` |
| git | Yes | `brew install git` / `apt install git` |
| fzf | For sessionizer | `brew install fzf` / `apt install fzf` |
| xclip / wl-copy | Linux clipboard | `apt install xclip` / `apt install wl-clipboard` |
