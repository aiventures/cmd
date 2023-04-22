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
# @TODO: DEFINE p_work
export_path p_work "/c/<Path to your folder containing work files>"

# $p_cmd root path pointing to all cmd files
# @TODO: DEFINE/CHECK p_cmd
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

# --- EXE Section define executables ---
# uncomment if used / veify woth you own path 
# search for all #TODO TAGS

# your personal folder containing tools and programs
# @TODO
#export_path p_tools "/c/<PATH TO YOUR TOOLS FOLDER>"

# my life organized / delete if not used
# # @TODO
#export_path EXE_MLO "$p_tools/MLO/mlo.exe"
# global mlo file
# # @TODO
#export_path F_MLO "$p_work/<MyMLO File>.ml"
#mlo="$EXE_MLO $f_mlo &"
#alias go_mlo=$mlo

# notepad++ (theres already a shortcut available)
# @TODO / CHECK PATH
export_path EXE_NPP "$p_tools/Notepad++/notepad++.exe"
# there is a bash alias already for NPP
OPEN_NPP="Notepad++"

# total commander define path if you want to use it 
# export_path EXE_TOTAL_COMMANDER "$p_tools/totalcmd/TOTALCMD64.EXE"

# VS CODE
# @TODO / CHECK PATH
export_path EXE_CODE "${P_PROGRAM_FILES}/Microsoft VS Code/code.exe"
# there is a bash alias already for code
OPEN_CODE="CODE"

# MELD
# @TODO / CHECK PATH / CHECK WHTHER YOU USE A DIFFERENT CODE DIFF TOOL
export_path EXE_MELD "${p_tools}/Meld_3_20_4/Meld.exe"

# MS Excel
# @TODO / CHECK PATH
export_path EXE_XLS "${P_PROGRAM_FILES}/Microsoft Office/root/Office16/EXCEL.EXE"

# 7ZIP Commandline and windows GUI
# @TODO / CHECK PATH / CHECK FOR YOUR OWN ZIP TOOL
p_7zip="p_tools/7Zip/7-Zip"
export_path EXE_7ZIP_CMD "$p_7zip/7z.exe"
export_path EXE_7ZIP "$p_7zip/7zFM.exe"
# open 7zip links
OPEN_7Z="${EXE_7ZIP}"
OPEN_7Z_CMD="${EXE_7ZIP_CMD} l"

# TBD PYTHON RUNTIME
# export_path EXE_PYTHON "<path to your>/python.exe"

# check for git installation
echo "---- CHECK FOR GIT EXECUTABLES ----"
where "git.exe" || echo "GIT is not installed!"

# git commands list and edit global config
alias git_config="git config --list --global"
alias git_config_edit="git config --edit --global"

# graphical standard git guis # commit viewer and graphical ui
# check whether tools are in path
# where "gi2tk.exe" > /dev/null; r="$?"
where "gitk.exe" && alias git_k="gitk &" || echo "WARN gitk not found"
where "git-gui.exe" && alias git_gui="git-gui &" || echo "WARN git gui not found"

# if git dff and got merge tools are installed and 
# registered in environment path in windows, merge angitd diff tools are called
alias git_difftool="git difftool --dir-diff &"
alias git_mergetool="git mergetool &"

# MAP SPECIFIC PROGRAMS TO GENERIC ONES
# @TODO / CHECK FOR YOUR OWN ZIP TOOL DEFINITION / COPY HERE
export_path EXE_ZIP "${EXE_7ZIP}"
export_path EXE_ZIP_CMD "${EXE_7ZIP_CMD}"
OPEN_ZIP="${OPEN_7Z}"
OPEN_ZIP_CMD="{OPEN_7Z_CMD}"

# @TODO / CHECK FOR YOUR OWN TEXT EDITOR TOOL DEFINITION 
# it might be the case that you need to define a different 
# call to your text editor
export_path EXE_TEXT_EDITOR "${EXE_NPP}"
# is directly an execution code, not a path
export OPEN_TEXT_EDITOR="${OPEN_NPP}"

# @TODO / CHECK FOR YOUR OWN CODE  EDITOR TOOL DEFINITION 
# here we use VISUAL STUDIO CODE 
export_path EXE_CODE_EDITOR "${EXE_CODE}"
export OPEN_CODE_EDITOR="${OPEN_CODE}"

# @TODO / CHECK FOR YOUR OWN CODE DIFF TOOL DEFINITION 
# here we use MELD
export_path EXE_DIFFTOOL "${EXE_MELD}"
export_path EXE_MERGETOOL "${EXE_MELD}"

echo -e "\r\n     END global.sh ----"