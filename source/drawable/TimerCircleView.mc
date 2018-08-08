using Toybox.WatchUi as Ui;
using Toybox.Application as App;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;

class TimerCircleView extends Ui.Drawable {

    // ui consts
    const START_ANGEL = 270;
    const ROUND_WIDTH = 12;

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
        var currentTokenLifetime = App.getApp().getCurrentTokenLifetime();

        var time   = System.getClockTime();

        if (time.sec % currentTokenLifetime > currentTokenLifetime - 5 || time.sec % currentTokenLifetime == 0) {
            timeColor = Gfx.COLOR_RED;
        }

        var angel = time.sec * 360 / currentTokenLifetime;
        var r     = maxR - (ROUND_WIDTH / 2);

        // draw main time filler
        dc.setPenWidth(ROUND_WIDTH);
        dc.setColor(timeColor, Gfx.COLOR_TRANSPARENT);
        dc.drawArc(x, y, r, Gfx.ARC_CLOCKWISE,
                   START_ANGEL, START_ANGEL - angel);

        if (useArrows) {
            // draw arrows of time filler
            dc.setPenWidth(1);
            for (var i = 0; i < ROUND_WIDTH; i++) {
                var shift = i < ROUND_WIDTH / 2 ? i : ROUND_WIDTH - i;

                dc.setColor(bgColor, Gfx.COLOR_TRANSPARENT);
                dc.drawArc(x, y, maxR - i, Gfx.ARC_CLOCKWISE,
                           START_ANGEL,
                           START_ANGEL - shift);

                dc.setColor(timeColor, Gfx.COLOR_TRANSPARENT);
                dc.drawArc(x, y, maxR - i, Gfx.ARC_CLOCKWISE,
                           START_ANGEL - angel + 1,
                           START_ANGEL - angel - shift - 1);

            }
        }
    }

    function getCenterAndRadius(dc) {
        return [dc.getWidth() / 2, dc.getHeight() / 2, dc.getWidth() / 2];
    }

}