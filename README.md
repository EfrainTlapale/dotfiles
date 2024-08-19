# dotfiles
My Dotfiles

## Setup

Install gnu `stow`

Clone this repo in $home eg. `~/dotfiles`

Cd into it and run `stow .`

## Git config

After "stowing" the dotfiles, add this snippet to `~/.gitconfig`

``` gitconfig
[include]
  path = ./.git-config-base
```


