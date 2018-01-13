//! SHA1 implementation
//! https://tools.ietf.org/html/rfc3174
//! 
//! Based on java implementation http://www.intertwingly.net/stories/2004/07/18/SHA1.java
module Sha1 {

    const H = [0x67452301, 0xEFCDAB89, 0x98BADCFE, 0x10325476, 0xC3D2E1F0];
    const K = [0x5A827999, 0x6ED9EBA1, 0x8F1BBCDC, 0xCA62C1D6];

    //! Encode given byte array input to SHA1 hash as a byte array
    //! @param [Toybox::Lang::Array] input The byte array to be encrypted
    //! @return [Toybox::Lang::Array] computed SHA1 hash as byte array
    function encode(input) {
        var inSize = input.size();
        var bloks = new [(((inSize + 8) >> 6) + 1) * 16];
        var bloksSize = bloks.size();

        for (var i = 0; i < bloksSize; i++) {
            bloks[i] = 0;
        }

        for(var i = 0; i < inSize; i++) {
            bloks[i >> 2] |= input[i] << (24 - (i % 4) * 8);
        }
        bloks[inSize >> 2] |= 0x80 << (24 - (inSize % 4) * 8);
        bloks[bloksSize - 1] = inSize * 8;

        var w = new [80];

        var a = H[0];
        var b = H[1];
        var c = H[2];
        var d = H[3];
        var e = H[4];

        for(var i = 0; i < bloksSize; i += 16) {
            var ta = a;
            var tb = b;
            var tc = c;
            var td = d;
            var te = e;
            
            for(var j = 0; j < 80; j++) {
                w[j] = (j < 16) ? bloks[i + j] : (rotate(w[j - 3] ^ w[j - 8] ^ w[j - 14] ^ w[j - 16], 1));

                var temp = rotate(a, 5) + e + w[j] + (
                   (j < 20) ? K[0] + ((b & c) | ((~b) & d)) :
                   (j < 40) ? K[1] + (b ^ c ^ d) :
                   (j < 60) ? K[2] + ((b & c) | (b & d) | (c & d)) :
                              K[3] + (b ^ c ^ d)
                );
                e = d;
                d = c;
                c = rotate(b, 30);
                b = a;
                a = temp;
            }

            a += ta;
            b += tb;
            c += tc;
            d += td;
            e += te;
        }
        var words = [a, b, c, d, e];

        var res = new [20];
        for (var i = 0; i < 20; i++) {
            res[i] = words[i>>2] >> (8 * (3 - (i & 0x03))) & 0xFF ;
        }

        return res;
    }

    function rotate(num, cnt) {
        var mask = (1 << cnt) - 1;
        var leftPart = (num << cnt) & (~mask);
        var rightPart = (num >> (32 - cnt)) & (mask);
        return leftPart | rightPart;
    }
}