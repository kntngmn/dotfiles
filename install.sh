#!/bin/zsh

DOTFILES=(emacs.d)
ZSHFILES=(zpreztorc zshrc)

# add submodule
git submodule update --init --recursive

# for prezto
git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"
setopt EXTENDED_GLOB
for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md(.N); do
  ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
done

echo "start setup..."
for dotfile in ${DOTFILES[@]};
do
    ln -svf $PWD/$dotfile $HOME/.$dotfile
done

echo "start zsh setup..."
for zshfile in ${ZSHFILES[@]};
do
    ln -svf $PWD/$zshfile $HOME/.zprezto/runcoms/$zshfile
done

# change shell to zsh
chsh -s $(which zsh)

source ~/.zshrc
source ~/.zpreztorc

echo "complete!"
