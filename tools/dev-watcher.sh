#!/bin/bash
#%
#% Development watcher for oclif commands
#%
#%   Runs commands on save.  Provide a command name.
#%   USAGE
#%     $ ${THIS_FILE} [COMMAND]
#%
#%   COMMANDS
#%     name of command being developed
#%   
#%

# Specify halt conditions (errors, unsets, non-zero pipes), field separator and verbosity
#
set -euo pipefail
IFS=$'\n\t'
[ ! "${VERBOSE:-}" == "true" ] || set -x

# Base conditions
#
SCRIPT_DIR="$(dirname ${0})"

# Receive parameters
#
COMMAND=${1:-}

# If no parameters have been passed show the help header from this script
#
[ "${#}" -gt 0 ] || {
	THIS_FILE="${SCRIPT_DIR}/$(basename ${0})"

	# Cat this file, grep #% lines and clean up with sed
	cat ${THIS_FILE} |
		grep "^#%" |
		sed -e "s|^#%||g" |
		sed -e "s|\${THIS_FILE}|${THIS_FILE}|g"
	exit
}

# Verify nodemon is installed
#
if (! which nodemon)
then
	echo -e "\n Install nodemon globally to use this tool.  E.g.:"
	echo -e "   $ npm i -g nodemon\n"
	exit
fi

# Run commanbd on save using nodemon
#
nodemon -I --exec "clear; bcoc ${COMMAND}" ${SCRIPT_DIR}/../src/commands/*
