# PYFO
PYFO (Put Your Fedora On) is a post-install script for upstream version of fedora. It also focuses on security.

This script has been tested for Fedora Workstation 37.

It is meant to use right after you installed Fedora. This script will just install needed software that most people probably use.
So you will not have a bunch of sketchy software that you don't need.

*N.B: This script is mostly based on osiris2600's [script](https://github.com/osiris2600/fedora-setup)*

## Secure boot

If you want to want install Nvidia drivers and/or kernel-hardened while having secure boot enabled, you will have to [autosign](https://docs.fedoraproject.org/en-US/fedora/latest/system-administrators-guide/kernel-module-driver-configuration/Working_with_Kernel_Modules/#sect-signing-kernel-modules-for-secure-boot) your kernel every update with Nvidia. You should make a script which will go in `/etc/kernel/postinst.d`

This script should not be used with secure boot as it is [completely](https://privsec.dev/posts/linux/linux-insecurities/#lack-of-verified-boot) [flawed](https://madaidans-insecurities.github.io/guides/linux-hardening.html#verified-boot) [anyway](https://privsec.dev/posts/linux/desktop-linux-hardening/#secure-boot). [If you still want secure boot on Linux](https://wiki.archlinux.org/title/Unified_Extensible_Firmware_Interface/Secure_Boot), you should remove third party certificates in your motherboard, sign the bootloader with your own signature, protect your private key, use dm-verity to verify the integrity of the kernel and so on and so forth. If you want decent security, just don't use Linux.

## Install

Clone this repo

`git clone https://github.com/d4rklynk/PYFO.git`

Switch directory

`cd ~/PYFO`

Make it executable

`chmod +x pyfo-install.sh`

Execute it

`./pyfo-install.sh`
