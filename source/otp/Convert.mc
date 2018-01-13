module Convert {

    function byteArrayToHexString(bytes) {
        var str = "";
        for (var i = 0; i < bytes.size(); i++) {
            str += bytes[i].format("%02X");
        }
        return str;
    }

    function hexStringToByteArray(hexStr) {
        var bytes = new [hexStr.length() / 2];
        for (var i = 0; i < bytes.size(); i++) {
            var hexIdx = i * 2;
            bytes[i] = hexStr.substring(hexIdx, hexIdx + 2).toNumberWithBase(16);
        }
        return bytes;
    }

    const ALPHABET = "ABCDEFGHIJKLMNOPQRSTUVWXYZ234567";
    const BASE32 = ALPHABET.toCharArray();
    const SHIFT = 5;
    const CSIZE = 8;

    function base32decode2HexString(encoded) {
        var encodedChars = encoded.toUpper().toCharArray();
        var result = new [encodedChars.size() * SHIFT / CSIZE];

        var resultStr = "";
        var buffer = 0;
        var next = 0;
        var bitsLeft = 0;
        
        for (var i = 0; i < encodedChars.size(); i++) {
            buffer <<= SHIFT;
            buffer |= BASE32.indexOf(encodedChars[i]) & 0x1F;
            bitsLeft += SHIFT;
            if (bitsLeft >= CSIZE) {
                result[next] = (buffer >> (bitsLeft - CSIZE) & 0xFF);
                resultStr += result[next].format("%02X");
                bitsLeft -= CSIZE;
                next++;
            }
        }
        return resultStr;
    }
}