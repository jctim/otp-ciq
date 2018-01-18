using Toybox.Application as App;
using Toybox.System as Sys;
using Toybox.WatchUi as Ui;

class OtpApp extends App.AppBase {

    var dataProvider;
    var view;
    var delegate;

    function initialize() {
        AppBase.initialize();
        self.dataProvider = new OtpDataProvider();
    }

    // onStart() is called on application start up
    function onStart(state) {
    }

    // onStop() is called when your application is exiting
    function onStop(state) {
    }

    // Return the initial view of your application here
    function getInitialView() {
        view = new OtpWidgetView(dataProvider);
        delegate = new OtpWidgetDelegate(view, dataProvider);
        return [ view, delegate ];
    }

    // New app settings have been received so trigger a UI update
    function onSettingsChanged() {
        self.dataProvider.reloadData(true);
        // AppBase.onSettingsChanged();
        // Ui.requestUpdate();
        // view.reloadCurrentOtp();
        Ui.switchToView(view, delegate, Ui.SLIDE_LEFT);
    }

}