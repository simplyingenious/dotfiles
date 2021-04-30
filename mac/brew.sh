#!/usr/bin/env bash

# Install Homebrew (if not installed)
echo "Installing Homebrew."

# Make sure we’re using the latest Homebrew.
brew update

# Upgrade any already-installed formulae.
brew upgrade

# Save Homebrew’s installed location.
BREW_PREFIX=$(brew --prefix)

# Install and setup Mongodb
# brew tap mongodb/brew
# brew install mongodb-community
# sudo mkdir -p /System/Volumes/Data/data/db
# sudo chown -R `id -un` /System/Volumes/Data/data/db

# Install GNU core utilities (those that come with macOS are outdated).
# Don’t forget to add `$(brew --prefix coreutils)/libexec/gnubin` to `$PATH`.
brew install coreutils
ln -s "${BREW_PREFIX}/bin/gsha256sum" "${BREW_PREFIX}/bin/sha256sum"

# Install some other useful utilities like `sponge`.
brew install moreutils
# Install GNU `find`, `locate`, `updatedb`, and `xargs`, `g`-prefixed.
brew install findutils
# Install GNU `sed` as gsed
brew install gnu-sed

# Install `wget` with IRI support.
brew install wget

brew install gmp
brew install grep
brew install ripgrep
# brew install node

# Install useful binaries.
brew install ack
brew install antibody
brew install autojump
brew install docker
brew install docker-machine
brew install ffmpeg
brew install fzf
brew install git
brew install git-delta
brew install git-lfs
brew install gh
brew install gpg
brew install n
brew install rbenv
brew install imagemagick --with-webp
brew install mas
brew install nmap
brew install p7zip
brew install pigz
brew install pv
brew install rsync
brew install rename
brew install ssh-copy-id
brew install tree
brew install vbindiff
brew install youtube-dl
brew install bat
brew install prettyping
brew install ncdu
brew install tldr

# Installs Casks
brew tap homebrew/cask-fonts

# Installs fonts for code
brew install --cask font-cascadia-code
brew install --cask font-cascadia-code-pl
brew install --cask font-fantasque-sans-mono
brew install --cask font-ibm-plex-mono
brew install --cask font-iosevka
brew install --cask font-jetbrains-mono
brew install --cask font-juliamono
brew install --cask font-lilex
brew install --cask font-nanum-gothic-coding
brew install --cask font-recursive
brew install --cask font-victor-mono

## Apps I use
brew install --cask alfred
brew install --cask appcleaner
# brew install --cask beamer
brew install --cask dash
brew install --cask dropbox
brew install --cask homebrew/cask-versions/firefox-developer-edition # Firefox Dev Edition
brew install --cask google-chrome # Chrome
brew install --cask iconset
brew install --cask iina
brew install --cask iterm2
brew install --cask kap
brew install --cask keycastr
# brew install --cask sketch
brew install --cask onlyoffice
brew install --cask rectangle
brew install --cask skitch
brew install --cask skype
brew install --cask slack
brew install --cask textexpander
brew install --cask virtualbox
brew install --cask vnc-viewer
brew install --cask zoomus

# Remove outdated versions from the cellar.
brew cleanup
