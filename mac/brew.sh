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
brew install git-lfs
brew install gh
brew install gpg
brew install n
brew install rbenv
brew install imagemagick --with-webp
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
brew tap caskroom/cask

## Apps I use
brew cask install alfred
# brew cask install beamer
brew cask install dash
brew cask install dropbox
brew cask install homebrew/cask-versions/firefox-developer-edition # Firefox Dev Edition
brew cask install google-chrome # Chrome
brew cask install iterm2
brew cask install kap
brew cask install keycastr
# brew cask install sketch
brew cask install onlyoffice
brew cask install skitch
brew cask install skype
brew cask install slack
# brew cask install spotify
# brew cask install textexpander
# brew cask install tower
brew cask install virtualbox

# Remove outdated versions from the cellar.
brew cleanup
