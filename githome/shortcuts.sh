echo "---- BEGIN shortcuts.sh  ----"

# --- verify variable definitions that are referenced below---
var_exists p_docs
var_exists p_links

# defining shortcuts to some commands
# notice: aliases to path definitions are loaded from header.sh

# reload bash
alias reset="exec bash"
alias r="source ~/.bashrc"

# https://stackoverflow.com/questions/5367068/clear-a-terminal-screen-for-real
alias cls='printf "\033c"'

# aliases for default usage of bash commands
alias ll='ls -l -a --color=auto --show-control-chars'
alias lc='ls -F -a --color=auto --show-control-chars'

# display links in links folder
open_links="walk_dir \"$p_links\""
alias open_links=$open_links

# opening multiple links of a folder in browser
open_multiple_links="open_multiple_links"
alias open_links_mult=$open_multiple_links

# grep convenience command
alias GREP="grep --color=always -in"

# todo search for filenames 
# find . -type f -iname "*.url" -o -iname "*.txt"
# find ./ -type f -regex '.*\.\(jpg\|png\)$'


# alias for search
# grep pattern -irn --color=always --include=\*.{cpp,h} rootdir
# standard grep with color recursive and non recursive version
# using aliases for some quick searches
function_exists "grepm"
if [[ $? -eq 0 ]]; then
    # piped grep 
    grep_multiple="grepm \"grep --color=always -irn\""
    alias grep_m="ls -a; $grep_multiple"
    # search in docs
    alias grep_docs="cdd \"$p_docs\"; ls -a; $grep_multiple"
    # search in cmd
    alias grep_cmd="cdd \"$p_cmd\"; ls -a; $grep_multiple"
    # search in aliases
    alias grep_alias="grepm \"alias\"" 
    # search in variables
    alias grep_variables="grepm \"compgen -v\""  
    # search for available commands
    alias grep_commands="grepm \"compgen  -abckA function\""
    # list functions excluding git
    alias grep_functions="grepm \"declare -F|grep -iv _git\""
    # list exported functions
    alias grep_export="grepm \"export -p\""
    # list links in links folder
    alias grep_links="grepm \"$open_links\""
    # list environment variables
    alias grep_env="grepm \"env\""
    # https://unix.stackexchange.com/questions/94775/list-all-commands-that-a-shell-knows
    # compgen -a # will list all the aliases you could run.
    # compgen -b # will list all the built-ins you could run.
    # compgen -k # will list all the keywords you could run.
    # compgen -A function # will list all the functions you could run.
    # compgen -A function -abck # will list all the above in one go.
fi

echo -e "\r\n     END shortcuts.sh  ----"