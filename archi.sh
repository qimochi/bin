#!/bin/sh

loadkeys us
timedatectl set-ntp true

# partitions u need to do by manual before next step, make sure u mount everythin on proper place (SWAPON,/mnt/boot,/mnt,/mnt/home)
# use lsblk, then cfdisk, then format those with mkfs

#base
pacstrap /mnt base base-devel linux-lts linux-firmware

#fstab
genfstab -U /mnt >> /mnt/etc/fstab

#chroot
arch-chroot /mnt /bin/bash

#things
ln -sf /usr/share/zoneinfo/Asia/Jakarta /etc/localtime
hwclock --systohc
sed -i '177s/.//' /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" >> /etc/locale.conf
echo "KEYMAP=us" >> /etc/vconsole.conf
echo "arch" >> /etc/hostname
echo "127.0.0.1 localhost" >> /etc/hosts
echo "::1       localhost" >> /etc/hosts
echo "127.0.1.1 arch.localdomain arch" >> /etc/hosts

# for adsblock https://github.com/StevenBlack/hosts

echo root:password | chpasswd

# default password is password

pacman -S grub efibootmgr arandr fish ffmpeg tumbler imagemagick maim htop thunar pkgfile ncmpcpp mpd mpc mpv neofetch polkit-gnome gnome-keyring inter-font ttf-roboto noto-fonts-cjk noto-fonts-emoji ttf-font-awesome awesome-terminal-fonts playerctl scrot dunst pacman-contrib light-locker lightdm bspwm sxhkd firefox picom nitrogen lxappearance dmenu mtpfs git less intel-ucode android-udev networkmanager man-pages man-db network-manager-applet dialog wpa_supplicant mtools dosfstools reflector avahi xdg-user-dirs xdg-utils gvfs gvfs-smb nfs-utils inetutils dnsutils bluez bluez-utils cups hplip alsa-utils pipewire pipewire-alsa pipewire-pulse pipewire-jack bash-completion openssh rsync reflector acpi acpi_call tlp ufw blueman flatpak sof-firmware acpid os-prober ntfs-3g terminus-font vim ranger w3m cmake macchanger gucharmap

# add chaotic & other repos
pacman-key --recv-key 3056513887B78AEB --keyserver keyserver.ubuntu.com
pacman-key --lsign-key 3056513887B78AEB
pacman -U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst' 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst'
cat <<EOF >> /etc/pacman.conf
[chaotic-aur]
Include = /etc/pacman.d/chaotic-mirrorlist

[seblu]
Server = https://al1.seblu.net/$repo/$arch
Server = https://al2.seblu.net/$repo/$arch

[kernel]
Server = https://repo.archlinuxrepo.dev/$arch/$repo

EOF
pacman -Syy

# pacman -S --noconfirm xf86-video-intel
# pacman -S --noconfirm nvidia nvidia-utils nvidia-settings


#uefi
grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg

#bios
#grub-install --target=i386-pc /dev/sdX #bootable partition
#grub-mkconfig -o /boot/grub/grub.cfg

systemctl enable NetworkManager
systemctl enable bluetooth
systemctl enable cups.service
systemctl enable sshd
systemctl enable avahi-daemon
systemctl enable tlp
systemctl enable reflector.timer
systemctl enable fstrim.timer
systemctl enable acpid

ln -s /etc/fonts/conf.avail/70-no-bitmaps.conf /etc/fonts/conf.d
ln -s /etc/fonts/conf.avail/10-sub-pixel-rgb.conf /etc/fonts/conf.d
ln -s /etc/fonts/conf.avail/11-lcdfilter-default.conf /etc/fonts/conf.d
echo "<?xml version="1.0"?>
<!DOCTYPE fontconfig SYSTEM "fonts.dtd">
<fontconfig>
	<match>
		<edit mode="prepend" name="family">
			<string>Inter</string>
		</edit>
	</match>
	<match target="pattern">
		<test qual="any" name="family">
			<string>serif</string>
		</test>
		<edit name="family" mode="assign" binding="same">
			<string>Noto Serif</string>
		</edit>
	</match>
	<match target="pattern">
		<test qual="any" name="family">
			<string>sans-serif</string>
		</test>
		<edit name="family" mode="assign" binding="same">
			<string>Noto Sans</string>
		</edit>
	</match>
	<match target="pattern">
		<test qual="any" name="family">
			<string>monospace</string>
		</test>
		<edit name="family" mode="assign" binding="same">
			<string>Noto Mono</string>
		</edit>
	</match>
</fontconfig>" >> /etc/fonts/local.conf

useradd -m sex -s /bin/bash
echo sex:password | chpasswd
usermod -aG storage,video,wheel,audio,input,power,rfkill sex
echo "sex ALL=(ALL) ALL" >> /etc/sudoers.d/sex

#patch pkg
git clone https://github.com/siduck76/st.git && cd st/ && make install && rm -rf st/ && cd ..
git clone https://github.com/Stardust-kyun/dmenu && cd dmenu/ && make clean install && rm -rf dmenu/ && cd


gsettings set org.blueman.plugins.powermanager auto-power-on false
/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1

printf "\e[1;32mDone! Type exit, umount -a and reboot, post installation u need to config fish, lightdm/xinit, and wm .\e[0m"

##################################### post installations ###################################################################


# sudo pacman -S aura
# sudo pacman -S gtk3-nocsd-git polybar gksu octopi
# sudo aura -Ay upd72020x-fw wd719x-firmware aic94xx-firmware libxft-bgra rxvt-unicode-truecolor-wide-glyphs i3lock-color-git lightdm-webkit2-theme-glorious python-ueberzug-git cwm

# echo "if [[ $(ps --no-header --pid=$PPID --format=cmd) != "fish" ]]
# then
#	exec fish
# fi" >> /home/sex/.bashrc
# sudo pkgfile --update
# curl -L https://get.oh-my.fish | fish
# omf install archlinux bang-bang cd colorman sudope vcs bass pure
# echo "source /home/sex/.local/share/omf/pkg/colorman/init.fish" >> /home/sex/.config/fish/config.fish
