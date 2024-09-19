using Toybox.WatchUi as Ui;
using Toybox.System as Sys;

class OtpMenuDelegate extends Ui.MenuInputDelegate {

    var dataProvider;

    function initialize(dataProvider) {
        Ui.MenuInputDelegate.initialize();
        self.dataProvider = dataProvider;
    }

    function onMenuItem(item) {
        dataProvider.setCurrentAccountIdx(item);
    }
}
