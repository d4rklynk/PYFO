#!/usr/bin/env bash

height=20
width=90
choice_height=4
backtitle="PYFO by samsepi0l - Initally by Osiris - https://lsass.co.uk"
title="Make a selection"
menu="Choose one of the following options:"

#Other variables
oh_my_zsh_url="https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh"

#Check to see if Dialog is installed, if not install it - Thanks Kinkz_nl
if [ $(rpm -q dialog 2>/dev/null | grep -c "is not installed") -eq 1 ]; then
  dnf install -y dialog
fi

#Check to see if firewalld is installed, if not install it - Thanks Kinkz_nl
if [ $(rpm -q firewalld 2>/dev/null | grep -c "is not installed") -eq 1 ]; then
  dnf install -y firewalld
  systemctl enable --now firewalld
fi

options=(1 "Update your system - Do that first if you did not already"
         2 "Speed up DNF - This enables fastestmirror, max downloads and deltarpms"   
         3 "Enable AutoUpdates - Recommended"
         4 "Enable RPM Fusion - Enables the RPM Fusion repos for your specific version"
         5 "Update Firmware - If your system supports fw update delivery"
         6 "Install Basic Software - check basic-softwares file for more information"
         7 "Install Extras Software - Installs a bunch of my most used software"
         8 "Enable Flatpak - Enables the Flatpak repo and installs packages"
         9 "Install some flatpak software - Check flatpak-packages.txt"
         10 "Install Brave - Recommended, installed from official repo"
         11 "Install Videos packages - Video codec and stuff as per the official doc"
         12 "Install Oh-My-ZSH - ZSH will be also installed"
         13 "Install minimal Oh-My-ZSH plugins"
         14 "Install Nvidia - Install akmod nvidia drivers and CUDA"
	 15 "Harden your Fedora - Download kicksecure files, blacklisting unused modules, harden boot"
         16 "Install hardened_malloc - A hardened_malloc package for fedora"
         17 "Set default for hardened_malloc - If you don't know, do nothing"
         18 "More hardening tweaks - NTS time, umask, firewall"
	 19 "Harden SSH - DO NOT. READ THE CODE FIRST and what it implies."
	 20 "Set vim your default editor - Because who use nano"
	 21 "Install Orchis shell theme"
	 22 "Install Tela Circle Icons theme"
	 23 "Gnome layout settings - Clock 24h format, titlebar buttons"
         98 "Reboot your system"
	 99 "Quit")

