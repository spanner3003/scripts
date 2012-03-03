#!/bin/bash

cd /var/lib/jenkins/workspace/cm9_with_cornerstone

. build/envsetup.sh
lunch cm_galaxytab-userdebug

cd $ANDROID_BUILD_TOP/device/samsung/galaxytab

git remote add upstream-sgt7 git://github.com/sgt7/device_samsung_galaxytab.git
git fetch upstream-sgt7
git merge upstream-sgt7/master

cd $ANDROID_BUILD_TOP/frameworks/base

git remote add upstream-sgt7 git://github.com/sgt7/android_frameworks_base.git
git remote add upstream-cyan git://github.com/CyanogenMod/android_frameworks_base.git
git fetch upstream-sgt7
git merge upstream-sgt7/ics
git fetch upstream-cyan
git merge upstream-cyan/ics

cd $ANDROID_BUILD_TOP/packages/apps/Phone

git remote add upstream-sgt7 git://github.com/sgt7/android_packages_apps_Phone.git
git remote add upstream-cyan git://github.com/CyanogenMod/android_packages_apps_Phone.git
git fetch upstream-sgt7
git merge upstream-sgt7/ics
git fetch upstream-cyan
git merge upstream-cyan/ics

cd $ANDROID_BUILD_TOP/packages/apps/Settings

git remote add upstream-sgt7 git://github.com/sgt7/android_packages_apps_Settings.git
git remote add upstream-cyan git://github.com/CyanogenMod/android_packages_apps_Settings.git
git fetch upstream-sgt7
git merge upstream-sgt7/ics
git fetch upstream-cyan
git merge upstream-cyan/ics

cd $ANDROID_BUILD_TOP/kernel/samsung/p1

git remote add upstream-sgt7 git://github.com/sgt7/p1000-kernel-cm9.git
git fetch upstream-sgt7
git merge upstream-sgt7/android-samsung-2.6.35

cd $ANDROID_BUILD_TOP/kernel/samsung/initramfs

git remote add upstream-sgt7 git://github.com/sgt7/p1000-initramfs-cm9.git
git fetch upstream-sgt7
git merge upstream-sgt7/master

cd $ANDROID_BUILD_TOP/vendor/samsung

git remote add upstream-sgt7 git://github.com/sgt7/proprietary_vendor_samsung.git
git fetch upstream-sgt7
git merge upstream-sgt7/ics


