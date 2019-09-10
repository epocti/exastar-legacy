package scripts.game;

import com.stencyl.models.Actor;
import scripts.tools.Util;
import com.stencyl.behavior.Script;
import com.stencyl.models.Region;

// Need: Region, disable movement flag, dialog chunk, main override, direction

class DialogZone {
	var script:Script = new Script();
	public var enabled:Bool = true;
	var dialogRegion:Region;
	var chunk:String;
	var disableMovement:Bool;
	var playerDir:String;

	public function new(chunk:String = "generalError", x:Float, y:Float, width:Float = 2, height:Float = 2, disableMovement:Bool = true, dir:String = "u"){
		this.chunk = chunk;
		this.disableMovement = disableMovement;
		this.playerDir = dir;
		dialogRegion = Script.createBoxRegion(x, y, width, height);

		// Keypress check
		script.addWhenUpdatedListener(null, function(elapsedTime:Float, list:Array<Dynamic>):Void {
			for(actor in Script.getActorsInRegion(dialogRegion)){
				if(actor.getGroup() == Script.getGroupByName("Players")){
					// Final validation before dialog is called
					if((Script.isKeyPressed("action1") && !Util.inDialog()) && !Util.getAttr("bttlTransitionStatus")){
						// Set parameters accordingly
						if(disableMovement) Util.disableMovement();
						if(dir != "n") Script_Emotive.setDirection("alex", dir);
						killIndicator();
						// Call dialog
						dialog.core.Dialog.cbCall(chunk, "style_main", this, "");
					}
				}
			}
		});

		// Create indicator/kill old indicator when entering region
		script.addActorEntersRegionListener(dialogRegion, function(a:Actor, list:Array<Dynamic>):Void {
			if(Script.sameAsAny(Script.getActorGroup(0),a.getType(),a.getGroup())){
				killIndicator();
				createIndicator();
			}
		});

		// Kill indicator when exiting region
		script.addActorExitsRegionListener(dialogRegion, function(a:Actor, list:Array<Dynamic>):Void {
			if(Script.sameAsAny(Script.getActorGroup(0),a.getType(),a.getGroup())){ killIndicator(); }
		});
	}

	function createIndicator():Void { Script.createRecycledActorOnLayer(Script.getActorTypeByName("gfx_gwlDgPrompt"), 0, 0, Script.FRONT, "above"); }
	function killIndicator():Void { for(actor in Script.getActorsOfType(Script.getActorTypeByName("gfx_gwlDgPrompt"))){ Script.recycleActor(actor); } }
}