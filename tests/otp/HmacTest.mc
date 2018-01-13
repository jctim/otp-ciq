module HmacTest {

    (:test)
    function test1AuthenticateWithSha1(logger) {
        // test example from Wiki - https://en.wikipedia.org/wiki/Hash-based_message_authentication_code#Examples
        // HMAC_SHA1("key", "The quick brown fox jumps over the lazy dog")   = de7c9b85b8b78aa6bc8a7a36f70a90701c9db4d9
        var hmac = Hmac.authenticateWithSha1(
            "key".toUtf8Array(),
            "The quick brown fox jumps over the lazy dog".toUtf8Array());
        logger.debug(hmac);
        var hmacHex = Convert.byteArrayToHexString(hmac);
        logger.debug(hmacHex);
        return hmacHex.equals("DE7C9B85B8B78AA6BC8A7A36F70A90701C9DB4D9");
    }

     (:test)
     function test2AuthenticateWithSha1(logger) {
         // test example from Wiki - https://en.wikipedia.org/wiki/Hash-based_message_authentication_code#Examples
         // HMAC_SHA1("", "")   = fbdb1d1b18aa6c08324b7d64b71fb76370690e1d
         var hmac = Hmac.authenticateWithSha1(
             "".toUtf8Array(),
             "".toUtf8Array());
         logger.debug(hmac);
         var hmacHex = Convert.byteArrayToHexString(hmac);
         logger.debug(hmacHex);
         return hmacHex.equals("FBDB1D1B18AA6C08324B7D64B71FB76370690E1D");
     }
}