OPERATORSDK_ARCH := $(shell uname -m)
OPERATORSDK_DIR := $(BUILD_HARNESS_EXTENSIONS_PATH)/vendor/operatorsdk
OPERATORSDK_VERSION ?= v0.17.0

OPERATORSDK := $(OPERATORSDK_DIR)/operator-sdk

ifeq ($(BUILD_HARNESS_OS), darwin)
	OPERATORSDK_OS := apple-darwin
else
	OPERATORSDK_OS := linux-gnu
endif
OPERATORSDK_DL := https://github.com/operator-framework/operator-sdk/releases/download
OPERATORSDK_URL := $(OPERATORSDK_DL)/$(OPERATORSDK_VERSION)/operator-sdk-$(OPERATORSDK_VERSION)-$(OPERATORSDK_ARCH)-$(OPERATORSDK_OS)

# Installs the Operator SDK.
#
# Variables:
#   OPERATORSDK_VERSION:
#     The operator-sdk version.  Default: 0.17.0.
## Installs the Operator SDK
operatorsdk/install:
	[ -x $(OPERATORSDK) ] || ( \
		echo "Installing Operator SDK $(OPERATORSDK_VERSION) ($(BUILD_HARNESS_OS)) from $(OPERATORSDK_URL)" && \
		mkdir -p $(OPERATORSDK_DIR) && \
		curl '-#' -fL -o $(OPERATORSDK) $(OPERATORSDK_URL) && \
		chmod a+x $(OPERATORSDK) \
		)
	$(OPERATORSDK) version

# Runs a build using the Operator SDK.
#
# Variables:
#   GO_LDFLAGS
#     The Go -ldflags settings.  If set, they are passed
#     to the operator-sdk in the variable GO_ARGS.
#   IMAGE_NAME
#     The name of the image.
#   TARGET_DOCKER_REGISTRY
#     The name of the Docker registry.
#   TARGET_VERSION
#     The image version.
## Runs a build using the Operator SDK
operatorsdk/build: operatorsdk/install
	@BUILD_ARGS=`for arg in $$ARGS; do \
		printf -- '--build-arg %s=%s ' "$$arg" "$${!arg}"; \
	done`; \
	[ -n $(GO_LDFLAGS) ] && GO_ARGS="-ldflags $(GO_LDFLAGS)" ; \
	echo "Building operator with image build args $$BUILD_ARGS and GO args $$GO_ARGS" ; \
	$(OPERATORSDK) build --go-build-args "$$GO_ARGS" --image-build-args "$$BUILD_ARGS" $(TARGET_DOCKER_REGISTRY)/$(IMAGE_NAME):$(TARGET_VERSION)
