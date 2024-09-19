import Toybox.Lang;

module Strings {

    function isEmpty(str) {
        return str == null || (str instanceof Toybox.Lang.String && str.length() == 0);
    }

    //! compare two strings
    //!
    //! @param [Toybox::Lang::String] str1 must not be null
    //! @param [Toybox::Lang::String] str2 must not be null
    //! @return [Toybox::Lang::Number] comparison result: -1 if str1 < str2,
    //!                                                    0 if str1 == str2
    //!                                                    1 if str1 > str2
    function compare(str1 as String, str2 as String) as Number {
        var arr1 = str1.toCharArray();
        var arr2 = str2.toCharArray();
        var idx1 = 0;
        var idx2 = 0;
        while (idx1 < arr1.size() && idx2 < arr2.size()) {
            if (arr1[idx1] > arr2[idx2]) {
                return 1;
            } else if (arr1[idx1] < arr2[idx2]) {
                return -1;
            } else {
               idx1++;
               idx2++;
            }
        }
        if (arr1.size() > arr2.size()) {
            return 1;
        } else if (arr1.size() < arr2.size()) {
            return -1;
        } else {
            return 0;
        }
    }
}