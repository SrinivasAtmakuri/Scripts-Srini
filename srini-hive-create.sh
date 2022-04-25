#!/bin/bash

## Config files to create
cat <<EOF > /home/Srini/yaml/srini-azure-creds-srini.yaml
apiVersion: v1
data:
  osServicePrincipal.json:XXXX
kind: Secret
metadata:
  name: srini-azure-creds
  namespace: srini
type: Opaque
EOF

cat <<EOF > /home/Srini/yaml/srini-azure-creds-hive.yaml
apiVersion: v1
data:
  osServicePrincipal.json: XXXX
kind: Secret
metadata:
  name: srini-azure-creds
  namespace: hive
type: Opaque
EOF

cat <<EOF > /home/Srini/yaml/srini-cluster-deployment.yaml
apiVersion: hive.openshift.io/v1
kind: ClusterDeployment
metadata:
  name: srini-hive-cluster
  namespace: srini
spec:
  baseDomain: srini.osadev.cloud
  clusterName: srini-hive-cluster
  installAttemptsLimit: 1
  platform:
    azure:
      baseDomainResourceGroupName: srini-aro
      credentialsSecretRef:
        name: srini-azure-creds
      region: eastus
  provisioning:
    imageSetRef:
      name: openshift-v4.9.9
    installConfigSecretRef:
      name: srini-install-config
  pullSecretRef:
    name: srini-pull-secret
EOF

cat <<EOF > /home/Srini/yaml/srini-image.yaml 
apiVersion: hive.openshift.io/v1
kind: ClusterImageSet
metadata:
  name: openshift-v4.9.9
spec:
  releaseImage: quay.io/openshift-release-dev/ocp-release@sha256:dc6d4d8b2f9264c0037ed0222285f19512f112cc85a355b14a66bd6b910a4940
EOF

cat <<EOF > /home/Srini/yaml/srini-install-config.yaml
apiVersion: v1
baseDomain: srini.osadev.cloud
compute:
- name: worker
  platform:
    azure:
      osDisk:
        diskSizeGB: 512
      type: Standard_D8s_v3
  replicas: 3
controlPlane:
  name: master
  platform:
    azure:
      osDisk:
        diskSizeGB: 512
      type: Standard_D8s_v3
metadata:
  name: srini-install-config
networking:
  clusterNetwork:
  - cidr: 10.128.0.0/14
    hostPrefix: 23
  machineCIDR: 10.0.0.0/16
  networkType: OpenShiftSDN
  serviceNetwork:
  - 172.30.0.0/16
platform:
 azure:
    baseDomainResourceGroupName: srini-aro
    region: eastus
pullSecret: srini-pull-secret
EOF


cat <<EOF > /home/Srini/yaml/srini-worker.yaml
apiVersion: hive.openshift.io/v1
kind: MachinePool
metadata:
  name: srini-hive-cluster-worker
  namespace: srini
spec:
  clusterDeploymentRef:
    name: srini-hive-cluster
  name: worker
  platform:
    azure:
      osDisk:
        diskSizeGB: 512
      type: Standard_D8s_v3
  replicas: 3
EOF

## OC Commands
/usr/bin/oc create -f /home/Srini/yaml/srini-image.yaml
/usr/bin/oc create -f /home/Srini/yaml/srini-azure-creds-srini.yaml
/usr/bin/oc create -f /home/Srini/yaml/srini-azure-creds-hive.yaml
/usr/bin/oc create secret generic srini-install-config --from-file=install-config.yaml=/home/Srini/yaml/srini-install-config.yaml
/usr/bin/oc create -f /home/Srini/yaml/srini-cluster-deployment.yaml
/usr/bin/oc create -f /home/Srini/yaml/srini-worker.yaml
