echo "---- BEGIN functions_util.sh ----" 

# check for existing commands
var_exists P_PROGRAM_FILES
var_exists P_PROGRAM_FILES_X86
var_exists p_work
var_exists p_tools
var_exists EXE_MLO
var_exists EXE_XLS
var_exists OPEN_ZIP
var_exists EXE_ZIP_CMD
var_exists OPEN_TEXT_EDITOR
var_exists NUM_LINE_TEXT_EDITOR
var_exists OPEN_CODE_EDITOR
var_exists CODE_EDITOR

function get_line_command () {
    : "gets the code editor command to jump"
    : "to a file at a given line"
    : "needs to be coded when it simply cant be appended"
    : "right now only for VSCODE"
    p="$1"
    l="$2"    
    open_code_at_line=""
    if [ "$CODE_EDITOR" = "VSCODE" ]; then
        # replace @ by path and # by line number
        open_code_at_line="\"CODE\" --goto \"@:#\""
        open_code_at_line="${open_code_at_line//@/${p}}"
        open_code_at_line="${open_code_at_line//#/${l}}"        
    fi
    echo "$open_code_at_line"
}

function func_open () {
    : open "<bash path> [n]"
    : transforms bash path to windows and opens win explorer     
    : files will be opened with notepad++ as default
    : or with specific application if extension is defined
    : if it is an url it will open default browser instead 
    : breaks with paths that have spaces in it, use encode_path to resolve it
    : if the optional numeric parameter n is passed it will be tried 
    : to open the document in editor or code editor at given line

    pwin=""
    
    echo "test"
    # check if it is url
    is_url "$1";
    if [ $? -eq 0 ]; then
        echo "Open browser: $1"
        start "$1"
        return 0
    fi 
    
    # check for number of arguments
    num_args=$#
    p=""
    l=""
    # 2 arguments suggest it contains a line number
    if [ num_args=2 ]; then
        p="${1}"
        l="${2}"
    else
        p="$@"
    fi
    
    # now get concatenated string
	encoded_path="$(encode_path $p)";
	#local open_explorer="explorer \"$(towinpath "$encoded_path")\"";    
    echo "Encoded Path: \"$encoded_path\""
    
    if [ -f "$encoded_path" ]; then
        f=$(basename "$encoded_path")
        
        # get extensions and put them into an array
        # right now it can't discern if there is a blank
        # right now only if it has two parts, get the second as extension
        file_ext=$(get_file_extension "$f")
        file_name=$(get_file_name "$f")                                    
        
        pwin_path=$(towinpath "$(dirname "$encoded_path")")
        pwin="$pwin_path\\$f"                
        echo "Opening ($file_ext) file \"$pwin\""
        
        # depending on file type open with different applications
        # default is opening in Notepad
        # @TODO add more filetypes to open
        s_cmd=""
        case $file_ext in 
            # filetype My Life Organized
            ml)
                s_cmd="$EXE_MLO \"$pwin\" &"
                ;;
            # filetype Excel
            xlsx|xls)
                s_cmd="\"$EXE_XLS\" \"$pwin\" &"
                ;;
            doc|docx)
                s_cmd="\"$EXE_WORD\" \"$pwin\" &"
                ;;                
            # filetype: Images / opened with default editor
            jpg|png|svg)
                p_curr="$PWD"
                p_image=$(dirname "$encoded_path")
                cd "$p_image"
				start "$f"
                cd "$p_curr"
                ;;
            exe|bat)			
                s_cmd="\"$pwin\" &"
                ;;
            pdf)			            
                s_cmd="\"$EXE_PDF\" \"$pwin\" &"
                echo "${s_cmd}"
                ;;                                
            zip|jar)
                s_cmd="\"$OPEN_ZIP\" \"$pwin\" &"             
                ;;
            py|sh|java|json)
                # open code at given line
                if [ ! -z "$l" ]; then
                    echo "CALL get_line_command"
                    s_cmd=$( get_line_command "${pwin}" "$l" )                    
                # open code without given line
                else
                    s_cmd="\"$OPEN_CODE_EDITOR\" \"$pwin\""
                fi                
                ;;
            json)
                # open code with eclipse at given line
                if [ ! -z "$l" ]; then
                    echo "CALL get_line_command"					
                    s_cmd="${OPEN_ECLIPSE} \"$pwin:"$l"\""                 
                # open code without given line
                else
                    s_cmd="${OPEN_ECLIPSE} \"$pwin\""
                fi                
                ;;				
            *)  
                # default is to start with notepad++
                # todo also check out for other extensions
                if [ ! -z "$l" ]; then
                    l="${NUM_LINE_TEXT_EDITOR}${l}"
                    s_cmd="\"${OPEN_TEXT_EDITOR}\" \"${pwin}\" \"${l}\" &"
                else
                    s_cmd="\"$OPEN_TEXT_EDITOR\" \"$pwin\" &"
                fi
                ;;
        esac
        # execute when there is a command
        if [ ! -z "$s_cmd" ]; then
            echo "${s_cmd}"
            eval "${s_cmd}"
        fi
        
    elif [ -d "$encoded_path" ]; then
        # parameter is a path
        pwin=$(towinpath "$encoded_path")
        echo "Opening path \"$pwin\""
        # use total commander if it is defined 
        # (preferably in globals.sh)
        # otherwise use explorer 
        var_exists "EXE_TOTAL_COMMANDER"
        if [ $? -eq 0 ]; then
            total_commander_s="\"${EXE_TOTAL_COMMANDER}\" /o /L=\"${pwin}\" /R=\"${pwin}\" &"
            echo "Running ${total_commander_s}"
            eval "${total_commander_s}"  
        else
	        explorer_s="\"${WIN_EXPLORER}\" \"${pwin}\""
            echo "${explorer_s}"
	        eval "${explorer_s}"              
        fi
    else
        pwin="$encoded_path"
        echo "\"$pwin\" is not a valid file object"
    fi
}

