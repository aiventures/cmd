echo "---- load header.sh definitions ----"

# define your own setting
# check the header_personal_template.sh 
# file, adapt it and rename it to 
# header_personal.sh 
. ~/header_personal.sh

# suggestion for prefix notation conventions
# (helps with autocomplete feature)

# files and win representations
# f_
# fwin_

# paths and win representaion
# p_
# pwin_

# work files (changing per task)
# w_{f_,fwin_...}

# executables 
# EXE_ ...

# help files
# HELP_ ...

# --- path definitions ---

# root path pointing to all cmd files
# $p_work is defined in ~/header_personal.sh
export p_cmd="$p_work/CMD"

# git home ($HOME in windows)
export p_home="$p_cmd/githome"

# load todo config (optional)
# comment the following line if todo.txt not used
. ~/../todo/header_todo.sh

# --- define help files ---

# help documents 
# use cat <$f_...> to display file
# use open <$f_...> to open file
export p_docs="$p_cmd/docs"
export help_bash="$p_docs/help_bash.txt"
export help_todo="$p_docs/help_todo.txt"
export help_todo_extended="$p_docs/help_todo_extended.txt"
export help_cmder="$p_docs/help_cmder.txt"














