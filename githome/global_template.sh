echo "---- BEGIN global.sh ----"

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
#TODO 
export_path p_work "/c/<Path to your folder containing work files>"

# $p_cmd root path pointing to all cmd files
#TODO 
export_path p_cmd "$p_work/<Path to the CMD Folder, in this case its a subfolder of p_work but chang to your needs>"

# git home ($HOME should be set in windows environment)
# for now Git $HOME is the same $p_cmd/githome
#CHECK
export_path p_home "$p_cmd/githome"

# ########################################################

# txt documents folder 
export_path p_docs "$p_cmd/docs"

# links folder
export_path p_links "$p_cmd/links"

# define global paths
export_path P_PROGRAM_FILES_X86 "/c/Program Files (x86)"
export_path P_PROGRAM_FILES "/c/Program Files"

# --- define executables ---

# check for git installation
echo "CHECK FOR GIT Installations"; where git || echo "GIT is not installed!"

# folder you might have
# export_path p_tools "/c/<folder to any tools you have installed>"

# special tool my life organized / delete if not used
# but you can see how windows apps can be called
# convenience alias is defined
#TODO - IGNORE/DELETE/COMMENT THESE LINES IF NOT USED
export_path EXE_MLO "$p_tools/MLO/mlo.exe"
export_path f_mlo "$p_work/<path to your mlo file>.ml"
mlo="$EXE_MLO $f_mlo &"
alias go_mlo=$mlo

# notepad++ (theres already a shortcut available)
# "https://notepad-plus-plus.org/"
#TODO 
export_path EXE_NPP "$p_tools/Notepad++/notepad++.exe"

# MS Excel / depending on version this can be a different folder
#TODO 
export_path EXE_XLS "/c/Program Files/Microsoft Office/root/Office16/EXCEL.EXE"

echo -e "\r\n     END global.sh ----"