while [ "$choice -ne 4" ]; do
  choice=$(dialog --clear \
    --backtitle "$backtitle" \
    --title "$title" \
    --nocancel \
    --menu "$menu" \
    $height $width $choice_height \
    "${options[@]}" \
    2>&1 >/dev/tty)

    clear
    case $choice in
        1)
            echo "Update system"
            dnf upgrade -y
            dnf autoremove -y
            notify-send "System updated - Reboot now" --expire-time=10
            ;;
        2)
            echo "Speeding Up DNF"
            echo 'fastestmirror=1' | tee -a /etc/dnf/dnf.conf
            echo 'max_parallel_downloads=10' | tee -a /etc/dnf/dnf.conf
            echo 'deltarpm=true' | tee -a /etc/dnf/dnf.conf
            notify-send "Your DNF config has now been amended" --expire-time=10
           ;;
        3)
            echo "Enable AutoUpdates"
            dnf install -y dnf-automatic
            systemctl enable --now dnf-automatic-install.timer
            notify-send "System updated - Reboot now" --expire-time=10
            ;;
        4)  
            echo "Enabling RPM Fusion"
            dnf install -y https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
	    dnf upgrade --refresh -y
            dnf group update -y core
            dnf install -y dnf-plugins-core
            notify-send "RPM Fusion Enabled" --expire-time=10
            ;;
        5)  
            echo "Updating Firmware"
	        dnf upgrade -y
            fwupdmgr get-devices 
            fwupdmgr refresh --force 
            fwupdmgr get-updates -y
            fwupdmgr update -y
            ;;
        6)
            echo "Install Basic Software"
            dnf install -y $(cat basic-dnf.txt)
            notify-send "Basic Software have been installed" --expire-time=10
            ;;
        7)  
            echo "Installing Extras Software"
            dnf install -y $(cat extras-dnf.txt)
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
            dnf install -y dnf-plugins-core
            dnf config-manager --add-repo https://brave-browser-rpm-release.s3.brave.com/x86_64/
            rpm --import https://brave-browser-rpm-release.s3.brave.com/brave-core.asc
            dnf install -y brave-browser
            notify-send "Brave has been installed" --expire-time=10
            ;;
        11)  
            echo "Installing Videos packages"
            dnf install gstreamer1-plugins-{bad-\*,good-\*,base} gstreamer1-plugin-openh264 gstreamer1-libav --exclude=gstreamer1-plugins-bad-free-devel
            dnf install -y lame\* --exclude=lame-devel
            dnf group upgrade -y --with-optional Multimedia
            dnf update -y
            notify-send "All done" --expire-time=10
           ;;
        12)  
            echo "Installing Oh-My-Zsh"
            dnf -y install zsh util-linux-user
            sh -c "$(curl -fsSL $oh_my_zsh_url)"
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
            dnf install -y akmod-nvidia
	        dnf install xorg-x11-drv-nvidia-cuda
            notify-send "All done" --expire-time=10
	    ;;
	15)
	    echo "Hardening Fedora [WIP]"
	    ### Download sysctl files from kicksecure
	    echo "Downloading sysctl files from kicksecure"
	    curl -fsSL https://raw.githubusercontent.com/Kicksecure/security-misc/master/usr/lib/sysctl.d/990-security-misc.conf > /etc/sysctl.d/30_security-misc.conf
	    curl -fsSL https://raw.githubusercontent.com/Kicksecure/security-misc/master/usr/lib/sysctl.d/30_silent-kernel-printk.conf > /etc/sysctl.d/30_silent-kernel-printk.conf
	    curl -fsSL https://raw.githubusercontent.com/Kicksecure/security-misc/master/usr/lib/sysctl.d/30_security-misc_kexec-disable.conf > /etc/sysctl.d/30_security-misc_kexec-disable.conf
	    ### Harden boot parameters
	    # echo "Hardening Boot paramaters"
	    # bash -c 'sed -i '6iGRUB_CMDLINE_LINUX_DEFAULT="slab_nomerge init_on_alloc=1 init_on_free=1 page_alloc.shuffle=1 pti=on vsyscall=none debugfs=off oops=panic lockdown=confidentiality mce=0 quiet loglevel=0 spectre_v2=on spec_store_bypass_disable=on tsx=off tsx_async_abort=full,nosmt mds=full,nosmt l1tf=full,force nosmt=force kvm.nx_huge_pages=force randomize_kstack_offset=on"''
	    # grub2-mkconfig -o /boot/grub2/grub.cfg
	    # echo "You can add "module.sig_enforce=1" if you signed your Nvidia drivers"
	    ### Modules blacklisting
	    curl -fsSL https://raw.githubusercontent.com/Kicksecure/security-misc/master/etc/modprobe.d/30_security-misc.conf > /etc/modprobe.d/30_security-misc.conf
	    notify-send "Fedora is hardened (you must reboot to make it effective)" --expire-time=10
	    ;;       
        16)
            echo "Installing hardened_malloc"
            dnf copr enable samsepi0l/HardHatOS
            dnf install -y hardened_malloc
            notify-send "hardened_malloc installed (you must reboot to make it effective)" --expire-time=10
           ;;
        17)
            echo "Set hardening_malloc to default"
    	    echo "libhardened_malloc.so" > /etc/ld.so.preload
            notify-send "hardening_malloc has been set to default (you must reboot to make it effective)" --expire-time=10
           ;;
        18)
	        ### umask 
            echo "Set umask to 077 for all users instead of 022"
            echo "umask 077" > /etc/profile.d/set-umask077-for-all-users.sh
	        ### Make home directory private
	        chmod 700 /home/*
	        ### SSH
	        echo "GSSAPIAuthentication no" | tee /etc/ssh/ssh_config.d/10-custom.conf
	        echo "VerifyHostKeyDNS yes" | tee -a /etc/ssh/ssh_config.d/10-custom.conf
	        ### Firewall
            echo "Set firewall to drop zone"
            firewall-cmd --set-default-zone=drop
            firewall-cmd --add-protocol=ipv6-icmp --permanent
            firewall-cmd --add-service=dhcpv6-client --permanent
	        ### NTS
            echo "Replicate chrony.conf from GrapheneOS"
            curl -fsSL https://raw.githubusercontent.com/GrapheneOS/infrastructure/main/chrony.conf > /etc/chrony.conf
            systemctl restart chronyd
	        ### Hardening
	        mkdir -p /etc/systemd/system/NetworkManager.service.d
	        curl https://gitlab.com/divested/brace/-/raw/master/brace/usr/lib/systemd/system/NetworkManager.service.d/99-brace.conf -o /etc/systemd/system/NetworkManager.service.d/99-brace.conf
	        mkdir -p /etc/systemd/system/irqbalance.service.d
	        curl https://gitlab.com/divested/brace/-/raw/master/brace/usr/lib/systemd/system/irqbalance.service.d/99-brace.conf -o /etc/systemd/system/irqbalance.service.d/99-brace.conf
            echo "Hardening tweaks have been set up, you should reboot"
           ;;
	19)
		# Harden SSH
		echo "Download sshd_config from GrapheneOS configuration"
		curl https://raw.githubusercontent.com/GrapheneOS/infrastructure/main/ssh/sshd_config -o /etc/ssh/sshd_config
		
		# /!\/!\/!\ Change samsepi0l with the user you want to connect, for example if your name is darlene, do like so :
		# -> sed -i 's/AllowUsers {{ssh_users}}/AllowUsers darlene/' /etc/ssh/sshd_config
		# and for multiples users, like darlene and Angela do so :
		# -> sed -i 's/AllowUsers {{ssh_users}}/AllowUsers darlene Angela/' /etc/ssh/sshd_config
		sed -i 's/AllowUsers {{ssh_users}}/AllowUsers root/' /etc/ssh/sshd_config
		sed -i 's/KexAlgorithms sntrup761x25519-sha512@openssh.com/KexAlgorithms curve25519-sha256/' /etc/ssh/sshd_config
		systemctl restart sshd	
	   ;;
	20)
	   ### vim default editor
	   rm -f /etc/profile.d/nano-default-editor.{csh,sh}
	   if grep -qi '^export SUDO_EDITOR=' /etc/environment; then
	    sed -i 's/^export SUDO_EDITOR=.*/export SUDO_EDITOR="vim"/' /etc/environment
	   else
	   	echo "export SUDO_EDITOR="vim"" >> /etc/environment
	   fi
	   if grep -qi '^export VISUAL=' /etc/environment; then
	   	sed -i 's/^export VISUAL=.*/export VISUAL="vim"/' /etc/environment
	   else
	   	echo "export VISUAL="vim"" >> /etc/environment
	   fi
	   if grep -qi '^export EDITOR=' /etc/environment; then
	   	sed -i 's/^export EDITOR=.*/export EDITOR="vim"/' /etc/environment
	   else
	   	echo "export EDITOR="vim"" >> /etc/environment
	   fi
	   ;;
	21)
	   ### Install Orchis Theme
	   dnf install -y gtk-murrine-engine sassc gnome-shell-extension-user-theme
	   git clone https://github.com/vinceliuice/Orchis-theme.git ~/Downloads/Orchis-theme
	   pushd ~/Downloads/Orchis-theme
	   ./install.sh -l --tweaks compact macos
	   gnome-extensions enable user-theme@gnome-shell-extensions.gcampax.github.com 
	   gsettings set org.gnome.shell.extensions.user-theme name "Orchis"
	   gsettings set org.gnome.desktop.interface gtk-theme "Orchis"
	   ;;
	22)
	   ### Install Tela circle icons theme
	   git clone https://github.com/vinceliuice/Tela-circle-icon-theme.git ~/Downloads/Tela-circle-icon-theme
	   pushd ~/Downloads/Tela-circle-icon-theme
	   ./install.sh -c
	   gsettings set org.gnome.desktop.interface icon-theme "Tela-circle"
	   ;;
	23)
	   # Clocks and calendar settings
	   gsettings set org.gnome.desktop.interface clock-format '24h'
	   gsettings set org.gnome.desktop.interface clock-show-date true
	   gsettings set org.gnome.desktop.interface clock-show-seconds true
	   gsettings set org.gnome.desktop.interface clock-show-weekday true
	   # Enable window buttons
	   gsettings set org.gnome.desktop.wm.preferences button-layout ":minimize,maximize,close"
	   # Set new windows centered
	   gsettings set org.gnome.mutter center-new-windows true
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
