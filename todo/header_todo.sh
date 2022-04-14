echo "---- load header_todo.sh definitions ----"

# --- verify variable definitions that are referenced below---
var_exists p_cmd

# define config files locations for todo.txt
# https://github.com/todotxt

# variables defined in header.sh
# (needs to be loaded in advance)

# absolute path pointing todo installation
export_path p_todo_home "$p_cmd/todo"
export_path p_todo_cfg "$p_todo_home/todo_cfg"

# @TODO check for todo file
export_path EXE_TODO "$p_todo_home/todo_cli/todo.sh"

# todo file location (should be an absolute path)
# is used in configuration files
# the files tobe written are defined in config files
export_path p_todo_work "$p_cmd/todo/todo_txt"

# search in todo folder / only in text files
grep_todo="cd \"$p_todo_work\"; ls -a; grep --include='*.txt' --color=always -irn"
alias grep_todo=$grep_todo

# ------ todo files ----------
# - assumes you have a todo.cfg in todo_cfg subfolder
# - assumes you have file todo.txt in todo_txt folder
#
# usage of variables: in the todo.cfg file (placed in folder todo_cfg)
# (https://raw.githubusercontent.com/todotxt/todo.txt-cli/master/todo.cfg)
# replace the first lines by the following:
# variable defined in ~/header.sh or any other files
#
# export TODO_DIR="$p_todo_work"
# Your todo/done/report.txt locations
# export TODO_FILE="$f_todo"
# export DONE_FILE="$f_todo_done"
# export REPORT_FILE="$f_todo_report"
#
# testdrive the todo.txt by entering \"t ls\"

# @todo generate variables in function

# --- liste todo ---
export_path f_todo_cfg "$p_todo_cfg/todo.cfg"
todo_command="cls; $EXE_TODO -c -d \"$f_todo_cfg\""
alias t_=$todo_command

# you can open the files in notepad++ 
# by entering "open $f_todo" in console
export_path f_todo_done "$p_todo_work/todo_done.txt"
export_path f_todo_report "$p_todo_work/todo_report.txt"
export_path f_todo "$p_todo_work/todo.txt"

# open todo.txt in notepad
alias open_todo="open \"$f_todo\""

# --- shopping list ---
#     shows that you can have different todo.txt files
#     delete if not needed
export_path f_todo_einkauf_cfg "$p_todo_cfg/einkauf.cfg"
t_einkauf_command="cls; $EXE_TODO -c -d \"$f_todo_einkauf_cfg\""
alias t_einkauf=$t_einkauf_command

export_path f_todo_einkauf "$p_todo_work/einkauf.txt"
export_path f_todo_einkauf_done "$p_todo_work/einkauf_done.txt"
export_path f_todo_einkauf_report "$p_todo_work/einkauf_report.txt"
alias open_todo_einkauf="open \"$f_todo_einkauf\""
