#!/bin/bash

ARCHIVEDIR="$HOME/archive"
DOTFILESROOT="$HOME/dotfiles"
PRIVROOT="$HOME/dotfiles-private"

archiveit {
  if [[ -e "$1" ]]; then
    # if it's a symlink, just make it go away
    if [[ -h "$1" ]]; then
      rm -v "$1"
    else
      [[ -d $ARCHIVEDIR ]] || mkdir -p "$ARCHIVEDIR"
      echo "Moving $1 to $ARCHIVEDIR ..."
      mv -v "$1" "$ARCHIVEDIR/" 
    fi
  fi
}


pushd $HOME
echo "Cloning private files..."
git clone gitosis@git.9minuntesnooze.com:dotfiles-private.git "$PRIVROOT"
echo "Building symlinks"

# dotfiles
for FILE in bash_profile bashrc inputrc vim; do 
  FN="$HOME/.${FILE}" 
  archiveit "$FN"
  ln -vs "$DOTFILESROOT/$FILE" "$FN"
done

#vimrc
archiveit "$HOME/.vim"
ln -vs "$DOTFILESROOT/.vim/vimrc" "$HOME/.vimrc"

#private stuff
archiveit "$HOME/.ssh"
ln -vs "$PRIVROOT/.ssh" "$HOME/.ssh"

echo "Done."
popd
