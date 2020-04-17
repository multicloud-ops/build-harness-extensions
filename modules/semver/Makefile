# If we're running in a CI environment, we do not want to add dirty tags.
ifdef TRAVIS
    export SEMVER_RUNNING_IN_CI = true
endif
ifdef JENKINS_HOME
    export SEMVER_RUNNING_IN_CI = true
endif
ifeq ($(SEMVER_RUNNING_IN_CI), true)
    export SEMVERSION_GIT_CANONICAL=$(shell $(GIT) describe --always  --abbrev=10)
    SEMVERSION_CANONICAL_APPEND_DEVHASH = false
else
    export SEMVERSION_GIT_CANONICAL=$(shell $(GIT) describe --always  --abbrev=10 --dirty)
endif
SEMVERSION_CANONICAL_APPEND_DEVHASH ?= true

# If dirty, create hash of uncommitted work.
ifeq ($(findstring dirty,$(SEMVERSION_GIT_CANONICAL)), dirty)
    # Get hash of uncommitted work.
    export SEMVERSION_CANONICAL_DEVHASH=$(shell echo $(shell git add -u && git write-tree && git reset) | cut -c-10)
endif
ifeq ($(SEMVERSION_CANONICAL_APPEND_DEVHASH), true)
export SEMVERSION_CANONICAL = $(SEMVERSION_GIT_CANONICAL)$(SEMVERSION_CANONICAL_DEVHASH)
else
export SEMVERSION_CANONICAL = $(SEMVERSION_GIT_CANONICAL)
endif
