module ConvertTest {

    (:test)
    function testByteArrayToHexString(logger) {
        var hexString = Convert.byteArrayToHexString([169, 153, 62, 54, 71, 6, 129, 106, 186, 62]);
        return hexString.equals("A9993E364706816ABA3E");
    }

    (:test)
    function testHexStringToByteArray(logger) {
        var byteArray = Convert.hexStringToByteArray("A9993E364706816ABA3E");
        return [169, 153, 62, 54, 71, 6, 129, 106, 186, 62].toString().equals(byteArray.toString());
    }

    (:test)
    function testbase32decode2HexSring(logger) {
        var hexString = Convert.base32decode2HexString("VK54ZXPO74");
        return hexString.equals("AABBCCDDEEFF");
    }
}