using Toybox.WatchUi as Ui;
using Toybox.Application as App;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;

class TimerCircleView extends Ui.Drawable {

    function initialize(params) {
        Drawable.initialize(params);
    }

    function draw(dc) {
        var cr = getCenterAndRadius(dc);
        var x = cr[0];
        var y = cr[1];
        var maxR = cr[2];
        var timeColor = AppData.readProperty(Constants.TIME_CIRCLE_COLOR_PROP);

        var time = System.getClockTime();
        if (time.sec % Constants.TIME_STEP_SEC > Constants.RED_ZONE_SEC) {
            dc.setColor(Gfx.COLOR_RED, Gfx.COLOR_TRANSPARENT);
        } else {
            dc.setColor(timeColor, Gfx.COLOR_TRANSPARENT);
        }

        // draw borders
        for (var i = 0; i <= 2; i++) {
            dc.drawCircle(x, y, maxR - i);
        }
        // for (var i = 6; i <= 8; i++) {
        //     dc.drawCircle(x, y, maxR - i);
        // }

        // draw time filler
        if (time.sec % Constants.TIME_STEP_SEC == 0) {
            return;
        }
        var angel = time.sec * Constants.ANGEL_MULTIPLIER;
        for (var i = 1; i <= 6; i++) {
            dc.drawArc(x, y, maxR - i, Gfx.ARC_CLOCKWISE, Constants.START_ANGEL, Constants.START_ANGEL - angel);
        }
    }

    function getCenterAndRadius(dc) {
        return [dc.getWidth() / 2, dc.getHeight() / 2, dc.getWidth() / 2];
    }

}