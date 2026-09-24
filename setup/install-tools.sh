#!/usr/bin/env bash
set -euo pipefail

if [[ "$(uname -s)" != "Linux" || ! -f /etc/debian_version ]]; then
  echo "This installer supports Debian-based Linux workspaces only." >&2
  exit 1
fi

sudo apt-get update
sudo apt-get install -y awscli ca-certificates curl git gnupg jq docker.io python3-pip

if ! command -v kubectl >/dev/null 2>&1; then
  curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.30/deb/Release.key |
    sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
  echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.30/deb/ /' |
    sudo tee /etc/apt/sources.list.d/kubernetes.list >/dev/null
  sudo apt-get update
  sudo apt-get install -y kubectl
fi

python3 -m pip install --user pipenv
export PATH="$HOME/.local/bin:$PATH"

if [[ ! -s "$HOME/.nvm/nvm.sh" ]]; then
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
fi
# shellcheck disable=SC1090
source "$HOME/.nvm/nvm.sh"
nvm install 18

if ! command -v tfswitch >/dev/null 2>&1; then
  curl -L https://raw.githubusercontent.com/warrensbox/terraform-switcher/release/install.sh | bash
fi
tfswitch 1.3.9

if ! command -v kustomize >/dev/null 2>&1; then
  curl -s https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/hack/install_kustomize.sh | bash
  sudo install -m 0755 kustomize /usr/local/bin/kustomize
  rm -f kustomize
fi

required_tools=(aws docker kubectl pipenv nvm tfswitch terraform kustomize jq)
for tool in "${required_tools[@]}"; do
  if ! command -v "$tool" >/dev/null 2>&1; then
    echo "Required tool is unavailable: $tool" >&2
    exit 1
  fi
done

echo "All project tools are installed and available."