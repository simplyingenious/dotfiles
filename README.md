# Device installation scripts for Mac

This repository was inspired by [Mathias Bynens' dotfiles](https://github.com/mathiasbynens/dotfiles) repository. Although I copied many things from him, I also deleted many things to suit my custom installation. Use this at your own risk!
## Run `./install`

[Dotbot](https://github.com/anishathalye/dotbot) is being used to setup the system

What this does:

- Installs Homebrew
- Installs binaries and apps with Homebrew (see [Brewfile](mac/Brewfile) for a list of installed items)
- Sets permissions on `/usr/local`
- Sets up ZSH plugins using antibody
- Installs Node LTS version using `n`
- Installs npm clis (see [npm.sh](shared/npm.sh) for a list of installed clis)
- Create symlinks for dotfiles
- Sets up GitHub CLI
- Sets several defaults for MacOS
