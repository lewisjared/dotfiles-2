# TAKE A LOOK AT THIS SOURCES:
#
# https://wiki.archlinux.org/index.php/Zsh
# http://ohmyz.sh/
#

if [[ $- != *i* ]] || [ -z "$PS1" ]; then
  return 0
fi

# try to load global-bashrc
if [ -f /etc/zsh/zshrc ]; then
  . /etc/zsh/zshrc
fi

source ~/.zprofile
source ~/.shellrc

## time on the right side
strlen() {
  FOO=$1
  local zero='%([BSUbfksu]|([FB]|){*})'
  LEN=${#${(S%%)FOO//$~zero/}}
  echo $LEN
}

# show right prompt with date ONLY when command is executed
preexec() {
  DATE=$( date +"[%H:%M:%S]" )
  local len_right=$( strlen "$DATE" )
  len_right=$(( $len_right+1 ))
  local right_start=$(($COLUMNS - $len_right))

  local len_cmd=$( strlen "$@" )
  local len_prompt=$(strlen "$PROMPT" )
  local len_left=$(($len_cmd+$len_prompt))

  RDATE="\033[${right_start}C ${DATE}"

  if [ $len_left -lt $right_start ]; then
    # command does not overwrite right prompt
    # ok to move up one line
    echo -e "\033[1A${RDATE}"
  else
    echo -e "${RDATE}"
  fi
}

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$($CONFIG_CONDA_LOCATION/bin/conda 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "$CONFIG_CONDA_LOCATION/etc/profile.d/conda.sh" ]; then
        . "$CONFIG_CONDA_LOCATION/etc/profile.d/conda.sh"
    else
        export PATH="$CONFIG_CONDA_LOCATION/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

