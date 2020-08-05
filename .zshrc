# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt autocd
setopt interactivecomments
setopt printexitvalue
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/martin/.zshrc'

export PS1="%n@%~$ "
bindkey -e

autoload -Uz compinit
compinit
# End of lines added by compinstall
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
