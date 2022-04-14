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
    : checks whether functions exists
    : "https://stackoverflow.com/questions/85880/determine-if-a-function-exists-in-bash"
    [[ $(type -t $1) == "function" ]] && return 0
}

echo "     END functions_global.sh ----"