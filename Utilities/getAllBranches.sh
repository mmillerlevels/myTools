#!/bin/sh

## Run after your typical git clone (Within the repo dir)

for branch in `git branch -a | grep remotes | grep -v HEAD | grep -v master `; do
   git branch --track ${branch#remotes/origin/} $branch
done
