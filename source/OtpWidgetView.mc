using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.Lang as Lang;
using Toybox.Application as App;

class OtpWidgetView extends Ui.View {

    function initialize() {
        View.initialize();
    }

    // Load your resources here
    function onLayout(dc) {
        setLayout(Rez.Layouts.MainLayout(dc));
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() {
        AppTimers.startUiTimer(method(:uiTimerCallback));
    }

    function uiTimerCallback() {
        var time = System.getClockTime();
        if (time.sec % Constants.MAX_TIME_SEC == 0) {
            // TODO start generating new OTP
        }
        if (time.sec % Constants.MAX_TIME_SEC == 1) {
            reloadCurrentOtp();
        }
        Ui.requestUpdate();
    }

    // stub var and method
    var currentOtp = 123456;
    function reloadCurrentOtp() {
        currentOtp += 1;
    }

    // Update the view
    function onUpdate(dc) {
        // Sys.println("on update");

        // Update the view
        var fgColor = AppProps.readProperty(Constants.FG_COLOR_PROP);

        var viewName = View.findDrawableById("NameLabel");
        viewName.setColor(fgColor);
        viewName.setText("Google");
        var viewCode = View.findDrawableById("CodeLabel");
        viewCode.setColor(fgColor);
        viewCode.setText(currentOtp.format("%06d"));

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
