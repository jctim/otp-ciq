using Toybox.WatchUi as Ui;
using Toybox.System as Sys;
import Toybox.Lang;

class OtpWidgetDelegate extends Ui.BehaviorDelegate {

    var mainView;
    var dataProvider;
    var menuDelegate;

    function initialize(mainView, dataProvider) {
        Ui.BehaviorDelegate.initialize();
        self.mainView = mainView;
        self.dataProvider = dataProvider;
        self.menuDelegate = new OtpMenuDelegate(dataProvider);
    }

    function onKey(key) {
        if (key.getKey() == Ui.KEY_ENTER) {
            toNextOtpUi();
            return true;
        }
        return false;
    }

    function onTap(evt) {
        if (evt.getType() == Ui.CLICK_TYPE_TAP) {
            toNextOtpUi();
            return true;
        }
        return false;
    }

    function onMenu() {
        var enabledAccounts = dataProvider.getEnabledAccounts() as Array<Account>;
        if (enabledAccounts.size() == 0) {
            return false;
        }

        var menuView = new Ui.Menu();
        for (var i = 0; i < enabledAccounts.size(); i++) {
            menuView.addItem(enabledAccounts[i].name, i as Symbol);
        }
        Ui.pushView(menuView, menuDelegate, Ui.SLIDE_UP);
        return true;
    }

    hidden function toNextOtpUi() {
        if (dataProvider.nextOtp()) {
            Ui.switchToView(mainView, self, Ui.SLIDE_LEFT);
        }
    }

}
