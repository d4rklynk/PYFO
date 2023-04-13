# PYFO
PYFO (Put Your Fedora On) is a post-install script for upstream version of fedora. It also focuses on security.

This script has been tested for Fedora Workstation 37 and Fedora Server 37.

The script will make the default zone to `drop` in Fedora Server too, you can revert to public by doing this command :

`sudo firewall-cmd --set-default-zene public`

It is meant to use right after you installed Fedora. This script will just install needed software that most people probably use.
So you will not have a bunch of sketchy software that you don't need.

*N.B: This script is mostly based on osiris2600's [script](https://github.com/osiris2600/fedora-setup)*

## Install

Clone this repo

`git clone https://github.com/d4rklynk/PYFO.git`

Switch directory

`cd ~/PYFO`

Make it executable

`chmod +x pyfo-install.sh`

Execute it (read [Usage](#usage) before executing)

`./pyfo-install.sh`

## Usage

`basic-dnf.txt` > Really basic software, and needed for the script anyway. You probably don't want to edit it (but you **CAN**).

`extras-dns.txt` > Bunch of software that you probably need, you **MUST** edit it to fit your needs.

`flatpak-packages.txt` > Bunch of most used flatpak softwares, you **MUST** edit it to fit your needs. Check [Flathub](https://flathub.org/home) and search your software to find the flatpak ID.

`gsettings.sh` > useless, I'll probably remove that in the near future.
