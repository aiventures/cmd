echo "---- load global.sh definitions ----"

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
    param="$1"
    # address issue with spaces in path
    value="${@:2}"
    expr="$param=\"$value\""
    eval $expr
    export $param
    # display declaration 
    # echo "EXPR [$expr]"
    check_path "$value"
    # export -p | grep $param
}

# ########################################################
# suggestion for prefix notation conventions
# (helps with autocomplete feature)
# files and win representations
# f_ / fwin_: files & paths and win representaion
# p_ / pwin_ 
# w_{f_,fwin_...}: work files (changing per task)
# executables: EXE_ ...
# help files: HELP_ ...

# $p_work is supposed to contain your personal files
# so they can be searched as well
export_path p_work "<path to your work>"

# $p_cmd root path pointing to all cmd files
export_path p_cmd "$p_work/CMD"

# git home ($HOME should be set in windows environment)
# for now Git $HOME is the same $p_cmd/githome
export_path p_home "$p_cmd/githome"

# ########################################################

# txt documents folder 
export_path p_docs "$p_cmd/docs"

# links folder (tbd)
export_path p_links "$p_cmd/links"

# define global paths
export_path P_PROGRAM_FILES_X86 "/c/Program Files (x86)"
export_path P_PROGRAM_FILES "/c/Program Files"

# --- define executables ---
export_path p_tools "/c/10_Tools"

# my life organized / delete if not used
export_path EXE_MLO "$p_tools/MLO/mlo.exe"
export_path f_mlo "$p_work/MeineAufgaben.ml"
go_mlo="$EXE_MLO $f_mlo &"
alias go_mlo=$mlo

# notepad++ (theres already a shortcut available)
export_path EXE_NPP "$p_tools/Notepad++/notepad++.exe"

# MS Excel
export_path EXE_XLS "/c/Program Files/Microsoft Office/root/Office16/EXCEL.EXE"

