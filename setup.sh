# timedatectl set-ntp true;
# fdisk -l

# read -p "Type device to install on (e.g. /dev/sda): " device;
# read -p "Install on $device? (Y/N): " confirm && [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]] || exit 1;

bios () {
	fdisk -l;
	read -p "Type device to install on (e.g. /dev/sda): " device;
	read -p "This will delete everything on $device! Would you like to proceed? (Y/N): " confirm && [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]] || exit 1;

	dd if=/dev/zero of=$device bs=512 count=1 conv=notrunc
	sed -e 's/\s*\([\+0-9a-zA-Z]*\).*/\1/' << EOF | fdisk $device;
		o # set to dos

		n # new partition
		p # primary partition
		1 # partition number 1
		# default - start at beginning of disk 
		+4G # 4G swap partition

		n # new partition
		p # primary partition
		2 # partion number 2
		# default, start immediately after preceding partition
		# default, extend partition to end of disk

		t # change type to swap
		1 # sda1 is swap
		82 #number for swap partition

		w # write the partition table
EOF

mkfs.ext4 "${device}2";
mkswap "${device}1";
swapon "${device}1";

mount "${device}2 /mnt";

pacstrap /mnt base linux linux-firmware;

genfstab -U /mnt >> /mnt/etc/fstab;

arch-chroot /mnt;

ln -sf /usr/share/zoneinfo/America/New_York /etc/localtime;

hwclock --systohc;

#uncomment US keyboard
sed -i '/en_US.UTF-8\ UTF-8 /s/^#//' /etc/locale.gen;
locale-gen;

#modify locale.conf
echo 'LANG=en_US.UTF-8' > /etc/locale.conf;

#modify hostname
echo 'arch-dell' > /etc/hostname;

#modify hosts
echo '127.0.0.1		localhost
::1		localhost
127.0.1.1	arch-dell.localdomain	arch-dell' >> /etc/hosts;

sed -e 's/\s*\([\+0-9a-zA-Z]*\).*/\1/' << EOF | passwd;
	hercahercules
	hercahercules
EOF

pacman -Sy grub;

echo 'Installed grub

grub

GRUB

GRUB'

grub-install --target=i386-pc $device --force;

echo 'GRUB INSTALL COMPLETED

LOOK HERE DUMBASS'

grub-mkconfig -o /boot/grub/grub.cfg;

echo 'GRUB CONFIG MADE


MADE GRUB CONFIG'

exit;

echo 'EXITED arch-chroot

LOOK HERE'

unmount -a;

echo 'UNMOUNTED

LOOK ABOVE'

reboot;



}


get_boot () {
	read -p "Type B for BIOS\n U for EFI\n (e.g. B): " boot;

	if [ $boot == 'B' ] || [ $boot == 'b' ]; then
		bios;
	elif [ $boot == 'E' ] || [ $boot == 'e' ]; then
		echo 'need to implement efi';
	else
		get_boot;
	fi;
}
get_boot;