echo "---- BEGIN functions_todo.sh BEGIN  ----"

function read_todo_config () {    
    : "read_todo_config <root name>"
    : reads todo config file and reads out variables
    : useful for checking
    i=0;
    root_name=$1
    # get the configuration file
    config_file_name="f_${root_name}_cfg"
    echo -e "---- READ TODO CFG FILE FOR ROOT $1 variable $config_file_name ----"
    var_exists "$config_file_name" || return 1
    f=${!config_file_name}
    echo "     PATH: $f"

    regex="^(export|EXPORT) (TODO_DIR|TODO_FILE|DONE_FILE|REPORT_FILE)=(.*)"
    
    while read line; do
        #echo "$line"
        if [[ $line =~ $regex ]]; then
            ((i++))
            param=${BASH_REMATCH[2]}
            value=${BASH_REMATCH[3]}                        
            value=$(echo $value|tr -d '"') # strip quotes
            echo "     $i FOUND PARAM [$param], VALUE [$value]"
            [ ${value::1} = "$" ] && eval echo "\ \ \ \ \ \ \ Variable $value"
        fi         
        if [ $i -eq 4 ]; then break; fi
    done < "$f"
}

function register_todo () {
    : "register_todo <todo_root_name>"
    : "creates aliases and file references to given todo.txt files"
    : "creates file paths f_<root_name>_[_;done;report;cfg]"
    : "cfg points to config file"
    : "creates alias open_<root_name> to open the file and"
    : "alias t_<root_name> to execute todo with config file"
    : "for special case root name todo alias t_ is used"
    : "it needs to be insured that paths and config and todo files"
    : "are existent and created paths, this is done in header_todo.sh"

    root_name="$1"
    # decomment
    # echo -e "\r\n     ***** Register todo files with root name $root_name"

    # create / validate path
    f_todo="${p_todo_work}/${root_name}"    
    f_todo_done="${f_todo}_done.txt"
    f_todo_report="${f_todo}_report.txt"
    local f_todo="${f_todo}.txt"    
    # decomment
    echo "     TODO.TXT FILE:        $f_todo"
    check_path $f_todo; [ "$?" -eq 0 ] || return false   
    
    # check todo.txt configuration
    local f_todo_cfg="${p_todo_cfg}/${root_name}.cfg"
    # decomment
    # echo "     TODO.TXT CONFIG FILE: ${f_todo_cfg}"
    # check_path "${f_todo_cfg}"; [ "$?" -eq 0 ] || return false

    # export variables
    # echo "EXPORT TO VARIABLE f_${root_name} $f_todo "
    export_path "f_${root_name}" $f_todo
    export_path "f_${root_name}_done" $f_todo_done
    export_path "f_${root_name}_report" $f_todo_report
    export_path "f_${root_name}_cfg" $f_todo_cfg

    # create alias to open todo file
    expr_open="alias open_${root_name}='open_extended \"${f_todo}\"'"
    eval "${expr_open}" 

    # create alias to run todo.txt with given configuration
    todo_alias="t_"
    [ $root_name != "todo" ] && todo_alias="t_${root_name}"
    expr_todo="alias ${todo_alias}='\"${EXE_TODO}\" -d \"${f_todo_cfg}\"'"
    # decomment
    # echo "     $expr_todo"
    eval $expr_todo
    # create alias for ls
    t_ls_alias="${todo_alias}_ls"
    [ $root_name = "todo" ] && t_ls_alias="t_ls"
    expr_todo_ls="alias ${t_ls_alias}=\"${todo_alias} ls\""
    eval $expr_todo_ls    
}

function todo_add_task () {
    : "2023-04-30"
    : "adds a task to todo.txt with default prio B"
    : "additional tag p:[A-Z] is used to change prio"
    : "configuration path for todo.txt is set according to todo.cfg"
    todo="${@}"
    
    # check for prio
    if [[ "${todo}" =~ ( p:[A-Z]| p:[a-z]) ]]; then
        prio="${BASH_REMATCH}"
        todo="${todo/$prio/''}"
        prio=${prio:3}
    else 
        prio="B"
    fi    

    # #TODO for other todo configurations todo.cfg needs to be changed
    f_todo_cfg=$( cygpath_convert "$p_todo_cfg/todo.cfg" )
    exe_todo=$( cygpath_convert "$p_todo_home/todo_cli/todo.sh" u )
    # add task with timestamp 
    todo_cmd="\"${exe_todo}\" -d \"${f_todo_cfg}\" -t a \"${todo}\""
    # echo "${todo_cmd}"
    out=$( eval "$todo_cmd" )
    echo "$out"
    # now get the line number and add a default prio of B 
    [[ "${out}" =~ [0-9]+ ]]; todo_item="${BASH_REMATCH}"
    todo_cmd_s="\"${exe_todo}\" -d \"${f_todo_cfg}\" p ${prio} ${todo_item}"
    eval ${todo_cmd_s}
}

function archive_extended () {
    : archives extended information to archive file 
	: replaces the archive function in todo .txt
	: adds dates and default priorities to todo prior to archiving it 	

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

# decomment
# echo -e "\r\n     END   functions_todo.sh definitions"
