all: run

# This makefile contains some convenience commands for deploying and publishing.

# For example, to build and run the docker container locally, just run:
# $ make

# or to publish the :latest version to the specified registry as :1.0.0, run:
# $ make publish version=1.0.0

name = main/api-service
registry = 707153133171.dkr.ecr.eu-west-1.amazonaws.com
version ?= latest
region ?= eu-west-1

image:
	$(call blue, "Building docker image...")
	docker build -t ${name}:${version} .
	$(MAKE) clean

run: image
	$(call blue, "Running Docker image locally...")
	docker run -i -t --rm -p 8080:8080 ${name}:${version} 

publish:  
	$(call blue, "Publishing Docker image to registry...")
	aws ecr get-login --no-include-email --region ${region} | /bin/bash
	docker tag ${name}:latest ${registry}/${name}:${version}
	docker push ${registry}/${name}:${version} 

clean: 
	@rm -f app 

define blue
	@tput setaf 6
	@echo $1
	@tput sgr0
endef
