#!/bin/bash

# hardstatus text:

declare -a STATUS=( $(hg prompt "[{status|full}]" 2>/dev/null)
                  )

#STATUS=$( echo $(echo -n $-) )


# send window title text to screen via fork/exec:
REPOROOT=$(hg showconfig bundle.mainreporoot 2>/dev/null)
REPO=$(basename $REPOROOT 2>/dev/null)
DIR=$(basename $PWD 2>/dev/null)
DIRPARENT=$(dirname $(dirname $PWD) 2>/dev/null)

BOOKMARK=$(hg summary 2>/dev/null | awk '/^bookmarks: / { $1="" ;  # delete "bookmarks:" string
                              gsub("^ ","",$0);        # delete leading spaces
                              # print warnings
                              if (NF>1) { multiple_bookmarks=1 ; printf "{! rc}MULTIPLE{-} BOOKMARKS " }
                              if (index($0,"*")==0) { no_default_bookmark=1 ; printf "{! rc}NO ACTIVE{-} BOOKMARK " }
                              # gsub = put each bookmark in (parens)
                              # printf = highlight bookmarks
                              switch (multiple_bookmarks + no_default_bookmark) {
                                                   #________________# == highlight stop+space+restart
                                 case 2 : gsub(" ","){-} {! rc}(",$0) ; printf "{! rc}%s{-}", $0 ; exit 0
                                 case 1 : gsub(" ","){-} {! bw}(",$0) ; printf "{! bw}(%s){-}", $0 ; exit 0
                                 case 0 : print $0 ; exit 0
                              } ;
                            }'
           )
[[ $BOOKMARK ]] || BOOKMARK=$"<"$"<""NO BOOKMARK"$">"$">"

screen -p $WINDOW -X title "${REPO}"

# emit to SCREEN(1) as a hardstatus string
#
#                  --> [AMR!?]-hg flags         --> hg bookmark list
#                  |                            |
#                  ~~~~~~~~~~~~                 ~~~~~~~~~~~
#echo -n $'\033']0\;${STATUS[0]}"{-} {= wdk}(${BOOKMARK}){-}"$'\007'
echo -n $'\033']0\;${STATUS[0]}"{-} ${BOOKMARK}"$'\007'
