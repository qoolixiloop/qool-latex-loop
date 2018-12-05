#!/bin/bash

# checking if STDIN is a terminal
# -t file is associated with a terminal
# 0 is file descriptor of stdin
if [ -t 0 ]; then 
  
  # stty: print or change terminal characteristics
  # -icrnl negated to properly catch return key
  #    negated, i.e. do not translate CR to Newline
  # -icanon negated to not let loop be killed other than "x"
  #    negated, i.e. do not enable erase, kill, werase, rprnt
  # -echo negated
  #    negated, i.e. do not echo input characters
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
  # instead of read to catch space
  keypress="$(cat -v)"

done

# checking if STDIN is a terminal
if [ -t 0 ]; then 
  
  # sets terminal back to default values
  stty sane

fi

# say goodby
echo "You pressed '$keypress' after $count loop iterations"
echo "Thanks for using this script."
exit 0
