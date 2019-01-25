#!/bin/bash
# travis.sh script to

SDK_URL="https://developer.garmin.com/downloads/connect-iq/sdks/connectiq-sdk-win-3.0.7-2018-12-17-efeb3e3.zip"
SDK_FILE="sdk.zip"
SDK_DIR="sdk"

PEM_FILE="/tmp/developer_key.pem"
DER_FILE="/tmp/developer_key.der"

###

wget -O "${SDK_FILE}" "${SDK_URL}"
unzip "${SDK_FILE}" "bin/*" -d "${SDK_DIR}"

openssl genrsa -out "${PEM_FILE}" 4096
openssl pkcs8 -topk8 -inform PEM -outform DER -in "${PEM_FILE}" -out "${DER_FILE}" -nocrypt

export MB_HOME="${SDK_DIR}"
export MB_PRIVATE_KEY="${DER_FILE}"

cd sdk/bin/
echo -e '#!/bin/bash\n\nwine $(dirname "$0")/shell.exe "$@"' > shell
echo -e '#!/bin/bash\n\nwine $(dirname "$0")/simulator.exe "$@"' > simulator
chmod a+x monkeyc monkeydo monkeygraph connectiq connectiqpkg simulator shell
sed -i 's/\r//g' monkeygraph
cd ../../

./mb_runner.sh build
./mb_runner.sh test
./mb_runner.sh package 
