
using Toybox.WatchUi as Ui;
using Toybox.Application as App;
using Toybox.Graphics as Gfx;

class PowerPacerView extends Ui.DataField
{
    hidden var color ;

    hidden var ARC_THICKNESS = 20;
    hidden var POINTER_H = 15;

    hidden var REGULAR_LINE = 2;
    hidden var speed;     
    hidden var min;
    hidden var max;
    hidden var speedStr;
    
    function initialize() {
        DataField.initialize();
        speedStr = Ui.loadResource(Rez.Strings.speed);
    }
     
    function compute(info) {
        min= App.getApp().getProperty("speed_min");
        if(info.maxSpeed!=null && App.getApp().getProperty("speed_max_auto")){
            max = info.maxSpeed*3.6;
        } else {
            max= App.getApp().getProperty("speed_max");
        }
        speed = info.currentSpeed*3.6;
    }

    function onUpdate(dc) {
  
        color = (getBackgroundColor() == Graphics.COLOR_BLACK) ? Graphics.COLOR_WHITE : Graphics.COLOR_BLACK;

        var flag = getObscurityFlags();
        var width = dc.getWidth();
        System.println("width:" + width.toString());
        var height = dc.getHeight();
        System.println("height:" + height.toString());
        var x = width / 2;
        var y = height / 2;

        drawGauge(dc, 50);
        drawFields(dc);
        drawMainField(dc);
    }
    
    function drawGauge(dc, percent) {
        /***
        First draw gauge
        Than draw pointers: small triangle
        Need:
            code to draw small triangle
            code to compute small triangle position
         ***/

        // Draw Arc
        var x = dc.getWidth() / 2;
        var y = 0;
        var radius = dc.getWidth()/2-ARC_THICKNESS/2;
        y = dc.getHeight() / 2;

        dc.setPenWidth(ARC_THICKNESS);
        dc.setColor( Graphics.COLOR_RED, getBackgroundColor() );
        dc.drawArc(x, y, radius, Gfx.ARC_COUNTER_CLOCKWISE, 10, 58);

        dc.setColor( Graphics.COLOR_GREEN, getBackgroundColor() );
        dc.drawArc(x, y, radius, Gfx.ARC_COUNTER_CLOCKWISE, 60, 120);

        dc.setColor( Graphics.COLOR_RED, getBackgroundColor() );
        dc.drawArc(x, y, radius, Gfx.ARC_COUNTER_CLOCKWISE, 122, 170);

        // Draw pointer
        dc.setColor( Graphics.COLOR_BLACK, getBackgroundColor() );

        var orientation=-Math.PI*percent-3*Math.PI/2;
        radius= dc.getWidth()/2-6;
        var xy1 = pol2Cart(x, y, orientation, radius);
        var xy2 = pol2Cart(x, y, orientation-5*Math.PI/180, radius);
        var xy3 = pol2Cart(x, y, orientation-5*Math.PI/180, radius-ARC_THICKNESS-8);
        var xy4 = pol2Cart(x, y, orientation, radius-ARC_THICKNESS-8);
        dc.fillPolygon([xy1, xy2, xy3, xy4]);

        /*
        dc.setPenWidth(REGULAR_LINE);
        var orientation = -Math.PI*percent-3*Math.PI/2;
        radius= dc.getWidth()/2-6;
        var xy1 = pol2Cart(x, y, orientation-5*Math.PI/180, radius);
        var xy2 = pol2Cart(x, y, orientation-5*Math.PI/180, radius-ARC_THICKNESS-8);
        var xy3 = pol2Cart(x, y, orientation, radius-ARC_THICKNESS-8);
        dc.fillPolygon([xy1, xy2, xy3]);
        */
    }

    function pol2Cart(center_x, center_y, radian, radius) {
        var x = center_x - radius * Math.sin(radian);
        var y = center_y - radius * Math.cos(radian);
 
        return [Math.ceil(x), Math.ceil(y)];
    }

    function drawMainField(dc) {
        var label_y = (6*dc.getHeight())/32;

        var number_y = (10*dc.getHeight())/32;
        var number_x = (dc.getWidth())/2;

        var aux_y = (63*dc.getHeight())/128;
        var aux1_x = (dc.getWidth())/4;
        var aux2_x = (3*dc.getWidth())/4;
        dc.setColor( Graphics.COLOR_BLACK, getBackgroundColor() );
        centerText(dc, number_x, label_y, "Pace", Graphics.FONT_SMALL);
        centerText(dc, number_x, number_y, "12:35", Graphics.FONT_NUMBER_MEDIUM);

        centerText(dc, number_x, number_y, "12:35", Graphics.FONT_NUMBER_MEDIUM);

        dc.setColor( Graphics.COLOR_DK_GRAY, getBackgroundColor() );
        centerText(dc, aux1_x, aux_y, "Min: 12:35", Graphics.FONT_SMALL);
        centerText(dc, aux2_x, aux_y, "Max: 12:35", Graphics.FONT_SMALL);

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
        centerText(dc, number_f2_x, number_y, "12.35", Graphics.FONT_NUMBER_MILD);
        
    }

    function centerText(dc, x, y, str, font) {
        dc.drawText(x, y, font, str, Graphics.TEXT_JUSTIFY_CENTER|Graphics.TEXT_JUSTIFY_VCENTER);
    }
    
}
