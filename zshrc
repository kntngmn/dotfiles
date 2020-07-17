#
# Executes commands at the start of an interactive session.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

## emacs daemon
alias edaemon="emacs --daemon -bg = '#000000' > /dev/null 2>&1"

if emacsclient -e "t" > /dev/null 2>&1 ; then
    echo 'Emacs daemon is already running.'
else
    echo 'Starting Emacs daemon.'
    edaemon
fi

export SUDO_EDITOR='emacsclient -t'
export EDITOR='emacsclient -t'

alias e=${EDITOR}
alias ekill='emacsclient -e "(kill-emacs)"'

## alias
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

## 補完時に大文字小文字を区別しない
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

## history
HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000
# 同時に起動したzsh間でヒストリを共有する
setopt share_history
# 直前と同じコマンドはヒストリに追加しない
setopt hist_ignore_dups

# anyenv
export PATH="$HOME/.anyenv/bin:$PATH"
eval "$(anyenv init -)"

# pyenv
export PIPENV_VENV_IN_PROJECT=true
