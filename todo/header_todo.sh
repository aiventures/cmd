echo "---- BEGIN header_todo.sh definitions ----"

# reading additional functions for todo.txt
. ~/../todo/functions_todo.sh

# --- verify variable definitions that are referenced below---
var_exists p_cmd

# define config files locations for todo.txt
# https://github.com/todotxt

# variables defined in header.sh
# (needs to be loaded in advance)

# absolute path pointing todo installation
export_path p_todo_home "$p_cmd/todo"; [ "$?" -eq 0 ] || return false
export_path p_todo_cfg "$p_todo_home/todo_cfg"; [ "$?" -eq 0 ] || return false
export_path EXE_TODO "$p_todo_home/todo_cli/todo.sh"

# todo file location (should be an absolute path)
# is used in configuration files
# the files tobe written are defined in config files
export_path p_todo_work "$p_cmd/todo/todo_txt"

# search in todo folder / only in text files
alias grep_todo="cd \"$p_todo_work\"; ls -a; grepm  \"grep --include='*.txt' --color=always -irn\" "

# register todo files and their variabes / aliases
# optional reading of config files
register_todo "einkauf"
# read_todo_config "einkauf"
register_todo "todo"
# register_todo "todo"

# shortcut to short help
alias t_help="t_ shorthelp"

echo -e "\r\n     header_todo.sh definitions ----"