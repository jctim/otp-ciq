include properties.mk

GREP := $(shell command -v ggrep >/dev/null 2>&1 && echo ggrep || echo grep)
APP_NAME = $(shell $(GREP) entry manifest.xml | sed 's/.*entry="\([^"]*\).*/\1/')
ALL_DEVICES = $(shell $(GREP) -Po 'product id="\K[^"]*' manifest.xml | tr '\n' ' ')

build:
	@echo "Building $(APP_NAME) for $(DEVICE)...";
	@$(SDK_HOME)/bin/monkeyc --warn --output bin/$(APP_NAME)-$(DEVICE).prg \
	-f ./monkey.jungle \
	-y $(DEVELOPER_KEY) \
	-d $(DEVICE)
	
build-test:
	@echo "Building $(APP_NAME)-test for $(DEVICE)...";
	@$(SDK_HOME)/bin/monkeyc --warn --output bin/$(APP_NAME)-$(DEVICE)-test.prg \
	-f ./monkey.jungle \
	--unit-test \
	-y $(DEVELOPER_KEY) \
	-d $(DEVICE)

build-all:
	@for device in $(ALL_DEVICES); do \
		echo "Building $(APP_NAME) for $$device..."; \
		$(SDK_HOME)/bin/monkeyc --warn --output bin/$(APP_NAME)-$$device.prg \
		-f ./monkey.jungle \
		-y $(DEVELOPER_KEY) \
		-d $$device || exit 1; \
		echo "-----"; \
	done

run:
	@echo "Running $(APP_NAME) on $(DEVICE)...";
	@$(SDK_HOME)/bin/connectiq &&\
	$(SDK_HOME)/bin/monkeydo bin/$(APP_NAME)-$(DEVICE).prg $(DEVICE)

test:
	@echo "Running $(APP_NAME)-test on $(DEVICE)...";
	@$(SDK_HOME)/bin/connectiq &&\
	$(SDK_HOME)/bin/monkeydo bin/$(APP_NAME)-$(DEVICE)-test.prg $(DEVICE) -t

clean:
	@rm -rf bin/*

deploy: build
	@cp bin/$(APP_NAME)-$(DEVICE).prg $(DEPLOY)

package:
	@echo "Packaging $(APP_NAME)...";
	@$(SDK_HOME)/bin/monkeyc --warn -e -r --output bin/$(APP_NAME).iq \
    -f ./monkey.jungle \
	-y $(DEVELOPER_KEY) \
