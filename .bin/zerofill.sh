#!/bin/bash
filename=$(basename -- "$0")
extension="${filename##*.}"
filename="${filename%.*}"
dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
args="${@:1}"
lua $dir/../$filename.lua $args
