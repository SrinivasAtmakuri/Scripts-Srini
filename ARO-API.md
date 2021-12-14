## Make admin-action API call(s) to the local-rp

```
export CLUSTER=cluster
```

* Perform AdminUpdate on a dev cluster
```
curl -X PATCH -k "https://localhost:8443/subscriptions/$AZURE_SUBSCRIPTION_ID/resourceGroups/$RESOURCEGROUP/providers/Microsoft.RedHatOpenShift/openShiftClusters/$CLUSTER?api-version=admin" --header "Content-Type: application/json" -d "{}"
```

* Get Cluster detials of a dev cluster
````
curl -X GET -k "https://localhost:8443/subscriptions/$AZURE_SUBSCRIPTION_ID/resourceGroups/$RESOURCEGROUP/providers/Microsoft.RedHatOpenShift/openShiftClusters/$CLUSTER?api-version=admin" --header "Content-Type: application/json" -d "{}"
````

* Get SerialConsole logs of a VM of dev cluster
```
VMNAME="aro-cluster-qplnw-master-0"
curl -X GET -k "https://localhost:8443/admin/subscriptions/$AZURE_SUBSCRIPTION_ID/resourceGroups/$RESOURCEGROUP/providers/Microsoft.RedHatOpenShift/openShiftClusters/$CLUSTER/serialconsole?vmName=$VMNAME" --header "Content-Type: application/json" -d "{}"
```

* List Clusters of a local-rp
```
curl -X GET -k "https://localhost:8443/admin/providers/microsoft.redhatopenshift/openshiftclusters"
```


* List cluster Azure Resources of a dev cluster
```
curl -X GET -k "https://localhost:8443/admin/subscriptions/$AZURE_SUBSCRIPTION_ID/resourceGroups/$RESOURCEGROUP/providers/Microsoft.RedHatOpenShift/openShiftClusters/$CLUSTER/resources"
```

* Perform Cluster Upgrade on a dev cluster
```
curl -X POST -k "https://localhost:8443/admin/subscriptions/$AZURE_SUBSCRIPTION_ID/resourceGroups/$RESOURCEGROUP/providers/Microsoft.RedHatOpenShift/openShiftClusters/$CLUSTER/upgrade"
```
