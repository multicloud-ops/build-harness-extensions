CHECKSTYLE_VERSION := 8.31

CHECKSTYLE_DIR := $(BUILD_HARNESS_EXTENSIONS_PATH)/vendor/checkstyle
CHECKSTYLE_JAR := $(CHECKSTYLE_DIR)/checkstyle-$(CHECKSTYLE_VERSION)-all.jar
CHECKSTYLE_SOURCE ?=
CHECKSTYLE_TARGET_DIR ?= $(shell pwd -P)
CHECKSTYLE_TARGET_FILE ?= checkstyle-results.xml

GOSEC_DIR := $(BUILD_HARNESS_EXTENSIONS_PATH)/vendor/gosec
GOSEC_BIN_DIR := $(GOSEC_DIR)/bin

GOSEC_SOURCE ?=
GOSEC_TARGET_DIR ?= $(shell pwd -P)
GOSEC_TARGET_FILE ?= gosec-results.txt

JAVA ?= $(shell which java 2>/dev/null)

PMD_VERSION := 6.23.0

PMD_DIR := $(BUILD_HARNESS_EXTENSIONS_PATH)/vendor/pmd
PMD_SOURCE ?=
PMD_TARGET_DIR ?= $(shell pwd -P)
PMD_TARGET_FILE ?= pmd-results.xml
PMD_ZIP := pmd-bin-$(PMD_VERSION).zip

SPOTBUGS_VERSION = 4.0.2

SPOTBUGS_CLASSPATH ?=
SPOTBUGS_DIR := $(BUILD_HARNESS_EXTENSIONS_PATH)/vendor/spotbugs
SPOTBUGS_REPORT_FORMAT ?= html
SPOTBUGS_SOURCE ?=
SPOTBUGS_TARGET_DIR ?= $(shell pwd -P)
SPOTBUGS_TARGET_FILE ?= spotbugs-results.xml
SPOTBUGS_ZIP := spotbugs-$(SPOTBUGS_VERSION).zip

# Runs a gosec scan.
#
# Variables:
#   GO:
#     The fully qualified path to the "go" executable.
#     Default:  the output of "which go".
#   GOSEC_SOURCE:
#     The directory against which gosec should be run.
#     This directory will be recursively scanned for go files.
#   GOSEC_TARGET_DIR:
#     The directory to which the gosec results are written.
#     Default:  The current working directory.
#   GOSEC_TARGET_FILE:
#     The file to which the gosec results are written.
#     Default:  gosec-results.txt
.PHONY: code-quality/go/gosec
## Runs a gosec scan
code-quality/go/gosec:
	$(call assert-set,GO)
	$(call assert-set,GOSEC_SOURCE)
	$(call assert-set,GOSEC_TARGET_DIR)
	$(call assert-set,GOSEC_TARGET_FILE)
	mkdir -p $(GOSEC_BIN_DIR)
	mkdir -p $(GOSEC_TARGET_DIR)
	export GOPATH=$(GOSEC_DIR) && \
	[ -f $(GOSEC_BIN_DIR)/gosec ] || $(GO) get -u github.com/securego/gosec/cmd/gosec && \
	cd $(GOSEC_SOURCE) && \
	OUTPUT=$(GOSEC_TARGET_DIR)/$(GOSEC_TARGET_FILE) && \
	$(GOSEC_BIN_DIR)/gosec -fmt=text -out=$${OUTPUT} ./... && \
	echo Output written to $${OUTPUT}: && \
	cat $${OUTPUT}
	# This is annoying, but Go makes the pkg directory read only.
	chmod -R +w ${GOSEC_DIR}


# Runs Checkstyle on one or more Java files.
#
# Variables:
#   CHECKSTYLE_SOURCE:
#     A file or directory of files against which Checkstyle
#     should be run.
#   CHECKSTYLE_TARGET_DIR:
#     The directory to which the Checkstyle results are written.
#     Default:  The current working directory.
#   CHECKSTYLE_TARGET_FILE:
#     The file to which the Checkstyle results are written.
#     Default:  checkstyle-results.xml.
#   JAVA:
#     The fully qualified path to the "java" executable.
#     Default:  the output of "which java".
## Runs Checkstyle on one or more Java files
.PHONY: code-quality/java/checkstyle
code-quality/java/checkstyle:
	$(call assert-set,CHECKSTYLE_SOURCE)
	mkdir -p $(CHECKSTYLE_DIR)
	mkdir -p $(CHECKSTYLE_TARGET_DIR)
	[ -f $(CHECKSTYLE_JAR) ] || curl -LJ --insecure -o $(CHECKSTYLE_JAR) \
	    https://github.com/checkstyle/checkstyle/releases/download/checkstyle-$(CHECKSTYLE_VERSION)/checkstyle-$(CHECKSTYLE_VERSION)-all.jar
	$(JAVA) -jar $(CHECKSTYLE_JAR) com.puppycrawl.tools.checkstyle.gui.Main \
		-c $(BUILD_HARNESS_EXTENSIONS_PATH)/modules/code-quality/cp4mcm_checkstyle.xml \
		-f xml \
		-o $(CHECKSTYLE_TARGET_DIR)/$(CHECKSTYLE_TARGET_FILE) $(CHECKSTYLE_SOURCE)

