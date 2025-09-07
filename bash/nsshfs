#!/usr/bin/env bash

function __nsshfs_usage() {
    echo -e "Usage: nsshfs -s <server> [-d remote_dir]"
}

function nsshfs() {
    local remote_dir='/'
    local server=''
    local OPTIND=1

    while getops "hd:s:" opt; do
        case ${opt} in
            h )
                __nsshfs_usage
                return 0
                ;;
            d )
                local remote_dir=$OPTARG
                ;;
            s )
                local server=$OPTARG
                ;;
            \? )
                echo -e "Invalid options"
                __nsshfs_usage
                return 1
                ;;
        esac
    done

    if [ -z "$server" ]; then
        __nsshfs_usage
        return 1
    fi

    if [ -d ~/.sshfs ]; then mkdir ~/.sshfs > /dev/null 2 &1; fi
    if [ -d ~/.sshfs/"$server" ]; then mkdir ~/.sshfs/"$server" > /dev/null 2>&1; fi

    echo -e "sshfs -o default_permissions $server:$remote_dir $HOME/.sshfs/$server"
    echo -e "nvim $HOME/.sshfs/$server"
    echo -e "fusemount -zu $HOME/.sshfs/$server"
    echo -e "rm -rf $HOME/.sshfs/$server"
}
