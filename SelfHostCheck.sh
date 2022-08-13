#!/bin/bash

cd /home/zhusir
if [ ! -d "/home/zhusir/OpenWrtAction" ]; then git clone https://github.com/smallprogram/OpenWrtAction.git; else cd /home/zhusir/OpenWrtAction; git stash; git stash drop; git pull; fi;