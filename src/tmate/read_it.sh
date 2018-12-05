#!/bin/bash

# ------------------------------------------------------------------------
# Purpose: read FILE and write characters to stdout
#          with WAIT_SEC between each character
# Wait:    use [wait] in FILE to halt. Resume with Enter-keystroke. 
# Stop:    stop running script with Ctrl-s and resume with Ctrl-q
#          stop with backspace and resume with enter (own implementation)
# Call:    ./read_it FILE WAIT_SEC
# Author:  Roland Benz
# Date:    5. Dec. 2018
# ------------------------------------------------------------------------

read_write() {
  
  # assign input arguments to local variables
  local File_to_read_from="$1"
  local Wait_in_sec="$2"

  # define file descriptor for file to read from
  # <: is an input fd; i.e. to read from;
  exec 3< "$File_to_read_from"
  
  # define file descriptor for line to write and then read from
  # <: is an input fd; i.e. to read from;
  # >: is an output fd; i.e. to write to;
  # <>: is an input/output fd
  local FileTmp_to_readwrite_line="/tmp/read_it_789.txt"
  touch "$FileTmp_to_readwrite_line"
  exec 4< "$FileTmp_to_readwrite_line"
  exec 5> "$FileTmp_to_readwrite_line"
  exec 6<> "$FileTmp_to_readwrite_line"

  # read file line by line
  while IFS= read -r -u 3 line; do 
    
    # define file descriptor for line to read
    # &: not used to define fd, but to use it outside of read
    # echo: must be used, else "$line" will be interpreted as command 
    # !!!this appends lines!!!
    echo "$line" >&5
    
    # read line character by character
    # IFS= means no word split
    # read considers a line as one word
    # -n1 means read nr of chars=1 at a time
    while IFS= read -r -u 4 -n1 char; do

      #echo "------cat_begin--------"
      #cat "$FileTmp_to_readwrite_line" 
      #echo "------cat_end-----------"
      
      #stop a defined points, enter-key to move on
      if [[ "$line" == '[wait]' ]]; then 
        
        # just wait for enter key
        local wait_resume_1
        #shellcheck disable=2034
        read -r -u 0 wait_resume_1; 
      
        # delete file
        # true >&5 does not work
        true > "$FileTmp_to_readwrite_line"

        # then continue with next line
        # continue out of two loops
        # goes at the beginning of outer loop
        continue 2
        
        # vs break out of one loop
        # goes at the end of outer loop 
        #break

      fi
      
      # print out whole lines
      if [[ "$line" =~ '===' ]]; then 
        
        #print line
        echo -n "$line" 
        
        # delete file 
        true > "$FileTmp_to_readwrite_line"

        # then continue with next line, i.e.
        # break out of this loops, holding the line
        break

      fi
      
      # -t for timeout, 
      # set to very low value, so read is listening,
      # without waiting so that it is noticed.
      # -N for just 1 character
      local listen=""
      read -r -t "$Wait_in_sec" -s -u 0 -N 1 listen
      if [[ $listen == $'\x7f' ]]; then
        
        # just wait for enter key
        local wait_resume_2
        #shellcheck disable=2034
        read -r -s -u 0 -N 1 wait_resume_2
     
      fi
        
      # display one character at a time
      # -n means no newline
      # comment, if entire words shall be printed
      echo -n  "$char"
      
      # then make a little pause
      # good values: [0.1,0.2]
      # sleep "$Wait_in_sec" # in units [sec]

    done #<<< "$line"

    # delete file 
    true > "$FileTmp_to_readwrite_line"

    # make a newline
    echo

  done

  # remove temporary file
  #echo "------cat_begin--------"
  #cat "$FileTmp_to_readwrite_line"
  #echo "------cat_end-----------"
  rm "$FileTmp_to_readwrite_line"

}
read_write "$@"
