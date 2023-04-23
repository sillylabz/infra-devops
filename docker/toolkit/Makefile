image_tag ?= 1.0.0

image-latest:
	docker build -t hernanku/toolkit:latest .

image-tag:
	docker build -t hernanku/toolkit:$(image_tag) .

toolkit-tag:
	docker run -ti --rm --name toolkit-$(image_tag) hernanku/toolkit:$(image_tag) bash

toolkit-latest:
	docker run -ti --rm --name toolkit-latest hernanku/toolkit "$@"

push-image:
	docker push hernanku/toolkit:latest 
	docker push hernanku/toolkit:$(image_tag) 


