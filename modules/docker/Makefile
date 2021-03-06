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

DOCKER_IMAGE_LATEST ?= $(TARGET_DOCKER_REGISTRY)/$(IMAGE_NAME):$(TARGET_VERSION_LATEST)

IMAGE_ARCH_SEPARATOR ?= -

# Builds an architecture-specific Docker image.
#
# Variables:
#   None
.PHONY: docker/arch/build
## Builds an architecture-specific Docker image
docker/arch/build:
	$(SELF) docker/build TARGET_VERSION:=$(TARGET_VERSION_ARCH)

# Pushes a architecture-specific Docker image.
#
# Variables:
#   None
.PHONY: docker/arch/image/push
## Pushes a architecture-specific Docker image
docker/arch/image/push:
	$(SELF) docker/image/push TARGET_VERSION:=$(TARGET_VERSION_ARCH)

# Builds a "fat" (multi-platform) Docker manifest.
# Target docker/registry/login should be called first.
#
# Variables:
#   DOCKER_IMAGE_NAME
#     The name of the Docker manifest.  This is often of the
#     form "registry/image:tag".
#   DOCKER_USERNAME
#     The user name with which to log in to the registry.
#   DOCKER_PASSWORD
#     The password for the Docker user name.
#   DOCKER_PLATFORMS
#     The platforms to include in the manifest.  Default:
#     "amd64 ppc64le s390x".
#   TARGET_DOCKER_REGISTRY
#     The name of the Docker registry.
## *DEPRECATED* Builds a "fat" (multi-platform) Docker manifest
docker/fatmanifest/build: docker/arch/manifest/build docker/arch/manifest/push docker/arch/manifest/push/release-latest
	@echo "DEPRECATED: docker/fatmanifest/build. Please use the following targets: docker/arch/manifest/build docker/arch/manifest/push docker/arch/manifest/push/release-latest"	

# Builds a "fat" (multi-platform) Docker manifest.
# Target docker/registry/login should be called first.
#
# Variables:
#   DOCKER_IMAGE_NAME
#     The name of the Docker manifest.  This is often of the
#     form "registry/image:tag".
#   DOCKER_PLATFORMS
#     The platforms to include in the manifest.  Default:
#     "amd64 ppc64le s390x".
.PHONY: docker/arch/manifest/build
## Builds a "fat" (multi-platform) Docker manifest
docker/arch/manifest/build: docker/fatmanifest/config
	$(call assert-set,DOCKER)
	$(call assert-set,DOCKER_IMAGE_NAME)
	$(call assert-set,DOCKER_PLATFORMS)
	$(eval IMAGES := $(foreach platform, $(DOCKER_PLATFORMS), $(DOCKER_IMAGE_NAME)$(IMAGE_ARCH_SEPARATOR)$(platform)))
	$(DOCKER) --config $(DOCKER_CFG_FOLDER) manifest create --amend $(DOCKER_IMAGE_NAME) $(IMAGES)
	$(DOCKER) --config $(DOCKER_CFG_FOLDER) manifest create --amend $(DOCKER_IMAGE_LATEST) $(IMAGES)
	$(DOCKER) --config $(DOCKER_CFG_FOLDER) manifest inspect $(DOCKER_IMAGE_NAME)

# Pushes a "fat" (multi-platform) Docker manifest.
#
# Variables:
#   DOCKER_IMAGE_NAME
#     The name of the Docker manifest.  This is often of the
#     form "registry/image:tag".
#   DOCKER_USERNAME
#     The user name with which to log in to the registry.
#   DOCKER_PASSWORD
#     The password for the Docker user name.
#   TARGET_DOCKER_REGISTRY
#     The name of the Docker registry.
.PHONY: docker/arch/manifest/push
## Pushes a "fat" (multi-platform) Docker manifest
docker/arch/manifest/push: docker/fatmanifest/config
	$(call assert-set,DOCKER)
	$(call assert-set,DOCKER_IMAGE_NAME)
	$(call assert-set,DOCKER_PLATFORMS)
	# Use --purge to remove local cache of manifest lists.
	$(DOCKER) --config $(DOCKER_CFG_FOLDER) manifest push --purge $(DOCKER_IMAGE_NAME)

