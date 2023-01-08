#!/usr/bin/env bash
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
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

OPTIONS=(1 "Update your system - Do that first if you didn't already"
         2 "Enable AutoUpdates - Recommended"        
         3 "Install Basic Software (check "cat basic-softwares" file for more information)"
         4 "Enable RPM Fusion - Enables the RPM Fusion repos for your specific version"
         5 "Update Firmware - If your system supports fw update delivery"
         6 "Speed up DNF - This enables fastestmirror, max downloads and deltarpms"
         7 "Enable Flatpak - Enables the Flatpak repo and installs packages"
         8 "Install Extras Software - Installs a bunch of my most used software"
         9 "Install Brave - Recommended, installed from offical repo"
         10 "Install Oh-My-ZSH"
         11 "Install minimal Oh-My-ZSH plugins"
         12 "Install Nvidia - Install akmod nvidia drivers"
         13 "Install linux-hardened - A linux hardened package from my COPR repo"
         14 "Install hardened_malloc - A hardened_malloc package for fedora"
         15 "Set default for hardened_malloc - If you don't know, do nothing"
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
            sudo fwupdmgr update
            ;;
        6)  
            echo "Speeding Up DNF"
            echo 'fastestmirror=1' | sudo tee -a /etc/dnf/dnf.conf
            echo 'max_parallel_downloads=10' | sudo tee -a /etc/dnf/dnf.conf
            echo 'deltarpm=true' | sudo tee -a /etc/dnf/dnf.conf
            notify-send "Your DNF config has now been amended" --expire-time=10
            ;;
        7)  
            echo "Enabling Flatpak"
            flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
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
        8)  
            echo "Installing Extras"
            sudo dnf install gstreamer1-plugins-{bad-\*,good-\*,base} gstreamer1-plugin-openh264 gstreamer1-libav --exclude=gstreamer1-plugins-bad-free-devel
            sudo dnf install -y lame\* --exclude=lame-devel
            sudo dnf group upgrade -y --with-optional Multimedia
            sudo dnf update -y
            notify-send "All done" --expire-time=10
           ;;
        10)  
            echo "Installing Oh-My-Zsh"
            sudo dnf -y install zsh util-linux-user
            sh -c "$(curl -fsSL $OH_MY_ZSH_URL)"
            echo "change shell to ZSH"
            chsh -s "$(which zsh)"
            notify-send "Oh-My-Zsh is ready to rock n roll" --expire-time=10
            ;;
        11)  
            echo "Installing minimal Oh-My-ZSH plugins"
            git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
            curl -fsSL https://raw.githubusercontent.com/d4rklynk/my-zsh-config/main/.zshrc > ~/.zshrc
            notify-send "Plugins have been installed" --expire-time=10
            ;;
        12)  
            echo "Installing Nvidia Driver Akmod-Nvidia"
            sudo dnf install -y akmod-nvidia
            notify-send "All done" --expire-time=10
	       ;;
        13)
            echo "Hardening kernel"
            sudo dnf copr enable samsepi0l/HardHatOS
            sudo dnf install kernel-hardened
            sudo echo "kernel.unprivileged_userns_clone=1" > /etc/sysctl.d/10_kernel.unprivileged_userns_clone.conf
            notify-send "Kernel is hardened (you must reboot to make it effective)" --expire-time=10
           ;;
        14)
            echo "Installing hardened_malloc"
            sudo dnf copr enable samsepi0l/HardHatOS
            sudo dnf install hardened_malloc
            notify-send "hardened_malloc installed (you must reboot to make it effective)" --expire-time=10
           ;;
        15)
            echo "Set hardening_malloc to default"
            sudo echo "libhardened_malloc.so" > /etc/ld.so.preload
            notify-send "hardening_malloc has been set to default (you must reboot to make it effective)" --expire-time=10
           ;;
        99)
          exit 0
          ;;
    esac
done
