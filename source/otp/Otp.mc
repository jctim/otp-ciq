using Toybox.System as Sys;
using Toybox.Time as Time;

//! HOTP and TOTP implementation
//! https://tools.ietf.org/html/rfc6238
//!
//! HOTP(K,C) = Truncate(HMAC-SHA-1(K,C))
//!
//! Basically, we define TOTP as TOTP = HOTP(K, T), where T is an integer
//!       and represents the number of time steps between the initial counter
//!       time T0 and the current Unix time.
//! More specifically, T = (Current Unix time - T0) / X, where the
//!       default floor function is used in the computation.
module Otp {

    const DIGITS_POWER
        // 0  1   2    3     4      5       6        7         8
        = [1, 10, 100, 1000, 10000, 100000, 1000000, 10000000, 100000000];

    //! Generate TOTP code, with help of HMAC_SHA1
    //! @param [Toybox::Lang::String] key The HEX String of secret key
    //! @return [Toybox::Lang::String] generated TOTP code
    function generateTotpSha1(base32EncodedKey) {
        var keyHex = Convert.base32decode2HexString(base32EncodedKey);
        var message = Time.now().value() / Constants.TIME_STEP_SEC;
        return generateHotpSha1(keyHex, message, 6);
    }

    //! Generate HOTP code, where H (has function) is HMAC_SHA1
    //! @param [Toybox::Lang::String] keyHex The HEX String of secret key
    //! @param [Toybox::Lang::String] message The String message to generate OTP
    //! @param [Toybox::Lang::String] how many digits to generate in OTP (no more then 8)
    //! @return [Toybox::Lang::String] generated HOTP code
    function generateHotpSha1(keyHex, message, returnDigits) {
        if (returnDigits > 8) {
            returnDigits = 8;
        }

        // Using the counter
        // First 8 bytes are for the movingFactor
        // Compliant with base RFC 4226 (HOTP)
        var msgHex = message.format("%016X");

        // Get the HEX in a Byte[]
        var msgBytes = Convert.hexStringToByteArray(msgHex);
        var keyBytes = Convert.hexStringToByteArray(keyHex);

        var hash = Hmac.authenticateWithSha1(keyBytes, msgBytes);

        // put selected bytes into result int
        var offset = hash[hash.size() - 1] & 0xf;

        var binary =
            ((hash[offset] & 0x7f) << 24) |
            ((hash[offset + 1] & 0xff) << 16) |
            ((hash[offset + 2] & 0xff) << 8) |
            (hash[offset + 3] & 0xff);
        var otp = binary % DIGITS_POWER[returnDigits];

        return otp.format("%0" + returnDigits + "d");
    }
}