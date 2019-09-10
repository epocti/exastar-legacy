package scripts;

import scripts.assets.Assets;
import scripts.id.FontID;
import scripts.tools.EZImgInstance;
import com.stencyl.graphics.G;
import com.stencyl.behavior.Script;
import com.stencyl.behavior.Script.*;
import com.stencyl.behavior.ActorScript;
import com.stencyl.behavior.SceneScript;
import com.stencyl.behavior.TimedTask;
import com.stencyl.models.Actor;
import com.stencyl.models.GameModel;
import com.stencyl.models.actor.Animation;
import com.stencyl.models.actor.ActorType;
import com.stencyl.models.actor.Collision;
import com.stencyl.models.actor.Group;
import com.stencyl.models.Scene;
import com.stencyl.models.Sound;
import com.stencyl.models.Region;
import com.stencyl.models.Font;
import com.stencyl.models.Joystick;
import com.stencyl.Engine;
import com.stencyl.Input;
import com.stencyl.utils.Utils;
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
import scripts.gfx.particle.GFX_part;

class SE_rhytest2 extends SceneScript {
	var ms:Int = 0;																	// Milliseconds passed / 10, so 1 second = 100
	var indic:EZImgInstance = new EZImgInstance("g", true, "bttl.rhythm.indic.n");	// Indicator image
	var coolzone:EZImgInstance = new EZImgInstance("g", true, "bttl.rhythm.marker");	// Activation image
	var beatIDList:Array<Int> = new Array<Int>();									// List of the actor IDs of all of the beats that are not activated
	var canActivateBeat:Bool = true;												// Can activate the next beat
	// var particles:Array<GFX_part> = new Array<GFX_part>();							// particle cache
	var beatmap:Array<Int> = new Array<Int>();

    public function new(dummy:Int, dummy2:Engine){
		super();
		addWhenUpdatedListener(null, onUpdate);
		addWhenDrawingListener(null, onDraw);
	}
	public function onUpdate(elapsedTime:Float, list:Array<Dynamic>){ update(elapsedTime); }
	public function onDraw(g:G, x:Float, y:Float, list:Array<Dynamic>){ draw(g); }

	// ==== top ten code that will most likely be hacked to fit into another part of the game: number 1 ====

	override public function init(){
		playSoundOnChannel(Assets.get("mus.fc"), 0);

		var beatmapTemp:Array<String> = DataUtils.getTextData("beatmap/bm_test.txt").split("\r");
		// convert loaded beatmap into ints (-1 on length because last string is null)
		for(i in 0...beatmapTemp.length - 1) if(beatmapTemp[i] != null) beatmap.push(Std.parseInt(beatmapTemp[i]));

		indic.setOrigin("CENTER");
		indic.setXY(Std.int(getScreenWidth() - 40), Std.int(getScreenHeight() / 2));
		indic.setWidth(200);
		indic.setHeight(200);
		coolzone.setOrigin("CENTER");
		coolzone.setXY(Std.int(getScreenWidth() - 90), Std.int(getScreenHeight() / 2));
	}

	public inline function update(elapsedTime:Float){
		ms++;
		for(i in 0...beatmap.length){
			if(Std.int(getPositionForChannel(0)) == beatmap[i] * 100){
				createActor(getActorTypeByName("obj_beat"), 0, getScreenHeight() / 2, Script.FRONT);
				beatIDList.push(getLastCreatedActor().getID());
			}
		}

		if(isKeyPressed("action1") && beatIDList.length != 0){
			if(canActivateBeat){
				getActor(beatIDList[0]).setAnimation("pass");
				getActor(beatIDList[0]).moveBy(0, -40, .5, Expo.easeOut);
				// for(i in 0...8){ particles.push(new GFX_part_MB1(getActor(beatIDList[0]).getXCenter(), getActor(beatIDList[0]).getYCenter())); }
				beatIDList.remove(beatIDList[0]);

				indic.changeImage("bttl.rhythm.indic.n_beatHit");
				runLater(325, function(timeTask:TimedTask):Void {
					indic.changeImage("bttl.rhythm.indic.n");
				}, null);
			}
			else {
				getActor(beatIDList[0]).setAnimation("miss");
				getActor(beatIDList[0]).moveBy(0, 40, .5, Expo.easeOut);
				// for(i in 0...8){ particles.push(new GFX_part_MB2(getActor(beatIDList[0]).getXCenter(), getActor(beatIDList[0]).getYCenter() + 20)); }
				beatIDList.remove(beatIDList[0]);

				startShakingScreen(.01, .125);
				indic.changeImage("bttl.rhythm.indic.n_beatMiss");
				runLater(325, function(timeTask:TimedTask):Void {
					indic.changeImage("bttl.rhythm.indic.n");
				}, null);
			}
		}

		// remove beat from list after leaving screen
		for(actorOfType in getActorsOfType(getActorType(407))){
			if(actorOfType != null && !actorOfType.dead && !actorOfType.recycled){
				if(actorOfType.getX() >= 420){
					var wasUncompleteBeat:Bool = false;

					for(i in 0...beatIDList.length){
						if(beatIDList[i] == actorOfType.getID()) wasUncompleteBeat = true;
					}

					if(wasUncompleteBeat){
						beatIDList.remove(actorOfType.getID());
						// for(i in 0...8){ particles.push(new GFX_part_MB2(actorOfType.getXCenter(), actorOfType.getYCenter() + 20)); }
						startShakingScreen(.01, .125);
						indic.changeImage("bttl.rhythm.indic.n_beatMiss");
						runLater(325, function(timeTask:TimedTask):Void {
							indic.changeImage("bttl.rhythm.indic.n");
						}, null);
						recycleActor(actorOfType);
					}
				}
			}
		}
	}

	public inline function draw(g:G){
		g.setFont(getFont(FontID.MAIN_WHITE));
		g.drawString("Current frame: " + ms, 1, 24);
		g.drawString("BeatIDs: " + beatIDList.toString(), 1, 38);

		// Draw beat ids above beats
		engine.allActors.reuseIterator = false;
		for(actorOnScreen in engine.allActors){
			if(actorOnScreen != null && !actorOnScreen.dead && !actorOnScreen.recycled && actorOnScreen.isOnScreenCache){
				g.drawString("ID:" + actorOnScreen.getID(), actorOnScreen.getX(), actorOnScreen.getY() - 14);
			}
		}
		engine.allActors.reuseIterator = true;
	}
}
