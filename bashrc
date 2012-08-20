PLATFORM=$(uname -s)

# all vi, all the time
set -o vi
export VISUAL=vi
export EDITOR=vi

export PATH=/usr/local/bin:/usr/local/sbin:$HOME/bin:/opt/local/icagent/bin/:$PATH

alias gam="python $HOME/gam/gam.py"

if [[ $PLATFORM = "Darwin" ]]; then
  alias md5sum=md5
  if [[ -f "/usr/local/bin/gtar" ]]; then
    alias tar="/usr/local/bin/gtar"
  fi

  if [[ -f "$(which mvim)" ]]; then 
    alias vim=mvim
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
  export CC=/usr/bin/gcc-4.2
  if [[ -d "$HOME/.rvm/bin" ]]; then
    PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
  fi
fi

# MySQL
export MYSQL_PS1="$(hostname) (\h://\d:\p)> "

if [[ -d "$HOME/dotfiles/dotfiles-private/rc.d" ]]; then
  for RC in "$HOME/dotfiles/dotfiles-private/rc.d/*"; do 
    . $RC
  done
fi
