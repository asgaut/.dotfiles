# shellcheck shell=bash

# Load colors so we can access $fg and more.
autoload -U colors && colors

# No bell: Shut up Zsh
unsetopt beep

# Use emacs keybindings even if our EDITOR is set to vi
#bindkey -e

# Disable CTRL-s from freezing your terminal's output.
stty stop undef

# Enable comments when working in an interactive shell.
setopt interactive_comments

# Keep lots of history within the shell and save it to ~/.zsh_history:
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history

# Use modern completion system. Other than enabling globdots for showing
# hidden files, these ares values in the default generated zsh config.
autoload -U compinit
compinit
_comp_options+=(globdots)

# zsh-autosuggestions settings.
export ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20

# shellcheck disable=SC1091
source "$HOME/.zsh/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh"
# shellcheck disable=SC1091
source "$HOME/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh"

# https://github.com/Aloxaf/fzf-tab
source ~/.zsh/fzf-tab/fzf-tab.plugin.zsh

# disable sort when completing `git checkout`
zstyle ':completion:*:git-checkout:*' sort false
# set descriptions format to enable group support
# NOTE: don't use escape sequences (like '%F{red}%d%f') here, fzf-tab will ignore them
zstyle ':completion:*:descriptions' format '[%d]'
# set list-colors to enable filename colorizing
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
# force zsh not to show completion menu, which allows fzf-tab to capture the unambiguous prefix
zstyle ':completion:*' menu no
# preview directory's content with eza when completing cd
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
# custom fzf flags
# NOTE: fzf-tab does not follow FZF_DEFAULT_OPTS by default
zstyle ':fzf-tab:*' fzf-flags --color=fg:1,fg+:2 --bind=tab:accept
# To make fzf-tab follow FZF_DEFAULT_OPTS.
# NOTE: This may lead to unexpected behavior since some flags break this plugin. See Aloxaf/fzf-tab#455.
zstyle ':fzf-tab:*' use-fzf-default-opts yes
# switch group using `<` and `>`
zstyle ':fzf-tab:*' switch-group '<' '>'

# use tmux popup feature
#zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup

# Ensure colors match by using FZF_DEFAULT_OPTS.
zstyle ":fzf-tab:*" use-fzf-default-opts yes

# Preview file contents when tab completing directories.
zstyle ":fzf-tab:complete:cd:*" fzf-preview "ls --color=always \${realpath}"

# Configure fzf.
export FZF_DEFAULT_COMMAND="rg --files --follow --hidden --glob '!.git'"
export FZF_DEFAULT_OPTS="--info=inline-right --ansi --layout=reverse --border=none"
export FZF_CTRL_T_OPTS="--preview='less {}' --height=100% --bind shift-up:preview-page-up,shift-down:preview-page-down"
# shellcheck disable=SC1091
. ~/.dotfiles/themes/tokyonight-moon/fzf.sh


zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=2
eval "$(dircolors -b)"
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' menu select=long
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

# Load aliases if they exist.
# shellcheck disable=SC1091
[ -f "$HOME/.config/zsh/.aliases" ] && . "$HOME/.config/zsh/.aliases"


# ==================== #
#        Prompt        #
# ==================== #

# RPROMPT - execution time of the last command shown to the right on the prompt

# Function to format seconds into HHhMMmSSs (or just MmSs, etc.)
function format_seconds() {
    local T=$1
    local D=$((T/60/60/24))
    local H=$((T/60/60%24))
    local M=$((T/60%60))
    local S=$((T%60))

    if [[ $D -gt 0 ]]; then
        printf "%d d %02dh%02dm%02ds" $D $H $M $S
    elif [[ $H -gt 0 ]]; then
        printf "%02dh%02dm%02ds" $H $M $S
    elif [[ $M -gt 0 ]]; then
        printf "%02dm%02ds" $M $S
    elif [[ $S -gt 0 ]]; then
        printf "%ds" $S
    fi
}

# This function is executed just before a command is run. It records the current value of the SECONDS 
# shell variable (which counts seconds since the shell started) into a custom timer variable.
function preexec() {
    # $SECONDS: Zsh has a built-in SECONDS variable that provides the number of seconds since the shell was started.
    timer=${timer:-$SECONDS}
}

# This function is executed just before the prompt is displayed, after a command has finished.
function precmd() {
    if [ $timer ]; then
        local cmd_end="$SECONDS"
        local elapsed=$((cmd_end - timer))

        # Format the time using the function and export to RPROMPT
        local formatted_time=$(format_seconds $elapsed)
        export RPROMPT="%F{cyan}${formatted_time}%{$reset_color%}"

        unset timer
    fi
}

# Left prompt setup
# Using single quotes around the PROMPT is very important, otherwise
# the git branch will always be empty. Using single quotes delays the
# evaluation of the prompt. Also PROMPT is an alias to PS1.# shellcheck disable=SC2016
#PROMPT='%B%{$fg[green]%}%n@%{$fg[green]%}%M %{$fg[blue]%}%~%{$fg[yellow]%}$(git_prompt)%{$reset_color%} %(?.$.%{$fg[red]%}$)%b '
#PROMPT='%B%{$fg[green]%}%n %{$fg[blue]%}%~%{$fg[yellow]%}$(git_prompt)%{$reset_color%} %(?.$.%{$fg[red]%}$)%b '
#export PROMPT

# Enable prompt substitution
# This is necessary to allow variable expansion and command substitution within the prompt strings ($PROMPT and $RPROMPT).
setopt prompt_subst

source ~/.dotfiles/git-info.zsh

PROMPT='%B' # Start bold text
# PROMPT+='%F{yellow}%n@%m ' # Display the username followed by @ and hostname in yellow
PROMPT+='%F{blue}%~' # Display the current working directory in blue
PROMPT+='%F{yellow}$(__git_info)%f ' # Display the vcs info in yellow
PROMPT+='%(?.%F{green}%# .%F{red} %# )' # Display a green prompt if the last command succeeded, or red if it failed
PROMPT+='%b%f' # Turn off bold text and reset the text color
