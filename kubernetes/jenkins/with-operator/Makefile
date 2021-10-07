cluster_name = cloudops-cluster-dev

# setup-jenkins-sa:
# 	sh setup-jenkins-sa.sh $(cluster_name)

install-jenkins-resources:
	kubectl apply -f jenkins-namespace.yaml,jenkins-sa.yaml,jenkins-configmaps.yaml,jenkins-pvcs.yaml

install-jenkins-operator:
	helm upgrade -i jenkins-operator jenkins/jenkins-operator -n jenkins-operator -f operator-values-helm.yaml --create-namespace

# install-jenkins-instance:
# 	helm upgrade -i jenkins-master jenkins/jenkins-operator -n jenkins-operator -f instance-values-helm.yaml --create-namespace

install-jenkins-instance:
	kubectl apply -f jenkins-instance-deployment.yaml

install-jenkins-ingress:
	kubectl apply -f jenkins-alb.yaml

#clean up
remove-jenkins-operator:
	helm uninstall -n jenkins-operator jenkins-operator

remove-jenkins-instance:
	kubectl delete -f jenkins-instance-deployment.yaml

remove-jenkins-ingress:
	kubectl delete -f jenkins-alb.yaml

remove-jenkins-resources:
	kubectl delete -f jenkins-namespace.yaml



