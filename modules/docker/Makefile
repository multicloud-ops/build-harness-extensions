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

CONFIG_FOLDER := "dockerTmp"
PLATFORMS ?= "amd64 ppc64le s390x"

# Builds a "fat" (multi-platform) Docker manifest.
#
# Variables:
#   DOCKER_USERNAME
#     The user name with which to log in to the registry.
#   DOCKER_PASSWORD
#     The password for the Docker user name.
#   IMAGE_NAME
#     The name of the Docker image.  This is often of the
#     form "registry/image:tag".
#   PLATFORMS
#     The platforms to include in the manifest.  Default:
#     "amd64 ppc64le s290x".
#   TARGET_DOCKER_REGISTRY
#     The name of the Docker registry.
.PHONY: docker/fatmanifest/build
docker/fatmanifest/build: $(DOCKER) docker/fatmanifest/config
	$(call assert-set,DOCKER)
	$(call assert-set,DOCKER_USERNAME)
	$(call assert-set,DOCKER_PASSWORD)
	$(call assert-set,IMAGE_NAME)
	$(call assert-set,PLATFORMS)
	$(call assert-set,TARGET_DOCKER_REGISTRY)
	x = foreach(platform, PLATFORMS, "IMAGE_NAME-$(platform) ")
	echo CJB $(x)

# Logs in to a Docker registry.
#
# Variables:
#   DOCKER_USERNAME
#     The user name with which to log in to the registry.
#   DOCKER_PASSWORD
#     The password for the Docker user name.
#   TARGET_DOCKER_REGISTRY
#     The name of the Docker registry.
.PHONY: docker/registry/login
docker/registry/login: $(DOCKER)
	$(call assert-set,DOCKER)
	$(call assert-set,DOCKER_USERNAME)
	$(call assert-set,DOCKER_PASSWORD)
	$(call assert-set,TARGET_DOCKER_REGISTRY)
	@$(DOCKER) login -u $(DOCKER_USERNAME) -p $(DOCKER_PASSWORD) $(TARGET_DOCKER_REGISTRY)

# Helper targets:
.PHONY: docker/fatmanifest/config
docker/fatmanifest/config:
	mkdir -p $(CONFIG_FOLDER)
    echo '{ \"experimental\": \"enabled\" }' > $(CONFIG_FOLDER)/config.json
