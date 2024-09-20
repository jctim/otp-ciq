using Toybox.Application as App;
using Toybox.System as Sys;
using Toybox.StringUtil as StringUtil;
import Toybox.Lang;

class Account {
    var enabled;
    var name;
    var secret;

    function initialize(enabled, name, secret) {
        self.enabled = enabled;
        self.name = name;
        self.secret = secret;
    }

    function toString() {
        return "account[n=" + name + ":e=" + enabled + "]";
    }
}

class AccountToken {
    var name;
    var token;

    function initialize(name, token) {
        self.name = name;
        self.token = token;
    }

    function toString() {
        return "token[n=" + name + ":t=" + token + "]";
    }
}

class OtpDataProvider {

    hidden var enabledAccounts as Array<Account> = [];
    hidden var currentAccountIdx as Number = -1;
    hidden var maxAccountIdx as Number = -1;

    function initialize() {
        reloadData();
    }

    function reloadData() {
        Sys.println("reload data");

        // clear current data
        enabledAccounts = [];
        currentAccountIdx = -1;
        maxAccountIdx = -1;

        var accountsFromProperties = readAccountsFromProperties();
        // Migration needed to move all secrets from storage to app settings.
        // App Settings allow to define password fields in new SDKs, it helped to get rid of the ugly previous solution
        var secretsMigrated = migrateSecretsToProperties(accountsFromProperties);

        // Sys.println("account secrets from storage: " + accountsSecretsFromStorgate);
        for (var i = 0; i < Constants.MAX_ACCOUNTS; i++) {
            var acc = accountsFromProperties[i];
            if (acc.enabled) {
                enabledAccounts.add(acc);
            }
        }

        if (enabledAccounts.size() != 0) {
            maxAccountIdx = enabledAccounts.size() - 1;
            if (secretsMigrated) {
                currentAccountIdx = 0; // if secretsMigrated - reset to 0. It can happen once
            } else {
                currentAccountIdx = AppData.readStorageValue(Constants.CURRENT_ACC_IDX_KEY);
                if (currentAccountIdx == null || currentAccountIdx  < 0 || currentAccountIdx > maxAccountIdx) {
                    currentAccountIdx = 0;
                }
            }
        }

        AppData.saveStorageValue(Constants.CURRENT_ACC_IDX_KEY, currentAccountIdx);
        Sys.println("enabledAccounts: " + enabledAccounts);
        Sys.println("currentAccountIdx: " + currentAccountIdx);
        Sys.println("maxAccountIdx: " + maxAccountIdx);
    }

    hidden function readAccountsFromProperties() as Array<Account> {
        var accounts = [];
        for (var accIdx = 1; accIdx <= Constants.MAX_ACCOUNTS; accIdx++) {
            var accEnabledProp = "Account" + accIdx + "Enabled";
            var accNameProp    = "Account" + accIdx + "Name";
            var accSecretProp  = "Account" + accIdx + "Secret";

            Sys.println("accEnabledProp: " + accEnabledProp);
            Sys.println("accNameProp: " + accNameProp);
            Sys.println("accSecretProp: " + accSecretProp);

            var accEnabled = AppData.readProperty(accEnabledProp);
            var accName    = AppData.readProperty(accNameProp);
            var accSecret  = normalizeSecret(AppData.readProperty(accSecretProp));

            Sys.println("accEnabled: " + accEnabled);
            Sys.println("accName: " + accName);
            Sys.println("accSecret: " + accSecret);

            accounts.add(new Account(accEnabled, accName, accSecret));
        }
        Sys.println("accounts from properties: " + accounts);
        return accounts;
    }

    hidden function migrateSecretsToProperties(accountsFromProperties as Array<Account>) {
        var secretsMigrated = false;
        for (var i = 0; i < Constants.MAX_ACCOUNTS; i++) {
            var acc = accountsFromProperties[i];
            var accIdx = i + 1;
            var accSecretStorageKey = "Account" + accIdx + "SecretKey";
            var accSecretPropsKey = "Account" + accIdx + "Secret";

            Sys.println("account " + accIdx); 
            var accSecretToMigrate = AppData.readStorageValue(accSecretStorageKey);
            Sys.println("secret to migrate: " +  accSecretToMigrate);

            if (!isEmptyString(accSecretToMigrate)) {
                // if secret exists in storate but no in properties - copy it to the propertie
                // otherwise keep existing secret in properties
                if (isEmptyString(acc.secret)) {
                    Sys.println("secret of acc " + i + " exsists in storage, will copy it to properties and clean the storage...");
                    acc.secret = accSecretToMigrate;
                    AppData.saveProperty(accSecretPropsKey, acc.secret);

                    secretsMigrated = true;
                }
                // delete secret from storage to not let migration start next time
                AppData.deleteStorageValue(accSecretStorageKey);
            }

        }
        Sys.println("secrets migrated. done = " + secretsMigrated);
        return secretsMigrated;
    }

    hidden function isEmptyString(str) {
        return str == null || (str instanceof Toybox.Lang.String && str.length() == 0);
    }

    //! delete all spaces and upper case all letters
    //!
    //! @param [Toybox::Lang::String] str must not be null
    //! @return [Toybox::Lang::String] normalized string
    hidden function normalizeSecret(str as String) as String {
        System.println("normalize " + str);
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
        System.println("normalized " + outStr);
        return outStr;

    }

    function getCurrentOtp() {
        if (currentAccountIdx < 0 || enabledAccounts.size() == 0) {
            return null;
        }

        var acc = enabledAccounts[currentAccountIdx];
        return new AccountToken(acc.name, Otp.generateTotpSha1(acc.secret));
    }

    function getEnabledAccounts() {
        return enabledAccounts;
    }

    function setCurrentAccountIdx(newAccIdx) {
        currentAccountIdx = newAccIdx;
        if (currentAccountIdx > maxAccountIdx) {
            currentAccountIdx = 0;
        }
        AppData.saveStorageValue(Constants.CURRENT_ACC_IDX_KEY, currentAccountIdx);
        Sys.println("currentAccountIdx: " + currentAccountIdx);
        return true;
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