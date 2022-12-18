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
# will not be processed if the paths are not there
export_path p_todo_home "$p_cmd/todo"; [ "$?" -eq 0 ] || return false
export_path p_todo_cfg "$p_todo_home/todo_cfg"; [ "$?" -eq 0 ] || return false
# will throw a warning if file won't be found
export_path EXE_TODO "$p_todo_home/todo_cli/todo.sh"

# decomment
# echo -e "\r\n"
# echo "     TODO.TXT p_todo_home: $p_todo_home"
# echo "     TODO.TXT p_todo_cfg:  $p_todo_cfg"
# echo "     TODO.TXT EXE_TODO:    $EXE_TODO"

# todo file location (should be an absolute path)
# is used in configuration files
# the files tobe written are defined in config files
export_path p_todo_work "${p_cmd}/todo/todo_txt"

# search in todo folder / only in text files
alias grep_todo="cd \"{$p_todo_work}\"; ls -a; grepm  \"grep --include='*.txt' --color=always -irn\" "

# register todo files and their variabes / aliases
# optional reading of config files
# @TODO - DELETE THIS CUSTOM TODO IF NOT USED
# or replace by your own custom todo list(s)
# register_todo "einkauf"
register_todo "info"
# register_todo "entmisteliste"

# register todo.txt  DEFAULT list
# #TODO: Assumes there will be at least 
# /todo/todo_cfg/todo.cfg (config file)
# /todo/todo_txt/todo.txt (todo.txt file)
# check the readme files in the subfolders!
# this function will create paths to files
# and will provide a short cut alias
# execute "t_ ls" to output list
# execute "open_todo" to open todo.txt in text editor
register_todo "todo"

# shortcut to short help
alias t_help="t_ shorthelp"
# decomment
# echo -e "\r\n     header_todo.sh definitions ----"
