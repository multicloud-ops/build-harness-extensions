TARGET_DOCKER_REGISTRY ?=


## Login to private container registry $(TARGET_DOCKER_REGISTRY) as $(DOCKER_USERNAME) $(DOCKER_PASSWORD)
.PHONY: docker/registry/login
# Logs in to a Docker registry.
#
# Variables:
#   DOCKER_USERNAME
#     The user name with which to log in to the registry.
#   DOCKER_PASSWORD
#     The password for the Docker user name.
#   TARGET_DOCKER_REGISTRY
#     The name of the Docker registry.
## Logs in to a private container registry $(TARGET_DOCKER_REGISTRY) as $(DOCKER_USERNAME) $(DOCKER_PASSWORD)
docker/registry/login: $(DOCKER)
	$(call assert-set,DOCKER)
	$(call assert-set,TARGET_DOCKER_REGISTRY)
	$(call assert-set,DOCKER_USERNAME)
	$(call assert-set,DOCKER_PASSWORD)
	@$(DOCKER) login -u $(DOCKER_USERNAME) -p $(DOCKER_PASSWORD) $(TARGET_DOCKER_REGISTRY)