# Runs PMD on one or more Java files.
#
# Variables:
#   PMD_SOURCE:
#     A file or directory of files against which Checkstyle
#     should be run.
#   PMD_TARGET_DIR:
#     The directory to which the Checkstyle results are written.
#     Default:  The current working directory.
#   PMD_TARGET_FILE:
#     The file to which the Checkstyle results are written.
#     Default:  pmd-results.xml.
#   JAVA:
#     The fully qualified path to the "java" executable.
#     Default:  the output of "which java".
## Runs PMD on one or more Java files
.PHONY: code-quality/java/pmd
code-quality/java/pmd:
	$(call assert-set,PMD_SOURCE)
	mkdir -p $(PMD_DIR)
	mkdir -p $(PMD_TARGET_DIR)
	if [ ! -f $(PMD_DIR)/$(PMD_ZIP) ]; then \
		curl -LJ --insecure -o $(PMD_DIR)/$(PMD_ZIP) https://github.com/pmd/pmd/releases/download/pmd_releases%2F$(PMD_VERSION)/$(PMD_ZIP); \
		cd $(PMD_DIR) && unzip $(PMD_ZIP); \
	fi
	CLASSPATH=$(BUILD_HARNESS_EXTENSIONS_PATH)/modules/code-quality $(PMD_DIR)/pmd-bin-$(PMD_VERSION)/bin/run.sh pmd \
		-d $(PMD_SOURCE) \
		-f xml \
		-failOnViolation false \
		-r $(PMD_TARGET_DIR)/$(PMD_TARGET_FILE) \
		-R cp4mcm_pmd.xml

# Runs Spotbugs on one or more Java classes.
#
# Variables:
#   SPOTBUGS_CLASSPATH
#     A classpath of all JAR files and directories containing classes
#     that are part of the program being analyzed but you do not want
#     to have analyzed for bugs.
#   SPOTBUGS_REPORT_FORMAT
#     Any of the supported output formats.  Possible values are:
#     emacs, html, xml, xml:withMessages, xdocs.  Default:  html.
#   SPOTBUGS_SOURCE:
#     A file or directory of files against which Spotbugs
#     should be run.  Spotbugs analyzes Java class files, so
#     this may be JAR or ZIP files, or a directory containing
#     class files.
#   SPOTBUGS_TARGET_DIR:
#     The directory to which the Spotbugs results are written.
#     Default:  The current working directory.
#   SPOTBUGS_TARGET_FILE:
#     The file to which the Spotbugs results are written.
#     Default:  spotbugs-results.xml.
#   JAVA:
#     The fully qualified path to the "java" executable.
#     Default:  the output of "which java".
## Runs Spotbugs on one or more Java files
.PHONY: code-quality/java/spotbugs
code-quality/java/spotbugs:
	$(call assert-set,SPOTBUGS_SOURCE)
	mkdir -p $(SPOTBUGS_DIR)
	mkdir -p $(SPOTBUGS_TARGET_DIR)
	if [ ! -f $(SPOTBUGS_DIR)/$(SPOTBUGS_ZIP) ]; then \
		curl -LJ --insecure -o $(SPOTBUGS_DIR)/$(SPOTBUGS_ZIP) \
			https://github.com/spotbugs/spotbugs/releases/download/$(SPOTBUGS_VERSION)/$(SPOTBUGS_ZIP); \
		cd $(SPOTBUGS_DIR) && unzip -n $(SPOTBUGS_ZIP); \
		chmod +x $(SPOTBUGS_DIR)/spotbugs-$(SPOTBUGS_VERSION)/bin/*; \
	fi
	auxCP=""; [ -n $(SPOTBUGS_CLASSPATH) ] && auxCP="-auxclasspath $(SPOTBUGS_CLASSPATH)"; \
	$(SPOTBUGS_DIR)/spotbugs-$(SPOTBUGS_VERSION)/bin/spotbugs \
		$${auxCP} \
		-output $(SPOTBUGS_TARGET_DIR)/$(SPOTBUGS_TARGET_FILE) \
		-$(SPOTBUGS_REPORT_FORMAT) $(SPOTBUGS_SOURCE)
