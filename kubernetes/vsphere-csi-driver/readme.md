

- Create namespace
```sh
kubectl apply -f namespace.yml
```


- Taint control plane node(s)
```sh
kubectl describe nodes | egrep "Taints:|Name:"
```
If above command shows no taint on control plane nodes, or missing required taint, then run below command to taint node appropriately
```sh
kubectl taint nodes <k8s-primary-name> node-role.kubernetes.io/control-plane=:NoSchedule
```


- Create a vSphere configuration file for block volumes or file volumes
```sh
cat /etc/kubernetes/csi-vsphere.conf
[Global]
cluster-id = "<cluster-id>"

[VirtualCenter "<IP or FQDN>"]
insecure-flag = "true"
user = "<username>"
password = "<password>"
datacenters = "<datacenter1-path>"
```
```sh
kubectl create secret generic vsphere-config-secret --from-file=csi-vsphere.conf --namespace=vmware-system-csi
```
```sh
rm csi-vsphere.conf
```


- Deploy vSphere Container Storage Plug-in.
```sh
kubectl apply -f driver-2.7.yml
```


- Check csi driver
```sh
kubectl describe csidrivers
```
```sh
kubectl get CSINode
```


- Create Storage Class
```sh
kubectl apply -f storage-class.yml
```