function open_extended () {
    : "2023-04-29"
    : "like open but you can pass grep links directly to open "
	: "tries to identify paths and line numbers for input of "
	: "open command. can be used to separate filename and num from grep"
	: "if num is not present only s will be returned "
	: "will only return valid file paths"    

	num_args=$#
	# echo "INPUT ($@) , num args $num_args"		
	
	# all params is path done
	check_path "${@}"    
    if [ $? -eq 0 ]; then 
		f="${@}"
		l=""
    else				
		p="${1}"
		check_path "$p"; [ $? -eq 0 ] && f="$p" || f=""
			
		# check  if second parameter 
		# can be interpreted as line number
		if [ $num_args -gt 1 ]; then
			is_integer "${2}"; [ $? -eq 0 ] && l=$2 || false
		fi
		
		# now check if file part / line can be extracted from 1st parameter
		if [ -z "$f" ]; then		
			# match numbers preceded by numbers
			# http://molk.ch/tips/gnu/bash/rematch.html
			[[ "${p}" =~ :[0-9]+ ]]; regex_match="${BASH_REMATCH}"
			l=${regex_match:1}
            # cut substring
			p="${p/$regex_match/''}"  
			# check if there is a valid file 
			check_path "$p"; [ $? -eq 0 ] && f="$p" || f=""		
		fi	
		
		# if still no file was found then check for cutting off all parts after number match 
		if [ -z "$f" ]; then		
			p="${1}"
			# match numbers preceded by numbers
			[[ "$p" =~ :[0-9]+.* ]]; regex_match="${BASH_REMATCH}"
			p="${p/$regex_match/''}"  
			# check if there is a valid file 
			check_path "$p"; [ $? -eq 0 ] && f="$p" || f=""		
		fi		
	fi
	
	# no file signature found pass over original parameters 
	if [ -z "$f" ]; then 
		f="${@}"
	fi
	# pass over params either with or without lines
	if [ -z "$l" ]; then 
		func_open "${f}"
	else
		func_open "${f}" "$l"
	fi	

}

function walk_dir () {    
    : "walk_dir <path>"
    : recursively check files opens link files
    : and displays them in output for opening
    : https://unix.stackexchange.com/questions/494143/recursive-shell-script-to-list-files
    shopt -s nullglob dotglob    
    encoded_path="$@"
    dirname="$(dirname "$encoded_path")"
    echo "$encoded_path"

    # @todo support other filetypes for walk_dir
    for pathname in "$encoded_path"/*; do
        if [ -d "$pathname" ]; then
            walk_dir "$pathname"
        else
            f=$(basename "$pathname")
            # echo "FILE [$f]"
            case "$pathname" in
                *.txt|*.doc)
                    # printf '    txt %s\n' "$f"
                    ;;
                *.url)
                    # printf '    link %s\n' "$f"
                    url=$(read_link "$pathname")
                    printf "    - [%s] %s\n" "$f" "$url"
                    ;;
                *)
                    ;;
            esac
        fi
    done
}

function grepm_zip () {
    : calling "grepm_zip <path to zip in bash format> <grep filters>"
    : constructs command for executing zip    
    : right now works with arguments for 7zip
    local args=2
    local exe_zip_cmd_command="\"$EXE_ZIP_CMD\" l"
    local grep_args="${@:2}"
    # convert path into windows format
    p="${1}"
    # echo "BASH PATH $p"    
    d=$(dirname ${p})
    d="$(towinpath $d)"
    filename="$(basename "$p")"
    win_p="\"${d}\\${filename}\""
    grepm_zip_cmd=$(grepm_args $args "$exe_zip_cmd_command" "${win_p}" $grep_args)
    echo "$grepm_zip_cmd"
    eval "$grepm_zip_cmd"
}

# decomment
# echo "     END functions_util.sh ----" 
