package scripts;

import scripts.tools.EZImgInstance;
import com.stencyl.graphics.G;
import com.stencyl.behavior.Script.*;
import com.stencyl.behavior.SceneScript;
import com.stencyl.behavior.TimedTask;
import com.stencyl.Engine;
import motion.Actuate;
import motion.easing.Linear;

class SE_c0_storyIntro2 extends SceneScript {
	var slideView:EZImgInstance = new EZImgInstance("g", true, "cutscene.storyIntro.alienStory.s1");
	var currentSlide:Int = 1;
	var slideOpacity:Float = 0;

    public function new(dummy:Int, dummy2:Engine){
		super();	
		addWhenUpdatedListener(null, onUpdate);
		addWhenDrawingListener(null, onDraw);
	}
	public function onUpdate(elapsedTime:Float, list:Array<Dynamic>){ update(elapsedTime); }
	public function onDraw(g:G, x:Float, y:Float, list:Array<Dynamic>){ draw(g); }
	
	// ========
	
	override public function init(){
		dialog.core.Dialog.cbCall("dg_strtel2", "style_main", this, "");
		Actuate.tween(this, .4, {slideOpacity:5}).ease(Linear.easeNone);
	}

	public inline function update(elapsedTime:Float){ slideView.setAlpha(Std.int(slideOpacity) * 20); }

	public inline function draw(g:G){}

	public function incrementSlide(){
		Actuate.tween(this, .4, {slideOpacity:0}).ease(Linear.easeNone);
		runLater(400, function(timeTask:TimedTask):Void {
			// todo: what
			switch(currentSlide){
				case 1: slideView.changeImage("cutscene.storyIntro.alienStory.s2");
				case 2: slideView.changeImage("cutscene.storyIntro.alienStory.s3");
				case 3: slideView.changeImage("cutscene.storyIntro.alienStory.s4");
				case 4: slideView.changeImage("cutscene.storyIntro.alienStory.s5");
				case 5: slideView.changeImage("cutscene.storyIntro.alienStory.s6");
				case 6: slideView.changeImage("cutscene.storyIntro.alienStory.s7");
				case 7: slideView.changeImage("cutscene.storyIntro.alienStory.s8");
				case 8: slideView.changeImage("cutscene.storyIntro.alienStory.s9");
				case 9: slideView.changeImage("cutscene.storyIntro.alienStory.s10");
				case 10: slideView.changeImage("cutscene.storyIntro.alienStory.s11");
				case 11: slideView.changeImage("cutscene.storyIntro.alienStory.s9");
				case 12: slideView.changeImage("cutscene.storyIntro.alienStory.s10");
				case 13: slideView.changeImage("cutscene.storyIntro.alienStory.s11");
				case 14: slideView.changeImage("cutscene.storyIntro.alienStory.s10");
				case 15: slideView.changeImage("cutscene.storyIntro.alienStory.s12");
				case 16: slideView.changeImage("cutscene.storyIntro.alienStory.s13");
				case 17: slideView.changeImage("cutscene.storyIntro.alienStory.s14");
				case 18: slideView.changeImage("cutscene.storyIntro.alienStory.s15");
				case 19: slideView.changeImage("cutscene.storyIntro.alienStory.s16");
				case 20: slideView.changeImage("cutscene.storyIntro.alienStory.s17");
				case 21: slideView.changeImage("cutscene.storyIntro.alienStory.s18");
				case 22: slideView.changeImage("cutscene.storyIntro.alienStory.s19");
			}
			Actuate.tween(this, .4, {slideOpacity:5}).ease(Linear.easeNone);
			currentSlide++;
		}, null);
	}
}
