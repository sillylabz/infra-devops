# Install cpi and csi to vanilla k8s cluster  

## Install vsphere cpi  

- Taint  node(s)
```sh
kubectl describe nodes | egrep "Taints:|Name:"
```
***If above command shows no taint on control plane nodes, or missing required taint, then run below command to taint node appropriately***   
```sh
k8_nodes=(
    "tools-k8s-dev-cp1" 
    "tools-k8s-dev-node1" 
    "tools-k8s-dev-node2" 
)
for node in "${k8_nodes[@]}"; do
    kubectl taint nodes "$node" node.cloudprovider.kubernetes.io/uninitialized=true:NoSchedule
done
```  

- Deploy the 3 cpi manifests  
```sh
VERSION=1.31
wget https://raw.githubusercontent.com/kubernetes/cloud-provider-vsphere/release-$VERSION/releases/v$VERSION/vsphere-cloud-controller-manager.yaml
```

**update values in secrets for vcenter `host`, `username` and `password`**  
**update values in configmap section for vcenter `host`**  


- untaint nodes  
```sh
k8_nodes=(
    "tools-k8s-dev-cp1" 
    "tools-k8s-dev-node1" 
    "tools-k8s-dev-node2" 
)
for node in "${k8_nodes[@]}"; do
    kubectl taint nodes "$node" node.cloudprovider.kubernetes.io/uninitialized=true:NoSchedule
done
```


## Install vsphere csi   

- Tainit control plane node(s)
```sh
k8_nodes=(
    "tools-k8s-dev-cp1" 
)
for node in "${k8_nodes[@]}"; do
    kubectl taint nodes "$node" node-role.kubernetes.io/control-plane=:NoSchedule
done
```

- Create namespace
```sh
kubectl apply -f csi/namespace.yml
```

- Create secret for csi
```sh
kubectl apply -f csi/secrets.yml
```

- Install csi 
```sh
CSI_RELEASE_VERSION=release-3.5
kubectl apply -f https://raw.githubusercontent.com/kubernetes-sigs/vsphere-csi-driver/refs/heads/$CSI_RELEASE_VERSION/manifests/vanilla/vsphere-csi-driver.yaml 

```

```sh
kubectl scale deployment vsphere-csi-controller \
  --namespace vmware-system-csi \
  --replicas=1
```


- untaint control plane node(s)
```sh
k8_nodes=(
    "tools-k8s-dev-cp1" 
)
for node in "${k8_nodes[@]}"; do
    kubectl taint nodes "$node" node-role.kubernetes.io/control-plane=:NoSchedule
done
```


- create default storage class
```sh
kubectl apply -f csi/default-sc.yml
```


