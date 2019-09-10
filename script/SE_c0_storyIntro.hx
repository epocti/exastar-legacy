package scripts;

import scripts.assets.Assets;
import motion.easing.Linear;
import scripts.tools.EZImgInstance;
import com.stencyl.graphics.G;
import com.stencyl.behavior.Script;
import com.stencyl.behavior.Script.*;
import com.stencyl.behavior.ActorScript;
import com.stencyl.behavior.SceneScript;
import com.stencyl.behavior.TimedTask;
import com.stencyl.Engine;
import motion.Actuate;
import motion.easing.Back;
import motion.easing.Cubic;
import motion.easing.Elastic;
import motion.easing.Expo;
import motion.easing.Linear;
import motion.easing.Quad;
import motion.easing.Quart;
import motion.easing.Quint;
import motion.easing.Sine;

class SE_c0_storyIntro extends SceneScript {
	var book:EZImgInstance = new EZImgInstance("g", true, "cutscene.storyIntro.bookFront");
	var bookSize:Float = .25;
    public function new(dummy:Int, dummy2:Engine){
		super();	
		addWhenUpdatedListener(null, onUpdate);
		addWhenDrawingListener(null, onDraw);
	}
	public function onUpdate(elapsedTime:Float, list:Array<Dynamic>){ update(elapsedTime); }
	public function onDraw(g:G, x:Float, y:Float, list:Array<Dynamic>){ draw(g); }
	
	// ========
	
	override public function init(){
		book.setOrigin("CENTER");
		book.centerOnScreen(true, true);
		book.spinBy(-20, 0.01, Linear.easeNone);

		book.setAlpha(0);
		runLater(8000, function(timeTask:TimedTask):Void {
			book.fadeTo(100, 15, Linear.easeNone);
			book.spinBy(20, 15, Linear.easeNone);
			Actuate.tween(this, 15, {bookSize:1}).ease(Linear.easeNone);
		}, null);


		// Music/dialog
		playSoundOnChannel(Assets.get("mus.storyteller2"), 0);
		runLater(1000, function(timeTask:TimedTask):Void { dialog.core.Dialog.cbCall("dg_strtel1", "style_main", this, ""); }, null);

		// Book spinning
		runPeriodically(6000, function(timeTask:TimedTask):Void {
			book.growTo(0, 100*bookSize, 1.5, Quad.easeInOut);
			runLater(1500, function(timeTask:TimedTask):Void {
				book.changeImage("cutscene.storyIntro.bookBack");
				book.growTo(100*bookSize, 100*bookSize, 1.5, Quad.easeInOut);
				runLater(1500, function(timeTask:TimedTask):Void {
					book.growTo(0, 100*bookSize, 1.5, Quad.easeInOut);
					runLater(1500, function(timeTask:TimedTask):Void {
						book.changeImage("cutscene.storyIntro.bookFront");
						book.growTo(100*bookSize, 100*bookSize, 1.5, Quad.easeInOut);
					}, null);
				}, null);
			}, null);
		}, null);
	}
	
	public inline function update(elapsedTime:Float){
	}
	
	public inline function draw(g:G){
	}
}
