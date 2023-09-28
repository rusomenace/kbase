#!/bin/bash

echo "Choose a comment type:
1 - Build
2 - CI
3 - Docs
4 - Feat
5 - Fix
6 - Perf
7 - Refactor
8 - Style
9 - Test"

read -r type

case $type in
    1) choice="Build:" ;;
    2) choice="CI:" ;;
    3) choice="Docs:" ;;
    4) choice="Feat:" ;;
    5) choice="Fix:" ;;
    6) choice="Perf:" ;;
    7) choice="Refactor:" ;;
    8) choice="Style:" ;;
    9) choice="Test:" ;;
    *) echo "Invalid option. Exiting." && exit 1 ;;
esac

echo "Input commit message (default: Just another commit):"
read -r commit_message
commit_message=${commit_message:-"Just another commit"}

push_message="$choice $commit_message"
git pull
git add .
git commit -m "$push_message"
git push
