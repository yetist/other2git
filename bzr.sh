#!/bin/bash
if [ $# -ne 3 ];then
    echo "Usage:"
    echo -e "\t<bzr_repo> <work_dir> <git_repo>"
    exit 0
fi

BZR_SRC=$1
WORK_DIR=$2
GIT_DST=$3

START_DIR=`realpath .`

TMP_DIR=`mktemp -d`

cd $TMP_DIR
bzr branch $BZR_SRC
cd $WORK_DIR

git init
bzr fast-export --plain . | git fast-import
git reset --hard HEAD
git remote add origin $GIT_DST
git push origin --all
git push origin --tags

cd $START_DIR
rm -rf $TMP_DIR
