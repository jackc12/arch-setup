# timedatectl set-ntp true;
# fdisk -l

# read -p "Type device to install on (e.g. /dev/sda): " device;
# read -p "Install on $device? (Y/N): " confirm && [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]] || exit 1;

get_boot () {
	read -p 'Type B for BIOS U for UEFI (e.g. B): ' boot;

	if [ $boot == 'B' ] || [ $boot == 'b' ]; then
		echo 'BIOS';
	elif [ $boot == 'U' ] || [ $boot == 'u' ]; then
		echo 'UEFI';
	else
		get_boot;
	fi;
}
get_boot;
echo "Look $boot";
echo "Hercahercules $boot";



# packages=(gnome vim slatt);

# for i in ${packages[@]}; do
# 	echo "pacman -s $i";
# 	echo "installed $i\n"
# done

# echo $fullname;