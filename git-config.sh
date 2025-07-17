#!/bin/bash

set -e

GIT_USERNAME="l-gllme"
GIT_EMAIL="l-gllme@users.noreply.github.com"

echo "➤ Configuring Git global settings..."

git config --global user.name "$GIT_USERNAME"
git config --global user.email "$GIT_EMAIL"
git config --global init.defaultBranch main

echo "✅ Git configuration done."
