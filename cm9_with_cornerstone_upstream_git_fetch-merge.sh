#!/bin/bash

cd /var/lib/jenkins/workspace/cm9_with_cornerstone

. build/envsetup.sh
lunch cm_galaxytab-userdebug

cd $ANDROID_BUILD_TOP/device/samsung/galaxytab

git_remote=`git remote -v`
if [[ ! $git_remote = *upstream-sgt7* ]]; then
	git remote add upstream-sgt7 git://github.com/sgt7/device_samsung_galaxytab.git
fi
git fetch upstream-sgt7
echo "sgt7/device_samsung_galaxytab"
git merge upstream-sgt7/master

cd $ANDROID_BUILD_TOP/frameworks/base

git_remote=`git remote -v`
if [[ ! $git_remote = *upstream-sgt7* ]]; then
	git remote add upstream-sgt7 git://github.com/sgt7/android_frameworks_base.git
fi
git_remote=`git remote -v`
if [[ ! $git_remote = *upstream-cyan* ]]; then
	git remote add upstream-cyan git://github.com/CyanogenMod/android_frameworks_base.git
fi
git fetch upstream-sgt7
echo "sgt7/android_frameworks_base"
git merge upstream-sgt7/CS
git fetch upstream-cyan
echo "CyanogenMod/android_frameworks_base"
git merge upstream-cyan/ics

cd $ANDROID_BUILD_TOP/packages/apps/Phone

git_remote=`git remote -v`
if [[ ! $git_remote = *upstream-sgt7* ]]; then
	git remote add upstream-sgt7 git://github.com/sgt7/android_packages_apps_Phone.git
fi
git_remote=`git remote -v`
if [[ ! $git_remote = *upstream-cyan* ]]; then
	git remote add upstream-cyan git://github.com/CyanogenMod/android_packages_apps_Phone.git
fi
git fetch upstream-sgt7
echo "sgt7/android_packages_apps_Phone"
git merge upstream-sgt7/ics
git fetch upstream-cyan
echo "CyanogenMod/android_packages_apps_Phone"
git merge upstream-cyan/ics

cd $ANDROID_BUILD_TOP/packages/apps/Settings

git_remote=`git remote -v`
if [[ ! $git_remote = *upstream-sgt7* ]]; then
	git remote add upstream-sgt7 git://github.com/sgt7/android_packages_apps_Settings.git
fi
git_remote=`git remote -v`
if [[ ! $git_remote = *upstream-cyan* ]]; then
	git remote add upstream-cyan git://github.com/CyanogenMod/android_packages_apps_Settings.git
fi
git fetch upstream-sgt7
echo "sgt7/android_packages_apps_Settings"
git merge upstream-sgt7/ics
git fetch upstream-cyan
echo "CyanogenMod/android_packages_apps_Settings"
git merge upstream-cyan/ics

cd $ANDROID_BUILD_TOP/kernel/samsung/p1

git_remote=`git remote -v`
if [[ ! $git_remote = *upstream-sgt7* ]]; then
	git remote add upstream-sgt7 git://github.com/sgt7/p1000-kernel-cm9.git
fi
git fetch upstream-sgt7
echo "p1000-kernel-cm9"
git merge upstream-sgt7/android-samsung-2.6.35

cd $ANDROID_BUILD_TOP/kernel/samsung/initramfs

git_remote=`git remote -v`
if [[ ! $git_remote = *upstream-sgt7* ]]; then
	git remote add upstream-sgt7 git://github.com/sgt7/p1000-initramfs-cm9.git
fi
git fetch upstream-sgt7
echo "p1000-initramfs-cm9"
git merge upstream-sgt7/master

cd $ANDROID_BUILD_TOP/vendor/samsung

git_remote=`git remote -v`
if [[ ! $git_remote = *upstream-sgt7* ]]; then
	git remote add upstream-sgt7 git://github.com/sgt7/proprietary_vendor_samsung.git
fi
git fetch upstream-sgt7
echo "proprietary_vendor_samsung"
git merge upstream-sgt7/ics
