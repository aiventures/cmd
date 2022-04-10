echo "---- load header_personal.sh definitions ----"
echo "     check with tab tab $p_.. $f_... for defined stuff"

# your own definitions go in here

# --- personal files and paths ---
#     check the 
#     header_personal_template.sh file
#     at least p_work is required 

# path pointing to your work files
# 
export p_work="</c/<path to your work files containing CMDS folder>"

# several work files adapted to your own needs
# for example any subfolder you want to have as variables later
# export p_bat="$p_work/<any subfolder>"

# folder containing tool executables 
# export p_tools="/C/<Tools>" for example
export p_tools="/c/Program Files"

# --- define executables ---

# my life organized / delete if not used
# export EXE_MLO="$p_tools/MLO/mlo.exe"
# export f_mlo="$p_work/MyTasks.ml"
# mlo="$EXE_MLO $f_mlo &"
# alias mlo=$mlo

# notepad++ (theres already a shortcut available)
# notepad is required for the open command
# export EXE_NPP="$p_tools/Notepad++/notepad++.exe"
export EXE_NPP="$p_tools/Notepad++/notepad++.exe"

# MS Excel
# is required when opening foles of type xlsx / version might differ
export EXE_XLS="/c/Program Files/Microsoft Office/root/Office16/EXCEL.EXE"

