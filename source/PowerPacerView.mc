
using Toybox.WatchUi as Ui;
using Toybox.Application as App;
using Toybox.Graphics as Gfx;

class PowerPacerView extends Ui.DataField
{
    hidden const ARC_THICKNESS = 20;
    hidden const POINTER_W = 7;

    hidden const REGULAR_LINE = 2;

    hidden const DEG_MIN = 10;
    hidden const DEG_MAX = 170;

    hidden var value_pct;
    hidden var value_goal = 350;
    hidden var value_tolerance = .05;
    hidden var currentPace;
    hidden var currentDistance;
    hidden var expectedTime;
    
    function initialize() {
        DataField.initialize();
        currentDistance = 0;
        currentPace = 0;
        value_pct = 0;
    }
     
    function compute(info) {
        currentDistance = info.elapsedDistance;
        currentPace = speed2Pace(info.currentSpeed);
        if(currentPace > value_goal*(1 + 3*value_tolerance)) {
            value_pct = 100;
        }
        else if (currentPace < value_goal*(1 - 3*value_tolerance)) {
            value_pct = 0;
        }
        else {
            value_pct = 100*(currentPace - value_goal*(1 - 3*value_tolerance)) / 6*value_tolerance;
        }
        value_pct = value_pct.toNumber();

        System.println(value_pct + "   " + currentPace);
    }

    function onUpdate(dc) {
        drawFields(dc);
        drawMainField(dc);
        drawGauge(dc, value_pct);
    }
    
    function drawGauge(dc, percent) {
        // Draw Arc
        var x = dc.getWidth() / 2;
        var y = 0;
        var radius = dc.getWidth()/2-ARC_THICKNESS/2;
        y = dc.getHeight() / 2;

        dc.setPenWidth(ARC_THICKNESS);
        dc.setColor(Graphics.COLOR_RED, getBackgroundColor() );
        dc.drawArc(x, y, radius, Gfx.ARC_COUNTER_CLOCKWISE, DEG_MIN, 58);

        dc.setColor(Graphics.COLOR_GREEN, getBackgroundColor() );
        dc.drawArc(x, y, radius, Gfx.ARC_COUNTER_CLOCKWISE, 60, 120);

        dc.setColor(Graphics.COLOR_RED, getBackgroundColor() );
        dc.drawArc(x, y, radius, Gfx.ARC_COUNTER_CLOCKWISE, 122, DEG_MAX);

        // Draw pointer
        dc.setColor(Graphics.COLOR_BLACK, getBackgroundColor() );

        var deg = (percent*(DEG_MAX-DEG_MIN))/100 + DEG_MIN;
        dc.fillPolygon([pol2Cart(x, y, deg, radius), 
                        pol2Cart(x, y, deg-POINTER_W, radius-ARC_THICKNESS), 
                        pol2Cart(x, y, deg+POINTER_W, radius-ARC_THICKNESS)]);

    }

    function pol2Cart(center_x, center_y, deg, radius) {
        var x = center_x + radius * Math.sin((deg-90)*Math.PI/180);
        var y = center_y - radius * Math.cos((deg-90)*Math.PI/180);
 
        return [Math.ceil(x), Math.ceil(y)];
    }

    function speed2Pace(speed) {
        if (speed == 0) {
            return 0;
        }
        return (1000/speed).toNumber();
    }

    function distString(dist) {
        if (dist == null or dist == 0) {
            return "--:--";
        }

        currentDistance = currentDistance / 1000;
        return currentDistance.format("%.02f");
    }

    function paceString(pace) { 
        if(pace == null or pace == 0) {
            return "--:--";
        }

        pace = pace.toNumber();
        return Math.floor(pace/60).format("%02d") + ':' + Math.floor(pace%60).format("%02d");
    }

    function drawMainField(dc) {
        var label_y = (6*dc.getHeight())/32;

        var number_y = (10*dc.getHeight())/32 + dc.getHeight()/64;
        var number_x = (dc.getWidth())/2;

        var aux_y = (63*dc.getHeight())/128;
        var aux1_x = (dc.getWidth())/4;
        var aux2_x = (3*dc.getWidth())/4;
        dc.setColor( Graphics.COLOR_BLACK, getBackgroundColor() );
        centerText(dc, number_x, label_y, "Pace", Graphics.FONT_SMALL);
        centerText(dc, number_x, number_y, paceString(currentPace), Graphics.FONT_NUMBER_MEDIUM);

        dc.setColor( Graphics.COLOR_DK_GRAY, getBackgroundColor() );
        centerText(dc, aux1_x, aux_y, "> " + paceString(value_goal*(1-value_tolerance)), Graphics.FONT_SMALL);
        centerText(dc, aux2_x, aux_y, "< " + paceString(value_goal*(1+value_tolerance)), Graphics.FONT_SMALL);

    }

    function drawFields(dc) {

        dc.setColor( Graphics.COLOR_LT_GRAY, getBackgroundColor() );

        var middle_y = dc.getHeight() / 2 + dc.getHeight() / 16;
        var middle_x = dc.getWidth() / 2;
        dc.setPenWidth(REGULAR_LINE);
        dc.drawLine(0, middle_y, dc.getWidth(), middle_y);
        dc.drawLine(middle_x, middle_y, middle_x, dc.getHeight());

        var label_y = (10*dc.getHeight())/16;

        var number_y = (12*dc.getHeight())/16 + dc.getHeight()/64;
        var number_f1_x = (dc.getWidth())/4;
        var number_f2_x = (3*dc.getWidth())/4;

        dc.setColor( Graphics.COLOR_BLACK, getBackgroundColor() );
        centerText(dc, number_f1_x, label_y, "Ahead", Graphics.FONT_SMALL);
        centerText(dc, number_f1_x, number_y, "12.35", Graphics.FONT_NUMBER_MILD);

        centerText(dc, number_f2_x, label_y, "Dist.", Graphics.FONT_SMALL);
        centerText(dc, number_f2_x, number_y, distString(currentDistance), Graphics.FONT_NUMBER_MILD);
        
    }

    function centerText(dc, x, y, str, font) {
        dc.drawText(x, y, font, str, Graphics.TEXT_JUSTIFY_CENTER|Graphics.TEXT_JUSTIFY_VCENTER);
    }
    
}
