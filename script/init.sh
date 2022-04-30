#!/usr/bin/env bash

# Bash color variables
COLOR_GREEN="\x1b[32;01m"
COLOR_RESET="\x1b[39;49;00m"

# shellcheck disable=SC2155
export REPO_DIR="$(dirname "$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)")"

function prepare {
	echo -e "🚀  Initializing $REPO_NAME project...$COLOR_RESET"
}

function get_user_input {
	read -r -p "Enter repo name (e.g. gobase): " REPO_NAME
	read -r -p "Enter previous repo name (default: __REPO_NAME__): " PREVIOUS_REPO_NAME
	PREVIOUS_REPO_NAME=${PREVIOUS_REPO_NAME:-"__REPO_NAME__"}
}

function replace_repo_name {
	# shellcheck disable=SC2038
	find -E . -type f -regex '.*\.(go|yaml|md)' | xargs sed -i "" "s/$PREVIOUS_REPO_NAME/${REPO_NAME}/g"
	# shellcheck disable=SC2038
	find -E . -type f -regex '.*\install.sh' | xargs sed -i "" "s/$PREVIOUS_REPO_NAME/${REPO_NAME}/g"
}

function go_mod {
	rm -rf go.mod
	go mod init "${REPO_NAME}"
}

function setup_structure {
	read -r -p "Config as a what tool? " TOOL

	case "${TOOL}" in
	[cli])
		echo "Config as a CLI tool"
		;;
	*)
		echo "Not adding CLI tool"
		rm -rf "$REPO_DIR"/script/install.sh "$REPO_DIR"/script/release.sh
		;;
	esac

	rm -rf "$REPO_DIR"/script/init.sh
}

function post {
	"$REPO_DIR"/script/setup.sh
	pre-commit run --all-files
	git add "$REPO_DIR" && git commit --am "feat: init $REPO_NAME project" && git push -f
	echo -e "$COLOR_GREEN✅  Done\n$COLOR_RESET"
}

prepare
get_user_input
replace_repo_name
go_mod
setup_structure
post
