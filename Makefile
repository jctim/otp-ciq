include properties-travis.mk

sources = `find source -name '*.mc'`
resources = `find resources* -name '*.xml' | tr '\n' ':' | sed 's/.$$//'`
appName = `grep entry manifest.xml | sed 's/.*entry="\([^"]*\).*/\1/'`

build-test-legacy:
	$(SDK_HOME)/bin/monkeyc --warn --output bin/$(appName)-test-legacy.prg \
	-m manifest.xml \
	-z $(resources) \
	-y $(DEVELOPER_KEY) \
	-d $(DEVICE) \
	--unit-test \
	$(sources)

test-legacy: build-test-legacy
	@$(SDK_HOME)/bin/connectiq &&\
	$(SDK_HOME)/bin/monkeydo bin/$(appName)-test-legacy.prg $(DEVICE) -t
	

build:
	$(SDK_HOME)/bin/monkeyc --warn --output bin/$(appName).prg \
	-f ./monkey.jungle \
	-y $(DEVELOPER_KEY) \
	-d $(DEVICE)
	
build-test:
	$(SDK_HOME)/bin/monkeyc --warn --output bin/$(appName)-test.prg \
	-f ./monkey.jungle \
	--unit-test \
	-y $(DEVELOPER_KEY) \
	-d $(DEVICE)

buildall:
	@for device in $(SUPPORTED_DEVICES_LIST); do \
		echo "-----"; \
		echo "Building for" $$device; \
    $(SDK_HOME)/bin/monkeyc --warn --output bin/$(appName)-$$device.prg \
    -f ./monkey.jungle \
    -y $(DEVELOPER_KEY) \
    -d $$device; \
	done

run: build
	@$(SDK_HOME)/bin/connectiq &&\
	$(SDK_HOME)/bin/monkeydo bin/$(appName).prg $(DEVICE)

test: build-test
	@$(SDK_HOME)/bin/connectiq &&\
	$(SDK_HOME)/bin/monkeydo bin/$(appName)-test.prg $(DEVICE) -t

clean:
	@rm bin/*

deploy: build
	@cp bin/$(appName).prg $(DEPLOY)

package:
	@$(SDK_HOME)/bin/monkeyc --warn -e --output bin/$(appName).iq \
    -f ./monkey.jungle \
	-y $(DEVELOPER_KEY) \
	-r