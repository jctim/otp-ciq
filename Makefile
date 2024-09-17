include properties.mk

appName = `grep entry manifest.xml | sed 's/.*entry="\([^"]*\).*/\1/'`
all_devices = `grep -Po 'product id="\K[^"]*' manifest.xml | tr '\n' ' '`

build:
	$(SDK_HOME)/bin/monkeyc --warn --output bin/$(appName)-$(DEVICE).prg \
	-f ./monkey.jungle \
	-y $(DEVELOPER_KEY) \
	-d $(DEVICE)
	
build-test:
	$(SDK_HOME)/bin/monkeyc --warn --output bin/$(appName)-$(DEVICE)-test.prg \
	-f ./monkey.jungle \
	--unit-test \
	-y $(DEVELOPER_KEY) \
	-d $(DEVICE)

buildall:
	@for device in $(all_devices); do \
		echo "-----"; \
		echo "Building for" $$device; \
		$(SDK_HOME)/bin/monkeyc --warn --output bin/$(appName)-$$device.prg \
		-f ./monkey.jungle \
		-y $(DEVELOPER_KEY) \
		-d $$device || exit 1; \
	done

run: build
	@$(SDK_HOME)/bin/connectiq &&\
	$(SDK_HOME)/bin/monkeydo bin/$(appName)-$(DEVICE).prg $(DEVICE)

test: build-test
	@$(SDK_HOME)/bin/connectiq &&\
	$(SDK_HOME)/bin/monkeydo bin/$(appName)-$(DEVICE)-test.prg $(DEVICE) -t

clean:
	@rm -rf bin/*

deploy: build
	@cp bin/$(appName)-$(DEVICE).prg $(DEPLOY)

package:
	@$(SDK_HOME)/bin/monkeyc --warn -e --output bin/$(appName).iq \
	-f ./monkey.jungle \
	-y $(DEVELOPER_KEY) \
	-r
