using Toybox.Time as Time;
using Toybox.Timer as Timer;
using Toybox.System as Sys;

module AppTimers {

    var uiTimer = new Timer.Timer();
    var otpTimer = new Timer.Timer();

    function startUiTimer(callbackMethod) {
        var now = currentTime();
        uiTimer.start(callbackMethod, 200, true);
        Sys.println("UI Timer started at " + now);
    }

    function stopUiTimer() {
        var now = currentTime();
        uiTimer.stop();
        Sys.println("UI Timer stopped at " + now);
    }

    function startOtpTimer(callbackMethod) {
        var now = currentTime();
        otpTimer.start(callbackMethod, 1000, true);
        Sys.println("OTP Timer started at " + now);
    }

    function stopOtpTimer() {
        var now = currentTime();
        otpTimer.stop();
        Sys.println("OTP Timer stopped at " + now);
    }

    function currentTime() {
        return Time.now().value();
    }
}