#!/bin/bash

# hardstatus text:
declare -a STATUS=( $(hg prompt "{status|full}" 2>/dev/null)
                  )
[[ "${STATUS[0]}" ]] && [[ "${STATUS[0]}" != "?" ]] && {
    STATUS_FLAGS+="{= Wb}"  # white on blue -> reverse mode -> blue on white -> inverted CLUT -> dim yellow on black
    STATUS_FLAGS+=[${STATUS[0]}]
    STATUS_FLAGS+="{-}"
    STATUS_FLAGS+="{=dbu} {-}" # trailing space separates from BOOKMARK
}

#STATUS=$( echo $(echo -n $-) )


# send window title text to screen via fork/exec:
REPOROOT=$(hg showconfig bundle.mainreporoot 2>/dev/null)
IN_REPO=$?
REPO=$(basename $REPOROOT 2>/dev/null)
DIR=$(basename $PWD 2>/dev/null)
DIRPARENT=$(dirname $(dirname $PWD) 2>/dev/null)

BOOKMARK=$(hg summary 2>/dev/null | awk '/^bookmarks: / { $1="" ;  # delete "bookmarks:" string
                              gsub("^ ","",$0);        # delete leading spaces
                              # print warnings
                              if (NF>1) { multiple_bookmarks=1 ; printf "{! rc}MULTIPLE{-} BOOKMARKS " }
                              if (index($0,"*")==0) { no_default_bookmark=1 ; printf "{! rc}NO ACTIVE{-} BOOKMARK " }
                              switch (multiple_bookmarks + no_default_bookmark) {
                                        # gsub = put each bookmark in (parens)
                                                  # )
                                                  # |  {highlight stop}
                                                  # |  |  space
                                                  # |  |  |  {highlight start}
                                                  # |  |  |  |     (
                                                  # |  |  |  |     |
                                 case 2 : gsub(" ","){-} {! rc}(",$0) ; printf "{! rc}(%s){-}", $0 ; exit 0
                                 case 1 : gsub(" ","){-} {! bw}(",$0) ; printf "{! bw}(%s){-}", $0 ; exit 0
                                 case 0 : printf "{= Wm}%s{-}", $0 ; exit 0
                              } ;
                            }'
           )
[[ $IN_REPO -eq 0 ]] && {
    # we are in a hg repo, if no bookmark set, warn us:
    [[ $BOOKMARK ]] || BOOKMARK=$"<"$"<""NO BOOKMARK"$">"$">" ;
}

# =~ ^[0-9a-zA-Z_]
#     ! [[ ${_last_history_number_had_new_command} =~ ^[0-9a-zA-Z] ]] && {

# set the screen title in the background
( ( screen -p $WINDOW -X title "${REPO}" ) & )

# call wakatime in the background
[[ ${_last_history_number_had_new_command} ]] &&
    $(type -p "${_last_history_number_had_new_command}">/dev/null) && {
        ## we only log if the string is an executable file or function name
        echo $(date) ${REPO} ${_last_history_number_had_new_command} >> ~/.wakatime.prompt_lite.log ;
        ( ( wakatime --write --plugin "bash-wakatime/0.1.1" \
                     --entity-type app \
                     --project "${REPO:-$PWD}" \
                     --entity "${_last_history_number_had_new_command}" 2>&1 >/dev/null ) & ) ;
    }

# emit to SCREEN(1) as a hardstatus string
#
#                  --> [AMR!?]-hg flags         --> hg bookmark list
#                  |                            |
#                  ~~~~~~~~~~~~                 ~~~~~~~~~~~
#echo -n $'\033']0\;${STATUS[0]}"{-} {= wdk}(${BOOKMARK}){-}"$'\007'

echo -n $'\033'"]0;${STATUS_FLAGS}${BOOKMARK}"$'\007'
