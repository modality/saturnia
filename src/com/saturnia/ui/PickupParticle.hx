package com.saturnia.ui;

import com.haxepunk.Tween;
import com.haxepunk.tweens.misc.VarTween;
import com.haxepunk.tweens.misc.MultiVarTween;
import com.modality.Base;
import com.saturnia.ui.InfoPanel;

class PickupParticle extends Base
{
  public var x_target:Float;
  public var y_target:Float;
  public var panel:InfoPanel;

  public function new(_type:String, _panel:InfoPanel, _x:Float, _y:Float, _x_target:Float, _y_target:Float)
  {
    super(_x, _y, Assets.getImage("icon_"+_type));
    panel = _panel;
    x_target = _x_target;
    y_target = _y_target;
    layer = Constants.OVERLAY_LAYER;

    var yt = new VarTween(bounceComplete, OneShot);
    yt.tween(this, "y", _y-50, 0.8, easeOutBounce);
    addTween(yt, true);

    var xt = new VarTween(null, OneShot);
    var x_dist = [-50, -40, -20, 20, 40, 50];
    xt.tween(this, "x", _x+x_dist[Std.random(x_dist.length)], 0.8);
    addTween(xt, true);
  }

  public function bounceComplete(o:Dynamic):Void
  {
    y = y+50;
    var pt = new MultiVarTween(flyComplete, OneShot);
    pt.tween(this, {"x": x_target, "y": y_target}, 0.8, easeOutQuad);
    addTween(pt, true);
  }

  public function flyComplete(o:Dynamic):Void
  {
    panel.updateGraphic();
  }

  public function easeOutBounce(t:Float):Float
  {
		if (t < (1./3.)) {
			return 1-(7.5625*(1./3.-t)*(1./3.-t));
		} else if (t < (2./3.)) {
			return 1-(7.5625*(t-1./3.)*(t-1./3.));
		} else {
			return 1-(7.5625*(t-=(5./6.))*t + .75);
		}
  }

  public function easeOutQuad(t:Float):Float
  {
		return -(t)*(t-2);
  }
  
}
