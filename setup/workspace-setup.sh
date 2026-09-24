#!/bin/bash
set -e

script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
project_dir=$(cd "$script_dir/.." && pwd)

if [[ ! -s "$HOME/.nvm/nvm.sh" ]]; then
	echo "nvm is not installed. Run setup/install-tools.sh first." >&2
	exit 1
fi

# Source this so that nvm works in non-login shells.
. "$HOME/.nvm/nvm.sh"

required_tools=(aws docker kubectl pipenv nvm tfswitch terraform kustomize jq)
for tool in "${required_tools[@]}"; do
	if ! command -v "$tool" >/dev/null 2>&1; then
		echo "Required tool is unavailable: $tool" >&2
		echo "Run setup/install-tools.sh first." >&2
		exit 1
	fi
done

echo "Configuring backend application"
cd "$project_dir/starter/backend"
echo "Cleaning backend environment..."
pipenv --rm > /dev/null 2>&1 || true
echo "Done with cleanup!"

echo "Installing backend dependencies..."
pipenv install > /dev/null 2>&1
echo "Done configuring backend!"
cd "$project_dir"

echo "Configuring frontend application"
cd "$project_dir/starter/frontend"
echo "Cleaning frontend environment..."
npm run clean > /dev/null 2>&1

echo "Installing frontend dependencies..."
nvm install > /dev/null 2>&1
npm ci --silent > /dev/null 2>&1
echo "Done configuring frontend!"
cd "$project_dir"

echo "Done setting up workspace."