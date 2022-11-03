# .bashrc
# Copyright (c) 2022 Przemyslaw Bida prbida@gmail.com
#
# SPDX-License-Identifier: Apache-2.0

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# User specific aliases and functions
PS1="\n\[\e[1;37m\](\[\e[01;34m\]\u@\h\[\e[1;37m\])(\$(if [[ \$? == 0 ]]; then echo '\[\e[0;32m\]\342\234\223'; else echo '\[\e[0;31m\]\342\234\227'; fi)\[\e[1;37m\])(\[\e[1;34m\]\t\[\e[1;37m\])\[\e[1;37m\]\n(\[\e[1;32m\]\W\[\e[1;37m\])\[\e[1;31m\]\$\[\e[0m\]"

cd_func ()
{
  local x2 the_new_dir adir index
  local -i cnt

  if [[ $1 ==  "--" ]]; then
    dirs -v
    return 0
  fi

  the_new_dir=$1
  [[ -z $1 ]] && the_new_dir=$HOME

  if [[ ${the_new_dir:0:1} == '-' ]]; then
    #
    # Extract dir N from dirs
    index=${the_new_dir:1}
    [[ -z $index ]] && index=1
    adir=$(dirs +$index)
    [[ -z $adir ]] && return 1
    the_new_dir=$adir
  fi

  #
  # '~' has to be substituted by ${HOME}
  [[ ${the_new_dir:0:1} == '~' ]] && the_new_dir="${HOME}${the_new_dir:1}"

  #
  # Now change to the new dir and add to the top of the stack
  pushd "${the_new_dir}" > /dev/null
  [[ $? -ne 0 ]] && return 1
  the_new_dir=$(pwd)

  #
  # Trim down everything beyond 11th entry
  popd -n +11 2>/dev/null 1>/dev/null

  #
  # Remove any other occurence of this dir, skipping the top of the stack
  for ((cnt=1; cnt <= 10; cnt++)); do
    x2=$(dirs +${cnt} 2>/dev/null)
    [[ $? -ne 0 ]] && return 0
    [[ ${x2:0:1} == '~' ]] && x2="${HOME}${x2:1}"
    if [[ "${x2}" == "${the_new_dir}" ]]; then
      popd -n +$cnt 2>/dev/null 1>/dev/null
      cnt=cnt-1
    fi
  done

  return 0
}

alias cd=cd_func
alias ls='ls --color'
alias ll='ls -lah'
alias grep='grep --color'
export PATH=$PATH:$HOME/.local/bin
source /usr/share/bash-completion/completions/git

