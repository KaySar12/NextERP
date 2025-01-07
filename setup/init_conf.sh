#!/usr/bin/bash

export PATH=/usr/sbin:$PATH
export DEBIAN_FRONTEND=noninteractive

set -euo pipefail
ODOO_IMAGE='hub.nextzenos.com/nexterp/odoo'
DEPLOY_PATH=$(pwd)/deployment
PG_DB=nexterp
PG_USER=nexterp
CURRENT_BRANCH=$(git symbolic-ref --short HEAD)
ODOO_ADDONS=./addons
ODOO_CONFIG=./etc
# System
DEPENDS_PACKAGE=('wget' 'curl' 'git' 'unzip' 'make' 'build-essential')
DEPENDS_COMMAND=('wget' 'curl' 'git' 'unzip' 'make')
((EUID)) && sudo_cmd="sudo" || sudo_cmd=""
readonly MINIMUM_DOCER_VERSION="20"
UNAME_U="$(uname -s)"
readonly UNAME_U
readonly COLOUR_RESET='\e[0m'
readonly aCOLOUR=(
    '\e[38;5;154m' # green  	| Lines, bullets and separators
    '\e[1m'        # Bold white	| Main descriptions
    '\e[90m'       # Grey		| Credits
    '\e[91m'       # Red		| Update notifications Alert
    '\e[33m'       # Yellow		| Emphasis
)
trap 'onCtrlC' INT
onCtrlC() {
    echo -e "${COLOUR_RESET}"
    exit 1
}

Show() {
    # OK
    if (($1 == 0)); then
        echo -e "${aCOLOUR[2]}[$COLOUR_RESET${aCOLOUR[0]}  OK  $COLOUR_RESET${aCOLOUR[2]}]$COLOUR_RESET $2"
    # FAILED
    elif (($1 == 1)); then
        echo -e "${aCOLOUR[2]}[$COLOUR_RESET${aCOLOUR[3]}FAILED$COLOUR_RESET${aCOLOUR[2]}]$COLOUR_RESET $2"
        exit 1
    # INFO
    elif (($1 == 2)); then
        echo -e "${aCOLOUR[2]}[$COLOUR_RESET${aCOLOUR[0]} INFO $COLOUR_RESET${aCOLOUR[2]}]$COLOUR_RESET $2"
    # NOTICE
    elif (($1 == 3)); then
        echo -e "${aCOLOUR[2]}[$COLOUR_RESET${aCOLOUR[4]}NOTICE$COLOUR_RESET${aCOLOUR[2]}]$COLOUR_RESET $2"
    fi
}

Warn() {
    echo -e "${aCOLOUR[3]}$1$COLOUR_RESET"
}

GreyStart() {
    echo -e "${aCOLOUR[2]}\c"
}

ColorReset() {
    echo -e "$COLOUR_RESET\c"
}




Generate_Config(){
 python setup/gen-config.py
 Show 0 'Generate Config Complete'
}

Run_Test_Server(){
Show 0 'Test Server is online'
}
Generate_Config
Run_Test_Server