#!/bin/bash

FOLDER="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

COLS=
FILE=
SIZE=

TMP_FILE="$FOLDER/tmp/tmp.file.data"
EXEC_FILE="$FOLDER/tmp/exec.sh"
TEMPLATE_FILE="$FOLDER/template.sh"


[ -t 1 ] && STREAM="$FILE" || STREAM="-"
CONTENTS=
CNT=1
ADD_FIRST_COLUMN=


# -------------------------------------------------------

function get_long_options(){
   local ARGUMENTS=("$@")
   local index=0

   for ARG in "$@"; do
      index=$(($index+1));
      case $ARG in
         -a) ADD_FIRST_COLUMN="x";;
         -c) COLS="${ARGUMENTS[index]}";;
         -b) FILE="${ARGUMENTS[index]}";;
         -s) SIZE="${ARGUMENTS[index]}";;
      esac
   done
}


# ----------------------   MAIN   ------------------------

get_long_options "$@"

[ -z "$COLS" ] && COLS="2"
[ -z "$SIZE" ] && COLS=50


OPT=""
for COL in $COLS; do
   [ ! -z "$OPT" ] && OPT="$OPT, "
   OPT="$OPT '$TMP_FILE' using 1:$COL with lines"
done
OPT="plot $OPT"


sed "s|%PLOT%|$OPT|g" $TEMPLATE_FILE > $EXEC_FILE
chmod +x $EXEC_FILE



while read LINE; do
   [ ! -z "$ADD_FIRST_COLUMN" ] && LINE="$CNT $LINE"
   CONTENTS="$CONTENTS\n$LINE"
   MOD=$(($CNT%SIZE))
   if [ $MOD -eq 0 ]; then
      echo -e "$CONTENTS" > $TMP_FILE
      
      eval `$EXEC_FILE`

      eog file.png
      CNT=1
      CONTENTS=
   else
      CNT=$(($CNT+1))
   fi
done < <(cat $STREAM)


exit 0