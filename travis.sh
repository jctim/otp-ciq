#!/bin/bash
# travis.sh script to

SDK_URL="https://developer.garmin.com/downloads/connect-iq/sdks/connectiq-sdk-lin-3.0.7-2018-12-17-efeb3e3.zip"
SDK_FILE="sdk.zip"
SDK_DIR="sdk"

PEM_FILE="/tmp/developer_key.pem"
DER_FILE="/tmp/developer_key.der"

###

wget -O "${SDK_FILE}" "${SDK_URL}"
unzip "${SDK_FILE}" "bin/*" -d "${SDK_DIR}"

openssl genrsa -out "${PEM_FILE}" 4096
openssl pkcs8 -topk8 -inform PEM -outform DER -in "${PEM_FILE}" -out "${DER_FILE}" -nocrypt

export SDK_HOME="${SDK_DIR}"
export DEVELOPER_KEY="${DER_FILE}"
export DEVICE="vivoactive3"

appName=`grep entry manifest.xml | sed 's/.*entry="\([^"]*\).*/\1/'`

# make build
echo "${SDK_HOME}/bin/monkeyc" --warn --output "bin/${appName}.prg" \
	-f ./monkey.jungle \
	-y "${DEVELOPER_KEY}" \
	-d "${DEVICE}"

"${SDK_HOME}/bin/monkeyc" --warn --output "bin/${appName}.prg" \
	-f ./monkey.jungle \
	-y "${DEVELOPER_KEY}" \
	-d "${DEVICE}"

# make test
"${SDK_HOME}/bin/monkeyc" --warn --output "bin/${appName}-test.prg" \
	-f ./monkey.jungle \
	--unit-test \
	-y "${DEVELOPER_KEY}" \
	-d "${DEVICE}"

"${SDK_HOME}/bin/connectiq" && "${SDK_HOME}/bin/monkeydo" "bin/${appName}-test.prg" "${DEVICE}" -t

# make package
"${SDK_HOME}/bin/monkeyc" --warn -e --output "bin/${appName}.iq" \
    -f ./monkey.jungle \
	-y "${DEVELOPER_KEY}" \
	-r
