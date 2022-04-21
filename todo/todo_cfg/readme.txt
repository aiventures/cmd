# download todo.sh 
# https://github.com/todotxt/todo.txt-cli
# from this, use / tweak config file 
# https://raw.githubusercontent.com/todotxt/todo.txt-cli/master/todo.cfg

# place your config files here and reference them iin header_todo.sh
# in these config files you may reference to variables 
# you might have configure before, eg
# note that you need to reference all of the following variables

major part is to use valid paths in the variables 
for standard todo.txt this is
export TODO_DIR="$p_todo_work"
export TODO_FILE="$p_todo_work/todo.txt"
export DONE_FILE="$p_todo_work/todo_done.txt"
export REPORT_FILE="$p_todo_work/todo_report.txt"

for any custom "<custom>" todo.txt file this is
referencing to files
export TODO_DIR="$p_todo_work"
export TODO_FILE="$p_todo_work/<custom>.txt"
export DONE_FILE="$p_todo_work/<custom>_done.txt"
export REPORT_FILE="$p_todo_work/<custom>_report.txt"

The function register_todo "custom" in functions_todo.sh will
create aliases and paths.

Check with command "alias": open_<custom>, t_<custom> should be created
Use "t_<custom> ls" to list the contents of the todo.txt file

Check with command "env | grep "<custom>" " , when successful there should be 
variables f_<custom>,f_<custom>_done,f_<custom>_report,f_<custom>_cfg
referncing the file paths to each of the todo files
