package scripts;

import scripts.tools.Util;
import com.stencyl.behavior.Script.*;
import com.stencyl.behavior.ActorScript;
import com.stencyl.behavior.TimedTask;
import com.stencyl.models.Actor;
import com.stencyl.models.Region;
import com.stencyl.Engine;

class Script_NPC extends ActorScript {
	@:attribute("id='1' name='Disable Wandering' desc=''")
	public var disableWandering:Bool = false;
	@:attribute("id='2' name='Disable Dialog' desc=''")
	public var disableDialog:Bool = false;
	@:attribute("id='3' name='Dialog Messages' desc='Type out dialog messages in here. Will be picked randomly. <b>Note that macros are NOT supported here!</b>'")
	public var dialogMessages:Array<Dynamic>;
	@:attribute("id='4' name='Prefer Dialog Chunks' desc='Uses dialog chunks from the Dashboard > Dialog Extension panel. Simply set the name of the dialog chunk - without the number - you would like to use.'")
	public var preferDialogChunks:Bool = false;
	@:attribute("id='5' name='Dialog Chunk Stem Name' desc=''")
	public var dialogChunkStemName:String = "";
	@:attribute("id='6' name='# of dialog chunks' desc=''")
	public var numDialogChunks:Float = 1;

	@:attribute("id='7' name='Up Animation' desc='' type='ANIMATION'")
	public var upAnim:String;
	@:attribute("id='8' name='Up Idle Animation' desc='' type='ANIMATION'")
	public var upAnimIdle:String;
	@:attribute("id='9' name='Down Animation' desc='' type='ANIMATION'")
	public var downAnim:String;
	@:attribute("id='10' name='Down Idle Animation' desc='' type='ANIMATION'")
	public var downAnimIdle:String;
	@:attribute("id='11' name='Left Animation' desc='' type='ANIMATION'")
	public var leftAnim:String;
	@:attribute("id='12' name='Left Idle Animation' desc='' type='ANIMATION'")
	public var leftAnimIdle:String;
	@:attribute("id='13' name='Right Animation' desc='' type='ANIMATION'")
	public var rightAnim:String;
	@:attribute("id='14' name='Right Idle Animation' desc='' type='ANIMATION'")
	public var rightAnimIdle:String;

	public var tempChance:Float = 0;
	public var doAction:Float = 0;
	public var talkRegion:Region;
	public var talkChance:Float = 0;
	public var lastWalkingDir:String = "d";

	public function new(dummy:Int, actor:Actor, dummy2:Engine){
		super(actor);
		addWhenUpdatedListener(null, onUpdate);
	}
	public function onUpdate(elapsedTime:Float, list:Array<Dynamic>){ update(elapsedTime); }

	// ========

	override public function init(){
		// Initialize talk region
		createBoxRegion((actor.getX() - 16), ((actor.getY() + (actor.getHeight())) - 16), ((actor.getWidth()) + 32), 32);
		talkRegion = getLastCreatedRegion();

		// Wandering
		runPeriodically(1500, function(timeTask:TimedTask):Void {
			if(!disableWandering){
				tempChance = randomInt(Math.floor(0), Math.floor(3));
				doAction = randomInt(Math.floor(0), Math.floor(7));
				if(tempChance == 0){
					if(doAction == 0){
						actor.setAnimation(upAnim);
						lastWalkingDir = "u";
						actor.setXVelocity(0);
						actor.setYVelocity(-4);
					}
					else if(doAction == 1){
						actor.setAnimation(downAnim);
						lastWalkingDir = "d";
						actor.setXVelocity(0);
						actor.setYVelocity(4);
					}
					else if(doAction == 2){
						actor.setAnimation(leftAnim);
						lastWalkingDir = "l";
						actor.setXVelocity(-4);
						actor.setYVelocity(0);
					}
					else if(doAction == 3){
						actor.setAnimation(rightAnim);
						lastWalkingDir = "r";
						actor.setXVelocity(4);
						actor.setYVelocity(0);
					}
					else {
						if(lastWalkingDir == "u") actor.setAnimation(upAnimIdle);
						else if(lastWalkingDir == "d") actor.setAnimation(downAnimIdle);
						else if(lastWalkingDir == "l") actor.setAnimation(leftAnimIdle);
						else actor.setAnimation("" + rightAnimIdle);
						actor.setXVelocity(0);
						actor.setYVelocity(0);
					}
				}
				else {
					if(lastWalkingDir == "u") actor.setAnimation(upAnimIdle);
					else if(lastWalkingDir == "d") actor.setAnimation(downAnimIdle);
					else if(lastWalkingDir == "l") actor.setAnimation(leftAnimIdle);
					else actor.setAnimation(rightAnimIdle);
					actor.setXVelocity(0);
					actor.setYVelocity(0);
				}
			}
		}, actor);
		
		addWhenUpdatedListener(null, function(elapsedTime:Float, list:Array<Dynamic>):Void {

		});
	}

	public inline function update(elapsedTime:Float){
		// Prevent actor from leaving scene/update talk region
		talkRegion.setLocation((actor.getX() - 16), ((actor.getY() + (actor.getHeight())) - 16));
		if(actor.getX() < 0){
			actor.setX(0);
			actor.setXVelocity(0);
		}
		if(actor.getY() < 0){
			actor.setY(0);
			actor.setYVelocity(0);
		}
		if(actor.getX() + actor.getWidth() > getSceneWidth()){
			actor.setX(getSceneWidth() - actor.getWidth());
			actor.setXVelocity(0);
		}
		if(actor.getY() + actor.getHeight() > getSceneHeight()){
			actor.setY(getSceneHeight() - actor.getHeight());
			actor.setYVelocity(0);
		}

		// Dialog
		if(isKeyPressed("action1")){
			if(!disableDialog){
				if(getActorsInRegion(talkRegion).length > 0){
					for(actorInRegion in getActorsInRegion(talkRegion)){
						if((actorInRegion != null && !actorInRegion.dead) && actorInRegion.getGroup() == getActorGroup(0)){
							if(!Util.inDialog()){
								if(!preferDialogChunks){
									talkChance = randomInt(Math.floor(1), Math.floor(dialogMessages.length));
									dialog.core.Dialog.cbCall(dialogMessages[Std.int(talkChance - 1)], "style_main", this, "");
								}
								else {
									if(numDialogChunks >= 1){
										talkChance = asNumber(randomInt(Math.floor(1), Math.floor(numDialogChunks)));
										dialog.core.Dialog.cbCall(dialogChunkStemName + talkChance, "style_main", this, "");
									}
									else dialog.core.Dialog.cbCall(dialogChunkStemName, "style_main", this, "");
								}
							}
						}
					}
				}
			}
		}
	}
}