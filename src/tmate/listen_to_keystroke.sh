#!/bin/bash

# -t file is associated with a terminal
# 0 true
if [ -t 0 ]; then 
  stty -echo -icanon -icrnl time 0 min 0 
fi

# infinite loop until keypress no longer "x" 
count=0
keypress=''
while [ "x$keypress" = "x" ]; do
  
  # count
  let count+=1
  echo -ne $count'\r'
  
  # cat: with no FILE or '-' read from stdin
  # -v show nonprinting control characters
  keypress="$(cat -v)"

done

#
if [ -t 0 ]; then 
  stty sane
fi

# say goodby
echo "You pressed '$keypress' after $count loop iterations"
echo "Thanks for using this script."
exit 0
