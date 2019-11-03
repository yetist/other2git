#!/bin/bash

START_DIR=`realpath .`

svnurl=https://crosswire.org/svn/sword/

svn log -q $svnurl | awk -F '|' '/^r/ {sub("^ ", "", $2); sub(" $", "", $2); print $2" = "$2" <"$2">"}' | sort -u > authors-transform.txt
git svn clone $svnurl --no-metadata -A authors-transform.txt --stdlayout ~/temp

cd ~/temp
git svn show-ignore > .gitignore
git add .gitignore
git commit -m 'Convert svn:ignore properties to .gitignore.'

git init --bare ~/new-bare.git
cd ~/new-bare.git
git symbolic-ref HEAD refs/heads/trunk

cd ~/temp
git remote add bare ~/new-bare.git
git config remote.bare.push 'refs/remotes/*:refs/heads/*'
git push bare

cd ~/new-bare.git
git branch -m trunk master

cd ~/new-bare.git
git for-each-ref --format='%(refname)' refs/heads/tags |
cut -d / -f 4 |
while read ref
do
  git tag "$ref" "refs/heads/tags/$ref";
  git branch -D "tags/$ref";
done

#git remote add origin $GIT_DST
#git push origin --all
#git push origin --tags

cd $START_DIR
