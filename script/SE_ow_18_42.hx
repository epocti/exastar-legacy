package scripts;

import scripts.tools.Util;
import com.stencyl.graphics.G;
import com.stencyl.behavior.Script.*;
import com.stencyl.behavior.SceneScript;
import com.stencyl.behavior.TimedTask;
import com.stencyl.models.Region;
import com.stencyl.Engine;
import motion.easing.Linear;

class SE_ow_18_42 extends SceneScript {
	var madisonTalk:Region = createBoxRegion((getActor(2).getX() - 16), ((getActor(2).getY() + (getActor(2).getHeight())) - 16), ((getActor(2).getWidth()) + 32), 32);
	var madisonGuard:Region = createBoxRegion(560, 818, 65, 4);

    public function new(dummy:Int, dummy2:Engine){
		super();	
		addWhenUpdatedListener(null, onUpdate);
		addWhenDrawingListener(null, onDraw);
	}
	public function onUpdate(elapsedTime:Float, list:Array<Dynamic>){ update(elapsedTime); }
	public function onDraw(g:G, x:Float, y:Float, list:Array<Dynamic>){ draw(g); }
	
	// ========
	
	override public function init(){
		// VVV THIS LINE IS HERE FOR DEBUG VVV
		Util.setCurrentSceneState(0);
		// Initial state
		if(Util.getCurrentSceneState() == 0){
			Util.disableMovement();
			Util.disableStatOverlay();
			Util.disableMenu();
			Util.setFlag("hasTriedLeavingFest", false);
			Script_Emotive.setAnim("alex", "sleep", "d", false, false);
			dialog.core.Dialog.cbCall("cscene_wakeup1", "style_main", this, "ev1");
		}
		else if(Util.getCurrentSceneState() == 1){
			removeRegion(1);
		}
	}
	
	public inline function update(elapsedTime:Float){
		// Dialog (prompted)
		if(isKeyPressed("action1")){
			if(isInRegion(getActor(1), getRegion(0)) && !Util.inDialog()){
				dialog.core.Dialog.cbCall("dg_fest_sign1", "style_main", this, "");
			}
			else if(isInRegion(getActor(1), getRegion(3)) && !Util.inDialog()){
				dialog.core.Dialog.cbCall("dg_fest_signRelief1", "style_main", this, "");
			}
			else if(isInRegion(getActor(1), getRegion(4)) && !Util.inDialog()){
				dialog.core.Dialog.cbCall("dg_fest_signRelief2", "style_main", this, "");
			}
			else if((isInRegion(getActor(1), madisonTalk) && !Util.inDialog()) && Util.getCurrentSceneState() == 1){
				dialog.core.Dialog.cbCall("dg_fest_madiBother", "style_main", this, "");
			}
		}
		// Initial events
		if(Util.getCurrentSceneState() == 0){
			if(isInRegion(getActor(1), getRegion(1)) && !Util.inDialog()){
				Util.setCurrentSceneState(1);
				removeRegion(1);
				madisonTalk.setX(getActor(2).getX() + 12);
				madisonTalk.setY((getActor(2).getY() + (getActor(2).getHeight())) - 4);
				Util.disableMovement();
				Script_Emotive.setAnim("alex", "n", "u", false, false);
				dialog.core.Dialog.cbCall("dg_fest_wakeup2", "style_main", this, "");
			}
		}
		// Trying to go the other way in the beginning area
		if((isInRegion(getActor(1), getRegion(2)) && !Util.inDialog()) && !Util.getFlag("hasTriedLeavingFest")){
			if(Util.getCurrentSceneState() == 0){
				Util.disableMovement();
				dialog.core.Dialog.cbCall("dg_fest_noLeave", "style_main", this, "");
			}
			else dialog.core.Dialog.cbCall("generalError", "style_main", this, "");
			Util.setFlag("hasTriedLeavingFest", true);
		}
		// Caught trying to leave by Madison
		if((isInRegion(getActor(1), madisonGuard) && !Util.inDialog()) && !Util.movementIsDisabled()){
			if(Util.getCurrentSceneState() == 1){
				Util.disableMovement();
				Script_Emotive.setAnim("alex", "caught", "d", false, false);
				dialog.core.Dialog.cbCall("dg_fest_madiCatch", "style_main", this, "caughtReturn");
			}
		}
		// Madison direction
		if(Util.getCurrentSceneState() >= 1){
			if(getActor(1).getY() > getActor(2).getY()) Script_Emotive.setDirection("madi", "d");
			else Script_Emotive.setDirection("madi", "u");
		}
	}
	
	public inline function draw(g:G){}

	// Alex wake/Madison leave
	public function ev1():Void {
		getActor(2).moveTo(584, 1104, 2, Linear.easeNone);
		Script_Emotive.setAnim("alex", "wake", "d", false, false);
		runLater(2000, function(timeTask:TimedTask):Void {
			Util.enableMovement();
			Script_Emotive.setAnim("alex", "n", "d", false, false);
			getActor(2).moveTo(584, 700, 2.5, Linear.easeNone);
		}, null);
	}
	// Caught trying to leave by Madison
	public function caughtReturn():Void {
		getActor(1).moveBy(0, -128, 1, Linear.easeNone);
		Script_Emotive.setAnim("alex", "n", "u", true, false);
		runLater(1000, function(timeTask:TimedTask):Void { Util.enableMovement(); }, null);
	}

	public function nTaskFestTents():Void {
		Util.quests().add("q_test");
		Util.enableMenu();
	}
}