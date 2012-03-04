#!/bin/bash

cd $WORKSPACE/$REPO_BRANCH

. build/envsetup.sh
lunch aokp_galaxytab-userdebug

cd $ANDROID_BUILD_TOP/vendor/samsung

git_remote=`git remote -v`
if [[ ! $git_remote = *upstream-aokp* ]]; then
	git remote add upstream-aokp http://github.com/AOKP/vendor_samsung.git
fi
git fetch upstream-aokp
echo "AOKP/vendor_samsung"
git merge upstream-aokp/master

cd $ANDROID_BUILD_TOP/vendor/aokp

git_remote=`git remote -v`
if [[ ! $git_remote = *upstream-aokp* ]]; then
	git remote add upstream-aokp http://github.com/AOKP/vendor_aokp.git
fi
git fetch upstream-aokp
echo "AOKP/vendor_aokp"
git merge upstream-aokp/ics

