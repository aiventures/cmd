echo "---- BEGIN functions_global.sh ----"

# loading global definitions like exe files and work paths 
# that need to be defined up front
GREP_PIPE="| grep --color=always -in"

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

function check_path {
    : checks whether path / file exists
    # get concatenated string
	encoded_path="$(encode_path "$@")";    
    if [ -f "$encoded_path" ]; then
        # echo "EXISTING File [\"$encoded_path\"]"
        true
    elif [ -d "$encoded_path" ]; then        
        # echo "EXISTING Path [\"$encoded_path\"]"
        true
    else
        echo "MISSING File/Path [\"$encoded_path\"]"
        false
    fi        
}

function var_exists {
    : checks whether variable exists
    if [ -v "$1" ]; then
        # echo "INFO:    Variable [$1] exists"
        true
    else
        echo "WARNING: Variable ["$1"] not defined"
        false
    fi
}

function export_path {
    : "export_path "$1 ${@:2}""
    : "exports (valid) path as variable"
    param="$1"
    # address issue with spaces in path
    value="${@:2}"
    check_path "$value"
    # only export path if valid path
    if [ $? -eq 0 ]; then    
        expr="$param=\"$value\""
        # echo "CREATE EXPORT $expr"
        eval $expr
        export $param
        return 0
    else
        echo "WARNING Variable [$param] was not exported, check (file) path"
        return 1
    fi  
    # display declaration 
    # echo "EXPR [$expr]"
    # export -p | grep $param
}

function function_exists()
{
    : checks whether function exists
    : "https://stackoverflow.com/questions/85880/determine-if-a-function-exists-in-bash"
    [[ $(type -t $1) == "function" ]] && return 0 || echo "function $1 not found"
}

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
    # replaces any characters with nothing until the occurence of dot
    f_ext=$(echo "$filename" | sed 's/^.*\.//')    
    echo ${f_ext}
}

function get_file_name {
    : returns filename without suffix
    filename="$@"
    # replaces chars  ".<any non . chars> withnothing" 
    f_name=$(echo "$filename" | sed 's/\.[^.]*$//')
    echo ${f_name}
}

function read_link () {
    : reads an url link and displays it
    encoded_path="$(encode_path "$@")";
    regex="URL=(.*)"
    f=$(basename "$encoded_path")
    # echo "LINK $f"
    
    while read line; do    
        # echo "$line"
        if [[ $line =~ $regex ]]; then

            url="${BASH_REMATCH[1]}"
            echo "${url}"
        fi                
    done < "$encoded_path"
}

function open_multiple_links () {    
    : "open_multiple links <path>"
    : open_links for a given directory
    encoded_path="$@"
    echo "OPEN MULTIPLE LINKS IN PATH \"$encoded_path\"" 
    for filename in "$encoded_path"/*; do
        if [ -f "$filename" ]; then 
            fn=$(basename "${filename}")
            f_ext=$(get_file_extension ${fn})
            f_name=$(get_file_name ${fn})
            # echo "EXT [$f_ext] NAME [$f_name]"
            if [ $(get_file_extension ${fn}) = "url" ]; then
                echo "Open Link [${fn}]"
                encoded_path="$(encode_path "$filename")";
                url=$(read_link ${encoded_path})
                #echo "          $url"
                open "${url}"
            fi
        fi
    done
}

# @todo check if explorer file is present
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

p_last=""
function cdd () {
	: "cdd <bash path>", 
    : opens path in bash
	: is used to avoid add quotes so that paths containing spaces
	: can be used directly without the need to enclose them with quotes
    : will also store last visited path in variable p_last also available as alias
    p_last="${PWD}"
	encoded_path="$(encode_path "$@")"
	local d="cd \"$encoded_path\""
	echo "$d"; eval $d
}

function cdl () {
    : "cdl"
    : visits last path stored in variable p_last
    : when called with command cdd
    encoded_path="$(encode_path "$p_last")";
    p_last="${PWD}"
    local d="cd \"$encoded_path\"";
	echo "$d"; eval $d
}

function grepm () {
    : pipes multiple input keywords  
    : to grep pipe
    : usage grepm "first command" "list of search terms"
    : will create a piped grep search using first
    : parameter as initial command
    
    local num_arguments=$#;
    local command=""
    local n=2

    if [ $num_arguments -lt 2 ]; then
        echo "supply parameters to function grepm"
        return 1
    fi

    command="$1"

    if [[ "$command" =~ ^grep.* ]]; then
        command="${command} \"$2\""
        n=3
    else
        n=2
    fi

    # sort first list
    command+="|sort"

    for ((i=n; i<=$#; i++))
    do
        command+="$GREP_PIPE \"${!i}\""
    done    
    #echo "$command"
    eval "$command"
}

function grepm_args () {
    : like grepm but a given number of arguments first argument 
    : is taken as part of first command
    : "usage grepm_args <num> <arg1> <argn> <arg n+1> <arg N>"
    : takes the first n arguments and adds the remaining argumants
    : as argument grep chain
    : "<arg 1>...<arg n>|grep <arg n+1>|...|grep <arg N>"
    
    num_command_params=$(($1+1))
    num_params=$#

    command_part="${@:2:3}"
    grep_params=""
    n=0;
    grep_cmd=""
    for ((i=2; i<=$#; i++))
    do
        # echo "$i - PARAM ${!i}"
        ((n++))
        if [ $n -lt $num_command_params ]; then
            grep_cmd+="${!i} "
        else
            grep_cmd+="$GREP_PIPE \"${!i}\""
        fi

    done    
    echo "$grep_cmd"
}

echo "     END functions_global.sh ----"