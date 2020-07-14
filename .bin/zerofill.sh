#!/bin/bash
filename=$(basename -- "$0")
extension="${filename##*.}"
filename="${filename%.*}"
dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
args="${@:1}"
export LUA_PATH="$dir/../?.lua;$LUA_PATH"
lua $dir/../$filename.lua $args
