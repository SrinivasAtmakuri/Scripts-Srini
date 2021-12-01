#!/bin/bash

USER=srini
export RESOURCEGROUP=$USER-dev
VMSIZE=Standard_DS1_v2

if [[ $2 != "" && $1 == "create" ]]; then
   VMSIZE=$2
fi

if [[ $1 == "delete" ]]; then
    #az vm delete --name $USER-devel-vm -g $RESOURCEGROUP --yes
    #az group delete --resource-group $RESOURCEGROUP --yes
    exit 0
fi
if [[ $1 == "create" ]]; then
    #az group create --location eastus --resource-group $RESOURCEGROUP
    #az vm create -g $RESOURCEGROUP -n $USER-devel-vm --image OpenLogic:CentOS:7.5:latest --size $VMSIZE --ssh-key-values @~/.ssh/id_rsa.pub --admin-username cloud-user
    exit 0
fi
echo '\033[31minvalid args'
echo '\033[0musage: ./devel-vm.sh create <size>'
echo 'usage: ./devel-vm.sh delete'
exit 1
