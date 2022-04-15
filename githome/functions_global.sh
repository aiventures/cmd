echo "---- BEGIN functions_global.sh ----"

# loading global definitions like exe files and work paths 
# that need to be defined up front

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
    if [[ -v $1 ]]; then
        # echo "INFO:    Variable [$1] exists"
        true
    else
        echo "WARNING: Variable [$1] not defined"
        false
    fi
}

function check_var {
    : check for variable and dereference value
    var_exists $1
    if [ $? -eq 0 ]; then
        p="${!1}"
        check_path "$p"
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
        eval $expr
        export $param
    else
        echo "WARNING Variable [$param] was not exported, check path"
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
    # replaces chars  ".<any non . chars> withnothing" 
    f_prefix=$(echo "$filename" | sed 's/\.[^.]*$//')
    # replaces any characters with nothing until the occurence of dot
    f_ext=$(echo "$filename" | sed 's/^.*\.//')    
    echo "$f_prefix $f_ext"
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
            echo "$url"
        fi                
    done < "$encoded_path"
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

    GREP_PIPE="|grep --color=always -in"

    for ((i=n; i<=$#; i++))
    do
        command+="$GREP_PIPE \"${!i}\""
    done    
    #echo "$command"
    eval "$command"
}


echo "     END functions_global.sh ----"