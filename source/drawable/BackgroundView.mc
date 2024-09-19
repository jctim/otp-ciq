using Toybox.WatchUi as Ui;
using Toybox.Application as App;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;

class BackgroundView extends Ui.Drawable {

    function initialize(params) {
        Drawable.initialize(params);
    }

    function draw(dc) {
        dc.setColor(Gfx.COLOR_TRANSPARENT, AppData.readProperty(Constants.BG_COLOR_PROP));
        dc.clear();
    }

}
