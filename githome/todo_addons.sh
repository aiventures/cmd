# replaces the archive function in todo .txt
# adds dates and default priorities to todo prior to archiving it 

function archive_extended () {
    : archives extended information to archive file 

    if ! [ -f "${TODO_FILE}" ]; then 
        echo "TODO  FILE ${TODO_FILE} DOESN'T EXIST"
    fi

    if ! [ -f "${DONE_FILE}" ]; then 
        echo "ARCHIVE FILE ${DONE_FILE} DOESN'T EXIST"
    fi

    # create a backup first 
    sed -i.bak -e '/./!d' "$TODO_FILE"    
    sed -i.bak -e '/./!d' "$DONE_FILE"    

    [ "$TODOTXT_VERBOSE" -gt 0 ] &&  echo "ARCHIVING TASKS:" 

    # process each line of the todo. txt
    while read -r line; do
        line_out=""
        #process only if it matches compoletion pattern 
        
        # now get the line number and add a default prio of B 
        date_today="$(date '+%Y-%m-%d')";
        date_completed="${date_today}"
        
        # process completed lines only 
        if [[ "${line}" =~ ^x.* ]]; then
            # echo "Processing     ${line}"; 		
            # echo "${date_string}"
            todo_item="${BASH_REMATCH}"
            # check if line already contains double date
            # matches the YYYY-MM-[DD YYYY]-MM-DD Part 
            regex_s="[[:digit:]]{2}[[:blank:]]+[[:digit:]]{4}"
            
            # two dates contained alreeady do not process further 
            if [[ "${line}" =~ ${regex_s} ]]; then		
                #match="${BASH_REMATCH}"
                # echo "contains two dates already"
                # echo "MATCH|${match}|"
                line_out="${line}"
            # process the lines add prio / creation / completion dates
            else
                line_part="${line:2}"
                # echo "   LINEPART BEFORE;>>>${line_part}<<<"			
                # extract prio/ assign B as default 
                regex_s="x[[:blank:]]\([[:alpha:]]"
                if [[ "${line}" =~ ${regex_s} ]]; then		
                    # prio="${line:3:1}"
                    line_part="${line_part}"
                else
                    line_part="(B) ${line_part}"
                fi
                prio="${line_part:0:3}"
                line_part="${line_part:3}"
                # echo "   PRIO ${prio}, linepart ${line_part},"									
                # extract date created it to today as default
                # echo "   LINEPART AFTER PRIO >>>${line_part}<<<"	
                
                regex_s="[[:digit:]]{4}-[[:digit:]]{2}-[[:digit:]]{2}"
                if [[ "${line_part}" =~ ${regex_s} ]]; then		
                    start_date="${BASH_REMATCH}"
                    line_part="${line_part:11}"
                else
                    start_date="${date_today}"
                fi			
                # echo "   start date xxx${start_date}xxx"						
                # echo "   LINEPART AFTER ;>>>${line_part}<<<"			
                
                line_out="x ${prio} ${date_completed} ${start_date}${line_part}"
                #echo "   new line >>>${line_out}<<<"			
                
            fi					
        fi
        
        if ! [ -z "${line_out}" ]; then 
            if [ "$TODOTXT_VERBOSE" -gt 0 ]; then 
                echo "- [${line_out}]"
            fi
            # write  todo to archive 
            printf "${line_out}\n" >> "${DONE_FILE}"		
        fi			

    done < "${TODO_FILE}"

    # copying all todos in one go will be replaced by the logic below 
    # // grep "^x " "$TODO_FILE" >> "$DONE_FILE"

    # delete completed tasks from todo.txt 
    sed -i.bak '/^x /d' "$TODO_FILE"
    if [ "$TODOTXT_VERBOSE" -gt 0 ]; then
        echo "TODO: $TODO_FILE archived."
    fi    
}