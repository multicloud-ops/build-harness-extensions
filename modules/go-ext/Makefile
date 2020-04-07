#-----------------------------------------------------------------------
# Licensed Materials - Property of IBM
#
# (C) Copyright IBM Corporation 2020.
#
# US Government Users Restricted Rights - Use, duplication or disclosure
# restricted by GSA ADP Schedule Contract with IBM Corporation.
#-----------------------------------------------------------------------

GO := $(shell which go 2>/dev/null)
PACKAGES ?=
SOURCE_DIR ?= $(pwd)

# Builds one or more packages.
#
# Variables:
#   PACKAGES:
#     One or more packages to build.  Example:  PACKAGES="./util ./web"
#   SOURCE_DIR:
#     Typically, the parent directory containing PACKAGES.  This target
#     will switch to SOURCE_DIR before building the packages.  Default:
#     the current working directory.
go-ext/build: $(GO)
	$(call assert-set,PACKAGES)
	cd $(SOURCE_DIR) && $(GO) build $(PACKAGES)

# Gets one or more packages.
#
# Variables:
#   PACKAGES:
#     One or more packages to get.  Example:  PACKAGES=github.com/fsnotify/fsnotify
go-ext/get: $(GO)
	$(call assert-set,PACKAGES)
	$(GO) get -u -v $(PACKAGES)

# Installs one or more packages.
#
# Variables:
#   PACKAGES:
#     One or more packages to install.  Example:  PACKAGES=./server"
#   SOURCE_DIR:
#     Typically, the parent directory containing PACKAGES.  This target
#     will switch to SOURCE_DIR before installing the packages.  Default:
#     the current working directory.
go-ext/install: $(GO)
	$(call assert-set,PACKAGES)
	cd $(SOURCE_DIR) && $(GO) install $(PACKAGES)
