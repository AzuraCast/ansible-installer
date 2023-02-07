# AzuraCast Ansible Installation

Ansible installation components of AzuraCast.

Ansible installations are no longer officially supported by the core AzuraCast developer team. Community contributions may still be submitted to this repository.

## Ansible vs. Docker

Many users who are unfamiliar with server-side software are also unfamiliar with Docker, and are thus reluctant to use it. There are also valid reasons to use the Ansible installation in certain circumstances, which is why we continue to maintain it.

When evaluating which installation method to use, be aware of the following considerations in favor of, and against, using Ansible over our recommended Docker installation method.

### Advantages of Ansible

- **Advanced Customization:** For "power users" looking to build custom solutions, you can customize files and configuration more easily with Ansible installations. (Note that the Ansible updater may overwrite settings if necessary.)

- **Optimized for Low-Resource Computers:** Some computers that operate on narrow performance margins, like the Raspberry Pi devices, can benefit from AzuraCast running directly on the OS, rather than through Docker.

### Disadvantages of Ansible

- **Limited Operating System Selection:** This installation method requires using one of our few directly supported OS versions, namely the latest LTS releases of Ubuntu. With Docker, our software is configured inside containerized images, so you can use any Docker-supported host operating system.

- **"Clean" Installation Required:** The Ansible installation does not "coexist" with other software on an Ubuntu installation, and will often overwrite or conflict with other software. Docker's more "containerized" nature means you have a far lower chance of other software conflicting with AzuraCast.

- **Potential for Software Conflicts:** Because Ansible installs directly onto whatever version of Ubuntu you're running, it can't always take into account the specific configuration of your OS, or any bundled software that your hosting provider includes with it. This increases the likelihood that our installer may conflict with 

- **Longer Update Times:** If you use Docker, you can take advantage of the fact that our automated systems build the images for you, and all you need to do is pull down the latest images when updating. With Ansible, you have to run every updated installation step on your own computer, which can (and often does) take much longer.

## Supported Operating Systems

Currently, the following operating systems are supported:

- **Ubuntu 22.04 "Jammy" LTS (Recommended)**
- Ubuntu 20.04 "Focal" LTS

Our support for LTS versions of Ubuntu follows the [Ubuntu support lifecycle](https://ubuntu.com/about/release-cycle). Typically, LTS versions are supported for a period of 5 years following their release.

AzuraCast is optimized for speed and performance, and can run on very inexpensive hardware, from the Raspberry Pi 3 to the lowest-level VPSes offered by most providers.

Since AzuraCast installs its own radio tools, databases and web servers, you should always install AzuraCast on a "clean" server instance with no other web or radio software installed previously.

## Migrating from a Legacy Ansible Installation

If migrating from a legacy Ansible installation, follow the regular installation instructions below and your installation will be replaced by this version.

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
