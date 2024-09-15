using Toybox.Application as App;
using Toybox.System as Sys;
using Toybox.StringUtil as StringUtil;
import Toybox.Lang;

class Account {
    var enabled;
    var name;
    var secret;
    var digits;
    var lifetime;

    function initialize(enabled, name, secret, digits, lifetime) {
        self.enabled = enabled;
        self.name = name;
        self.secret = secret;
        self.digits = digits;
        self.lifetime = lifetime;
    }

    function toString() {
        return "account[n=" + name + ":e=" + enabled + ":d=" + digits + ":l=" + lifetime + "]";
    }
}

class AccountToken {
    var name;
    var token;
    var lifetime;

    function initialize(name, token, lifetime) {
        self.name = name;
        self.token = token;
        self.lifetime = lifetime;
    }

    function toString() {
        return "token[n=" + name + ":t=" + token + ":l=" + lifetime + "]";
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
        var accountsSecretsFromStorgate = readAccountSecretsFromStorage();
        
        var settingsUpdatedByUser = mergeAccountsAndSecrets(accountsFromProperties, accountsSecretsFromStorgate);

        // Sys.println("account secrets from storage: " + accountsSecretsFromStorgate);
        for (var i = 0; i < Constants.MAX_ACCOUNTS; i++) {
            var acc = accountsFromProperties[i];
            if (acc.enabled) {
                enabledAccounts.add(new Account(true, acc.name, accountsSecretsFromStorgate[i], acc.digits, acc.lifetime));
                sortAccounts(enabledAccounts);
            }
        }

        if (enabledAccounts.size() != 0) {
            maxAccountIdx = enabledAccounts.size() - 1;
            // if settingsUpdatedByUser == true - it was called from App.onSettingsChanged(). Need to reset it to the first token
            // if settingsUpdatedByUser == false - it was called from constructor. Need to obtain it from Storage (if exists)
            if (settingsUpdatedByUser) {
                currentAccountIdx = 0;
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
            var accEnabled  = AppData.readProperty("Account" + accIdx + "Enabled");
            var accName     = AppData.readProperty("Account" + accIdx + "Name");
            var accSecret   = AppData.readProperty("Account" + accIdx + "Secret");
            var accDigits   = AppData.readProperty("Account" + accIdx + "TokenDigits");
            var accLifetime = AppData.readProperty("Account" + accIdx + "TokenLifetime");

            accounts.add(new Account(accEnabled, accName, accSecret, accDigits, accLifetime));
        }
        Sys.println("accounts from properties: " + accounts);
        return accounts;
    }

    hidden function readAccountSecretsFromStorage() {
        var accountSecrets = [];
        for (var accIdx = 1; accIdx <= Constants.MAX_ACCOUNTS; accIdx++) {
            var accSecret  = AppData.readStorageValue("Account" + accIdx + "SecretKey");
            accSecret  = accSecret != null ? accSecret : "";

            accountSecrets.add(accSecret);
        }
        // Sys.println("account secrets from storage: " + accountSecrets);
        return accountSecrets;
    }

    hidden function mergeAccountsAndSecrets(accountsFromProperties as Array<Account>, accountSecretsFromStorgate as String) {
        var secretsUpdatedByUser = false;
        for (var i = 0; i < Constants.MAX_ACCOUNTS; i++) {
            var acc = accountsFromProperties[i];
            var accSecret = accountSecretsFromStorgate[i];
            var accIdx = i + 1;

            // User didn't enter secret property in settings and it didn't exists in storage - it was set yet.
            // just don't enable this account at all
            if (acc.enabled && Strings.isEmpty(acc.secret) && Strings.isEmpty(accSecret) ) {
                acc.enabled = false;
                AppData.saveProperty("Account" + accIdx + "Enabled", acc.enabled);     // switch off this account
            }

            // User updated secret property in settings - copy it to storage and clear in properties
            if (!Strings.isEmpty(acc.secret)) {
                Sys.println("secret of acc " + i + " is not empty in properties, will update storage with it and clean the property...");
                accSecret = normalizeSecret(acc.secret);
                acc.secret = "";
                AppData.saveStorageValue("Account" + accIdx + "SecretKey", accSecret); // to update secret in app sotrage
                AppData.saveProperty("Account" + accIdx + "Secret", acc.secret);       // to clear secret in app properties

                accountSecretsFromStorgate[i] = accSecret;                             // update array
                secretsUpdatedByUser = true;
            }

        }
        Sys.println("accounts merged. settingsUpdatedByUser = " + secretsUpdatedByUser);
        return secretsUpdatedByUser;
    }

    hidden function sortAccounts(accounts) {
        var tokensOrder = AppData.readProperty("TokensOrder") as Number;
        switch (tokensOrder) {
            case 0: // order by index, already sorted
                break;
            case 1: // order by name, simple insertion sort for not more then 20 items
                var temp;
                for (var i = 1; i < accounts.size(); i++) {
                    for (var j = i; j > 0; j--) {
                        if (Strings.compare(accounts[j].name, accounts[j-1].name) < 0) {
                            temp = accounts[j];
                            accounts[j] = accounts[j-1];
                            accounts[j-1] = temp;
                        }
                    }
                }
                 break;
        }
    }

    //! delete all spaces and upper case all letters
    //!
    //! @param [Toybox::Lang::String] str must not be null
    //! @return [Toybox::Lang::String] normalized string
    hidden function normalizeSecret(str) {
        var chars = str.toString().toUpper().toCharArray();
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

    function formatToken(token) {
        var tokenLength = token.length();
        var formatIndex = AppData.readProperty("TokenFormatFor" + tokenLength);
        var formatPattern = Constants.OTP_FORMAT.get(tokenLength).get(formatIndex);
        
        Sys.println("Formatting token " + token + " with pattern " + formatPattern);
        return Lang.format(formatPattern, token.toCharArray());
    }

    function getCurrentOtp() {
        if (currentAccountIdx < 0 || enabledAccounts.size() == 0) {
            return null;
        }

        var acc = enabledAccounts[currentAccountIdx];
        var otpToken = Otp.generateTotpSha1(acc.secret, acc.digits, acc.lifetime);
        return new AccountToken(acc.name, formatToken(otpToken), acc.lifetime);
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