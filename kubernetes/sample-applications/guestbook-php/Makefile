resources:
	kubectl apply -f namespace.yaml

redis:
	kubectl apply -f redis-leader-service.yaml,redis-leader-service.yaml,redis-follower-deployment.yaml,redis-follower-service.yaml

guestbook:
	kubectl apply -f frontend-deployment.yaml,frontend-service.yaml

ingress:
	kubectl apply -f guestbook-ingress.yaml

clean-up:
	kubectl delete -f namespace.yaml

# remove-redis:
# 	kubectl delete -f redis-leader-service.yaml,redis-leader-service.yaml,redis-follower-deployment.yaml,redis-follower-service.yaml

remove-ingress:
	kubectl delete -f guestbook-ingress.yaml



