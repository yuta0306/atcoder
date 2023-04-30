#!/bin/zsh

dir=$1
poetry run oj t -c "python $1/main.py" -d $dir/test