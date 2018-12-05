BEGIN=$(date +%s)

echo Starting Stopwatch...
echo Press Q to exit.

while true; do
    NOW=$(date +%s)
    let DIFF=$((NOW - BEGIN))
    let MINS=$((DIFF / 60))
    let SECS=$((DIFF % 60))
    let HOURS=$((DIFF / 3600))
    let DAYS=$((DIFF / 86400))

    # \r  is a "carriage return" - returns cursor to start of line
    printf "\r%3d Days, %02d:%02d:%02d" $DAYS $HOURS $MINS $SECS
    sleep 0.25

    # In the following line -t for timeout,
    # set a very low value then there is no noticable
    # interruption, but read is listening nevertheless. 
    # -N for just 1 character, do not wait for enter keystroke
    read -r -t 0.001 -N 1 input
    if [[ $input = "q" ]] || [[ $input = "Q" ]]; then
        # The following line is for the prompt to appear on a new line.
        echo
        break 
    fi
done
