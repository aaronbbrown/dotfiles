PLATFORM=$(uname -s)

parse_git_branch() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1) /'
}

# all vi, all the time
set -o vi
export VISUAL=vi
export EDITOR=vi

export PATH=$HOME/bin:/usr/local/bin:/usr/local/sbin:/usr/local/share/npm/bin:$PATH
export PS1="\$(parse_git_branch)$(echo \$?) [\t] \u@\h:\w\$ "

alias gam="python $HOME/gam/gam.py"

if [[ $PLATFORM = "Darwin" ]]; then
  if [[ -d "/usr/local/opt/coreutils/libexec/gnubin" ]]; then
    PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"
  fi

  if [[ -d "/usr/local/opt/coreutils/libexec/gnuman" ]]; then
    MANPATH="/usr/local/opt/coreutils/libexec/gnuman:$MANPATH"
  fi

  if [[ -f "/usr/local/bin/gtar" ]]; then
    alias tar="/usr/local/bin/gtar"
  fi

  if [[ -z $SSH_TTY ]]; then
    # not logged in via ssh
    if [[ -f "$(which mvim)" ]]; then 
      alias vim="mvim --remote-tab-silent"
    fi
  fi
fi

#bash_completion
case "$PLATFORM" in
  Darwin) BC=$(brew --prefix)/etc/bash_completion 
          ;;
  Linux)  BC="/etc/bash_completion"
          ;;
esac

if [ -f $BC ]; then
  . $BC
fi

if [[ $PLATFORM = "Darwin" ]]; then
  export JAVA_HOME=/System/Library/Frameworks/JavaVM.framework/Home/
  export CC="/usr/local/bin/gcc-4.2"
  if [[ -d "$HOME/.rvm/bin" ]]; then
     PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
  fi
fi

# MySQL
export MYSQL_PS1="$(hostname) (\h://\d:\p)> "

if [[ -d "$HOME/dotfiles-private/rc.d" ]]; then
  for RC in $HOME/dotfiles-private/rc.d/*; do 
    . $RC
  done
fi

alias bi="bundle install"
alias be="bundle exec"
