# Disable greeting
set fish_greeting

# Prompt

set __fish_git_prompt_showdirtystate yes
set __fish_git_prompt_showuntrackedfiles yes
set __fish_git_prompt_color_branch green

fish_config theme choose termcolors

# Added by OrbStack: command-line tools and integration
# This won't be added again if you remove it.
source ~/.orbstack/shell/init2.fish 2>/dev/null || :

#-------------------------------------------------------------------------------
# Vars
#-------------------------------------------------------------------------------
# Modify our path to include our Go binaries
contains $HOME/code/go/bin $fish_user_paths; or set -Ua fish_user_paths $HOME/code/go/bin
contains $HOME/bin $fish_user_paths; or set -Ua fish_user_paths $HOME/bin

# Editor
set -gx EDITOR nvim

# zoxide (z / zi)
zoxide init fish | source

# atuin (ctrl-r only; up arrow stays fish history)
atuin init fish --disable-up-arrow | source
