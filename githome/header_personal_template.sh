echo "---- BEGIN header_personal.sh ----"
echo "     check with tab tab $p_.. $f_... for defined stuff"

# your own definitions go in here

# --- personal files and paths ---
#     check the 
#     header_personal_template.sh file
#     at least p_work is required 

# path pointing to your work files
#TODO 
export p_work="</c/<path to your work files containing CMDS folder>"

# several work files adapted to your own needs
# for example any subfolder you want to have as variables later
# export p_bat="$p_work/<any subfolder>"

# folder containing tool executables 
# export p_tools="/C/<Tools>" for example
#TODO
export p_tools="/c/Program Files"

# --- define executables ---

# 7ZIP Commandline and windows GUI

#TODO 
p_zip="</c/path to your zip executable>"
# path zip command line executable
#TODO 
export_path EXE_ZIP_CMD "$p_zip/<zip executable>.exe"
# path to your interactive zip program
#TODO
export_path EXE_ZIP "$p_zip/<interactive zip executable>.exe"

echo -e "\r\n     END header_personal.sh ----"