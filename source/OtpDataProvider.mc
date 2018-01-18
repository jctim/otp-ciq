using Toybox.Application as App;
using Toybox.System as Sys;
using Toybox.StringUtil as StringUtil;

class Account {
    var name;
    var secret;

    function initialize(name, secret) {
        self.name = name;
        self.secret = secret;
    }

    function toString() {
        return "account[" + name + ":" + secret + "]";
    }
}

class OtpCode {
    var name;
    var code;

    function initialize(name, code) {
        self.name = name;
        self.code = code;
    }

    function toString() {
        return "otp[" + name + ":" + code + "]";
    }
}

class OtpDataProvider {

    hidden var enabledAccounts = [];
    hidden var currentAccountIdx = -1;
    hidden var maxAccountIdx = -1;

    function initialize() {
        reloadData(false);
    }

    function reloadData(resetCurrentAccountIdx) {
        Sys.println("reload data. Need to reset currentAccountIdx = " + resetCurrentAccountIdx + "; " +
                    "currentAccountIdx in storage = " + AppData.readStorageValue(Constants.CURRENT_ACC_IDX_KEY));

        // clear current data
        enabledAccounts = [];
        currentAccountIdx = -1;
        maxAccountIdx = -1;

        for (var i = 1; i <= Constants.MAX_ACCOUNTS; i++) {
            var accEnabledProp = "Account" + i + "Enabled";
            var accNameProp    = "Account" + i + "Name";
            var accSecretProp  = "Account" + i + "Secret";
            var accSecretKey   = "Account" + i + "SecretKey";

            var enabled = AppData.readProperty(accEnabledProp);
            if (enabled) {
                var name = AppData.readProperty(accNameProp);
                if (!isEmptyString(name)) {
                    var secret = tryRetrieveSecretFromPropsIfUpdated(accSecretProp, accSecretKey);
                    if (!isEmptyString(secret)) {
                        enabledAccounts.add(new Account(name, secret));
                    }
                }
            }
        }
        if (enabledAccounts.size() != 0) {
            // if resetCurrentAccountIdx == true - it was called from App.onSettingsChanged(). Need to reset it to the first token
            // if resetCurrentAccountIdx == false - it was called from constructor. Need to obtain it from Storage (if exists)
            if (resetCurrentAccountIdx) {
                currentAccountIdx = 0;
            } else {
                currentAccountIdx = AppData.readStorageValue(Constants.CURRENT_ACC_IDX_KEY);
                if (currentAccountIdx == null) {
                    currentAccountIdx = 0;
                }
            }
            maxAccountIdx = enabledAccounts.size() - 1;
        }

        AppData.saveStorageValue(Constants.CURRENT_ACC_IDX_KEY, currentAccountIdx);
        Sys.println("enabledAccounts: " + enabledAccounts);
        Sys.println("currentAccountIdx: " + currentAccountIdx);
        Sys.println("maxAccountIdx: " + maxAccountIdx);
    }

    hidden function tryRetrieveSecretFromPropsIfUpdated(secretPropName, secretStorageKey) {
        var secret = AppData.readProperty(secretPropName);
        if (isEmptyString(secret)) {
            // assume the secret was not changed, and it's should be exist in app storage already
            Sys.println("secret " + secretPropName +  " is empty in properties, will read it from storage...");
            return AppData.readStorageValue(secretStorageKey);
        } else {
            // assume the secret was changed by user, so take it and override it in app storage
            // after that the property should be cleared to hide it from reading by Garmin Connect app next time
            Sys.println("secret " + secretPropName +  " is not empty in properties, will update storage with it and clean the property...");
            secret = normalizeSecret(secret);
            AppData.saveStorageValue(secretStorageKey, secret);
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
        if (currentAccountIdx < 0 || enabledAccounts.size() == 0) {
            return null;
        }

        var acc = enabledAccounts[currentAccountIdx];
        return new OtpCode(acc.name, Otp.generateTotpSha1(acc.secret));
    }

    function nextOtp() {
        if (currentAccountIdx < 0 || maxAccountIdx == 0) {
            return false;
        }

        currentAccountIdx++;
        if (currentAccountIdx > maxAccountIdx) {
            currentAccountIdx = 0;
        }
        AppData.saveStorageValue(Constants.CURRENT_ACC_IDX_KEY, currentAccountIdx);
        Sys.println("currentAccountIdx: " + currentAccountIdx);
        return true;
    }

    function prevOtp() {
        if (currentAccountIdx < 0 || maxAccountIdx == 0) {
            return false;
        }

        currentAccountIdx--;
        if (currentAccountIdx < 0) {
            currentAccountIdx = maxAccountIdx;
        }
        AppData.saveStorageValue(Constants.CURRENT_ACC_IDX_KEY, currentAccountIdx);
        Sys.println("currentAccountIdx: " + currentAccountIdx);
        return true;
    }
}