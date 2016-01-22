#!/bin/bash

COLS="$1"
FILE="$2"

[ -z "$COLS" ] && COLS="2"

TMP_FILE="./tmp/tmp.file.data"
EXEC_FILE="./tmp/exec.sh"
TEMPLATE_FILE="template.sh"


OPT=
for COL in $COLS; do
   [ ! -z "$OPT" ] && OPT=", $OPT "
   OPT="$OPT '$TMP_FILE' using 1:$COL with lines"
done
OPT="plot $OPT"


sed "s|%PLOT%|$OPT|g" $TEMPLATE_FILE > $EXEC_FILE
chmod +x $EXEC_FILE


[ -t 1 ] && STREAM="$FILE" || STREAM="-"
CONTENTS=
CNT=1
SIZE=50


while read LINE; do
   CONTENTS="$CONTENTS\n$LINE"
   MOD=$(($CNT%SIZE))
   if [ $MOD -eq 0 ]; then
      echo -e "$CONTENTS" > $TMP_FILE
      ./$EXEC_FILE
      eog ./tmp/file.png
      CNT=1
      CONTENTS=
   else
      CNT=$(($CNT+1))
   fi
done < <(cat $STREAM)


exit 0