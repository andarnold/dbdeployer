#!/usr/bin/env bash
function variable_replace() {
  _variable="${1}"
  _replace="${2}"
  _file="${3}"


  sed -i "s/${_variable}/${_replace}/g" ${_file}

  if [ ${?} -eq 0 ]
  then
    return 0
  else
    return 1
  fi

}
