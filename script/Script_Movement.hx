package scripts;

import com.stencyl.behavior.Script.*;
import com.stencyl.behavior.ActorScript;
import com.stencyl.models.Actor;
import com.stencyl.Engine;
import com.stencyl.utils.Utils;
import com.stencyl.behavior.TimedTask;
import com.stencyl.Input;
import scripts.tools.Util;

class Script_Movement extends ActorScript {
	// Controls
	@:attribute("id='1' name='Up Control' desc='' type='CONTROL'")
	public var _UpControl:String;
	@:attribute("id='2' name='Down Control' desc='' type='CONTROL'")
	public var _DownControl:String;
	@:attribute("id='3' name='Left Control' desc='' type='CONTROL'")
	public var _LeftControl:String;
	@:attribute("id='4' name='Right Control' desc='' type='CONTROL'")
	public var _RightControl:String;

	// Movement params
	@:attribute("id='5' name='Walking Speed' desc='Speed used by default.' default='13'")
	public var walkSpeed:Float = 13;
	@:attribute("id='6' name='Jogging Speed' desc='Speed used when holding action2.' default='20'")
	public var jogSpeed:Float = 20;
	@:attribute("id='7' name='Running Speed' desc='Speed used when holding action3 after getting the run ability, or during Active Battles.' default='26'")
	public var runSpeed:Float = 26;
	@:attribute("id='8' name='Debug Sprint Speed' desc='If holding action3 in debugMode while not having the run ability, this speed is used.' default='42'")
	public var sprintSpeed:Float = 42;
	var currentSpeed:Float = 0;
	
	// Options
	@:attribute("id='9' name='Use Controls' desc=''")
	public var useControls:Bool;
	@:attribute("id='10' name='Use Animations' desc=''")
	public var useAnimations:Bool;

	var moveX:Float;
	var moveY:Float;

	public function new(dummy:Int, actor:Actor, dummy2:Engine){
		super(actor);
		addWhenUpdatedListener(null, onUpdate);
	}
	public function onUpdate(elapsedTime:Float, list:Array<Dynamic>){ update(elapsedTime); }

	// ==== What if we take the prepackaged 8way behavior, and require EMOTIVE TOO? ====

	override public function init(){ Script_Emotive.setAnim(actor.getValue("Script_Emotive", "internalName"), "n", "d", false, false); }

	public inline function update(elapsedTime:Float){
		if(Util.movementIsEnabled()){
			// If contollerMode is active, use tilt amount on the joystick to control moveX/Y granularly
			// TODO: check the config for dpad/digital setting	
			if(useControls){
				// Keyboard/dpad
				if(!Util.controllerMode){
					moveX = asNumber(isKeyDown(_RightControl)) - asNumber(isKeyDown(_LeftControl));
					moveY = asNumber(isKeyDown(_DownControl)) - asNumber(isKeyDown(_UpControl));
				}
				// Controller
				else {
					moveX = Input.getButtonPressure("right") - Input.getButtonPressure("left");
					moveY = Input.getButtonPressure("down") - Input.getButtonPressure("up");
				}
			}

			// Set the current speed
			if(isKeyDown("action3") && Util.inDebugMode()) currentSpeed = sprintSpeed;
			else if(isKeyDown("action2")) currentSpeed = jogSpeed;
			else currentSpeed = walkSpeed;
			
			// Actual movement velocity set
			actor.setVelocity(getDir(), currentSpeed);
			
			// Prevent continually moving if not pressing a horiz/vert button
			if(moveX == 0) actor.setXVelocity(0);
			if(moveY == 0) actor.setYVelocity(0);
			
			// Set animations, based on angle
			if(useAnimations){
				if(actor.getXVelocity() == 0 && actor.getYVelocity() == 0) Script_Emotive.setWalk(actor.getValue("Script_Emotive", "internalName"), false);
				else {
					Script_Emotive.pointTowards(actor.getValue("Script_Emotive", "internalName"), getDir());
					Script_Emotive.setWalk(actor.getValue("Script_Emotive", "internalName"), true);
				}
			}

			// Reset
			moveX = 0;
			moveY = 0;
		}
		// If movement is disabled, freeze the actor every single frame
		else {
			actor.setXVelocity(0);
			actor.setYVelocity(0);
		}
	}

	function getDir():Float {
		return Utils.DEG * Math.atan2(moveY, moveX);
	}

	public function MoveUp():Void { if(Util.movementIsEnabled()) moveY = -1; }
	public function MoveDown():Void { if(Util.movementIsEnabled()) moveY = 1; }
	public function MoveLeft():Void { if(Util.movementIsEnabled()) moveX = -1; }
	public function MoveRight():Void { if(Util.movementIsEnabled()) moveX = 1; }
}