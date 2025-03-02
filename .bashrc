#!/bin/bash
## alias fwconfig='DIR=$(pwd) && cd /mnt/sdd1/sdd1/IptablesRules/ && sudo ./main.sh "$@" && cd "$DIR"'


## Custom Script Firewall  ## Add on zshrc or bashrc
fwconfig() {
  DIR=$(pwd)
  cd /mnt/sdd1/sdd1/IptablesRules/ || return
  sudo ./main.sh "$@"
  cd "$DIR" || return
}
