#!/usr/bin/env bash

set -e

# Bash color variables
COLOR_GREEN="\x1b[32;01m"
COLOR_RESET="\x1b[39;49;00m"

echo -e "🚀  Bootstrapping project...$COLOR_RESET"

if [ -f "Brewfile" ] && [ "$(uname -s)" = "Darwin" ]; then
	brew bundle check >/dev/null 2>&1 || {
		echo -e "🛠 Installing Homebrew dependencies…\n$COLOR_RESET"
		brew bundle
	}
fi

if [[ $CI != "true" ]]; then
	echo -e "⚓  Setting up commit hooks$COLOR_RESET"
	pre-commit install
	pre-commit install --hook-type commit-msg
fi

if ! command -v air &>/dev/null; then
	# https://github.com/cosmtrek/air#installation
	# binary will be $(go env GOPATH)/bin/air
	curl -sSfL https://raw.githubusercontent.com/cosmtrek/air/master/install.sh | sh -s -- -b $(go env GOPATH)/bin
	air -v
fi

echo -e "$COLOR_GREEN✅  Done\n$COLOR_RESET"
