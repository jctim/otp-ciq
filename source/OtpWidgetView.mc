using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.Application as App;
import Toybox.Lang;

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
        AppTimers.startOtpTimer(method(:otpTimerCallback));
    }

    function uiTimerCallback() {
        Ui.requestUpdate();
    }

    function otpTimerCallback() {
        var time = System.getClockTime();
        var currentTokenLifetime = App.getApp().getCurrentTokenLifetime();
        if (time.sec % (currentTokenLifetime) == 0) {
            reloadCurrentOtp();
        }
    }

    function reloadCurrentOtp() {
        Sys.println("started new otp calculation at " + AppTimers.currentTime());
        currentOtp = dataProvider.getCurrentOtp();
        if (currentOtp != null) {
            App.getApp().setCurrentTokenLifetime(currentOtp.lifetime);
        } else {
            App.getApp().setCurrentTokenLifetime(Constants.DEFAULT_TOKEN_LIFETIME);
        }
        Sys.println("finised new otp calculation at " + AppTimers.currentTime());
    }

    // Update the view
    function onUpdate(dc) {
        // Sys.println("on update");

        // Update the view
        var fgColor = AppData.readProperty(Constants.FG_COLOR_PROP);

        if (currentOtp != null) {
            var viewName = View.findDrawableById("NameLabel") as Ui.Text;
            viewName.setColor(fgColor);
            viewName.setText(currentOtp.name);

            var viewCode = View.findDrawableById("CodeLabel") as Ui.Text;
            viewCode.setColor(fgColor);
            viewCode.setText(currentOtp.token);
        } else {
            var viewName = View.findDrawableById("NameLabel") as Ui.Text;
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
        AppTimers.stopOtpTimer();
        AppTimers.stopUiTimer();
    }

    // The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() {
    }

    // Terminate any active timers and prepare for slow updates.
    function onEnterSleep() {
    }

}
