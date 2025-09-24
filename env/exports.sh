#!/usr/bin/env zsh
eval "$(/opt/homebrew/bin/brew shellenv)"
# source $HOME/.zsh-plugins.sh

# Set Visual Studio Code as the default editor
export EDITOR="nvim"

# Make Python use UTF-8 encoding for output to stdin, stdout, and stderr.
export PYTHONIOENCODING='UTF-8';

# History
# https://kevinjalbert.com/more-shell-history/
# https://unix.stackexchange.com/a/273863
# Increase Bash history size. Allow 32^4 entries; the default is 500.
export HISTSIZE='1048576';
export HISTFILESIZE="${HISTSIZE}";
# Omit duplicates and commands that begin with a space from history.
export HISTCONTROL='ignoreboth';
# History won't be saved without the following command
# This isn't set by default.
export HISTFILE="$HOME/.zsh_history"

# Do not display a line previously found.
setopt HIST_FIND_NO_DUPS
# Delete old recorded entry if new entry is a duplicate.
setopt HIST_IGNORE_ALL_DUPS
# Write to the history file immediately, not when the shell exits.
setopt INC_APPEND_HISTORY
# Share history between all sessions.
setopt SHARE_HISTORY

# Prefer US English and use UTF-8.
export LANG='en_US.UTF-8';
export LC_ALL='en_US.UTF-8';

# Highlight section titles in manual pages.
export LESS_TERMCAP_md="${yellow}";

# Don’t clear the screen after quitting a manual page.
export MANPAGER='less -X';

# Avoid issues with `gpg` as installed via Homebrew.
# https://stackoverflow.com/a/42265848/96656
export GPG_TTY=$(tty);

export CONCURRENTLY_KILL_OTHERS=true
export CONCURRENTLY_HANDLE_INPUT=true

# fast ruby version manager
# eval "$(frum init)"

# fast node manager
eval "$(fnm env --use-on-cd)"

# mise, The front-end to your dev env
eval "$($(brew --prefix)/bin/mise activate zsh)"

# Bind UP and DOWN arrow keys
# Copied from https://github.com/zsh-users/zsh-history-substring-search/tree/47a7d416c652a109f6e8856081abc042b50125f4#usage
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# # Word style: directory delimiter
# # http://stackoverflow.com/a/1438523
# #
# autoload -U select-word-style
# select-word-style bash

# case insensitive (all), partial-word and substring completion
# https://github.com/robbyrussell/oh-my-zsh/blob/e8aba1bf5912f89f408eaebd1bc74c25ba32a62c/lib/completion.zsh#L23
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'
# Menu selection
# http://www.masterzen.fr/2009/04/19/in-love-with-zsh-part-one/
# Highlight
zstyle ':completion:*' menu select
# Tag name as group name
zstyle ':completion:*' group-name ''
# Format group names
zstyle ':completion:*' format '%B---- %d%b'

[ -f $HOME/.fzf.zsh ] && source $HOME/.fzf.zsh

# good alternative to `cd`
eval "$(zoxide init zsh)"

# Load .env file
if [[ -f .env ]]; then
  set -a
  source .env
  set +a
fi

# Setting PATHs
# export PATH="`brew --prefix coreutils`/libexec/gnubin:$PATH"
# export PATH="`brew --prefix`/opt/unbound/sbin:$PATH"
# export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"
export PATH="$HOME/node_modules/.bin:$PATH"

if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi

# Bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# bun completions
[ -s "/Users/salmanjaved/.bun/_bun" ] && source "/Users/salmanjaved/.bun/_bun"

# antidote
# clone antidote if necessary and generate a static plugin file
zhome=${ZDOTDIR:-$HOME}
if [[ ! $zhome/.zsh_plugins.zsh -nt $zhome/.zsh_plugins.txt ]]; then
  [[ -e $zhome/.antidote ]] \
    || git clone --depth=1 https://github.com/mattmc3/antidote.git $zhome/.antidote
  (
    source $zhome/.antidote/antidote.zsh
    antidote bundle < $zhome/dotfiles/env/.zsh-plugins.txt > $zhome/.zsh-plugins.zsh
  )
fi

# uncomment if you want your session to have commands like `antidote update`
autoload -Uz $zhome/.antidote/functions/antidote

# source static plugins file
source $zhome/.zsh-plugins.zsh
unset zhome

# initialize starship prompt
eval "$(starship init zsh)"
