#!/bin/bash

debug()
{
    echo -e "DEBUG: $*"
}

info()
{
    echo -e "\e[1mINFO: $*\e[0m"
}

warning()
{
    echo -e "\e[1;33mWARNING: $*\e[0m"
}

error()
{
    echo -e "\e[1;31mERROR: $*\e[0m"
}

fatal()
{
    echo -e "\e[1;31;47mFATAL: $*\e[0m"
    exit 1
}
