#! /bin/bash


name=$1

tamplate="$(cat lua/widgets/tamplate.txt)"

echo -e "$tamplate" > lua/widgets/$name.lua
