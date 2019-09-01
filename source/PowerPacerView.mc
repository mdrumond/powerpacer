
using Toybox.WatchUi as Ui;
using Toybox.Application as App;
using Toybox.Graphics as Gfx;

class PowerPacerView extends Ui.DataField
{
    hidden var color ;
    hidden var SIZE=20;
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
    	}else{
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

        drawGauge(dc);
		drawSpeed(System.getSystemStats().battery, dc, x, y);
    }
    
    function drawGauge(dc) {

        var x = dc.getWidth() / 2;
        var y = 0;
        var radius = dc.getWidth()/2-SIZE/2;
        if (dc.getWidth() == dc.getHeight()) {
            y = dc.getHeight() / 2;
        }
        else {
            y = dc.getHeight();
        }

        dc.setPenWidth(SIZE);
        dc.setColor( Graphics.COLOR_RED, getBackgroundColor() );
        dc.drawArc(x, y, radius, Gfx.ARC_COUNTER_CLOCKWISE, 10, 58);

        dc.setColor( Graphics.COLOR_GREEN, getBackgroundColor() );
        dc.drawArc(x, y, radius, Gfx.ARC_COUNTER_CLOCKWISE, 60, 120);

        dc.setColor( Graphics.COLOR_RED, getBackgroundColor() );
        dc.drawArc(x, y, radius, Gfx.ARC_COUNTER_CLOCKWISE, 122, 170);

    }

    function drawSpeed(battery, dc, x, y) { 
    	// dc.setPenWidth(2); 
        // dc.drawText(x, y, Graphics.FONT_NUMBER_HOT, speed.format("%.2f"), Graphics.TEXT_JUSTIFY_CENTER|Graphics.TEXT_JUSTIFY_VCENTER);
        
        // dc.drawText(x-dc.getWidth()/2+10+SIZE/2, y+15, Graphics.FONT_NUMBER_MILD, min.format("%d"), Graphics.TEXT_JUSTIFY_CENTER|Graphics.TEXT_JUSTIFY_VCENTER);
        // dc.drawText(x+dc.getWidth()/2-10-SIZE/2, y+15, Graphics.FONT_NUMBER_MILD, max.format("%d"), Graphics.TEXT_JUSTIFY_CENTER|Graphics.TEXT_JUSTIFY_VCENTER);
        // dc.drawText(x, y+y/1.75, Graphics.FONT_MEDIUM, speedStr, Graphics.TEXT_JUSTIFY_CENTER|Graphics.TEXT_JUSTIFY_VCENTER);
        
        dc.setColor( color, getBackgroundColor() );
        
        dc.setPenWidth(2);

        var percent=0;
        if(speed>0 && max-min>0){
        	percent= speed/(max-min);
        }
        
        var orientation=-Math.PI*percent-3*Math.PI/2;
        var radius= dc.getWidth()/2-6;
        var xy1 = pol2Cart(x, y, orientation, radius);
		var xy2 = pol2Cart(x, y, orientation-5*Math.PI/180, radius);
		var xy3 = pol2Cart(x, y, orientation-5*Math.PI/180, radius-SIZE-8);
		var xy4 = pol2Cart(x, y, orientation, radius-SIZE-8);
		dc.fillPolygon([xy1, xy2, xy3, xy4]);

    }
    
	function pol2Cart(center_x, center_y, radian, radius) {
		var x = center_x - radius * Math.sin(radian);
		var y = center_y - radius * Math.cos(radian);
		 
		return [Math.ceil(x), Math.ceil(y)];
	}
}
