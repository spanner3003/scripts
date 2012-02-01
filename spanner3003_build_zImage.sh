#!/bin/bash
#
# Script to build Galaxy Tab Kernel
# 2012 Chirayu Desai 

# Common defines
txtrst='\e[0m'  # Color off
txtred='\e[0;31m' # Red
txtgrn='\e[0;32m' # Green
txtylw='\e[0;33m' # Yellow
txtblu='\e[0;34m' # Blue

echo -e "${txtblu}##########################################"
echo -e "${txtblu}#                                        #"
echo -e "${txtblu}#      GALAXYTAB KERNEL BUILDSCRIPT      #"
echo -e "${txtblu}#                                        #"
echo -e "${txtblu}##########################################"
echo -e "\r\n ${txtrst}"

# Starting Timer
START=$(date +%s)
DEVICE="$1"
THREADS=`cat /proc/cpuinfo | grep processor | wc -l`

case "$DEVICE" in
	clean)
		make clean
		exit
		;;
	p1|P1)
		DEFCONFIG=p1_cm9_defconfig
		;;
	p1c|P1C)
		DEFCONFIG=p1c_cm9_defconfig
		;;
	p1l|P1L)
		DEFCONFIG=p1l_cm9_defconfig
		;;
	p1n|P1N)
		DEFCONFIG=p1n_cm9_defconfig
		;;
	*)
		echo -e "${txtred}Usage: $0 device"
		echo -e "Example: ./build.sh p1"
		echo -e "Supported Devices: p1|P1 p1c|P1C p1l|P1L p1n|P1N ${txtrst}"
		;;
esac

# Some defines
KERNEL_DIR=`pwd`
KERNEL_INITRD_DIR="../initramfs"
KERNEL_INITRD_GIT="https://github.com/sgt7/p1000-initramfs-cm9.git"
INITSOURCE=`grep CONFIG_INITRAMFS_SOURCE arch/arm/configs/$DEFCONFIG `

# Check if initramfs is present, if not, then clone it
if [ ! -d $KERNEL_INITRD_DIR ]; then
	cd ..
	git clone $KERNEL_INITRD_GIT initramfs
	cd $KERNEL_DIR
fi

# .git is huge!
mv $KERNEL_INITRD_DIR/.git ~/DONOTLOOKATME

#echo -e "${txtblu} Checking if your initramfs path is correct...."
#if [ ! "$INITSOURCE" = "CONFIG_INITRAMFS_SOURCE="../initramfs"" ]; then
#	sed -i "s|CONFIG_INITRAMFS_SOURCE="usr/galaxytab_initramfs.list"|CONFIG_INITRAMFS_SOURCE="../initramfs"|" arch/arm/configs/$DEFCONFIG
#fi

# The real build starts now
if [ ! "$1" = "" ] ; then
make -j$THREADS ARCH=arm $DEFCONFIG
make -j$THREADS
fi

# move it back just in case
mv ~/DONOTLOOKATME $KERNEL_INITRD_DIR/.git

# The end!
END=$(date +%s)
ELAPSED=$((END - START))
E_MIN=$((ELAPSED / 60))
E_SEC=$((ELAPSED - E_MIN * 60))
printf "Elapsed: "
[ $E_MIN != 0 ] && printf "%d min(s) " $E_MIN
printf "%d sec(s)\n" $E_SEC
