echo "---- BEGIN functions_global.sh ----"

# loading global definitions like exe files and work paths 
# that need to be defined up front
GREP_PIPE="| grep --color=always -in"

# WINDOWS_EXPLORER @TODO DEFINE
export WIN_EXPLORER="/C/Windows/explorer.exe"
echo "     Setting WINDOWS_EXPLORER TO \"${WIN_EXPLORER}\""

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
    param="${1}"
    # address issue with spaces in path
    value="${@:2}"
    check_path "${value}"
    # only export path if valid path
    if [ $? -eq 0 ]; then    
        expr="$param=\"${value}\""
        # echo "CREATE EXPORT $expr"
        eval "${expr}"
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

function display_multiple_links () {    
    : "display_multiple links <path>"
    : "displays  for a given directory"
    # @todo merge with open_multiple_links function / use getopts
    encoded_path="$@"
    echo "DISPLAY MULTIPLE LINKS IN PATH \"$encoded_path\"" 
    for filename in "$encoded_path"/*; do
        if [ -f "$filename" ]; then 
            fn=$(basename "${filename}")
            f_ext=$(get_file_extension ${fn})
            f_name=$(get_file_name ${fn})
            # echo "EXT [$f_ext] NAME [$f_name]"
            if [ $(get_file_extension ${fn}) = "url" ]; then
                encoded_path="$(encode_path "$filename")";
                url=$(read_link ${encoded_path})
                echo "[${fn}] \"$url\""        
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

    # check if path is a valid path
    check_path "${encoded_path}"
    if [ $? -ne 0 ]; then    
        echo "WARNING Variable [${encoded_path}] was not exported, check (file) path"
        return 1
    fi 

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
	# ls -F -a --color=auto --show-control-chars
}

function cdl () {
    : "cdl"
    : visits last path stored in variable p_last
    : when called with command cdd
    encoded_path="$(encode_path "$p_last")";

    # check if path is a valid path
    check_path "${encoded_path}"
    if [ $? -ne 0 ]; then    
        echo "WARNING Variable [${encoded_path}] was not exported, check (file) path"
        return 1
    fi 

    p_last="${PWD}"
    local d="cd \"$encoded_path\"";
    echo "$d"; eval $d
    ls -F -a --color=auto --show-control-chars
}

function grepm () {
    : pipes multiple input keywords  
    : to grep pipe
    : usage grepm "first command" "list of search terms"
    : will create a piped grep search using first
    : parameter as initial command
    : can be replaced by more convenient grepmf method
    : using input flags    
    
    local num_arguments=$#;
    local command=""
    local n=2

    if [ $num_arguments -lt 2 ]; then
        echo "supply parameters to function grepm"
        return 1
    fi

    command="$1"
    # @todo restrict command execution
    # @todo drop grepm_args 
    # echo "GREPM COMMANDS EXECUTED ${command}"
    # check if commands contain valid operations
    # export / walk_dir / declare / compgen / grep / alias     

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
    # @todo validate command
    eval "$command"
}

function grepm_args () {
    : like grepm but a given number of arguments first argument 
    : is taken as part of first command
    : "usage grepm_args <num> <arg1> <argn> <arg n+1> <arg N>"
    : takes the first n arguments and adds the remaining argumants
    : as argument grep chain
    : "<arg 1>...<arg n>|grep <arg n+1>|...|grep <arg N>"
    : can be replaced by more convenient grepmf method
    : using input flags
    
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

function register_shortcuts () {
    : "register a file object to automatically create aliases"
    : "for opening files or directories"
    : "check register -h for help"
    local OPTIND
    local name=""
    local param=""
    local prefix=""
    local fp=""
    local status=""
    while getopts "f:n:vochl" opt; do
        case "${opt}" in
            f)  fp="${OPTARG}"
                base=$(basename -- ${fp})            
                echo -e "\n     REGISTER [PATH: ${fp}] [BASENAME: ${base}]"
                if [ -f "$fp" ]; then
                    prefix="f_"                    
                    name=$(get_file_name "$base")                    
                elif [ -d "$fp" ]; then                
                    prefix="p_"
                    name="${base}"
                else
                    echo "${fp} is not a file object"
                    return 1
                fi
                param="${prefix}${name}"
                ;;
            n)
                name=${OPTARG}
                if [ ${#prefix} -eq 0 ]; then 
                    echo "${name} -n:Prefix is empty filepath needs to be first argument"
                    return 1
                fi
                param="${prefix}${name}"
                ;;
            o)  
                if [[ ${#name} -eq 0 || ${#fp} -eq 0 || ${#prefix} -eq 0 ]]; then 
                    echo "${fp} -o:  Name or Path is empty/wrong, check order of arguments"
                    continue
                fi
                alias "open_${name}"="open \"${fp}\""
                status+="[ALIAS: open_${name}] "
                ;;
            c)  
                if [[ ${#name} -eq 0 || ${#fp} -eq 0 || "${prefix}" != "p_" ]]; then 
                    echo "${fp} -c: Name or Path is empty/wrong/not a path, check order of arguments"
                    continue
                fi
                alias "cdd_${name}"="cdd \"${fp}\";lc"
                status+="[CDD: cdd_${name}] "
                ;;                
            v)  if [[ ${#param} -eq 0 || ${#fp} -eq 0 ]]; then 
                    echo "${fp} -v: Parameter or Path is empty/wrong/not a path, check order of arguments"
                    continue
                fi
                export_path "${param}" "${fp}"
                status+="[PARAM: ${param}]"
                ;;     
            l)  if [[ ${#param} -eq 0 || "$prefix" != "p_" ]]; then 
                    echo "${fp} -v: Parameter or Path is empty/wrong/not a path, check order of arguments"
                    continue
                fi
                alias "lc_${name}"="lc \"${fp}\""
                status+=" [LC: lc_${name}] "                
                ;;                    
            h)  echo "usage register [-f \"path to file/path\"] [-n \"shortcut_name\"]"
                echo "                    if -n is not given name will be derived from basename"                
                echo "               (-o) create alias open_<shortcut_name> to open object"
                echo "               (-c) create alias cdd_<shortcut_name> to change to path object"
                echo "               (-v) export variable {p_f}_<shortcut_name> to point to file object"                
                echo "                    prefix f for files or p for paths will be created"
                echo "               (-l) create alias ls_<shortcut_name> to list directory"                
                echo "               (-h) Open help options"                        
                ;;
        esac
    done
    echo "     [NAME: $name] [VARIABLE: \$$param]"    
    echo "     ${status}"
}

function grepp () {
    : "convenience wrapper for grep command with params"    
    : "for help check grepp -h "
   
    local OPTIND
    local s_arg=""
    # command for grep command
    local s_cmd="grep --color=always -irn"
    local s_grep_pipe="|grep --color=always -in"

    # disable wildcard expansion; piut entries into list
    set -f
    while getopts "i:e:h" opt; do
        case "${opt}" in
            i)
                arr=(${OPTARG})
                # echo "$OPTIND ARGS[${OPTARG}] ERR $OPTERR ARR LENGTH ${#arr[@]}"
                for k in ${!arr[@]}; do
                  s_arg+=" --include=\"${arr[$k]}\""
                done
                ;;
            e)    
                arr=(${OPTARG})
                for k in ${!arr[@]}; do
                  s_arg+=" --exclude=\"${arr[$k]}\""
                done
                ;;
            h)  echo "usage grepp_args [-i \"list of including terms\"] [-e \"list of excluding terms\"] list of search terms for grep" 
                echo "                 arguments need to be put in string!"               
                echo "                 example grepp -i \"*.sh\" -e \"*.txt\" search1 search2  (search in specific filetypes)"               
                ;;
        esac
    done    
    
    shift $((OPTIND-1))
    # process the remaining arguments    
    arg_list=($@)      
    set +f    
    
    #s_cmd+="${s_arg}"    
    num_args=${#arg_list[@]}
    for ((k=0; k<num_args; k++)); do
        # echo " ${arg_list[$k]}"
        if [ $k -eq 0 ]; then
            s_cmd+=" ${s_arg} ${arg_list[$k]}"
        else
            s_cmd+="${s_grep_pipe} ${arg_list[$k]}"
        fi
    done           
    echo "grepp() [${s_cmd}]"
    eval "${s_cmd}"
}

function grep_path_any () {
    : "convenience wrapper for grep command with params"    
    : "to match any search terms"      
    : "i multiple directorues for help check grepp -h "
   
    local OPTIND
    local s_arg=""
    local s_path=""
    local s_search_term=""
    local s_search_arg=""
    # command for grep command
    local s_cmd="grep --color=always -irn"
    local s_grep_pipe="|grep --color=always -in"
    local s_grep_pipe_cmd=""
    local s_cmd_all="${s_cmd}"

    # disable wildcard expansion; put entries into list
    set -f
    while getopts "p:s:i:e:h" opt; do
        case "${opt}" in
            i)
                arr=(${OPTARG})
                #echo "PARAM I $OPTIND ARGS[${OPTARG}] ERR $OPTERR ARR LENGTH ${#arr[@]}"
                for k in ${!arr[@]}; do
                  s_arg+=" --include=\"${arr[$k]}\""
                done
                ;;
            e)    
                arr=(${OPTARG})
                for k in ${!arr[@]}; do
                  s_arg+=" --exclude=\"${arr[$k]}\""
                done
                ;;
            p)
                arr=(${OPTARG})
                for k in ${!arr[@]}; do
                  s_path+=" \"${arr[$k]}\""
                  echo "x ${arr[$k]}"
                done
                ;;                  
            s)
                #echo "ARGUMENT ${OPTARG} first arg is $first_arg"
                if [ "$s_search_arg" = "" ]; then
                    s_search_arg="${OPTARG}"
                    s_cmd_all=${s_cmd}
                else
                    #s_grep_pipe_cmd+="${s_grep_pipe} \"${OPTARG}\""
                    s_search_arg+="\|${OPTARG}"
                fi
                ;;                            
            h)  echo "usage grep_pathm -p path1 -p path2 ... -s search term 1 -s search term 2 ..."
                echo "                 [-i \"list of including terms\"] [-e \"list of excluding terms\"] list of search terms for grep" 
                echo "                 arguments need to be put in string!"               
                echo "                 example grepp -i \"*.sh\" -e \"*.txt\" search1 search2  (search in specific filetypes)"               
                ;;
        esac
    done    
    set +f 
    #echo "PATH ${s_path}"
    s_cmd_all="${s_cmd_all} ${s_arg} \"${s_search_arg}\" ${s_path}"
    echo "${s_cmd_all}"
    eval "${s_cmd_all}"
} 

function grep_path_all () {
    : "convenience wrapper for grep command with params"  
    : "to match all search terms"  
    : "i multiple directories for help check grepp -h "    
   
    local OPTIND
    local s_arg=""
    local s_path=""
    local s_search_term=""
    local s_search_arg=""
    local s_search_term_list="SEARCH TERMS: "
    local s_xarg="|xargs grep -il "
    local s_xargs=""
    # command for grep command
    local s_cmd="grep -ril"
    local s_grep_pipe="|xargs grep --color=always -Hin"
    local s_grep_pipe_cmd=""
    local s_cmd_all="${s_cmd}"

    # disable wildcard expansion; put entries into list
    set -f
    while getopts "p:s:i:e:h" opt; do
        case "${opt}" in
            i)
                arr=(${OPTARG})
                #echo "PARAM I $OPTIND ARGS[${OPTARG}] ERR $OPTERR ARR LENGTH ${#arr[@]}"
                for k in ${!arr[@]}; do
                  s_arg+=" --include=\"${arr[$k]}\""
                done
                ;;
            e)    
                arr=(${OPTARG})
                for k in ${!arr[@]}; do
                  s_arg+=" --exclude=\"${arr[$k]}\""
                done
                ;;
            p)
                arr=(${OPTARG})
                for k in ${!arr[@]}; do
                  # convert path
                  #converted_path="$(towinpath ${arr[$k]})"
                  #s_path+=" \"${converted_path}\""
                  s_path+="\"${arr[$k]}\" "
                  #echo "x ${arr[$k]}"
                done
                ;;                  
            s)
                s_search_term_list+=" \"${OPTARG}\""
                s_grep_pipe_cmd="${s_grep_pipe} \"${OPTARG}\""
                #echo "ARGUMENT ${OPTARG} first arg is $first_arg"
                if [ "$s_search_arg" = "" ]; then
                    s_search_arg="${OPTARG}"
                    s_cmd_all=${s_cmd}
                else
                    #s_grep_pipe_cmd+="${s_grep_pipe} \"${OPTARG}\""
                    s_xargs+="${s_xarg} \"${OPTARG}\""
                fi
                ;;                            
            h)  echo "usage grep_pathm -p path1 -p path2 ... -s search term 1 -s search term 2 ..."
                echo "                 [-i \"list of including terms\"] [-e \"list of excluding terms\"] list of search terms for grep" 
                echo "                 arguments need to be put in string! Right now p only works with unix notation /c/path/... " 
                echo "                 (only forward slashes allowed but C:/path/...  is also ok"                 
                echo "                 example grep_path_all -p \"C:/p/...\" -s \"greptest\" -s \"abc\" -i \"*.txt\""               
                echo "                 only matches txt files containing both abc and grep test"         

                ;;
        esac
    done    
    set +f 
    #echo "PATH ${s_path}"
    s_cmd_all="${s_cmd_all} ${s_arg} \"${s_search_arg}\" ${s_path} ${s_xargs} ${s_grep_pipe_cmd}"
    echo "${s_search_term_list}"
    echo "${s_cmd_all}"
    eval "${s_cmd_all}"
} 

echo "     END functions_global.sh ----"