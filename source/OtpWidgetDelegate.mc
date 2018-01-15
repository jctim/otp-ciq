using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.Application as App;

class OtpWidgetDelegate extends Ui.InputDelegate {

    var view;
    var dataProvider;

    function initialize(view, dataProvider) {
        Ui.InputDelegate.initialize();
        self.view = view;
        self.dataProvider = dataProvider;
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

    function toNextOtpUi() {
        if (dataProvider.nextOtp()) {
            // Ui.requestUpdate();
            // view.requestUpdate();
            // view.reloadCurrentOtp();
            Ui.switchToView(view, self, Ui.SLIDE_LEFT);
        }
    }

}