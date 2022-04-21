echo "---- BEGIN util.sh functions ----" 
echo "     repo: https://github.com/aiventures/cmd"
echo "     documentation ../docs/doc_install_util.txt"


# load global functions 
# all functions without need for prior 
# variable definition go here
. ~/functions_global.sh

# load global definitions 
# - main paths / application paths
#  p_cmd, p_home, p_docs, p_links
#  P_PROGRAM_FILES_..
# export_path
# - executable paths
# EXE_MLO, EXE_NPP, EXE_XLS, EXE_ZIP
# MAP Specific TOOLS to gerneric aliases
# (so that you do not need to touch
# functions_util.sh later)
# EXE_MLO (specific)
# EXE_XLS (doesnt need to be mapped)
# EXE_<your zip> => EXE_ZIP
# EXE_<your zip command line> => EXE_ZIP_CMD
# EXE_<your difftool> > EXE_DIFFTOOL
# EXE_<youre mergetool> > EXE_MERGETOOL
# EXE_PYTHON (YOUR RUNTIME)
# EXE_CODE > Visual Studio Code
# MAPS TO CODE_EDITOR, for example
# EXE_CODE => EXE_CODE_EDITOR
# Your note tool, for example
# EXE_NPP (Notepad++)
# MAPS TO NOTE_EDITOR for example
# EXE_NPP=EXE_NOTE_EDITOR

# use template global_template.sh
# @TODO copy/rename to global.sh 
# modify the missing variables to your own need
. ~/global.sh

# load header definitions
. ~/header.sh

# define your own setting check the header_personal_template.sh 
# file, adapt it and rename it to header_personal.sh 
. ~/header_personal.sh

# load todo config (optional)
# comment the following line if todo.txt not used
. ~/../todo/header_todo.sh

# load util functions / only loaded at this stage
# due to needed variable definitions from previous scripts
. ~/functions_util.sh

# load shortcuts
. ~/shortcuts.sh

# load own shortcuts / 
# use template shortcuts_template.sh
# @TODO copy/rename to shortcuts_personal.sh 
# you can also use all functions / variables here 
# that were defined previously
. ~/shortcuts_personal.sh

echo -e "\r\n     END util.sh functions ---- \r\n" 