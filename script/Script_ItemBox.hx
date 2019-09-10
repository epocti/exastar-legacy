package scripts;

import scripts.tools.Util;
import scripts.ui.UI_ItemGet;
import com.stencyl.models.Region;
import com.stencyl.behavior.Script;
import com.stencyl.behavior.TimedTask;
import scripts.tools.EZImgInstance;
import com.stencyl.behavior.ActorScript;
import com.stencyl.models.Actor;
import com.stencyl.models.actor.Group;
import com.stencyl.Engine;
import dialog.core.Dialog;

class Script_ItemBox extends ActorScript {
	@:attribute("id='1' name='Item' desc=''")
	public var item:String = "test";
	@:attribute("id='2' name='Item Amount' desc='Should be in the range of 1-99.'")
	public var amt:Int = 1;
	@:attribute("id='3' name='Box ID' desc='Relative to this scene.'")
	public var id:Int = 0;
	var sceneBoxList:Array<Int>;
	var ui:UI_ItemGet;
	var img:EZImgInstance = new EZImgInstance("g", false, "env.itemBox.closed");
	var activationRegion:Region;
	var opened:Bool = false;

    public function new(dummy:Int, actor:Actor, dummy2:Engine){
		super(actor);
		addWhenUpdatedListener(null, onUpdate);
	}
	public function onUpdate(elapsedTime:Float, list:Array<Dynamic>){ update(elapsedTime); }

	// ========

	override public function init(){
		actor.disableActorDrawing();
		img.attachToWorld(actor.getLayerName(), actor.getX(), actor.getY(), actor.getLayerOrder());
		activationRegion = Script.createBoxRegion((actor.getX() - 8), ((actor.getY() + (actor.getHeight())) - 17), 37, 24);

		if(Util.getAttr("openedBoxes").exists(Script.getCurrentSceneName())){
			// Copy scene's openedbox list since stencyl complains about getattr returning dynamic
			sceneBoxList = Util.getAttr("openedBoxes").get(Script.getCurrentSceneName());
			// Check if box was already opened
			for(id in sceneBoxList) if(this.id == id) opened = true;
			// ...and set the animation if so
			if(opened) img.changeImage("env.itemBox.opened");
		}
		else {
			Util.getAttr("openedBoxes").set(Script.getCurrentSceneName(), new Array<Int>());
		}
	}

	public inline function update(elapsedTime:Float){
		if(!opened && !(item == "empty")){
			if((Script.isKeyPressed("action1") && !Util.inDialog()) && !Util.getAttr("battleTransitionStatus")){
				for(actorOfGroup in cast(Script.getActorGroup(0), Group).list){
					if(actorOfGroup != null && !actorOfGroup.dead && !actorOfGroup.recycled){
						if(Script.isInRegion(actorOfGroup, activationRegion)){
							Util.getAttr("openedBoxes").get(Script.getCurrentSceneName()).push(id);
							Util.disableMovement();
							Script_Emotive.setWalk("alex", false);
							Util.enableInDialog();
							opened = true;
							img.enableAnimation("env.itemBox.anim", 7, 66, false);
							Script.runLater(500, function(timeTask:TimedTask):Void { ui = new UI_ItemGet(item, amt); }, null);
						}
					}
				}
			}
		}
		else if(!opened && item == "empty"){
			if((Script.isKeyPressed("action1") && !Util.inDialog()) && !Util.getAttr("battleTransitionStatus")){
				for(actorOfGroup in cast(Script.getActorGroup(0), Group).list){
					if(actorOfGroup != null && !actorOfGroup.dead && !actorOfGroup.recycled){
						if(Script.isInRegion(actorOfGroup, activationRegion)){
							Util.getAttr("openedBoxes").get(Script.getCurrentSceneName()).push(id);
							Util.disableMovement();
							Script_Emotive.setWalk("alex", false);
							opened = true;
							img.enableAnimation("env.itemBox.anim", 7, 66, false);
							Script.runLater(500, function(timeTask:TimedTask):Void {
								Dialog.cbCall("dg_emptyItemBox", "style_main", this, "");
								Script_Emotive.setAnim("alex", "ohWell", "d", false, false);
							}, null);
						}
					}
				}
			}		
		}
	}
}