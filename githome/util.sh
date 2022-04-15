echo "---- BEGIN util.sh functions ----" 
echo "     repo: https://github.com/aiventures/cmd"

# load global functions 
# all functions without need for prior 
# variable definition go here
. ~/functions_global.sh

# load global definitions use the global_template.sh 
# modify the missing variables to your own need
# and rename it to global.sh
. ~/global.sh

# load header definitions
. ~/header.sh

# define your own setting check the header_personal_template.sh 
# file, adapt it and rename it to header_personal.sh 
. ~/header_personal.sh

# load todo config (optional)
# comment the following line if todo.txt not used
. ~/../todo/header_todo.sh

# load shortcuts
. ~/shortcuts.sh

# load util functions / only loaded at this stage
# due to needed variable definitions
. ~/functions_util.sh

echo "     END util.sh functions ----" 