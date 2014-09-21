#!/bin/bash

function usage {
	cat <<- EOF
	
	  USAGE : `basename $0` node-type
	    node-type - master or slave
	EOF
}

export DEVSTACK_GATE_3PPRJ_BASE=osrg
export DEVSTACK_GATE_3PBRANCH=ofaci
export OSEXT_REPO="-b $DEVSTACK_GATE_3PBRANCH https://github.com/${DEVSTACK_GATE_3PPRJ_BASE}/os-ext-testing.git"
export CONFIG_REPO="-b $DEVSTACK_GATE_3PBRANCH https://github.com/${DEVSTACK_GATE_3PPRJ_BASE}/config.git"
export DEVSTACK_GATE_REPO="-b $DEVSTACK_GATE_3PBRANCH https://github.com/${DEVSTACK_GATE_3PPRJ_BASE}/devstack-gate.git"
export INST_PUPPET_SH="https://raw.github.com/${DEVSTACK_GATE_3PPRJ_BASE}/config/master/install_puppet.sh"

if [ -z "$1" ]; then
    echo "node-type does not specify !"
    usage
    exit 1
else
    if [ ! "${1}" == "master" -a ! "${1}" == "slave" ]; then
        echo "incorrect node-type: $1"
        usage
        exit 1
    fi
    SCRIPT=install_${1}.sh
fi

sudo apt-get update
sudo apt-get install -y wget openssl ssl-cert ca-certificates python-yaml

#git clone https://github.com/${DEVSTACK_GATE_3PPRJ_BASE}/os-ext-testing-data.git data
wget https://raw.github.com/${DEVSTACK_GATE_3PPRJ_BASE}/os-ext-testing/ofaci/puppet/${SCRIPT}
bash ./${SCRIPT}
