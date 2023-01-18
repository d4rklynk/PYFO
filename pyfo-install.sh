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
         2 "Speed up DNF - This enables fastestmirror, max downloads and deltarpms""Enable AutoUpdates - Recommended"     
         3 "Enable AutoUpdates - Recommended"
         4 "Enable RPM Fusion - Enables the RPM Fusion repos for your specific version"
         5 "Update Firmware - If your system supports fw update delivery"
         6 "Install Basic Software - check basic-softwares file for more information"
         7 "Install Extras Software - Installs a bunch of my most used software"
         8 "Enable Flatpak - Enables the Flatpak repo and installs packages"
         9 "Install some flatpak software - Check flaptak-packages.txt"
         10 "Install Brave - Recommended, installed from official repo"
         11 "Install Videos packages - Video codec and stuff as per the official doc"
         12 "Install Oh-My-ZSH - ZSH will be also installed"
         13 "Install minimal Oh-My-ZSH plugins"
         14 "Install Nvidia - Install akmod nvidia drivers and CUDA"
         15 "Install linux-hardened - NOT NVIDIA USER - A linux hardened package from my COPR repo"
	 16 "Harden your Fedora - Download kicksecure files, blacklisting unused modules, harden boot"
         17 "Install hardened_malloc - A hardened_malloc package for fedora"
         18 "Set default for hardened_malloc - If you don't know, do nothing"
         19 "More hardening tweaks - NTS time, umask, firewall"
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
            echo "Speeding Up DNF"
            echo 'fastestmirror=1' | sudo tee -a /etc/dnf/dnf.conf
            echo 'max_parallel_downloads=10' | sudo tee -a /etc/dnf/dnf.conf
            echo 'deltarpm=true' | sudo tee -a /etc/dnf/dnf.conf
            notify-send "Your DNF config has now been amended" --expire-time=10
           ;;
        3)
            echo "Enable AutoUpdates"
            sudo dnf install dnf-automatic
            sudo systemctl enable --now dnf-automatic-install.timer
            notify-send "System updated - Reboot now" --expire-time=10
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
            sudo fwupdmgr update
            ;;
        6)
            echo "Install Basic Software"
            sudo dnf install -y $(cat basic-dnf.txt)
            notify-send "Basic Software have been installed" --expire-time=10
            ;;
        7)  
            echo "Installing Extras Software"
            sudo dnf install -y $(cat extras-dnf.txt)
            notify-send "Extras Software have been installed" --expire-time=10
            ;;
        8)
            echo "Enabling Flatpak"
            flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
            flatpak update
            flatpak install flathub com.github.tchx84.Flatseal
            notify-send "Flatpak has now been enabled and Flatseal is installed" --expire-time=10
            ;;
        9)
            echo "Install some flatpak software"
            source 'flatpak-install.sh'
            ;;    
        10)  
            echo "Installing Brave"
            sudo dnf install -y dnf-plugins-core
            sudo dnf config-manager --add-repo https://brave-browser-rpm-release.s3.brave.com/x86_64/
            sudo rpm --import https://brave-browser-rpm-release.s3.brave.com/brave-core.asc
            sudo dnf install -y brave-browser
            notify-send "Brave has been installed" --expire-time=10
            ;;
        11)  
            echo "Installing Videos packages"
            sudo dnf install gstreamer1-plugins-{bad-\*,good-\*,base} gstreamer1-plugin-openh264 gstreamer1-libav --exclude=gstreamer1-plugins-bad-free-devel
            sudo dnf install -y lame\* --exclude=lame-devel
            sudo dnf group upgrade -y --with-optional Multimedia
            sudo dnf update -y
            notify-send "All done" --expire-time=10
           ;;
        12)  
            echo "Installing Oh-My-Zsh"
            sudo dnf -y install zsh util-linux-user
            sh -c "$(curl -fsSL $OH_MY_ZSH_URL)"
            echo "change shell to ZSH"
            chsh -s "$(which zsh)"
            notify-send "Oh-My-Zsh is ready to rock n roll" --expire-time=10
            ;;
        13)  
            echo "Installing minimal Oh-My-ZSH plugins"
            git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
            curl -fsSL https://raw.githubusercontent.com/d4rklynk/my-zsh-config/main/.zshrc > ~/.zshrc
            notify-send "Plugins have been installed" --expire-time=10
            ;;
        14)  
            echo "Installing Nvidia Driver Akmod-Nvidia"
            sudo dnf install -y akmod-nvidia
	    sudo dnf install xorg-x11-drv-nvidia-cuda
            notify-send "All done" --expire-time=10
	       ;;
        15)
            echo "Install kernel-hardened"
            sudo dnf copr enable samsepi0l/HardHatOS
            sudo dnf install -y kernel-hardened
            sudo bash -c 'echo "kernel.unprivileged_userns_clone=1" > /etc/sysctl.d/10_kernel.unprivileged_userns_clone.conf'
            notify-send "kernel-hardened has been installed (you must reboot to make it effective)" --expire-time=10
           ;;
	16)
	    echo "Hardening Fedora [WIP]"
	    echo "WIP"
	    notify-send "Fedora is hardened (you must reboot to make it effective)" --expire-time=10
        17)
            echo "Installing hardened_malloc"
            sudo dnf copr enable samsepi0l/HardHatOS
            sudo dnf install -y hardened_malloc
            notify-send "hardened_malloc installed (you must reboot to make it effective)" --expire-time=10
           ;;
        18)
            echo "Set hardening_malloc to default"
            sudo bash -c 'echo "libhardened_malloc.so" > /etc/ld.so.preload '
            notify-send "hardening_malloc has been set to default (you must reboot to make it effective)" --expire-time=10
           ;;
        19)
            echo "Set umask to 077 for all users instead of 022"
            sudo bash -c 'echo "umask 077" >  cat /etc/profile.d/set-umask077-for-all-users.sh'
            echo "Set firewall to drop zone"
            firewall-cmd --set-default-zone=drop
            firewall-cmd --add-protocol=ipv6-icmp --permanent
            firewall-cmd --add-service=dhcpv6-client --permanent
            echo "Replicate chrony.conf from GrapheneOS"
            sudo bash -c 'curl -fsSL https://raw.githubusercontent.com/GrapheneOS/infrastructure/main/chrony.conf > /etc/chrony.conf'
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
