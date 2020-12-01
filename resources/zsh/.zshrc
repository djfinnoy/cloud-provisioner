export PATH=$HOME/bin:/usr/local/bin:/opt/local/bin:/usr/local/go/bin/:$PATH
#
# Set default text editor
export EDITOR=nvim

# zsh functions
fpath=(~/.config/zsh/functions $fpath)
autoload -U $fpath[1]/*(.:t)

# zsh misc
ZSH_CUSTOM="$HOME/.config/zsh/custom/"

# oh-my-zsh
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"
plugins=(git kubectl kube-ps1)
ZSH_DISABLE_COMPFIX=true
source $ZSH/oh-my-zsh.sh
PROMPT='$(kube_ps1)'$PROMPT

