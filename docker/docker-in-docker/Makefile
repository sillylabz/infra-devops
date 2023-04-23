image_name=dind20
image_tag=1.0.0

build-latest:
	docker build -t hernanku/$(image_name):latest .

build-tag:
	docker build -t hernanku/$(image_name):$(image_tag) .

push-image:
	docker push hernanku/$(image_name):latest 
	docker push hernanku/$(image_name):$(image_tag) 
