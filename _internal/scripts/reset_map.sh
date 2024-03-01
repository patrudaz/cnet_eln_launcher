#!/bin/sh

exec >> sh_log_cnet.txt

if [ -d ../.minecraft/saves/SIn_world ]; then
  rm -R ../.minecraft/saves/SIn_world
fi

mkdir ../.minecraft/saves/SIn_world
cd ../.minecraft/saves/SIn_world

unzip ../SIn_world-20231122.zip
echo "Map reset successfully !"
