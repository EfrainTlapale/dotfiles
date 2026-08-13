# dotfiles

My dotfiles, linked into `$HOME` with GNU stow. Used on both Linux and macOS.

## What's in here

| Path | What it configures |
| --- | --- |
| `.zshrc` | zsh, via oh-my-zsh — aliases, git/bluetooth/input helpers, per-OS setup |
| `.oh-my-zsh/custom/themes/minimal.zsh-theme` | the prompt |
| `.git-config-base` | git settings, aliases and delta; included from `~/.gitconfig` |
| `.wezterm.lua`, `wezterm.sh` | WezTerm config and its shell integration |
| `.config/kitty/` | Kitty, as an alternative terminal |
| `.config/nvim/` | Neovim — lazy.nvim plugins, LSP, colorschemes |
| `.config/lazygit/` | lazygit |
| `.local/bin/` | standalone helper scripts (see below) |
| `.stow-local-ignore` | what stow should *not* link into `$HOME` |

## Scripts

| Script | What it does |
| --- | --- |
| `.local/bin/thermal-check` | Samples CPU temperature, clocks and Intel throttle counters under a synthetic load, so cooling work can be measured. Linux + Intel only. |

### thermal-check

Records a 30s idle baseline then a load phase, and writes a TSV per run under
`~/.local/state/thermal-check/`. The point is the before/after pair:

```sh
thermal-check run -l before-repaste      # 5 min load, then clean the fans
thermal-check run -l after-repaste
thermal-check compare before-repaste after-repaste
```

Falls back to `yes` × `nproc` for load when `stress-ng` isn't installed. Package
watts come from Intel RAPL, which is root-only since kernel 5.10 — run under
`sudo` if you want that column, everything else works unprivileged. Compare AC
runs to AC runs; power limits differ on battery, and the script warns if so.

## Setup

Install GNU `stow`, clone this repo into `$HOME` (so `~/dotfiles`), then:

```sh
cd ~/dotfiles
stow -n -v .   # dry run: check what would be linked
stow .
```

`stow` refuses to overwrite existing real files, so move any conflicting
`~/.zshrc` etc. out of the way first.

### Git config

Stow links `~/.git-config-base`, but git won't read it on its own. Add this to
`~/.gitconfig` (which stays untracked, since it holds the user identity):

```gitconfig
[include]
  path = ~/.git-config-base
```

### Dependencies

Everything below is optional in the sense that `.zshrc` no longer errors when a
tool is missing — but the config assumes these:

- **Required:** `zsh`, [oh-my-zsh](https://ohmyz.sh), `stow`, `git`
- **oh-my-zsh custom plugin** (not tracked here, install separately):
  [`zsh-autosuggestions`](https://github.com/zsh-users/zsh-autosuggestions)
  into `~/.oh-my-zsh/custom/plugins/`
- **Shell tools:** `fzf`, `zoxide` (bound to `j`), `fd`, `delta`, `lazygit`
- **Editor:** `nvim` (installed via [bob](https://github.com/MordechaiHadad/bob);
  the WezTerm config puts `~/.local/share/bob/nvim-bin` on `PATH`)
- **Terminal font:** FiraCode Nerd Font
- **Optional runtimes:** `go`, `deno`, `nvm`
- **Formatters** used by nvim's conform setup, when on `PATH`: `ruff` (Python),
  `stylua`, `prettier`/`biome`, `gofumpt`, `rustfmt`
- **Linux extras** for the input/bluetooth helpers: `xinput`, `gsettings`,
  `bluetoothctl`, `notify-send`. On macOS: `blueutil`.

## Notes

- **Secrets stay out.** `~/.gitconfig`, `.netrc` and
  `.config/nvim/.env.local` (API keys for nvim plugins) are gitignored, and
  stow skips `.netrc`.
- **Worktrees.** `git wta <branch>` creates a worktree under
  `~/worktrees/<repo>/<branch>`; `gwtcd <branch>` cds into one (with
  tab-completion), `git wtl` lists them, `git wtr <branch>` removes one.
- **Adding a new config directory.** `.gitignore` is an allowlist — it ignores
  `*` and then re-includes specific paths. A new `.config/foo/` is invisible to
  git until you add `!.config/foo` and `!.config/foo/**` to it.
