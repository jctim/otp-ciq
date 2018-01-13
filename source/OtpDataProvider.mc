using Toybox.Application as App;
using Toybox.System as Sys;

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

    hidden const MAX_TOKENS = 10;

    hidden var enabledTokens = new [0];
    hidden var currentTokenIdx = -1;
    hidden var maxTokenIdx = -1;

    function initialize() {
        reloadData();
    }

    function reloadData() {
        Sys.println("reload data");

        // clear current data
        enabledTokens = new [0];
        currentTokenIdx = -1;
        maxTokenIdx = -1;

        for (var i = 1; i <= MAX_TOKENS; i++) {
            // TODO save whole dictionary to add storage and clear every reload?

            var codeEnabledProp = "Code" + i + "Enabled";
            var codeNameProp    = "Code" + i + "Name";
            var codeSecretProp  = "Code" + i + "Secret";
            var codeTokenKey    = "Code" + i + "Token"; // TODO add prefix AppName.Code1Token etc.

            var enabled = AppData.readProperty(codeEnabledProp);
            if (enabled) {
                var name = AppData.readProperty(codeNameProp);
                var token = tryRetrieveTokenFromSecretPropIfUpdated(codeSecretProp, codeTokenKey);
                if (token != null && token.length() != 0) {
                    enabledTokens.add(new OtpToken(name, token));
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

    function tryRetrieveTokenFromSecretPropIfUpdated(secretPropName, tokenStorageKey) {
        Sys.println("try to retrieve token from " + secretPropName);
        var secret = AppData.readProperty(secretPropName);
        if (secret == null || secret.length() == 0) {
            // assume the secret was not changed, and it's should be exist in app storage already
            Sys.println("secret is empty, read from storage by " + tokenStorageKey);
            return AppData.readStorageValue(tokenStorageKey);
        } else {
            // assume the secret was changed by user, so take it and override it in app storage
            // after that the property should be cleared to hide it from reading by Garmin Connect app next time
            Sys.println("secret is not empty, will update storage with it and clean property...");
            AppData.saveStorageValue(tokenStorageKey, secret);
            AppData.saveProperty(secretPropName, "");
            return secret;
        }
    }

    function getCurrentOtp() {
        if (currentTokenIdx < 0) {
            return null;
        }
        var ti = enabledTokens[currentTokenIdx];
        return new OtpPassword(ti.name, Otp.generateTotpSha1(ti.token));
    }

    function nextOtp() {
        currentTokenIdx++;
        if (currentTokenIdx > maxTokenIdx) {
            currentTokenIdx = 0;
        }
        Sys.println("currentTokenIdx: " + currentTokenIdx);
    }

    function prevOtp() {
        currentTokenIdx--;
        if (currentTokenIdx < 0) {
            currentTokenIdx = maxTokenIdx;
        }
        Sys.println("currentTokenIdx: " + currentTokenIdx);
    }
}