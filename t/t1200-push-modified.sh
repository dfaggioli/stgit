#!/bin/sh
#
# Copyright (c) 2006 Yann Dirson
#

test_description='Exercise pushing patches applied upstream.

Especially, consider the case of a patch that adds a file, while a
subsequent one modifies it, so we have to use --merged for push to
detect the merge.  Reproduce the common workflow where one does not
specify --merged, then rollback and retry with the correct flag.'

. ./test-lib.sh

# don't need this repo, but better not drop it, see t1100
#rm -rf .git

# Need a repo to clone
test_create_repo foo

test_expect_success \
    'Clone tree and setup changes' \
    "stg clone foo bar &&
     (cd bar && stg new p1 -m p1
      printf 'a\nc\n' > file && stg add file && stg refresh &&
      stg new p2 -m p2
      printf 'a\nb\nc\n' > file && stg refresh
     )
"

test_expect_success \
    'Port those patches to orig tree' \
    "(cd foo &&
      GIT_DIR=../bar/.git git-format-patch --stdout bases/master..HEAD |
      git-am -3 -k
     )
"

test_expect_success \
    'Pull to sync with parent, preparing for the problem' \
    "(cd bar && stg pop --all &&
      stg pull
     )
"

test_expect_failure \
    'Attempt to push the first of those patches without --merged' \
    "(cd bar && stg push
     )
"

test_expect_success \
    'Rollback the push' \
    "(cd bar && stg push --undo
     )
"

test_expect_success \
    'Push those patches while checking they were merged upstream' \
    "(cd bar && stg push --merged --all
     )
"

test_done