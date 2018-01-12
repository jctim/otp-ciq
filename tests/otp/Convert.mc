module Convert {

    function byteArrayToHexString(bytes) {
        var str = "";
        for (var i = 0; i < bytes.size(); i++) {
            str += bytes[i].format("%02X");
        }
        return str;
    }
}