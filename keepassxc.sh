#!/bin/bash

SCRIPT_DIR=$(dirname "${BASH_SOURCE[0]}")
source "${SCRIPT_DIR}/messages.sh"


### Internal variables ###

_KEEPASSXC_DATABASE_FILE=""
_KEEPASSXC_DATABASE_PASSWORD=""
_KEEPASSXC_FATAL_ERROR="false"


### Internal functions ###

_keepassxc_error()
{
    if [ "${_KEEPASSXC_FATAL_ERROR}" == "true" ]; then
        fatal "$*"
    else
        error "$*"
    fi
}

_keepassxc_check_database_file_valid()
{
    if [ ! -f "${_KEEPASSXC_DATABASE_FILE}" ]; then
        _keepassxc_error "Cannot found '${_KEEPASSXC_DATABASE_FILE}'"
    fi
}


### Public functions ###

keepassxc_set_error_fatal()
{
    # Expected argument value: 'true' or 'false'
    _KEEPASSXC_FATAL_ERROR="${1}"
}

keepassxc_set_database_path()
{
    _KEEPASSXC_DATABASE_FILE="${1}"
    _keepassxc_check_database_file_valid
}

keepassxc_set_database_path_from_user()
{
    echo "What is the keepassxc database file to be used to get secrets?"
    read -r -e -p "Keepassxc database: " _KEEPASSXC_DATABASE_FILE
    _keepassxc_check_database_file_valid
}

keepassxc_set_password_from_user_with_verify()
{
    echo "What is the keepassxc password database?"
    read -r -s -p "Password :" _KEEPASSXC_DATABASE_PASSWORD
    echo
    echo "Verifying password..."
    if echo "${_KEEPASSXC_DATABASE_PASSWORD}" | keepassxc-cli ls -q "${_KEEPASSXC_DATABASE_FILE}" > "/dev/null"; then
        echo "Success"
    else
        _keepassxc_error "Invalid password."
    fi
}

keepassxc_get_username()
{
    entry="${1}"
    keepassxc_get_attribute "${entry}" "UserName"
}

keepassxc_get_password()
{
    entry="${1}"
    keepassxc_get_attribute "${entry}" "Password"
}

keepassxc_get_attribute()
{
    entry="${1}"
    attribute="${2}"
    echo "${_KEEPASSXC_DATABASE_PASSWORD}" | keepassxc-cli show -q -a "${attribute}" "${_KEEPASSXC_DATABASE_FILE}" "${entry}"
}

keepassxc_clear_password()
{
    _KEEPASSXC_DATABASE_PASSWORD="xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
}
