using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.Application as App;

class OtpWidgetView extends Ui.View {

    var currentOtp = null;
    var dataProvider;

    function initialize(dataProvider) {
        View.initialize();
        self.dataProvider = dataProvider;
    }

    // Load your resources here
    function onLayout(dc) {
        setLayout(Rez.Layouts.MainLayout(dc));
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() {
        reloadCurrentOtp();
        AppTimers.startUiTimer(method(:uiTimerCallback));
    }

    function uiTimerCallback() {
        var time = System.getClockTime();
        if (time.sec % Constants.TIME_STEP_SEC == 0) {
            reloadCurrentOtp();
        }
        Ui.requestUpdate();
    }

    function reloadCurrentOtp() {
        currentOtp = dataProvider.getCurrentOtp();
    }

    // Update the view
    function onUpdate(dc) {
        // Sys.println("on update");

        // Update the view
        var fgColor = AppData.readProperty(Constants.FG_COLOR_PROP);

        if (currentOtp != null) {
            var viewName = View.findDrawableById("NameLabel");
            viewName.setColor(fgColor);
            viewName.setText(currentOtp.name);

            var viewCode = View.findDrawableById("CodeLabel");
            viewCode.setColor(fgColor);
            viewCode.setText(currentOtp.token);
        } else {
            var viewName = View.findDrawableById("NameLabel");
            viewName.setColor(fgColor);
            viewName.setFont(Gfx.FONT_XTINY);
            viewName.setText("No Accounts\nSet up in app settings");
        }

        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() {
        AppTimers.stopUiTimer();
    }

    // The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() {
    }

    // Terminate any active timers and prepare for slow updates.
    function onEnterSleep() {
    }

}
