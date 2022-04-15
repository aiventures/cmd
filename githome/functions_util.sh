echo "---- BEGIN functions_util.sh ----" 

# check for existing variables
var_exists EXE_NPP
var_exists EXE_XLS
var_exists EXE_MLO
var_exists f_mlo
var_exists P_PROGRAM_FILES
var_exists P_PROGRAM_FILES_X86
var_exists p_work
var_exists p_tools

function open {
    : open "<bash path>"
    : transforms bash path to windows and opens win explorer     
    : files will be opened with notepad++ as default
    : or with specific application if extension is defined
    : if it is an url it will open default browser instead 
    : breaks with paths that have spaces in it, use encode_path to resolve it
    
    pwin=""
    
    # check if it is url
    is_url "$1";
    if [ $? -eq 0 ]; then
        echo "Open browser: $1"
        start "$1"
        return 0
    fi
    
    # now get concatenated string
	encoded_path="$(encode_path "$@")";
	#local open_explorer="explorer \"$(towinpath "$encoded_path")\"";    
    echo "Encoded Path: \"$encoded_path\""
    
    if [ -f "$encoded_path" ]; then
        f=$(basename "$encoded_path")
        
        # get extensions and put them into an array
        # right now it can't discern if there is a blank
        # right now only if it has two parts, get the second as extension
        file_split=$(get_file_extension "$f")
        file_parts=(`echo ${file_split}`)
        num_parts=${#file_parts[@]}
        f_ext=""
        
        #for (( i=0; i<$num_parts; i++ )); do; echo "${file_parts[$i]}"; done
        if [ $num_parts -eq 2 ]; then
            f_ext=${file_parts[1]}
            # echo "File has $num_parts parts, extension $f_ext"    
        fi                                
        
        pwin_path=$(towinpath "$(dirname "$encoded_path")")
        pwin="$pwin_path\\$f"                
        echo "Opening ($f_ext) file \"$pwin\\$f\""
        
        # depending on file type open with different applications
        # default is opening in Notepad
        # @TODO add more filetypes to open
        case $f_ext in 
            ml)
                mlo="$EXE_MLO \"$pwin\""
                eval "$mlo" &
                ;;
            xlsx)
                xls="\"$EXE_XLS\" \"$pwin\""
                echo "xls"
                eval "$xls" &
                ;;
            *)
                # default is to start with notepad++
                # todo also check out for other extensions
                start notepad++ "$pwin";;
        esac       
        
    elif [ -d "$encoded_path" ]; then
        pwin=$(towinpath "$encoded_path")
        echo "Opening path \"$pwin\""
        explorer "$pwin"
    else
        pwin="$encoded_path"
        echo "\"$pwin\" is not a valid file object"
    fi
    # @TODO add other file types
    
}

function walk_dir () {    
    : recursively check files
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
            esac
        fi
    done
}

echo "     END functions_util.sh ----" 
