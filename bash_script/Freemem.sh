#!/bin/bash
sudo sync
sudo sh -c 'echo 3 > /proc/sys/vm/drop_caches'
