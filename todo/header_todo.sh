echo "---- load header_todo.sh definitions ----"

# define config files locations for todo.txt
# https://github.com/todotxt

# variables defined in header.sh
# (needs to be loaded in advance)

# absolute path pointing todo installation
export p_todo_home="$p_cmd/todo"
export p_todo_cfg="$p_todo_home/todo_cfg"
export EXE_TODO="$p_todo_home/todo_cli/todo.sh"

# todo file location (should be an absolute path)
# is used in configuration files
# the files tobe written are defined in config files
export p_todo_work="$p_cmd/todo/todo_txt"

# search in todo / only in text files
search_todo="cd \"$p_todo_work\"; ls -a; grep --include='*.txt' --color=always -irn"
alias search_todo=$search_todo

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

# --- liste todo ---
export f_todo_cfg="$p_todo_cfg/todo.cfg"
todo_command="cls; $EXE_TODO -c -d \"$f_todo_cfg\""
alias t=$todo_command

# you can open the files in notepad++ 
# by entering "open $f_todo" in console
export f_todo="$p_todo_work/todo.txt"
export f_todo_done="$p_todo_work/todo_done.txt"
export f_todo_report="$p_todo_work/todo_report.txt"

# open todo.txt in notepad
alias open_todo="open \"$f_todo\""

# --- shopping list ---
#     shows that you can have different todo.txt files
#     delete if not needed
export f_todo_einkauf_cfg="$p_todo_cfg/einkauf.cfg"
t_einkauf_command="cls; $EXE_TODO -c -d \"$f_todo_einkauf_cfg\""
alias t_einkauf=$t_einkauf_command

export f_todo_einkauf="$p_todo_work/einkauf.txt"
export f_todo_einkauf_done="$p_todo_work/einkauf_done.txt"
export f_todo_einkauf_report="$p_todo_work/einkauf_report.txt"
alias open_todo_einkauf="open \"$f_todo_einkauf\""

# --- liste info ---

# eg use file containing commands











