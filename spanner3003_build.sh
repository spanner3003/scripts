#!/bin/bash
#
# Script to build CM9 for Galaxy Tab (with Kernel)
# 2012 Chirayu Desai 

# Common defines
txtrst='\e[0m'  # Color off
txtred='\e[0;31m' # Red
txtgrn='\e[0;32m' # Green
txtylw='\e[0;33m' # Yellow
txtblu='\e[0;34m' # Blue

echo -e "${txtblu}##########################################"
echo -e "${txtblu}#                                        #"
echo -e "${txtblu}#         GALAXYTAB BUILDSCRIPT          #"
echo -e "${txtblu}#                                        #"
echo -e "${txtblu}##########################################"
echo -e "\r\n ${txtrst}"
echo -e ""

# Starting Timer
START=$(date +%s)
DEVICE="$1"
BUILDTYPE="$2"
THREADS=$(cat /proc/cpuinfo | grep processor | wc -l)
TOPDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

checkrepo() {
        if [ -d "${TOPDIR}/kernel/samsung/p1" -a -d "${TOPDIR}/vendor/cm" -a \
                -x "${TOPDIR}/kernel/samsung/p1/build_zImage.sh" ]; then
		return
	fi
	echo -e "${txtred}Error, files or directories missing! Be sure you"
	echo -e "have a clean sync!${txtrst}"
	echo ""
	exit 10
}

usage() {
	echo -e "${txtblu}Usage: $0 device buildtype"
	echo -e "Example: $0 p1 eng"
	echo -e "${txtylw}Default:${txtblu} p1 userdebug"
	echo -e "${txtylw}Supported Devices:${txtblu} p1 p1c p1l p1n"
	echo -e "${txtylw}Supported Buildtypes:${txtblu} eng userdebug user"
	echo -e "${txtrst}"
	return
}

CHECK_ZIMAGE(){
	if [ ! -e kernel/samsung/p1/arch/arm/boot/zImage ]; then
		BUILD_ZIMAGE
	elif [ -e kernel/samsung/p1/arch/arm/boot/zImage ]
	then
		REBUILD_ZIMAGE
	fi
}

CHECK_BOOT_IMG(){
	if [ ! -e kernel/samsung/p1/boot.img ]; then
		BUILD_BOOT_IMG
	elif [ -e kernel/samsung/p1/boot.img ]
	then
		REBUILD_BOOT_IMG
	fi
}

BUILD_ZIMAGE(){
	echo -e "${txtylw}Building a zImage kernel.....${txtrst}"
	cd "$TOPDIR"/kernel/samsung/p1
	./build_zImage.sh "$TARGET" || exit 20
	cd "$TOPDIR"
}

BUILD_BOOT_IMG(){
	echo -e "${txtylw}Building a boot.img kernel...${txtrst}"
	cd "$TOPDIR"/kernel/samsung/p1
	./build_boot.img.sh "$TARGET" || exit 20
	cd "$TOPDIR"
}

REBUILD_ZIMAGE(){
	echo -e -n "${txtylw}zImage found, Do you want to build a new one? ${txtrst}"
	read yes_no

	if [ "$yes_no" = "yes" ]; then
		BUILD_ZIMAGE
	elif [ "$yes_no" = "no" ]
	then
		return
	else
		echo -e "${txtred}Plaese type yes or no.${txtrst}"
		REBUILD_ZIMAGE
	fi
}

REBUILD_BOOT_IMG(){
	echo -e -n "${txtylw}boot.img found, Do you want to build a new one? ${txtrst}"
	read yes_no

	if [ "$yes_no" = "yes" ]; then
		BUILD_BOOT_IMG
	elif [ "$yes_no" = "no" ]
	then
		return
	else
		echo -e "${txtred}Plaese type yes or no.${txtrst}"
		REBUILD_BOOT_IMG
	fi
}

checkrepo

case "$DEVICE" in
	clean)
		echo -e "${txtylw}Making Clean very clean....${txtrst}"
		make installclean || exit 30
		make clean || exit 31
		make clobber || exit 32
		cd kernel/samsung/p1
		./build_zImage.sh clean || exit 35
		exit
		;;
	p1|P1)
		TARGET=P1
		;;
	p1c|P1C)
		TARGET=P1C
		;;
	p1l|P1L)
		TARGET=P1L
		;;
	p1n|P1N)
		TARGET=P1N
		;;
	*)
		usage
		;;
esac

case "$BUILDTYPE" in
	eng)
		LUNCH=cm_galaxytab-eng
		;;
	userdebug)
		LUNCH=cm_galaxytab-userdebug
		;;
	user)
		LUNCH=cm_galaxytab-user
		;;
	*)
		usage
		;;
esac

if [ "$1" = "" ] ; then
TARGET=p1
fi

if [ "$2" = "" ] ; then
LUNCH=cm_galaxytab-userdebug
fi

# Check for Prebuilts
echo -e "${txtylw}Checking for Prebuilts...${txtrst}"
if [ ! -e vendor/cm/proprietary/RomManager.apk ] || [ ! -e vendor/cm/proprietary/Term.apk ] || [ ! -e vendor/cm/proprietary/lib/armeabi/libjackpal-androidterm3.so ]; then
	echo -e "${txtred}Prebuilts not found, downloading now...${txtrst}"
	cd vendor/cm
	./get-prebuilts || exit 40
	cd "$TOPDIR"
else
	echo -e "${txtgrn}Prebuilts found.${txtrst}"
fi

# Setup build environment and start the build
echo -e "${txtylw}Setting up Build environment....${txtrst}"
. build/envsetup.sh
lunch "$LUNCH" || exit 50

# Ask what do you want to build zImage or Boot.img
while :
do
	echo -e -n "${txtylw}What do you want to build choose 1 for zImage and 2 for boot.img: ${txtrst}"
	read build
	case $build in
		1) CHECK_ZIMAGE; break;;
		2) CHECK_BOOT_IMG; break;;
		*) echo -e "${txtred}Please choose 1 for zImage or 2 for boot.img.${txtrst}";;
	esac
done
# Android build
echo -e "${txtylw}Running make on it's own first....${txtrst}"
make -j$THREADS || exit 255
echo -e "${txtylw}Now running make bacon....${txtrst}"
make -j$THREADS bacon || exit 255

END=$(date +%s)
ELAPSED=$((END - START))
E_MIN=$((ELAPSED / 60))
E_SEC=$((ELAPSED - E_MIN * 60))
printf "Elapsed: "
[ $E_MIN != 0 ] && printf "%d min(s) " $E_MIN
printf "%d sec(s)\n" $E_SEC
