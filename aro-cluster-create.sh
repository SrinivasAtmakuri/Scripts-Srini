#!/bin/bash

# Link: https://docs.microsoft.com/en-us/azure/openshift/tutorial-create-cluster

/usr/bin/az login
touch $PWD/env

USER=$1
if [ -z "$1" ]; then
  USER=srini
fi

echo "RESOURCEGROUP=srini-aro" >> $PWD/env
echo "$LOCATION=eastus" >> $PWD/env
echo "$CLUSTER=srini-prod-test" >> $PWD/env
echo "$VNET=srini-aro-vnet" >> $PWD/env
echo "$MASTER_SUBNET=srini-master-subnet" >> $PWD/env
echo "$WORKER_SUBNET=srini-worker-subnet" >> $PWD/env

source ./env

/usr/bin/az group create \
  --name $RESOURCEGROUP \
  --location $LOCATION

/usr/bin/az network vnet create \
   --resource-group $RESOURCEGROUP \
   --name $VNET \
   --address-prefixes 10.0.0.0/22
  

/usr/bin/az network vnet subnet create \
  --resource-group $RESOURCEGROUP \
  --vnet-name $VNET \
  --name $MASTER_SUBNET \
  --address-prefixes 10.0.0.0/23 \
  --service-endpoints Microsoft.ContainerRegistry
 

/usr/bin/az network vnet subnet create \
  --resource-group $RESOURCEGROUP \
  --vnet-name $VNET \
  --name $WORKER_SUBNET \
  --address-prefixes 10.0.2.0/23 \
  --service-endpoints Microsoft.ContainerRegistry


/usr/bin/az aro create \
  --resource-group $RESOURCEGROUP \
  --name $CLUSTER \
  --vnet $VNET \
  --master-subnet $MASTER_SUBNET \
  --worker-subnet $WORKER_SUBNET
