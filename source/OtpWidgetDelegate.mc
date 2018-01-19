using Toybox.WatchUi as Ui;
using Toybox.System as Sys;

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
        }
    }

    function onTap(evt) {
        if (evt.getType() == Ui.CLICK_TYPE_TAP) {
            toNextOtpUi();
        }
    }

    function onMenu() {
        var enabledAccounts = dataProvider.getEnabledAccounts();
        if (enabledAccounts.size() == 0) {
            return;
        }

        var menuView = new Ui.Menu();
        for (var i = 0; i < enabledAccounts.size(); i++) {
            menuView.addItem(enabledAccounts[i].name, i);
        }
        Ui.pushView(menuView, menuDelegate, Ui.SLIDE_UP);
    }

    hidden function toNextOtpUi() {
        if (dataProvider.nextOtp()) {
            Ui.switchToView(mainView, self, Ui.SLIDE_LEFT);
        }
    }

}