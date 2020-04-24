CHECKSTYLE_VERSION := 8.31

CHECKSTYLE_DIR := $(BUILD_HARNESS_EXTENSIONS_PATH)/vendor/checkstyle
CHECKSTYLE_JAR := $(CHECKSTYLE_DIR)/checkstyle-$(CHECKSTYLE_VERSION)-all.jar
CHECKSTYLE_JAVA ?= $(shell which java 2>/dev/null)
CHECKSTYLE_SOURCE ?=
CHECKSTYLE_TARGET_DIR ?= $(shell pwd -P)
CHECKSTYLE_TARGET_FILE ?= checkstyle-results.xml

# Runs Checkstyle on one or more Java files.
#
# Variables:
#   CHECKSTYLE_JAVA:
#     The fully qualified path to the "java" executable.
#     Default:  the output of "which java".
#   CHECKSTYLE_SOURCE:
#     A file or directory of files against which Checkstyle
#     should be run.
#   CHECKSTYLE_TARGET_DIR:
#     The directory to which the Checkstyle results are written.
#     Default:  The current working directory.
#   CHECKSTYLE_TARGET_FILE:
#     The file to which the Checkstyle results are written.
#     Default:  checkstyle-results.xml.
## Runs Checkstyle on one or more Java files
.PHONY: quality/java/checkstyle
quality/java/checkstyle:
	$(call assert-set,CHECKSTYLE_SOURCE)
	mkdir -p $(CHECKSTYLE_DIR)
	mkdir -p $(CHECKSTYLE_TARGET_DIR)
	[ -f $(CHECKSTYLE_JAR) ] || curl -LJ --insecure -o $(CHECKSTYLE_JAR) \
	    https://github.com/checkstyle/checkstyle/releases/download/checkstyle-$(CHECKSTYLE_VERSION)/checkstyle-$(CHECKSTYLE_VERSION)-all.jar
	[ -d $${CHECKSTYLE_TARGET_DIR} ] || mkdir -p $${CHECKSTYLE_TARGET_DIR}
	$(CHECKSTYLE_JAVA) -jar $(CHECKSTYLE_JAR) com.puppycrawl.tools.checkstyle.gui.Main \
		-c $(BUILD_HARNESS_EXTENSIONS_PATH)/modules/quality/cp4mcm_checks.xml  -f xml \
		-o $(CHECKSTYLE_TARGET_DIR)/$(CHECKSTYLE_TARGET_FILE) $(CHECKSTYLE_SOURCE)