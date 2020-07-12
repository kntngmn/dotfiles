#!/bin/bash

DITFILES=(emacs.d)

echo "start setup..."
for fname in ${DITFILES[@]};
do
    ln -svi $PWD/$fname $HOME/.$fname
done

echo "complete!"
