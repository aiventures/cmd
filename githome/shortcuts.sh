echo "---- load shortcuts.sh  ----"

# defining shortcuts to some commands
# notice: aliases to path definitions are loaded from header.sh

# reset bash clear screen
alias r="exec bash"
# https://stackoverflow.com/questions/5367068/clear-a-terminal-screen-for-real
alias cls='printf "\033c"'

# aliases for default usage of bash commands
alias lsc="ls --color -a"

# alias for search
# grep pattern -irn --color=always --include=\*.{cpp,h} rootdir

# standard grep
alias GREP="grep --color=always -irn"

# search in docs
search_doc="cd \"$p_docs\"; ls -a; grep --color=always -irn"
alias search_doc=$search_doc

# search in current directory
search="ls -a; grep --color=always -irn"
alias search=$search

# search in aliases
search_alias="alias|grep --color=always -i"
alias search_alias=$search_alias

# search in variables
search_var="compgen -v|grep --color=always -i"
alias search_var=$search_var

# list functions excluding git
alias search_functions="declare -F|grep -iv _git"