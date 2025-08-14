#!/usr/bin/env bash

while [[ "$1" =~ ^- && ! "$1" == "--" ]]; do
  case $1 in
  --dev)
    APP_ENV="development"
    shift
    ;;
  esac
  shift
done
if [[ "$1" == '--' ]]; then shift; fi

. /etc/os-release

distros="$ID $ID_LIKE"
isRhelBased=false

for word in $distros
do
    if [[ $word == "rhel" ]]; then
      isRhelBased=true
    fi
done


if [[ $isRhelBased != true ]]; then
  echo "Ansible installation is only supported on RHEL based distributions."
  exit 0
fi

majorVersion=$(cat /etc/system-release-cpe | awk -F: '{ print $5 }' | grep -o ^[0-9]*)
if [[ $majorVersion -lt 8 ]]; then
  echo "RHEL 8+ is required"
  exit 0
fi

CURRENT_USER=$(whoami)
SUDOERS_FILE="/etc/sudoers.d/$CURRENT_USER-nopasswd"
if [ "$CURRENT_USER" != "root" ]; then
    echo "For everything to go smoothly we'll need to add $CURRENT_USER to sudoers with NOPASSWD privileges."
    if [ ! -f "$SUDOERS_FILE" ]; then
        echo "$CURRENT_USER ALL=(ALL:ALL) NOPASSWD: ALL" | sudo tee "$SUDOERS_FILE"
        echo "Added $CURRENT_USER to sudoers with NOPASSWD privileges."
    else
        echo "The sudoers file already exists for $CURRENT_USER."
    fi
fi


sudo dnf install -y epel-release
sudo dnf update -y
sudo dnf install -y ansible python3-pip python3-mysqlclient python3-pexpect curl yum ca-certificates --allowerasing

APP_ENV="${APP_ENV:-production}"

# @TODO: migrate this to the liquidsoap role to support remote deployments
if ! command -v opam &> /dev/null
then
    echo "[opam] Installing latest to /usr/local/bin"
    case "$(uname -m)" in
      x86_64)        plat="x86_64-linux" ;;
      aarch64|arm64) plat="arm64-linux" ;;
      *) echo "Unsupported arch: $(uname -m)"; exit 1 ;;
    esac
    tag="$(
      curl -fsSL "${authHeader[@]}" \
        https://api.github.com/repos/ocaml/opam/releases/latest |
      awk -F '"' '/tag_name/{print $4; exit}'
    )"
    if [ -z "$tag" ]; then
      echo "[opam] Could not determine latest tag"
      exit 1
    fi
    asset="opam-${tag}-${plat}"
    sudo curl -fL -o /usr/local/bin/opam \
      "https://github.com/ocaml/opam/releases/download/${tag}/${asset}"
    
    sudo chmod 0755 /usr/local/bin/opam
fi


echo "Installing AzuraCast (Environment: $APP_ENV)"
ansible-galaxy collection install community.general
ansible-playbook ansible/deploy.yml --inventory=ansible/hosts --extra-vars "app_env=$APP_ENV" #--tags centrifugo
