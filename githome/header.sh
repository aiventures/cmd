echo "---- BEGIN header.sh  ----"
# --- verify variable definitions that were previously exported (global.sh) and are needed here  ---
var_exists p_cmd
var_exists p_docs

# --- define help files ---

# help documents 
# use cat <$f_...> to display file
# use open <$f_...> to open file
export_path p_docs "$p_cmd/docs"
export_path help_bash "$p_docs/help_bash.txt"
export_path help_todo_extended "$p_docs/help_todo_extended.txt"
export_path help_todo "$p_docs/help_todo.txt"
export_path help_cmder "$p_docs/help_cmder.txt"

echo "     END header.sh  ----"