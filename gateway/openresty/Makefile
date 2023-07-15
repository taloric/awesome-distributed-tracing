.PHONY: build
build: build-base
	docker build --build-args OPENRESTY_IMAGE=$(OPENRESTY_IMAGE) OPENRESTY_IMAGE_TAG=$(OPENRESTY_IMAGE_TAG) -f Dockerfile.phrase2 -t $(IMAGE_NAME) .
build-base:
	docker build -f Dockerfile.phrase1 -t $(OPENRESTY_IMAGE):${OPENRESTY_IMAGE_TAG} .