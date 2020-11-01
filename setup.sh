# timedatectl set-ntp true;
# fdisk -l

# read -p "Type device to install on (e.g. /dev/sda): " device;
# read -p "Install on $device? (Y/N): " confirm && [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]] || exit 1;

bios () {
	read -p "Type device to install on (e.g. /dev/sda): " device;
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
}

efi () {
	read -p "Type device to install on (e.g. /dev/sda): " device;
	sed -e 's/\s*\([\+0-9a-zA-Z]*\).*/\1/' << EOF | fdisk $device;
		g # set to gpt
		n # new partition
		p # primary partition
		1 # partition number 1
		# default - start at beginning of disk 
		+550M # 550M boot partition

		n # new partition
		p # primary partition
		2 # partion number 2
		# default, start immediately after preceding partition
		+4G # 4G swap partition

		n # new partition
		p # primary partition
		3 # partion number 3
		# default, start immediately after preceding partition
		# default, extend partition to end of disk

		t # change sda1 type to EFI
		1 # sda1 for EFI
		1 #number for EFI partition

		t # change type to swap
		2 # sda2 for swap
		19 #number for swap partition

		w # write the partition table
EOF
}


get_boot () {
	read -p "Type B for BIOS\n U for EFI\n (e.g. B): " boot;

	if [ $boot == 'B' ] || [ $boot == 'b' ]; then
		bios;
	elif [ $boot == 'E' ] || [ $boot == 'e' ]; then
		efi;
	else
		get_boot;
	fi;
}
get_boot;



# packages=(gnome vim slatt);

# for i in ${packages[@]}; do
# 	echo "pacman -s $i";
# 	echo "installed $i\n"
# done

# echo $fullname;