# AzuraCast Ansible Installation

Ansible installation components of AzuraCast.

Ansible installations are no longer officially supported by the core AzuraCast developer team. Community contributions may still be submitted to this repository.

## Updating from a Legacy Ansible Installation

If updating from a legacy Ansible installation, follow the regular installation instructions below and your installation will be replaced by this version.

## Installing

```bash
mkdir -p /var/azuracast/ansible
cd /var/azuracast/ansible

git clone https://github.com/azuracast/ansible-installer.git .
chmod a+x install.sh
bash install.sh
```

## Updating

```bash
cd /var/azuracast/ansible
chmod a+x update.sh
bash update.sh
```
