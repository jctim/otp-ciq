using Toybox.Application as App;
using Toybox.System as Sys;
using Toybox.StringUtil as StringUtil;

class OtpToken {
    var name;
    var token;

    function initialize(name, token) {
        self.name = name;
        self.token = token;
    }

    function toString() {
        return "token[" + name + ":" + token + "]";
    }
}

class OtpPassword {
    var name;
    var otp;

    function initialize(name, otp) {
        self.name = name;
        self.otp = otp;
    }

    function toString() {
        return "password[" + name + ":" + otp + "]";
    }
}

class OtpDataProvider {

    hidden var enabledTokens = [];
    hidden var currentTokenIdx = -1;
    hidden var maxTokenIdx = -1;

    function initialize() {
        reloadData();
    }

    function reloadData() {
        Sys.println("reload data");

        // clear current data
        enabledTokens = [];
        currentTokenIdx = -1;
        maxTokenIdx = -1;

        for (var i = 1; i <= Constants.MAX_TOKENS; i++) {
            var codeEnabledProp = "Code" + i + "Enabled";
            var codeNameProp    = "Code" + i + "Name";
            var codeSecretProp  = "Code" + i + "Secret";
            var codeTokenKey    = "Code" + i + "Token";

            var enabled = AppData.readProperty(codeEnabledProp);
            if (enabled) {
                var name = AppData.readProperty(codeNameProp);
                if (!isEmptyString(name)) {
                    var token = tryRetrieveTokenFromSecretPropIfUpdated(codeSecretProp, codeTokenKey);
                    if (!isEmptyString(token)) {
                        enabledTokens.add(new OtpToken(name, token));
                    }
                }
            }
        }
        if (enabledTokens.size() != 0) {
            currentTokenIdx = 0;
            maxTokenIdx = enabledTokens.size() - 1;
        }

        Sys.println("enabledTokensByIdx: " + enabledTokens);
        Sys.println("currentTokenIdx: " + currentTokenIdx);
        Sys.println("maxTokenIdx: " + maxTokenIdx);
    }

    hidden function tryRetrieveTokenFromSecretPropIfUpdated(secretPropName, tokenStorageKey) {
        Sys.println("try to retrieve token from " + secretPropName);
        var secret = AppData.readProperty(secretPropName);
        if (isEmptyString(secret)) {
            // assume the secret was not changed, and it's should be exist in app storage already
            Sys.println("secret is empty, read from storage by " + tokenStorageKey);
            return AppData.readStorageValue(tokenStorageKey);
        } else {
            // assume the secret was changed by user, so take it and override it in app storage
            // after that the property should be cleared to hide it from reading by Garmin Connect app next time
            Sys.println("secret is not empty, will update storage with it and clean property...");
            secret = normalizeSecret(secret);
            AppData.saveStorageValue(tokenStorageKey, secret);
            AppData.saveProperty(secretPropName, "");
            return secret;
        }
    }

    hidden function isEmptyString(str) {
        return str == null || str.length() == 0;
    }

    //! delete all spaces and upper case all letters
    //!
    //! @param [Toybox::Lang::String] str must not be null
    //! @return [Toybox::Lang::String] normalized string
    hidden function normalizeSecret(str) {
        var chars = str.toUpper().toCharArray();
        chars.removeAll(' ');
        // Yeah. Why not to use StringUtil::charArrayToString()?
        // Becasue there is a strage bug here probably in SDK:
        // StringUtil.charArrayToString() returns non empty String
        // but method length() of that string returns 0 (!!!)
        var outStr = "";
        for (var i = 0; i < chars.size(); i++) {
            outStr += chars[i];
        }
        return outStr;

    }

    function getCurrentOtp() {
        if (currentTokenIdx < 0 || enabledTokens.size() == 0) {
            return null;
        }

        var ti = enabledTokens[currentTokenIdx];
        return new OtpPassword(ti.name, Otp.generateTotpSha1(ti.token));
    }

    function nextOtp() {
        if (currentTokenIdx < 0 || maxTokenIdx == 0) {
            return false;
        }

        currentTokenIdx++;
        if (currentTokenIdx > maxTokenIdx) {
            currentTokenIdx = 0;
        }
        Sys.println("currentTokenIdx: " + currentTokenIdx);
        return true;
    }

    function prevOtp() {
        if (currentTokenIdx < 0 || maxTokenIdx == 0) {
            return false;
        }

        currentTokenIdx--;
        if (currentTokenIdx < 0) {
            currentTokenIdx = maxTokenIdx;
        }
        Sys.println("currentTokenIdx: " + currentTokenIdx);
        return true;
    }
}