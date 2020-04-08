OPERATORSDK ?= $(BUILD_HARNESS_EXTENSIONS_PATH)/vendor/operator-sdk
OPERATORSDK_VERSION ?= v0.15.2
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
	$(OPERATORSDK) build $(TARGET_DOCKER_REGISTRY)/$(IMAGE_NAME):$(TARGET_VERSION)
