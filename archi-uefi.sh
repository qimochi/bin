#!/bin/bash

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
echo root:password | chpasswd

pacman -S grub efibootmgr arandr fish ffmpeg tumbler imagemagick maim htop thunar pkgfile ncmpcpp mpd mpc mpv neofetch polkit-gnome gnome-keyring noto-fonts-cjk noto-fonts-emoji ttf-font-awesome awesome-terminal-fonts playerctl scrot dunst pacman-contrib light-locker lightdm bspwm sxhkd firefox rxvt-unicode picom nitrogen lxappearance dmenu mtpfs git less intel-ucode android-udev networkmanager man-pages man-db network-manager-applet dialog wpa_supplicant mtools dosfstools reflector base-devel linux-lts-headers linux-lts avahi xdg-user-dirs xdg-utils gvfs gvfs-smb nfs-utils inetutils dnsutils bluez bluez-utils cups hplip alsa-utils pipewire pipewire-alsa pipewire-pulse pipewire-jack bash-completion openssh rsync reflector acpi acpi_call tlp virt-manager qemu qemu-arch-extra edk2-ovmf bridge-utils dnsmasq vde2 openbsd-netcat iptables-nft ipset ufw blueman flatpak sof-firmware nss-mdns acpid os-prober ntfs-3g terminus-font vim ranger w3m

# add chaotic
pacman-key --recv-key 3056513887B78AEB --keyserver keyserver.ubuntu.com
pacman-key --lsign-key 3056513887B78AEB
pacman -U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst' 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst'
cat <<EOF >> /mnt/etc/pacman.conf
[chaotic-aur]
Include = /etc/pacman.d/chaotic-mirrorlist
EOF
pacman -Syy

# pacman -S --noconfirm xf86-video-intel
# pacman -S --noconfirm nvidia nvidia-utils nvidia-settings

grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg

systemctl enable NetworkManager
systemctl enable bluetooth
systemctl enable cups.service
systemctl enable sshd
systemctl enable avahi-daemon
systemctl enable tlp
systemctl enable reflector.timer
systemctl enable fstrim.timer
systemctl enable libvirtd
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

useradd -m sex
echo sex:password | chpasswd
usermod -aG libvirt sex

echo "sex ALL=(ALL) ALL" >> /etc/sudoers.d/sex

echo "if [[ $(ps --no-header --pid=$PPID --format=cmd) != "fish" ]]
then
	exec fish
fi" >> ~/.bashrc
pkgfile --update
curl -L https://get.oh-my.fish | fish
omf install archlinux bang-bang cd colorman sudope vcs bass pure
echo "source ~/.local/share/omf/pkg/colorman/init.fish" >> ~/.config/fish/config.fish

# add bullshit
git clone https://aur.archlinux.org/yay-bin.git && cd yay-bin/ && makepkg -sri && rm -rf yay-bin/ && cd ..
yay -S upd72020x-fw wd719x-firmware aic94xx-firmware aura-git libxft-bgra rxvt-unicode-truecolor-wide-glyphs thinkfan --removemake --noconfirm
aura -Sy gtk3-nocsd-git

printf "\e[1;32mDone! Type exit, umount -a and reboot.\e[0m"
