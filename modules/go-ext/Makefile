#-----------------------------------------------------------------------
# Licensed Materials - Property of IBM
#
# (C) Copyright IBM Corporation 2020.
#
# US Government Users Restricted Rights - Use, duplication or disclosure
# restricted by GSA ADP Schedule Contract with IBM Corporation.
#-----------------------------------------------------------------------

GOEXT_COUNT ?= 1
GOEXT_PACKAGES ?=
GOEXT_SOURCE_DIR ?= $(shell pwd -P)

GOEXT_VENDOR_PATH := $(BUILD_HARNESS_EXTENSIONS_PATH)/vendor
GOEXT_TMP_DIR := $(GOEXT_VENDOR_PATH)/tmp

GOSEC_DIR := $(GOEXT_VENDOR_PATH)/gosec

GOSEC_BIN_DIR := $(GOSEC_DIR)/bin
GOSEC_SOURCE_DIR ?= $(shell pwd -P)
GOSEC_TARGET_DIR ?= $(GOSEC_SOURCE_DIR)
GOSEC_TARGET_FILE ?= gosec-results.txt

# Builds one or more packages.
#
# Variables:
#   GOEXT_PACKAGES:
#     One or more packages to build.  Example:  GOEXT_PACKAGES="./util ./web"
#   GOEXT_SOURCE_DIR:
#     Typically, the parent directory containing GOEXT_PACKAGES.  This target
#     will switch to GOEXT_SOURCE_DIR before building the packages.  Default:
#     the current working directory.
## Builds one or more packages
.PHONY: go/ext/build
go/ext/build:
	$(call assert-set,GO)
	$(call assert-set,GOEXT_PACKAGES)
	cd $(GOEXT_SOURCE_DIR) && $(GO) build $(GOEXT_PACKAGES)

# Gets one or more packages.
#
# Variables:
#   GOEXT_PACKAGES:
#     One or more packages to get.  Example:  GOEXT_PACKAGES=github.com/fsnotify/fsnotify
## Gets one or more packages
.PHONY: go/ext/get
go/ext/get:
	$(call assert-set,GO)
	$(call assert-set,GOEXT_PACKAGES)
	$(GO) get -u $(GOEXT_PACKAGES)

# Runs a gosec scan.
#
# Variables:
#   GOSEC_SOURCE_DIR:
#     The directory against which gosec should be run.
#     This directory will be recursively scanned for go files.
#     Default:  the current working directory.
#   GOSEC_TARGET_DIR:
#     The directory to which the gosec results are written.
#     Default:  The current working directory.
#   GOSEC_TARGET_FILE:
#     The file to which the gosec results are written.
#     Default:  gosec-results.txt
..PHONY: go/ext/gosec
## Runs a gosec scan
go/ext/gosec:
	$(call assert-set,GO)
	$(call assert-set,GOSEC_SOURCE_DIR)
	$(call assert-set,GOSEC_TARGET_DIR)
	$(call assert-set,GOSEC_TARGET_FILE)
	mkdir -p $(GOSEC_BIN_DIR)
	mkdir -p $(GOSEC_TARGET_DIR)
	export GOPATH=$(GOSEC_DIR) && \
	[ -f $(GOSEC_BIN_DIR)/gosec ] || $(GO) get -u github.com/securego/gosec/cmd/gosec && \
	cd $(GOSEC_SOURCE_DIR) && \
	OUTPUT=$(GOSEC_TARGET_DIR)/$(GOSEC_TARGET_FILE) && \
	$(GOSEC_BIN_DIR)/gosec -fmt=text -out=$${OUTPUT} ./... && \
	echo Output written to $${OUTPUT}: && \
	cat $${OUTPUT}
	#chmod -R +w \$(GOEXT_TMP_DIR)
	#rm -rf $(GOEXT_TMP_DIR)

# Installs one or more packages.
#
# Variables:
#   GOEXT_PACKAGES:
#     One or more packages to install.  Example:  GOEXT_PACKAGES=./server"
#   GOEXT_SOURCE_DIR:
#     Typically, the parent directory containing GOEXT_PACKAGES.  This target
#     will switch to GOEXT_SOURCE_DIR before installing the packages.  Default:
#     the current working directory.
## Installs one or more packages.
.PHONY: go/ext/install
go/ext/install:
	$(call assert-set,GO)
	$(call assert-set,GOEXT_PACKAGES)
	cd $(GOEXT_SOURCE_DIR) && $(GO) install $(GOEXT_PACKAGES)

# Tests one or more packages.
#
# Variables:
#   GOEXT_COUNT:
#     The number of times to run the tests.  Default: one.
#   GOEXT_PACKAGES:
#     One or more packages to test.  Example:  GOEXT_PACKAGES="./util ./web"
#   GOEXT_SOURCE_DIR:
#     Typically, the parent directory containing GOEXT_PACKAGES.  This target
#     will switch to GOEXT_SOURCE_DIR before building the packages.  Default:
#     the current working directory.
## Tests one or more packages
.PHONY: go/ext/test
go/ext/test:
	$(call assert-set,GO)
	$(call assert-set,GOEXT_PACKAGES)
	cd $(GOEXT_SOURCE_DIR) && $(GO) test -count=$(GOEXT_COUNT) $(GOEXT_PACKAGES)
