using Toybox.Lang as Lang;
using Toybox.Time as Time;

module OtpTest {

    (:test)
    function testTotpSha1(logger) {
        logger.debug("");

        // Seed for HMAC-SHA1 - 20 bytes
        var seed = "3132333435363738393031323334353637383930";
        var t0 = 0L;
        var x = 30L;
        var testTime = [59L, 1111111109L, 1111111111L];
        var expectedCodes = ["94287082", "07081804", "14050471"];
        var actualCodes = new [3];

        logger.debug("+---------------+-----------------------+------------------+--------+--------+");
        logger.debug("|  Time(sec)    |   Time (UTC format)   | Value of T(Hex)  |  TOTP  | Mode   |");
        logger.debug("+---------------+-----------------------+------------------+--------+--------+");
        for (var i = 0; i < testTime.size(); i++) {
            var theTime = testTime[i];
            var t = (theTime - t0) / x;

            var steps = t.format("%016X");

            var fmtTime = theTime.format("%11d");
            var utcTime = Time.Gregorian.info(new Time.Moment(theTime), Time.FORMAT_SHORT);
            var fmtUtcTime = Lang.format("$1$:$2$:$3$ $4$/$5$/$6$", [
                                             utcTime.hour.format("%02d"),
                                             utcTime.min.format("%02d"),
                                             utcTime.sec.format("%02d"),
                                             utcTime.day.format("%02d"),
                                             utcTime.month.format("%02d"),
                                             utcTime.year.format("%4d")
                                         ]);

            actualCodes[i] = Otp.generateHotpSha1(seed, t, 8);
            logger.debug("|  " + fmtTime + "  |  " + fmtUtcTime + "  | " + steps + " |" + actualCodes[i] + "| SHA1   |");
            logger.debug("+---------------+-----------------------+------------------+--------+--------+");
        }

        return actualCodes.toString().equals(expectedCodes.toString());
    }
}