#!/bin/bash

# Define a função que será adicionada ao ./.bashrc
# a string tb ser[a usada no grep para conferir se j[a existe no arquivo

JOT_FUNCTION="jot() {
    \"$HOME/jot.sh\" \"\$@\"
    history -d \$(history 1)
    sed -i '\$d' ~/.bash_history
}"

# Confere se a função existe no .bashrc
if grep -Fxq "$JOT_FUNCTION" ~/.bashrc
then
    echo "The 'jot' function is already present in .bashrc."
else
    echo "Adding 'jot' function to .bashrc. jot is a logging utility. jot -h for more info."
    echo -e "\n# Custom jot function. jot is a logging utility. jot -h for more info.\n$JOT_FUNCTION" >> ~/.bashrc
    echo "The 'jot' function has been added to .bashrc."
fi

# Recarrega o .bashrc
echo "Reloading .bashrc..."
source ~/.bashrc
