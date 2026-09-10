# dotfiles

My dotfiles, linked into `$HOME` with GNU stow. Used on both Linux and macOS.

## What's in here

- Wezterm config
- Neovim config
- Git config
- Other cli tools config

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

