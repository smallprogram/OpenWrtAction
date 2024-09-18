#!/bin/bash

function Func_LogMessage() {
    Begin="\033[1;96m"
    End="\033[0m"

    if [ ! -n "$isChinese" ]; then
        echo -e "${Begin}$1${End}"
    else
        echo -e "${Begin}$2${End}"
    fi
}

function Func_LogSuccess() {
    Begin="\033[1;92m"
    End="\033[0m"

    if [ ! -n "$isChinese" ]; then
        echo -e "${Begin}$1${End}"
    else
        echo -e "${Begin}$2${End}"
    fi
}

function Func_LogError() {
    Begin="\033[1;91m"
    End="\033[0m"

    if [ ! -n "$isChinese" ]; then
        echo -e "${Begin}$1${End}"
    else
        echo -e "${Begin}$2${End}"
    fi
}