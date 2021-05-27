#!/bin/sh
curPath=$(cd $(dirname "$0") && pwd)
cd $curPath
mkdir backup
cd backup
backupPath=$(pwd)
echo "backup config to $backupPath"
echo "--------------------------------"
function checkAndbBackup() {
    file=$1
    if [ -e $file ]; then
        echo "$file --->$backupPath/$(basename $file)"
        mv $file $backupPath/$(basename $file)
    fi
    if [ -L $file ]; then
        echo "clean link $file"
        rm $file
    fi
}

checkAndbBackup ~/.zshrc
checkAndbBackup ~/.zshenv
checkAndbBackup ~/.config/alacritty/alacritty.yml


echo "--------------------------------"

echo "release config"
echo "--------------------------------"
cd $curPath
echo "link to ~/.zshenv"
ln -s $curPath/zshenv ~/.zshenv
echo "link to ~/.zshrc"
ln -s $curPath/zshrc ~/.zshrc
echo "link to ~/.config/alacritty/alacritty.yml"
if [ ! -d ~/.config/alacritty/ ]; then
    mkdir -p ~/.config/alacritty/
fi
ln -s $curPath/config/alacritty/alacritty.yml ~/.config/alacritty/alacritty.yml

echo "--------------------------------"
