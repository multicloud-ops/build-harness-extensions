OPERATORSDK ?= $(BUILD_HARNESS_EXTENSIONS_PATH)/vendor/operator-sdk
OPERATORSDK_VERSION ?= v0.17.0
OPERATORSDK_URL ?= https://github.com/operator-framework/operator-sdk/releases/download/$(OPERATORSDK_VERSION)/operator-sdk-$(OPERATORSDK_VERSION)-x86_64-
ifeq ($(BUILD_HARNESS_OS), darwin)
	OPERATORSDK_INSTALL_OS=apple-darwin
else
	OPERATORSDK_INSTALL_OS=linux-gnu
endif

## Install operator-sdk
operatorsdk/install:
	@[ -x $(OPERATORSDK) ] || ( \
		echo "Installing Operator SDK $(OPERATORSDK_VERSION) ($(BUILD_HARNESS_OS)) from $(OPERATORSDK_URL)$(OPERATORSDK_INSTALL_OS)" && \
		curl '-#' -fL -o $(OPERATORSDK) $(OPERATORSDK_URL)$(OPERATORSDK_INSTALL_OS)&& \
		chmod a+x $(OPERATORSDK) \
		)
	$(OPERATORSDK) version

## Run operator-sdk build on $TARGET_DOCKER_REGISTRY/$IMAGE_NAME:$TARGET_VERSION
operatorsdk/build: operatorsdk/install
	@BUILD_ARGS=`for arg in $$ARGS; do \
		printf -- '--build-arg %s=%s ' "$$arg" "$${!arg}"; \
	done`; \
	[ -z $(GO_LDFLAGS) ] || GO_ARGS="-ldflags $(GO_LDFLAGS)" ; \
	echo "Building operator with image build args $$BUILD_ARGS and GO args $$GO_ARGS" ; \
	$(OPERATORSDK) build --go-build-args "$$GO_ARGS" --image-build-args "$$BUILD_ARGS" $(TARGET_DOCKER_REGISTRY)/$(IMAGE_NAME):$(TARGET_VERSION)
