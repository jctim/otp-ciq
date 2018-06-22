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
        var timeColor = AppData.readProperty(Constants.CIRCLE_TIMER_COLOR_PROP);
        var bgColor = AppData.readProperty(Constants.BG_COLOR_PROP);
        var useArrows = AppData.readProperty(Constants.CIRCLE_TIMER_ARROWS_PROP);

        var time   = System.getClockTime();

        if (time.sec % Constants.TIME_STEP_SEC > Constants.RED_ZONE_SEC || time.sec % Constants.TIME_STEP_SEC == 0) {
            timeColor = Gfx.COLOR_RED;
        }

        var angel = time.sec * Constants.ANGEL_MULTIPLIER;
        var r     = maxR - (Constants.ROUND_WIDTH / 2);

        // draw main time filler
        dc.setPenWidth(Constants.ROUND_WIDTH);
        dc.setColor(timeColor, Gfx.COLOR_TRANSPARENT);
        dc.drawArc(x, y, r, Gfx.ARC_CLOCKWISE,
                   Constants.START_ANGEL, Constants.START_ANGEL - angel);

        if (useArrows) {
            // draw arrows of time filler
            dc.setPenWidth(1);
            for (var i = 0; i < Constants.ROUND_WIDTH; i++) {
                var shift = i < Constants.ROUND_WIDTH / 2 ? i : Constants.ROUND_WIDTH - i;

                dc.setColor(bgColor, Gfx.COLOR_TRANSPARENT);
                dc.drawArc(x, y, maxR - i, Gfx.ARC_CLOCKWISE,
                           Constants.START_ANGEL,
                           Constants.START_ANGEL - shift);

                dc.setColor(timeColor, Gfx.COLOR_TRANSPARENT);
                dc.drawArc(x, y, maxR - i, Gfx.ARC_CLOCKWISE,
                           Constants.START_ANGEL - angel + 1,
                           Constants.START_ANGEL - angel - shift - 1);

            }
        }
    }

    function getCenterAndRadius(dc) {
        return [dc.getWidth() / 2, dc.getHeight() / 2, dc.getWidth() / 2];
    }

}