//! HMAC implementation with SHA1
//! https://tools.ietf.org/html/rfc2104
module Hmac {

    const BLOCK_SIZE = 64;

    //! Authenticate given text involving SHA1 and secret key
    //! @param [Toybox::Lang::Array] key The byte array of secret key
    //! @param [Toybox::Lang::Array] text The byte array of message to be authenticated
    //! @return [Toybox::Lang::Array] the authentication code as byte array
    function authenticateWithSha1(key, text) {
        if (key.size() > BLOCK_SIZE) {
            key = Sha1.encode(key);
        }
        
        // HMAC = H(K XOR opad, H(K XOR ipad, text)), where H = SHA1
        var ipad = new [BLOCK_SIZE];
        var opad = new [BLOCK_SIZE];
        for (var i = 0; i < BLOCK_SIZE; i++) {
            var k = i < key.size() ? key[i] : 0x00;
            ipad[i] = k ^ 0x36;
            opad[i] = k ^ 0x5C;
        }

        return Sha1.encode(opad.addAll(Sha1.encode(ipad.addAll(text))));
    }
}