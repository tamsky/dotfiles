#!/bin/bash

set -mi
STATUS=$(hg prompt "[{status|full}]" 2>/dev/null)
#STATUS=$( echo $(echo -n $-) )
echo -n $'\033']0\;${STATUS}$'\007'

BOOKMARK=$( hg prompt "{bookmark}" )
screen -X title ${BOOKMARK:-$(basename $SHELL)} 2>/dev/null
