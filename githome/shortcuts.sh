echo "---- BEGIN shortcuts.sh  ----"

# --- verify variable definitions that are referenced below---
var_exists p_docs
var_exists p_links

# defining shortcuts to some commands
# notice: aliases to path definitions are loaded from header.sh

# reload bash
# alias r="exec bash"
alias r="source ~/.bashrc"

# https://stackoverflow.com/questions/5367068/clear-a-terminal-screen-for-real
alias cls='printf "\033c"'

# aliases for default usage of bash commands
alias lsc="ls --color -a"

# alias for search
# grep pattern -irn --color=always --include=\*.{cpp,h} rootdir

# @todo swith all grep shortcuts to piped ones

# standard grep with color recursive and non recursive version
alias GREPR="grep --color=always -irn"
alias GREP="grep --color=always -in"

# search in docs
grep_doc="cd \"$p_docs\"; ls -a; grep --color=always -irn"
alias grep_doc=$grep_doc

# search in current directory
grep_="ls -a; grep --color=always -irn"
alias grep_=$grep_

# piped grep function if function was defined
function_exists "grepm"
[[ $? -eq 0 ]] && alias grep_m=grepm

# search in aliases
grep_alias="alias|grep --color=always -i"
alias grep_alias=$grep_alias

# search in variables
grep_var="compgen -v|grep --color=always -i"
alias grep_var=$grep_var

# list functions excluding git
# @TODO if no parameters are supplied supply dot
alias grep_functions="declare -F|grep -iv _git|grep -in --color=always"

# list exported functions
alias grep_export="export -p|grep -in --color=always"

# display links in links folder
open_links="walk_dir \"$p_links\""
alias open_links=$open_links

echo "     END shortcuts.sh  ----"
