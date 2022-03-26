#!/bin/bash

SCRIPT_DIR=$(dirname "${BASH_SOURCE[0]}")
source "${SCRIPT_DIR}/messages.sh"


### Internal variables ###

KEEPASSXC_DATABASE_FILE=""
KEEPASSXC_DATABASE_PASSWORD=""
KEEPASSXC_FATAL_ERROR="false"


### Internal functions ###

keepassxc_error()
{
    if [ "${KEEPASSXC_FATAL_ERROR}" == "true" ]; then
        fatal "$*"
    else
        error "$*"
    fi
}


### Public functions ###

keepassxc_set_error_fatal()
{
    # Expected argument value: 'true' or 'false'
    KEEPASSXC_FATAL_ERROR="${1}"
}

keepassxc_get_database_path_from_user()
{
    echo "What is the keepassxc database to get configuration secret?"
    read -r -e -p "Keepassxc database: " KEEPASSXC_DATABASE_FILE
    if [ ! -f "${KEEPASSXC_DATABASE_FILE}" ]; then
        keepassxc_error "Cannot found '${KEEPASSXC_DATABASE_FILE}'"
    fi
}

keepassxc_get_password_from_user_with_verify()
{
    echo "What is the keepassxc password database?"
    read -r -s -p "Password :" KEEPASSXC_DATABASE_PASSWORD
    echo
    echo "Verifying password..."
    if echo "${KEEPASSXC_DATABASE_PASSWORD}" | keepassxc-cli ls -q "${KEEPASSXC_DATABASE_FILE}" > "/dev/null"; then
        echo "Success"
    else
        keepassxc_error "Invalid password."
    fi
}

keepassxc_get_attribute()
{
    entry="${1}"
    attribute="${2}"
    echo "${KEEPASSXC_DATABASE_PASSWORD}" | keepassxc-cli show -q -a "${attribute}" "${KEEPASSXC_DATABASE_FILE}" "${entry}"
}

keepassxc_clear_password()
{
    KEEPASSXC_DATABASE_PASSWORD="xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
}
