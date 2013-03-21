#!/bin/bash

ARCHIVEDIR="$HOME/archive"
DOTFILESROOT="$HOME/dotfiles"
PRIVROOT="$HOME/dotfiles-private"

archiveit () {
  # if it's a symlink, just make it go away
  if [[ -h "$1" ]]; then
    echo "Removing symlink for $1 ..."
    rm -v "$1"
  elif [[ -e "$1" ]]; then
    [[ -d $ARCHIVEDIR ]] || mkdir -p "$ARCHIVEDIR"
    echo "Moving $1 to $ARCHIVEDIR ..."
    mv -v "$1" "$ARCHIVEDIR/" 
  fi
}

echo installing RVM
curl -L https://get.rvm.io | bash -s stable
rvm reload

pushd $DOTFILESROOT
git submodule update --init --recursive
popd && pushd $HOME
if [[ -d "$PRIVROOT" ]]; then
  pushd "$PRIVROOT"
  git pull
  popd
else
  echo "Cloning private files..."
  git clone gitosis@git.9minutesnooze.com:dotfiles-private.git "$PRIVROOT"
fi

echo "Building symlinks"

# dotfiles
for FILE in gitconfig bash_profile bashrc inputrc ; do 
  FN="$HOME/.${FILE}" 
  archiveit "$FN"
  ln -vs "$DOTFILESROOT/$FILE" "$FN"
done

#vimrc
archiveit "$HOME/.vimrc"
ln -vs "$DOTFILESROOT/.vim/vimrc" "$HOME/.vimrc"

#.slate
archiveit "$HOME/.slate"
ln -vs "$DOTFILESROOT/slate" "$HOME/.slate"

#tmux config
archiveit "$HOME/.tmux.conf"
ln -vs "$DOTFILESROOT/tmux.conf" "$HOME/.tmux.conf"

archiveit "$HOME/.gvimrc"
ln -vs "$DOTFILESROOT/gvimrc" "$HOME/.gvimrc"

#.vim
archiveit "$HOME/.vim"
ln -vs "$DOTFILESROOT/.vim" "$HOME/.vim"

#private stuff
archiveit "$HOME/.ssh"
ln -vs "$PRIVROOT/.ssh" "$HOME/.ssh"
chmod -Rv 600 "$HOME/.ssh"/*

#KeyRemap4MacBook private.xml
KR4MBDIR="$HOME/Library/Application Support/KeyRemap4MacBook"
mkdir -p $KR4MBDIR
archiveit "$KR4MBDIR/private.xml"
ln -vs "$DOTFILESROOT/private.xml" "$KR4MBDIR/private.xml"

echo "Done."
popd
