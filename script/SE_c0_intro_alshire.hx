package scripts;

import scripts.id.FontID;
import scripts.tools.Util;
import com.stencyl.graphics.G;
import com.stencyl.behavior.Script.*;
import com.stencyl.behavior.SceneScript;
import com.stencyl.behavior.TimedTask;
import com.stencyl.models.GameModel;
import com.stencyl.Engine;
import com.stencyl.utils.Utils;
import motion.Actuate;
import motion.easing.Linear;
import motion.easing.Quad;

class SE_c0_intro_alshire extends SceneScript {
	public var _camY:Int = 785;
	public var _opac:Float = 0;
	public var _textY:Int = 0;

	public function new(dummy:Int, dummy2:Engine){
		super();
		addWhenUpdatedListener(null, onUpdate);
		addWhenDrawingListener(null, onDraw);
	}
	public function onUpdate(elapsedTime:Float, list:Array<Dynamic>){ update(elapsedTime); }
	public function onDraw(g:G, x:Float, y:Float, list:Array<Dynamic>){ draw(g); }


	override public function init(){
		_textY = Std.int(Util.getMidScreenY() + 18);
		// Move text up
		Actuate.tween(this, 10, {_camY:0}).ease(Linear.easeNone);
		runLater(3000, function(timeTask:TimedTask):Void {
			Actuate.tween(this, 1.5, {_opac:100}).ease(Linear.easeNone);
			Actuate.tween(this, 1.5, {_textY:Util.getMidScreenY()}).ease(Quad.easeOut);
		}, null);
		// Move text down
		runLater(8000, function(timeTask:TimedTask):Void {
			Actuate.tween(this, 1.5, {_opac:0}).ease(Linear.easeNone);
			Actuate.tween(this, 1.5, {_textY:Util.getMidScreenY() + 18}).ease(Quad.easeIn);
		}, null);
		// End switch
		runLater(11000, function(timeTask:TimedTask):Void {
			switchScene(GameModel.get().scenes.get(39).getID(), createFadeOut(4, Utils.getColorRGB(0,0,0)), createFadeIn(0, Utils.getColorRGB(0,0,0)));
		}, null);
	}

	public inline function update(elapsedTime:Float){ engine.moveCamera(0, _camY); }

	public inline function draw(g:G){
		g.alpha = (_opac/100);
		g.setFont(getFont(FontID.MAIN_WHITE));
		g.drawString(Util.getString("LANDINTRO_ALSHIRE"), Util.getMidScreenX() - (g.font.font.getTextWidth(Util.getString("LANDINTRO_ALSHIRE")) / 2), _textY);
	}
}
