module SringsTest {

    (:test)
    function testIsEmpty(logger) {
        return Strings.isEmpty(null)
            && Strings.isEmpty("");
    }

    (:test)
    function testIsNotEmpty(logger) {
        return !Strings.isEmpty("abc")
            && !Strings.isEmpty(123);
    }

    (:test)
    function testCompareEq(logger) {
        return Strings.compare("123", "123") == 0
            && Strings.compare("abc", "abc") == 0;
    }

    (:test)
    function testCompareGt(logger) {
        return Strings.compare("abcd", "abc") == 1
            && Strings.compare("abcd", "abcc") == 1
            && Strings.compare("abcd", "aacd") == 1
            && Strings.compare("abcd", "abc1") == 1;
    }

    (:test)
    function testCompareLt(logger) {
        return Strings.compare("abc", "abcd") == -1
            && Strings.compare("abcc", "abcd") == -1
            && Strings.compare("aacd", "abcd") == -1
            && Strings.compare("abc1", "abcd") == -1;
    }
}