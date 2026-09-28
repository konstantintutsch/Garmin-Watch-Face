import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;

import Toybox.Time;
import Toybox.Time.Gregorian;

import Toybox.Weather;

import Toybox.Activity;

class View extends WatchUi.WatchFace {
    private var fontS as WatchUi.FontResource?;
    private var fontS_offset as Integer?;
    private var fontM as WatchUi.FontResource?;
    private var fontM_offset as Integer?;
    private var fontL as WatchUi.FontResource?;
    private var fontL_offset as Integer?;

    function initialize() {
        WatchFace.initialize();
    }

    function onLayout(dc as Dc) as Void {
        // _offset: font size * 0.5
        fontS = WatchUi.loadResource(Rez.Fonts.BebasNeueRegularS) as WatchUi.FontResource;
        fontS_offset = 15;
        fontM = WatchUi.loadResource(Rez.Fonts.BebasNeueRegularM) as WatchUi.FontResource;
        fontM_offset = 25;
        fontL = WatchUi.loadResource(Rez.Fonts.BebasNeueRegularL) as WatchUi.FontResource;
        fontL_offset = 60;
    }

    function onShow() as Void {
    }

    // Called every minute (and every second in high-power mode)
    function onUpdate(dc as Dc) as Void {
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.clear();

        var top_y = 0;
        var border_offset = 10;
        var bottom_y = dc.getHeight();
        var center_x = dc.getWidth() / 2;
        var center_y = bottom_y /2;

        // Time
        var time = System.getClockTime();

        var clock = Lang.format("$1$:$2$:$3$", [time.hour.format("%02d"), time.min.format("%02d"), time.sec.format("%02d")]);
        dc.drawText(center_x, center_y, fontL as WatchUi.FontResource, clock, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);

        // Date
        var now = Time.now();
        var calendar = Gregorian.info(now, Time.FORMAT_MEDIUM);

        var date = Lang.format("$1$ $2$", [calendar.day, calendar.month]);
        dc.drawText(center_x, center_y - fontL_offset - fontM_offset, fontM as WatchUi.FontResource, date, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);

        // Weather
        var weather = Weather.getCurrentConditions();

        var temperature = Lang.format("$1$°C", [weather.temperature.format("%d")]);
        dc.drawText(center_x, center_y + fontL_offset + fontM_offset, fontM as WatchUi.FontResource, temperature, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);


        // Battery
        var stats = System.getSystemStats();

        var battery = Lang.format("$1$%", [stats.battery.format("%d")]);
        dc.drawText(center_x, top_y + border_offset + fontS_offset, fontS as WatchUi.FontResource, battery, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);

        // Heart
        var activity = Activity.getActivityInfo();

        var bpm = "-";
        if (activity.currentHeartRate != null) {
            bpm = activity.currentHeartRate;
        }
        var heart = Lang.format("♥$1$", [bpm]);
        dc.drawText(center_x, bottom_y - border_offset - fontS_offset, fontS as WatchUi.FontResource, heart, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
    }

    function onHide() as Void {
    }

    function onExitSleep() as Void {
    }

    function onEnterSleep() as Void {
    }
}
