#!/bin/bash

for vfile in *.v; do
  echo Lint "$vfile"
  java Vcheck "$vfile"
done
