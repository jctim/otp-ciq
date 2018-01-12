module Sha1Test {

    (:test)
    function test1Encode(logger) {
        // test example from RFC - https://tools.ietf.org/html/rfc3174
        // input  "abc"
        // result "A9 99 3E 36 47 06 81 6A BA 3E 25 71 78 50 C2 6C 9C D0 D8 9D",
        var sha1 = Sha1.encode("abc".toUtf8Array());
        var sha1Hex = Convert.byteArrayToHexString(sha1);
        logger.debug(sha1Hex);
        var expectedBytes = [169, 153, 62,  54, 71,  6,   129, 106, 186, 62,
                             37,  113, 120, 80, 194, 108, 156, 208, 216, 157];
        var expectedHex = "A9993E364706816ABA3E25717850C26C9CD0D89D";
        return sha1.toString().equals(expectedBytes.toString())
            && sha1Hex.equals(expectedHex);
    }

    (:test)
    function test2Encode(logger) {
        // test example from Wiki - https://en.wikipedia.org/wiki/SHA-1#Example_hashes
        // input  "The quick brown fox jumps over the lazy dog"
        // result "2fd4e1c67a2d28fced849ee1bb76e7391b93eb12"
        var sha1 = Sha1.encode("The quick brown fox jumps over the lazy dog".toUtf8Array());
        var sha1Hex = Convert.byteArrayToHexString(sha1);
        logger.debug(sha1Hex);
        return sha1Hex.equals("2FD4E1C67A2D28FCED849EE1BB76E7391B93EB12");
    }

    (:test)
    function test3Encode(logger) {
        // test example from Wiki - https://en.wikipedia.org/wiki/SHA-1#Example_hashes
        // input  "The quick brown fox jumps over the lazy dog"
        // result "2fd4e1c67a2d28fced849ee1bb76e7391b93eb12"
        var sha1 = Sha1.encode("It very very long string. It very very long string. It very very long string. It very very long string".toUtf8Array());
        var sha1Hex = Convert.byteArrayToHexString(sha1);
        logger.debug(sha1Hex);
        return sha1Hex.equals("AACAAA9BC52E4D128A432EA65F9C6C26045C326A");
    }
}