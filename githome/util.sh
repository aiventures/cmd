echo "---- load util.sh functions ----"

# load header definitions
. ~/header.sh

# load shortcuts
. ~/shortcuts.sh

# path functions to convert bash path into win path 
# https://stackoverflow.com/questions/40879648/how-to-open-the-current-directory-on-bash-on-windows

function is_url {
    : "is_url <string>"
    : returns whether string is interpreted as url 
    : starts with http
    : returns 0=true / 1=false in return code "$?"
    # case insensitive
    shopt -s nocasematch

    if [[ "$1" =~ ^"http" ]]; then
        #echo "true"
        shopt -u nocasematch
        #return 0
        true
    else
        #echo "false"
        shopt -u nocasematch
        #return 1
        false
    fi
}

function encode_path () {
	: encode_path "<path that may contain spaces>"
    : navigates tp open explorer for path in shell notation 
	: works for path containing spaces
	: you can use path variables without quotation marks
	local num_arguments=$#;

	local i=0;
	local s=""

	for var in "$@"
	do   
	s+="${var}"
	i=$(($i + 1));
	if [ $i -lt $num_arguments ]
	then
	  s+=" "
	fi;
	done

	echo "$s";  
}

function towinpath {
    : towinpath "<bash path>"
    : encodes path to string
    : spaces in path will leads to breaks
    { cd "$1" && pwd -W; } | sed 's|/|\\|g'
}

# https://www.gnu.org/software/sed/manual/html_node/The-_0022s_0022-Command.html
# 's/regexp/replacement/flags’.
# https://stackoverflow.com/questions/965053/extract-filename-and-extension-in-bash
function get_file_extension {
    : splits filename into suffix and extension
    : returns array
    filename="$@"
    # replaces chars  ".<any non . chars> withnothing" 
    f_prefix=$(echo "$filename" | sed 's/\.[^.]*$//')
    # replaces any characters with nothing until the occurence of dot
    f_ext=$(echo "$filename" | sed 's/^.*\.//')    
    echo "$f_prefix $f_ext"
}

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
        case $f_ext in 
            ml)
                mlo="$EXE_MLO \"$pwin\""
                eval "$mlo" &
                ;;
            xlsx)
                exe_xls="/c/Program Files/Microsoft Office/root/Office16/EXCEL.EXE"
                xls="\"$exe_xls\" \"$pwin\""
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
    
}


function go () {   
    : go "<bash path>" 
    : opens windows explorer
	: is used to avoid add quotes so that paths containing spaces
	: can be used directly without the need to enclose them with quotes
	encoded_path="$(encode_path "$@")";
	local open_explorer="explorer \"$(towinpath "$encoded_path")\"";
	echo " $open_explorer"
	eval $open_explorer
}


function cdd () {
	: "cdd <bash path>", 
    : opens path in bash
	: is used to avoid add quotes so that paths containing spaces
	: can be used directly without the need to enclose them with quotes
	encoded_path="$(encode_path "$@")";
	local cdd="cd \"$encoded_path\"";
	echo "$cdd";
	eval $cdd;  
}




