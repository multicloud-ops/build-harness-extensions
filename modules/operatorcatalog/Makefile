OPCATALOG_LOCAL_RELEASE_IMG := quay.io/multicloudops/opcatalog-local-release:latest
OPCATALOG_PATH ?= $(BUILD_HARNESS_EXTENSIONS_PATH)/vendor/operator-catalog
OPERATOR_NAME ?= 
OPERATOR_CSV ?= $(PWD)/deploy/olm-catalog/$(OPERATOR_NAME)/manifests/$(OPERATOR_NAME).clusterserviceversion.yaml
OP_CATALOG_REPO ?=
OP_CATALOG_BRANCH ?= release-$(SEMVERSION_MAJOR_MINOR)-snapshot
OPERATOR_VERSION ?= 99.99.99
OPERATOR_VERSION_SNAPSHOT ?= --snapshot
OPCATALOG_REPLACE_TAG ?= $(TARGET_VERSION_ARCH)
OPCATALOG_AUTOREPLACE ?= --autoreplace $(OPCATALOG_REPLACE_TAG)
OPCATALOG_IMAGE_NAME := opcatalog-test
export OPCATALOG_IMAGE ?= $(TARGET_DOCKER_REGISTRY)/$(DOCKER_REPO)/$(OPCATALOG_IMAGE_NAME):$(TARGET_VERSION_ARCH)
OPCATALOG_BUILDER ?= $(BUILD_HARNESS_EXTENSIONS_PATH)/templates/opcatalog/Docker.opcatalog
OPCATALOG_CATALOGSOURCE ?= $(BUILD_HARNESS_EXTENSIONS_PATH)/templates/opcatalog/catalog-source.yaml-template


.PHONY: operatorcatalog/checkout 
## Checkout a specific or latest version of a operator catalog github repo
operatorcatalog/checkout:
	$(call assert-set,OP_CATALOG_REPO)
	${call assert-set,OP_CATALOG_BRANCH}
	$(GIT) clone -b $(OP_CATALOG_BRANCH) $(OP_CATALOG_REPO) $(OPCATALOG_PATH)

.PHONY: operatorcatalog/local/createrelease
## Create a new release version based on local CSV file
operatorcatalog/local/createrelease:
	$(call assert-set,OPCATALOG_LOCAL_RELEASE_IMG)
	$(call assert-set,OPERATOR_NAME)
	$(call assert-set,OPERATOR_VERSION)
	$(call assert-set,OPCATALOG_PATH)
	# To come $(DOCKER) run -it $(OPCATALOG_LOCAL_RELEASE_IMG) 
	@mkdir -p $(OPCATALOG_PATH)
	# python3 ../../operator-catalog/docker/release/local-release.py create-release $(OPERATOR_NAME) --release $(OPERATOR_VERSION) --catalog-path $(OPCATALOG_PATH) $(OPCATALOG_AUTOREPLACE) $(OPERATOR_VERSION_SNAPSHOT) 
	$(DOCKER) run -it -v $(OPCATALOG_PATH):/data -v $(OPERATOR_CSV):/manifests/local_csv.yaml -v $(PWD)/images-override.yaml:/overrides/images-override.yaml $(OPCATALOG_LOCAL_RELEASE_IMG)  \
		create-release $(OPERATOR_NAME) --release $(OPERATOR_VERSION) \
		--catalog-path /data --csv /manifests/local_csv.yaml --images /overrides/images-override.yaml \
		$(OPCATALOG_AUTOREPLACE) $(OPERATOR_VERSION_SNAPSHOT) 

.PHONY: operatorcatalog/local/overridetemplate
## Write out an image override template based on local CSV information
operatorcatalog/local/overridetemplate:
	$(call assert-set,OPCATALOG_LOCAL_RELEASE_IMG)
	$(call assert-set,GITHUB_TOKEN)
	$(call assert-set,OPERATOR_NAME)
	$(call assert-set,OP_CATALOG_BRANCH)
	# python3 ../../operator-catalog/docker/release/local-release.py create-images-override-template $(OPERATOR_NAME) --branch $(OP_CATALOG_BRANCH)
	$(DOCKER) run -it -e GITHUB_TOKEN -v $(PWD):/data $(OPCATALOG_LOCAL_RELEASE_IMG) create-images-override-template $(OPERATOR_NAME) -i /data/images-override.yaml --branch $(OP_CATALOG_BRANCH)

.PHONY: operatorcatalog/local/build
## Build OLM operator catalog
operatorcatalog/local/build:
	$(DOCKER) build -t $(OPCATALOG_IMAGE) --file $(OPCATALOG_BUILDER) $(OPCATALOG_PATH) 

.PHONY: operatorcatalog/local/push
## Push locally built OLM operator catalog to image registry
operatorcatalog/local/push:
	$(DOCKER) push $(OPCATALOG_IMAGE)

.PHONY: operatorcatalog/local/patch
## Patch the operator catalog
operatorcatalog/local/patch:
	# Attempting to find and patch subscription
	cat $(OPCATALOG_CATALOGSOURCE) | envsubst | oc apply -f - 
	oc -n $(shell oc get sub -A | awk '$$2=="$(OPERATOR_NAME)" { print $$1 }') patch sub $(OPERATOR_NAME) --type merge --patch '{"spec":{"source":"$(OPERATOR_NAME)"}}'