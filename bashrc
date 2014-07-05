PLATFORM=$(uname -s)

parse_git_branch() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1) /'
}

jcurl () {
        curl --write-out '\n{"content_type":"%{content_type}","filename_effective":"%{filename_effective}","ftp_entry_path":"%{ftp_entry_path}","http_code":"%{http_code}","http_connect":"%{http_connect}","local_ip":"%{local_ip}","local_port":"%{local_port}","num_connects":"%{num_connects}","num_redirects":"%{num_redirects}","redirect_url":"%{redirect_url}","remote_ip":"%{remote_ip}","remote_port":"%{remote_port}","size_download":"%{size_download}","size_header":"%{size_header}","size_request":"%{size_request}","size_upload":"%{size_upload}","speed_download":"%{speed_download}","speed_upload":"%{speed_upload}","ssl_verify_result":"%{ssl_verify_result}","time_appconnect":"%{time_appconnect}","time_connect":"%{time_connect}","time_namelookup":"%{time_namelookup}","time_pretransfer":"%{time_pretransfer}","time_redirect":"%{time_redirect}","time_starttransfer":"%{time_starttransfer}","time_total":"%{time_total}","url_effective":"%{url_effective}"}' "$@" | tail -n1 | python -mjson.tool
}

function ksearch(){
  query="$1"
  shift
  k search node "$query" \
    -a name \
    -a environment \
    -a fqdn \
    -a ipaddress \
    -a run_list \
    -a tags \
    -a ec2.instance_type \
    -a ec2.placement_availability_zone \
    "$@"
}

# all vi, all the time
set -o vi
set completion-ignore-case On

export VISUAL=vi
export EDITOR=vi

export PATH=$HOME/bin:/usr/local/bin:/usr/local/sbin:/usr/local/share/npm/bin:$PATH
export GIT_PS1_SHOWDIRTYSTATE=1     # unstaged (*) and staged (+) changes will be shown
export GIT_PS1_SHOWSTASHSTATE=1     # If something is stashed then a '$' will be shown
export GIT_PS1_SHOWUNTRACKEDFILES=1 # If there're untracked files, a '%' will be shown
export GIT_PS1_SHOWUPSTREAM="auto"  # "<" indicates you are behind, ">" indicates you are ahead,
                                    # "<>" indicates you have diverged and "=" indicates that there is no difference.
export GIT_PS1_SHOWCOLORHINTS=1

export ANDROID_HOME=/usr/local/opt/android-sdk
export PROMPT_COMMAND='__git_ps1 "[\t] \u@\h:\w" "\\\$ "'
#export PS1="\$(parse_git_branch)$(echo \$?) [\t] \u@\h:\w\$ "

alias utc='TZ=utc date'

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

  alias flushdns="sudo killall -HUP mDNSResponder"
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

if [[ -x "$(which aws)" ]]; then
  complete -C aws_completer aws
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

# this is stupid
alias rvbox='sudo /Library/StartupItems/VirtualBox/VirtualBox restart'
