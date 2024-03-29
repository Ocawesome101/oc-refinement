#!/bin/bash

imods=$(echo $IMODS | sed 's/,/\n/g')

rm -f includes.lua
touch includes.lua

for mod in $imods; do
  printf "including module $mod\n"
  echo "--#include \"$mod.lua\"" >> includes.lua
done

$PREPROCESSOR init.lua refinement.lua -strip-comments
rm -f includes.lua
