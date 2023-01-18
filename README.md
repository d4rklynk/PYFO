# PYFO
PYFO (Put Your Fedora On) is a post-install script for upstream version of fedora. It also focuses on security.

This script has been tested for Fedora Workstation 37.

It is meant to use right after you installed Fedora. This script will just install needed software that most people probably use.
So you will not have a bunch of sketchy software that you don't need.

*N.B: This script is mostly based on osiris2600's [script](https://github.com/osiris2600/fedora-setup)*

## NVidia

You can't use NVidia drivers **with** the linux-hardened package.

For secure boot, you will have to [autosign](https://docs.fedoraproject.org/en-US/fedora/latest/system-administrators-guide/kernel-module-driver-configuration/Working_with_Kernel_Modules/#sect-signing-kernel-modules-for-secure-boot) your kernel every update with Nvidia. You should make a script which will go in `/etc/kernel/postinst.d`.

## Install

Clone this repo

`git clone https://github.com/d4rklynk/PYFO.git`

Switch directory

`cd ~/PYFO`

Make it executable

`chmod +x pyfo-install.sh`

Execute it

`./pyfo-install.sh`
