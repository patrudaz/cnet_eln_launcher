#!/bin/sh

# remxttr.sh
# BatChmod
#
# Created by Renaud Boisjoly on 5/6/10.
# Copyright 2010 Apple Canada Inc.. All rights reserved.
# Version 1.6.2


# Takes a path and removes, recursively all xattr in this path
# if called with -R will be recursive, otherwise, no

# $1 = -R for recursive or -U for unrecursive. Must be specified
# $2 = path to affect

# Change the permissions
sudo chflags -R nouchg CNetMinecraftLauncher.app
sudo chmod -R u+r+w+x,g+r+w+x,o+r-w+x CNetMinecraftLauncher.app
sudo chmod a+w CNetMinecraftLauncher.app/Contents/Resources/_internal/scripts/sh_log_cnet.txt
sudo chmod -R -N CNetMinecraftLauncher.app


oldIFS=$IFS # save the field separator  
IFS=$'\n' # new field separator, the end of line  

if [ "$1" = "-R" ] 
then
	echo "Recursive"
	for i in $(ls -Rl@ $2 | grep '^	' | awk '{print $1}' | sort -u)
	do echo Removing $i ...
		find $2 -print0 | xargs -0t sudo xattr -d $i 2>/dev/null ;
	done

fi

echo "Doing path itself"
	
#ls parent but grep exact path
	
for i in $(sudo xattr $2 | awk 'BEGIN { FS = "\r" } ; {print $1}')
do echo Removing $i ...
	#find $2 -print0 | xargs -0t xattr -d $i 2>/dev/null ;
	sudo xattr -d $i $2
done


IFS=$old_IFS