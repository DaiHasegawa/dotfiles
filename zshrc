# --------------
# general
# --------------

# locale
export LANG='ja_JP.UTF-8'
export LC_ALL='ja_JP.UTF-8'
#prompt
autoload -U promptinit
autoload -U colors && colors

# vcs
setopt prompt_subst
autoload -Uz vcs_info
zstyle ':vcs_info:*' formats '[%b]'
zstyle ':vcs_info:*' actionformats '[%b|%a]'
_vcs_precmd () { vcs_info }
autoload -Uz add-zsh-hook
add-zsh-hook precmd _vcs_precmd

# ブランチ名を色付きで表示させるメソッド
function rprompt-git-current-branch {
  local branch_name st branch_status

  if [ ! -e  ".git" ]; then
    # gitで管理されていないディレクトリは何も返さない
    return
  fi
  branch_name=`git rev-parse --abbrev-ref HEAD 2> /dev/null`
  st=`git status 2> /dev/null`
  if [[ -n `echo "$st" | grep "^nothing to"` ]]; then
    # 全てcommitされてクリーンな状態
    branch_status="%F{cyan}clean"
  elif [[ -n `echo "$st" | grep "^Untracked files"` ]]; then
    # gitに管理されていないファイルがある状態
    branch_status="%F{red}untracked"
  elif [[ -n `echo "$st" | grep "^Changes not staged for commit"` ]]; then
    # git addされていないファイルがある状態
    branch_status="%F{magenta}to be staged"
  elif [[ -n `echo "$st" | grep "^Changes to be committed"` ]]; then
    # git commitされていないファイルがある状態
    branch_status="%F{yellow}to be commited"
  elif [[ -n `echo "$st" | grep "^rebase in progress"` ]]; then
    # コンフリクトが起こった状態
    echo "%F{red}!(no branch)"
    return
  else
    # 上記以外の状態の場合は青色で表示させる
    branch_status="%F{blue}"
  fi
  # ブランチ名を色付きで表示する
  echo "${branch_status}"
}


# prompt colors(black, red, green, yellow, blue, magenta, cyan, white)
PROMPT='%{${fg[black]}%}%~%{${reset_color}%}
%{${fg[green]}%}[%n]%{${reset_color}%}%{${fg[blue]}%}$vcs_info_msg_0_%{${reset_color}%}$ '

RPROMPT='`rprompt-git-current-branch`'

# path
export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"
# less env
export LESS='-i -M -R'

# cdr
setopt pushd_ignore_dups
setopt AUTO_PUSHD
DIRSTACKSIZE=100
autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
add-zsh-hook chpwd chpwd_recent_dirs

# vi keybind
bindkey -v

# autocd
setopt auto_cd

# --------------
# plugin
# --------------

if [ ! -e "${HOME}/.zplug/init.zsh" ]; then
  curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh| zsh
fi
source ${HOME}/.zplug/init.zsh
# install plugins
zplug 'zsh-users/zsh-syntax-highlighting'
zplug 'zsh-users/zsh-autosuggestions'
zplug "peco/peco", as:command, from:gh-r
zplug "mollifier/anyframe"
# Install plugins if there are plugins that have not been installed
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi
zplug load --verbose
# plugin settings
zstyle ":anyframe:selector:" use peco
bindkey '^Z' anyframe-widget-cdr
bindkey '^R' anyframe-widget-put-history
bindkey '^Y' vi-forward-word

# --------------
# completion
# --------------
autoload -Uz compinit && compinit
# sudo
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin \
    /usr/sbin /usr/bin /sbin /bin /usr/X11R6/bin

# --------------
# history
# --------------
HISTFILE=~/.zsh_history
HISTSIZE=1000000
SAVEHIST=1000000
setopt extended_history
setopt hist_ignore_dups
setopt hist_ignore_all_dups
setopt hist_ignore_space
setopt hist_verify
setopt hist_reduce_blanks
setopt hist_save_no_dups
setopt hist_expand
setopt inc_append_history
setopt share_history

# --------------
# alias
# --------------
alias ls='ls -G'

