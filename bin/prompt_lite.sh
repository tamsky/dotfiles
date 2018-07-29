#!/bin/bash

# hardstatus text:

declare -a STATUS=( $(hg prompt "{bookmark}
[{status|full}]" 2>/dev/null)
                  )

#STATUS=$( echo $(echo -n $-) )


# send window title text to screen via fork/exec:
REPOROOT=$(hg showconfig bundle.mainreporoot 2>/dev/null)
REPO=$(basename $REPOROOT 2>/dev/null)
DIR=$(basename $PWD 2>/dev/null)
DIRPARENT=$(dirname $(dirname $PWD) 2>/dev/null)
#BOOKMARK=$( hg prompt "{bookmark}" 2>/dev/null )
BOOKMARK=${STATUS[0]}
[[ $BOOKMARK ]] || BOOKMARK="_"
#screen -p $WINDOW -X title "(${REPO}) (${BOOKMARK}) (${DIRPARENT})"
screen -p $WINDOW -X title "${REPO}"

# emit to SCREEN(1) as a hardstatus string
echo -n $'\033']0\;${STATUS[1]}"{-} {= wdk}(${BOOKMARK}){-}"$'\007'
