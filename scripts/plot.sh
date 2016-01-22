#!/bin/bash

FOLDER="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

COLS="$1"
FILE="$2"

[ -z "$COLS" ] && COLS="2"

TMP_FILE="$FOLDER/tmp/tmp.file.data"
EXEC_FILE="$FOLDER/tmp/exec.sh"
TEMPLATE_FILE="$FOLDER/template.sh"


[ -t 1 ] && STREAM="$FILE" || STREAM="-"
CONTENTS=
CNT=1
SIZE=50
FIRST_COLUMN_IS_EMPTY=


# -------------------------------------------------------

function get_long_options(){
   local ARGUMENTS=("$@")
   local index=0

   for ARG in "$@"; do
      index=$(($index+1));
      case $ARG in
         -s) FIRST_COLUMN_IS_EMPTY="x";;
      esac
   done
}


# ----------------------   MAIN   ------------------------

get_long_options $@


OPT=
for COL in $COLS; do
   [ ! -z "$OPT" ] && OPT=", $OPT "
   OPT="$OPT '$TMP_FILE' using 1:$COL with lines"
done
OPT="plot $OPT"


sed "s|%PLOT%|$OPT|g" $TEMPLATE_FILE > $EXEC_FILE
chmod +x $EXEC_FILE



while read LINE; do
   [ ! -z "$FIRST_COLUMN_IS_EMPTY" ] && LINE="$CNT $LINE"
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