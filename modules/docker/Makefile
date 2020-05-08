#-----------------------------------------------------------------------
# Licensed Materials - Property of IBM
#
# (C) Copyright IBM Corporation 2020.
#
# US Government Users Restricted Rights - Use, duplication or disclosure
# restricted by GSA ADP Schedule Contract with IBM Corporation.
#-----------------------------------------------------------------------

DOCKER_USERNAME ?=
DOCKER_PASSWORD ?=
TARGET_DOCKER_REGISTRY ?=

DOCKER_CFG_FOLDER := $(BUILD_HARNESS_EXTENSIONS_PATH)/vendor/docker
DOCKER_PLATFORMS ?= amd64 ppc64le s390x

TARGET_VERSION_LATEST ?= $(SEMVERSION_MAJOR_MINOR)-latest

# Builds a "fat" (multi-platform) Docker manifest.
# Target docker/registry/login should be called first.
#
# Variables:
#   DOCKER_IMAGE_NAME
#     The name of the Docker image.  This is often of the
#     form "registry/image:tag".
#   DOCKER_USERNAME
#     The user name with which to log in to the registry.
#   DOCKER_PASSWORD
#     The password for the Docker user name.
#   DOCKER_PLATFORMS
#     The platforms to include in the manifest.  Default:
#     "amd64 ppc64le s290x".
#   TARGET_DOCKER_REGISTRY
#     The name of the Docker registry.
## Builds a "fat" (multi-platform) Docker manifest
docker/fatmanifest/build: docker/fatmanifest/config
	$(call assert-set,DOCKER)
	$(call assert-set,DOCKER_IMAGE_NAME)
	$(call assert-set,DOCKER_PLATFORMS)
	$(call assert-set,TARGET_DOCKER_REGISTRY)
	$(eval IMAGES := $(foreach platform, $(DOCKER_PLATFORMS), $(DOCKER_IMAGE_NAME)_$(platform)))
	echo $(DOCKER_PASSWORD) | $(DOCKER) --config $(DOCKER_CFG_FOLDER) login -u $(DOCKER_USERNAME) --password-stdin $(TARGET_DOCKER_REGISTRY)
	$(DOCKER) --config $(DOCKER_CFG_FOLDER) manifest create $(DOCKER_IMAGE_NAME) $(IMAGES)
	$(DOCKER) --config $(DOCKER_CFG_FOLDER) manifest inspect $(DOCKER_IMAGE_NAME)

	# Use --purge to remove local cache of manifest lists.
	$(DOCKER) --config $(DOCKER_CFG_FOLDER) manifest push --purge $(DOCKER_IMAGE_NAME)
	rm -rf $(DOCKER_CFG_FOLDER)

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
docker/registry/login:
	$(call assert-set,DOCKER)
	$(call assert-set,DOCKER_USERNAME)
	$(call assert-set,DOCKER_PASSWORD)
	$(call assert-set,TARGET_DOCKER_REGISTRY)
	@echo $(DOCKER_PASSWORD) | $(DOCKER) login -u $(DOCKER_USERNAME) --password-stdin $(TARGET_DOCKER_REGISTRY)

## Only to be used in CI. Retag the current image build to convention and pushes to $TARGET_DOCKER_REGISTRY/$IMAGE_NAME with all relevant tags
docker/image/tag-and-push:
	$(call assert-set,DOCKER)
	$(call assert-set,DOCKER_USERNAME)
	$(call assert-set,DOCKER_PASSWORD)
	$(call assert-set,TARGET_DOCKER_REGISTRY)
	@echo "Retagging $(TARGET_VERSION) to $(TARGET_VERSION_LATEST)"
	@$(DOCKER) tag $(TARGET_DOCKER_REGISTRY)/$(IMAGE_NAME):$(TARGET_VERSION) $(TARGET_DOCKER_REGISTRY)/$(IMAGE_NAME):$(TARGET_VERSION_LATEST)
	@$(SELF) -s docker/image/push
	@$(SELF) -s docker/image/push TARGET_VERSION=$(TARGET_VERSION_LATEST)
	@echo "digest: $(shell $(DOCKER) inspect $(TARGET_DOCKER_REGISTRY)/$(IMAGE_NAME):$(TARGET_VERSION) --format='{{index .RepoDigests 0}}')"

# Helper targets:

.PHONY: docker/fatmanifest/config
docker/fatmanifest/config:
	mkdir -p $(DOCKER_CFG_FOLDER)
	echo '{ "experimental": "enabled" }' > $(DOCKER_CFG_FOLDER)/config.json
