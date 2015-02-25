#!/bin/bash

COLOR_TITLE="\033[1;94m"
COLOR_MSG="\033[1;36m"
COLOR_DUMP="\033[2;37m"
COLOR_ERROR="\033[1;31m"
COLOR_WARN="\033[1;93m"
COLOR_RESET="\033[0m"

message() {
    COLOR=$1
    MESSAGE=$2
    echo -e $COLOR $MESSAGE $COLOR_RESET
}

check_ret() {
    RETVAL=$?
    if [ $RETVAL -ne 0 ]; then
        message $COLOR_ERROR "Exit Code $RETVAL"
        exit $RETVAL
    fi
}

checkout_server() {
    message $COLOR_TITLE "Checkout server"

    git clone git@github.com:ceph/calamari.git
    check_ret

    git clone git@github.com:ceph/Diamond.git --branch=calamari
    check_ret

    cd calamari/vagrant/precise-build
}

checkout_client() {
    git clone git@github.com:ceph/calamari-clients.git
    check_ret

    cd calamari-clients/vagrant/precise-build
}

build() {
    vagrant up
    vagrant ssh --command "sudo salt-call state.highstate"
    vagrant destroy -f
}


case "$1" in
    server)
        checkout_server
        build
        ;;
    client)
        checkout_client
        build
        ;;
    *)
        echo "Not supported"
        ;;
esac

