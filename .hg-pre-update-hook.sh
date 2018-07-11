#!/bin/bash
# check that we're not trying to merge with DO NOT MERGE

# handle simple update ( PARENT1 set, PARENT2 nil)
[[ $1 ]] && [[ -z $2 ]] && {
    # echo "update detected" ;
    exit 0 ; }

# handle merge ( PARENT1 set (unchanged), PARENT2 set (working directory ID) )
[[ $1 ]] && [[ $2 ]] && {
    echo "hg pre-update hook triggered: PARENT1=$1, PARENT2=$2" ;
    hg diff -r $2 -r $1 | grep ^+ | grep 'DO NOT MERGE' 2>&1 >/dev/null &&
        exit 1 || exit 0 ;
    }

[[ -z $1 ]] && echo "unknown state, PARENT1 unset" && exit 1
