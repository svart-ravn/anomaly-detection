#!/bin/bash

FILE="$1"
COLS="$2"
SIZE=$3

[ -z "$SIZE" ] && SIZE=100
[ -z "$COLS" ] && COLS="2"

TMP_FILE="./tmp/tmp.file.data"
EXEC_FILE="./tmp/exec.sh"
TEMPLATE_FILE="template.sh"
START=0


OPT=
for COL in $COLS; do
   [ ! -z "$OPT" ] && OPT=", $OPT "
   OPT="$OPT '$TMP_FILE' using 1:$COL with lines"
done
OPT="plot $OPT"


sed "s|%PLOT%|$OPT|g" $TEMPLATE_FILE > $EXEC_FILE
chmod +x $EXEC_FILE


while :; do
   head -$(($START+$SIZE)) $FILE | tail -$SIZE > $TMP_FILE
   ./$EXEC_FILE
   eog ./tmp/file.png

   START=$(($START+$SIZE))   
done

exit 0