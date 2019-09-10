package scripts;

import com.stencyl.models.Region;
import motion.easing.Quad;
import com.stencyl.behavior.Script;
import motion.easing.Linear;
import com.stencyl.behavior.TimedTask;
import scripts.tools.EZImgInstance;
import com.stencyl.behavior.ActorScript;
import com.stencyl.models.Actor;
import com.stencyl.models.actor.Group;
import com.stencyl.Engine;
import scripts.tools.Util;

class Script_SaveCube extends ActorScript {
	var imgs:Array<EZImgInstance> = new Array<EZImgInstance>();
	var activationRegion:Region;
	@:attribute("id='1' name='Save Location Name' desc='The name that shows up for this save location in the title screen.'")
	public var saveLocationName:String = "!!ERROR!!";

    public function new(dummy:Int, actor:Actor, dummy2:Engine){
		super(actor);
		addWhenUpdatedListener(null, onUpdate);
	}
	public function onUpdate(elapsedTime:Float, list:Array<Dynamic>){ update(elapsedTime); }

	// ========

	override public function init(){
		activationRegion = Script.createBoxRegion((actor.getX() - 8), ((actor.getY() + (actor.getHeight())) - 17), 37, 24);

		imgs.push(new EZImgInstance("g", false, "gfx.saveCube.shadow"));
		imgs[0].setAlpha(66);
		imgs[0].setOrigin("CENTER");
		imgs[0].attachToWorld("midbottom", Std.int(actor.getX()) + 2, Std.int(actor.getYCenter()) + 6, 1);
		for(i in 0...16){
			imgs.push(new EZImgInstance("g", false, "gfx.saveCube." + i));
			imgs[i + 1].setOrigin("CENTER");
			imgs[i + 1].attachToWorld("midbottom", Std.int(actor.getX()) + 4, Std.int(actor.getYCenter()) - i, 1);
		}
		// Animation
		for(img in imgs) img.spinBy(360, 4, Linear.easeNone);
		Script.runPeriodically(4000, function(timeTask:TimedTask):Void {
			for(img in imgs) img.spinBy(360, 4, Linear.easeNone);
		}, null);
		Script.runPeriodically(3000, function(timeTask:TimedTask):Void {
			for(i in 0...16) imgs[i + 1].slideBy(0, 4, 1.5, Quad.easeInOut);
			imgs[0].fadeTo(100, 1.5, Quad.easeInOut);
			Script.runLater(1500, function(timeTask:TimedTask):Void {
				for(i in 0...16) imgs[i + 1].slideBy(0, -4, 1.5, Quad.easeInOut);
				imgs[0].fadeTo(66, 1.5, Quad.easeInOut);
			}, null);
		}, null);

		// Create indicator/kill old indicator when entering region
		addActorEntersRegionListener(activationRegion, function(a:Actor, list:Array<Dynamic>):Void {
			if(Script.sameAsAny(Script.getActorGroup(0),a.getType(),a.getGroup())){
				killIndicator();
				createIndicator();
			}
		});

		// Kill indicator when exiting region
		addActorExitsRegionListener(activationRegion, function(a:Actor, list:Array<Dynamic>):Void {
			if(Script.sameAsAny(Script.getActorGroup(0),a.getType(),a.getGroup())){ killIndicator(); }
		});

		actor.disableActorDrawing();
	}

	public inline function update(elapsedTime:Float){
		if(Script.isKeyPressed("action1")){
			for(actorOfGroup in cast(Script.getActorGroup(0), Group).list){
				if(actorOfGroup != null && !actorOfGroup.dead && !actorOfGroup.recycled){
					if(Script.isInRegion(actorOfGroup, activationRegion)){
						if(!Util.getAttr("saveCooldown") && !Util.inDialog()){
							var box:scripts.ui.UI_SaveBox = new scripts.ui.UI_SaveBox();
							Util.setAttr("saveLocationName", saveLocationName);
							box.init();
							box.show();
						}
					}
				}
			}
		}
	}

	function createIndicator():Void { Script.createRecycledActorOnLayer(Script.getActorTypeByName("gfx_gwlSvPrompt"), 0, 0, Script.FRONT, "above"); }
	function killIndicator():Void { for(actor in Script.getActorsOfType(Script.getActorTypeByName("gfx_gwlSvPrompt"))){ Script.recycleActor(actor); } }
}