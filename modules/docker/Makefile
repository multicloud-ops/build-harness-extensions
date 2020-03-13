TARGET_DOCKER_REGISTRY ?=


## Login to private container registry $(TARGET_DOCKER_REGISTRY) as $(DOCKER_USERNAME) $(DOCKER_PASSWORD)
.PHONY: docker/registry/login
docker/registry/login: $(DOCKER)
	$(call assert-set,DOCKER)
	$(call assert-set,TARGET_DOCKER_REGISTRY)
	$(call assert-set,DOCKER_USERNAME)
	$(call assert-set,DOCKER_PASSWORD)
	@$(DOCKER) login -u $(DOCKER_USERNAME) -p $(DOCKER_PASSWORD) $(TARGET_DOCKER_REGISTRY)
