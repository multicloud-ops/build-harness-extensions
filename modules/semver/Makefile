export SEMVERSION_GIT_CANONICAL=$(shell $(GIT) describe --always  --abbrev=10 --dirty)
SEMVERSION_CANONICAL_APPEND_DEVHASH ?= true

# If dirty, create hash of uncommitted work
ifeq ($(findstring dirty,$(SEMVERSION_GIT_CANONICAL)), dirty)
    # Get hash of uncommitted work
    export SEMVERSION_CANONICAL_DEVHASH=$(shell echo $(shell git add -u && git write-tree && git reset) | cut -c-10)
endif

ifeq ($(SEMVERSION_CANONICAL_APPEND_DEVHASH), true)
export SEMVERSION_CANONICAL = $(SEMVERSION_GIT_CANONICAL)$(SEMVERSION_CANONICAL_DEVHASH)
else
export SEMVERSION_CANONICAL = $(SEMVERSION_GIT_CANONICAL)
endif
