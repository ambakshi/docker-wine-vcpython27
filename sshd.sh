#!/bin/bash
#
#

mkdir -m 0700 -p ~/.ssh
[ ! -f ~/.ssh/authorized_keys ] && {
    touch ~/.ssh/authorized_keys
    chmod 0600 ~/.ssh/authorized_keys

    [ -n "$GH_USER" ] && {
        echo >&2 "Downloading pubkeys from https://github.com/${GH_USER}.keys ..."
        wget -qO- https://github.com/${GH_USER}.keys >> ~/.ssh/authorized_keys
    }

    [ -n "$LP_USER" ] && {
        echo >&2 "Downloading pubkeys from https://launchpad.net/~${LP_USER}/+sshkeys ..."
        wget -qO- https://launchpad.net/~${LP_USER}/+sshkeys >> ~/.ssh/authorized_keys
    }
}

if [ $# -gt 0 ]; then
    "$@"
else
    sudo  /usr/bin/ssh-keygen -A
    sudo mkdir -p -m 0755 /var/run/sshd
    echo >&2 "Starting sshd ..."
    #exec sudo /usr/sbin/sshd -D
    exec sudo /usr/sbin/sshd -o X11Forwarding=yes -D
fi
