#!/bin/bash

cd /home/$USER
if [ ! -d "/home/$USER/OpenWrtAction" ]; then git clone https://github.com/smallprogram/OpenWrtAction.git; else cd /home/$USER/OpenWrtAction; git stash; git stash drop; git pull; fi;