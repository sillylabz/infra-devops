resources:
	kubectl apply -f namespace.yaml

mysql:
	kubectl apply -f mysql-deployment.yaml

server:
	kubectl apply -f polling-app-server.yaml

client:
	kubectl apply -f polling-app-client.yaml

ingress:
	kubectl apply -f client-ingress.yaml


clean-up:
	kubectl delete -f namespace.yaml
