# timedatectl set-ntp true;
# fdisk -l

# read -p "Type device to install on (e.g. /dev/sda): " device;
# read -p "Install on $device? (Y/N): " confirm && [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]] || exit 1;

bios () {
	fdisk -l;
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