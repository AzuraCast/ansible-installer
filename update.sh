#!/usr/bin/env bash

while [[ "$1" =~ ^- && ! "$1" == "--" ]]; do
  case $1 in
  --dev)
    APP_ENV="development"
    ;;

  --full)
    UPDATE_REVISION=0
    ;;
  esac
  shift
done
if [[ "$1" == '--' ]]; then shift; fi

. /etc/os-release

distros=$ID . ' ' . $ID_LIKE
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

majorVersion=$(rpm -q --queryformat '%{RELEASE}' rpm | grep -o [[:digit:]]*\$)
echo $majorVersion
if [[ $majorVersion -lt 8 ]]; then
  echo "RHEL 8+ is required"
  exit 0
fi


sudo dnf update
sudo dnf install -y ansible python3-pip python3-mysqlclient

APP_ENV="${APP_ENV:-production}"
UPDATE_REVISION="${UPDATE_REVISION:-1}"

echo "Updating AzuraCast (Environment: $APP_ENV, Update revision: $UPDATE_REVISION)"

if [[ ${APP_ENV} == "production" ]]; then
  if [[ -d ".git" ]]; then
    git config --global --add safe.directory $(dirname $0)
    git reset --hard
    git pull
  else
    echo "You are running a downloaded release build. Any code updates should be applied manually."
  fi
fi

ansible-playbook ansible/update.yml --inventory=ansible/hosts --extra-vars "app_env=$APP_ENV update_revision=$UPDATE_REVISION"
