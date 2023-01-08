#!/usr/bin/env bash
HEIGHT=20
WIDTH=90
CHOICE_HEIGHT=4
BACKTITLE="PYFO by samsepi0l - Initally by Osiris - https://lsass.co.uk"
TITLE="Please Make a selection"
MENU="Please Choose one of the following options:"

#Other variables
OH_MY_ZSH_URL="https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh"

#Check to see if Dialog is installed, if not install it - Thanks Kinkz_nl
if [ $(rpm -q dialog 2>/dev/null | grep -c "is not installed") -eq 1 ]; then
sudo dnf install -y dialog
fi

OPTIONS=(1 "Update your system - Do that first if you did not already"
         2 "Enable AutoUpdates - Recommended"        
         3 "Install Basic Software - check basic-softwares file for more information"
         4 "Enable RPM Fusion - Enables the RPM Fusion repos for your specific version"
         5 "Update Firmware - If your system supports fw update delivery"
         6 "Speed up DNF - This enables fastestmirror, max downloads and deltarpms"
         7 "Enable Flatpak - Enables the Flatpak repo and installs packages"
         8 "Install Extras Software - Installs a bunch of my most used software"
         9 "Install Brave - Recommended, installed from official repo"
         10 "Install Videos packages - Video codec and stuff as per the official doc"
         11 "Install Oh-My-ZSH - ZSH will be also installed"
         12 "Install minimal Oh-My-ZSH plugins"
         13 "Install Nvidia - Install akmod nvidia drivers"
         14 "Install linux-hardened - A linux hardened package from my COPR repo"
         15 "Install hardened_malloc - A hardened_malloc package for fedora"
         16 "Set default for hardened_malloc - If you don't know, do nothing"
         17 "More hardening tweaks - NTS time, umask, firewall"
         98 "Reboot your system"
	 99 "Quit")

while [ "$CHOICE -ne 4" ]; do
    CHOICE=$(dialog --clear \
                --backtitle "$BACKTITLE" \
                --title "$TITLE" \
                --nocancel \
                --menu "$MENU" \
                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)

    clear
    case $CHOICE in
        1)
            echo "Update system"
            sudo dnf upgrade -y
            sudo dnf autoremove
            notify-send "System updated - Reboot now" --expire-time=10
            ;;
        2)
            echo "Enable AutoUpdates"
            sudo dnf install dnf-automatic
            sudo systemctl enable --now dnf-automatic-install.timer
            notify-send "System updated - Reboot now" --expire-time=10
            ;;
        3)
            echo "Install Basic Software"
            sudo dnf install -y $(cat dnf-basic-packages.txt)
            notify-send "Basic Software have been installed" --expire-time=10
            ;;
        4)  
            echo "Enabling RPM Fusion"
            sudo dnf install -y https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
	        sudo dnf upgrade --refresh
            sudo dnf group update -y core
            sudo dnf install -y rpmfusion-free-release-tainted
            sudo dnf install -y dnf-plugins-core
            notify-send "RPM Fusion Enabled" --expire-time=10
            ;;
        5)  
            echo "Updating Firmware"
            sudo fwupdmgr get-devices 
            sudo fwupdmgr refresh --force 
            sudo fwupdmgr get-updates 
            sudo fwupdmgr updatecho "Set hardening_malloc to default"ps://flathub.org/repo/flathub.flatpakrepo
            flatpak update
            flatpak install flathub com.github.tchx84.Flatseal
            source 'flatpak-install.sh'
            notify-send "Flatpak has now been enabled and Flatseal is installed" --expire-time=10
            ;;
        8)  
            echo "Installing Extras Software"
            sudo dnf install -y $(cat dnf-packages.txt)
            notify-send "Extras Software have been installed" --expire-time=10
            ;;
        9)  
            echo "Installing Brave"
            sudo dnf install dnf-plugins-core
            sudo dnf config-manager --add-repo https://brave-browser-rpm-release.s3.brave.com/x86_64/
            sudo rpm --import https://brave-browser-rpm-release.s3.brave.com/brave-core.asc
            sudo dnf install brave-browser
            notify-send "Brave has been installed" --expire-time=10
            ;;
        10)  
            echo "Installing Videos packages"
            sudo dnf install gstreamer1-plugins-{bad-\*,good-\*,base} gstreamer1-plugin-openh264 gstreamer1-libav --exclude=gstreamer1-plugins-bad-free-devel
            sudo dnf install -y lame\* --exclude=lame-devel
            sudo dnf group upgrade -y --with-optional Multimedia
            sudo dnf update -y
            notify-send "All done" --expire-time=10
           ;;
        11)  
            echo "Installing Oh-My-Zsh"
            sudo dnf -y install zsh util-linux-user
            sh -c "$(curl -fsSL $OH_MY_ZSH_URL)"
            echo "change shell to ZSH"
            chsh -s "$(which zsh)"
            notify-send "Oh-My-Zsh is ready to rock n roll" --expire-time=10
            ;;
        12)  
            echo "Installing minimal Oh-My-ZSH plugins"
            git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
            curl -fsSL https://raw.githubusercontent.com/d4rklynk/my-zsh-config/main/.zshrc > ~/.zshrc
            notify-send "Plugins have been installed" --expire-time=10
            ;;
        13)  
            echo "Installing Nvidia Driver Akmod-Nvidia"
            sudo dnf install -y akmod-nvidia
            notify-send "All done" --expire-time=10
	       ;;
        14)
            echo "Hardening kernel"
            sudo dnf copr enable samsepi0l/HardHatOS
            sudo dnf install kernel-hardened
            echo "kernel.unprivileged_userns_clone=1" > /etc/sysctl.d/10_kernel.unprivileged_userns_clone.conf
            sudo chown root:root /etc/sysctl.d/10_kernel.unprivileged_userns_clone.conf
            notify-send "Kernel is hardened (you must reboot to make it effective)" --expire-time=10
           ;;
        15)
            echo "Installing hardened_malloc"
            sudo dnf copr enable samsepi0l/HardHatOS
            sudo dnf install hardened_malloc
            notify-send "hardened_malloc installed (you must reboot to make it effective)" --expire-time=10
           ;;
        16)
            echo "Set hardening_malloc to default"
            sudo echo "libhardened_malloc.so" > /etc/ld.so.preload
            notify-send "hardening_malloc has been set to default (you must reboot to make it effective)" --expire-time=10
           ;;
        17)
            echo "Set umask to 077 for all users instead of 022"
            echo "umask 077" >  cat /etc/profile.d/set-umask077-for-all-users.sh
            echo "Set firewall to drop zone"
            firewall-cmd --set-default-zone=drop
            firewall-cmd --add-protocol=ipv6-icmp --permanent
            firewall-cmd --add-service=dhcpv6-client --permanent
            echo "Replicate chrony.conf from GrapheneOS"
            sudo curl -fsSL https://raw.githubusercontent.com/GrapheneOS/infrastructure/main/chrony.conf > /etc/chrony.conf
            sudo systemctl restart chronyd
            echo "Hardening tweaks have been set up, you should reboot"
           ;;
        98)
            echo "Reboot"
            shutdown -r now
           ;;
        99)
          exit 0
          ;;
    esac
done
