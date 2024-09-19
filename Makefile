include properties.mk

GREP := $(shell command -v ggrep >/dev/null 2>&1 && echo ggrep || echo grep)
APP_NAME = $(shell $(GREP) entry manifest.xml | sed 's/.*entry="\([^"]*\).*/\1/')
ALL_DEVICES = $(shell $(GREP) -Po 'product id="\K[^"]*' manifest.xml | tr '\n' ' ')

build:
	$(SDK_HOME)/bin/monkeyc --warn --output bin/$(APP_NAME)-$(DEVICE).prg \
	-f ./monkey.jungle \
	-y $(DEVELOPER_KEY) \
	-d $(DEVICE)
	
build-test:
	$(SDK_HOME)/bin/monkeyc --warn --output bin/$(APP_NAME)-$(DEVICE)-test.prg \
	-f ./monkey.jungle \
	--unit-test \
	-y $(DEVELOPER_KEY) \
	-d $(DEVICE)

buildall:
	@for device in $(ALL_DEVICES); do \
		echo "-----"; \
		echo "Building for" $$device; \
		$(SDK_HOME)/bin/monkeyc --warn --output bin/$(APP_NAME)-$$device.prg \
		-f ./monkey.jungle \
		-y $(DEVELOPER_KEY) \
		-d $$device || exit 1; \
	done

run:
	@$(SDK_HOME)/bin/connectiq &&\
	$(SDK_HOME)/bin/monkeydo bin/$(APP_NAME)-$(DEVICE).prg $(DEVICE)

test:
	@$(SDK_HOME)/bin/connectiq &&\
	$(SDK_HOME)/bin/monkeydo bin/$(APP_NAME)-$(DEVICE)-test.prg $(DEVICE) -t

clean:
	@rm -rf bin/*

deploy: build
	@cp bin/$(APP_NAME)-$(DEVICE).prg $(DEPLOY)

package:
	@$(SDK_HOME)/bin/monkeyc --warn -e --output bin/$(APP_NAME).iq \
	-f ./monkey.jungle \
	-y $(DEVELOPER_KEY) \
	-r