.PHONY: docker/arch/manifest/push/release-latest
## Retags the current "fat" (multi-platform) Docker manifest to conventions and pushes to the target Docker registry
docker/arch/manifest/push/release-latest:
	$(call assert-set,DOCKER)
	$(call assert-set,DOCKER_IMAGE_NAME)
	$(call assert-set,DOCKER_PLATFORMS)
	$(call assert-set,TARGET_DOCKER_REGISTRY)
	@echo $(DOCKER_PASSWORD) | $(DOCKER) --config $(DOCKER_CFG_FOLDER) login -u $(DOCKER_USERNAME) --password-stdin $(TARGET_DOCKER_REGISTRY)
	# Use --purge to remove local cache of manifest lists.
	$(DOCKER) --config $(DOCKER_CFG_FOLDER) manifest push --purge $(DOCKER_IMAGE_LATEST)

# Retags the current image to meet conventions and pushes
# the image to the target Docker registry.
#
# Variables:
#   DOCKER_USERNAME
#     The user name with which to log in to the registry.
#   DOCKER_PASSWORD
#     The password for the Docker user name.
#   TARGET_DOCKER_REGISTRY
#     The name of the Docker registry.
.PHONY: docker/image/push/release-latest
## Retags the current image build to conventions and pushes to the target Docker registry
docker/image/push/release-latest:
	$(call assert-set,DOCKER)
	$(call assert-set,DOCKER_USERNAME)
	$(call assert-set,DOCKER_PASSWORD)
	$(call assert-set,TARGET_DOCKER_REGISTRY)
	@echo "Retagging $(TARGET_VERSION) to $(TARGET_VERSION_LATEST)"
	@$(DOCKER) tag $(TARGET_DOCKER_REGISTRY)/$(IMAGE_NAME):$(TARGET_VERSION) $(TARGET_DOCKER_REGISTRY)/$(IMAGE_NAME):$(TARGET_VERSION_LATEST)
	@$(SELF) -s docker/image/push TARGET_VERSION=$(TARGET_VERSION_LATEST)

# Retags the current image to meet conventions and pushes
# the image to the target Docker registry.
#
# Variables:
#   DOCKER_USERNAME
#     The user name with which to log in to the registry.
#   DOCKER_PASSWORD
#     The password for the Docker user name.
#   TARGET_DOCKER_REGISTRY
#     The name of the Docker registry.
.PHONY: docker/image/tag-and-push
## *DEPRECATED* Retags the current image build to conventions and pushes to the target Docker registry
docker/image/tag-and-push:
	@echo "DEPRECATED: docker/image/tag-and-push. Please use the following targets: docker/image/push and docker/image/push/release-latest"
	@$(SELF) -s docker/image/push TARGET_VERSION:=$(TARGET_VERSION_ARCH)
	@$(SELF) -s docker/image/push/release-latest TARGET_VERSION:=$(TARGET_VERSION_ARCH)

.PHONY: docker/image/feature/build-and-push
docker/image/feature/build-and-push:
	$(call assert-set,DOCKER)
	$(call assert-set,DOCKER_USERNAME)
	$(call assert-set,DOCKER_PASSWORD)
	$(call assert-set,TARGET_DOCKER_REGISTRY)
	$(SELF) docker/build TARGET_VERSION:=$(shell git rev-parse --abbrev-ref HEAD)
	@$(SELF) -s docker/image/push TARGET_VERSION=$(shell git rev-parse --abbrev-ref HEAD)

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
## Logs in to a private container registry $(TARGET_DOCKER_REGISTRY) as $(DOCKER_USERNAME) $(DOCKER_PASSWORD)
docker/registry/login:
	$(call assert-set,DOCKER)
	$(call assert-set,DOCKER_USERNAME)
	$(call assert-set,DOCKER_PASSWORD)
	$(call assert-set,TARGET_DOCKER_REGISTRY)
	@echo $(DOCKER_PASSWORD) | $(DOCKER) login -u $(DOCKER_USERNAME) --password-stdin $(TARGET_DOCKER_REGISTRY)

# Helper targets:

.PHONY: docker/fatmanifest/config
docker/fatmanifest/config:
	$(call assert-set,DOCKER)
	$(call assert-set,DOCKER_USERNAME)
	$(call assert-set,DOCKER_PASSWORD)
	$(call assert-set,TARGET_DOCKER_REGISTRY)
	mkdir -p $(DOCKER_CFG_FOLDER)
	echo '{ "experimental": "enabled" }' > $(DOCKER_CFG_FOLDER)/config.json
	@echo $(DOCKER_PASSWORD) | $(DOCKER) --config $(DOCKER_CFG_FOLDER) login -u $(DOCKER_USERNAME) --password-stdin $(TARGET_DOCKER_REGISTRY)
