package scripts.tools;

import com.stencyl.models.GameModel;
import com.stencyl.behavior.Script;
import com.stencyl.Engine;
import com.stencyl.Input;
import scripts.game.Inventory;
import scripts.game.QuestContainer;
import scripts.game.Party;
import haxe.macro.Context;
import vixenkit.Tail;
import motion.Actuate;
import motion.easing.Linear;

class Util {
	public static inline var version:String = "v3.1.2-4 [ALPHA]";

	public static var movement:Bool = true;
	public static var menuEnabled:Bool = true;
	public static var snapCamera:Bool = true;
	public static var hudEnabled = true;
	public static var showSpecialRegions = false;
	public static var controllerMode = false;
	public static var controllerType = "ps";
	//public static var debugMode = false;

	public static macro function getBuildDate(){
        var date = Date.now().toString();
        return Context.makeExpr(date, Context.currentPos());
    }

	public static function createTestDatabases():Void {
		// Test party definitions
		setAttr("party", new Party(false));
		setAttr("inactiveParty", new Party(true));
		// Alex, 100hp, 100mp, level 1
		getAttr("party").add(0, 1, 100, 100, 100, 100, 0, 66);
	}

	// Get/set common global attrs
	public static inline function getAttr(variable:String):Dynamic { return Engine.engine.getGameAttribute(variable); }
	public static inline function setAttr(variable:String, value:Dynamic):Void { return Engine.engine.setGameAttribute(variable, value); }

	public static function inventory():Inventory { return getAttr("inventory"); }
	public static function quests():QuestContainer { return getAttr("quests"); }
	public static function party():Party { return getAttr("party"); }
	public static function inactiveParty():Party { return getAttr("inactiveParty"); }

	public static function getFlag(variable:String):Dynamic { return getAttr("storyFlags").get(variable); }
	public static function setFlag(variable:String, value:Dynamic):Void { getAttr("storyFlags").set(variable, value); }

	public static function currentSceneHasState():Bool { return getAttr("sceneStates").exists(Script.getCurrentSceneName()); }
	public static function getCurrentSceneState():Dynamic { return getAttr("sceneStates").get(Script.getCurrentSceneName()); }
	public static function setCurrentSceneState(newState:Int):Void { getAttr("sceneStates").set(Script.getCurrentSceneName(), newState); }
	public static function getSceneState(sceneName:String):Dynamic { return getAttr("sceneStates").get(sceneName); }
	public static function setSceneState(sceneName:String, newState:Int):Void { getAttr("sceneStates").set(sceneName, newState); }

	public static function getCurrentFile():Int { return getAttr("currentFile"); }

	// Check/set if in dialog (used a lot)
	public static inline function enableInDialog():Void { setAttr("inDialog", true); }
	public static inline function disableInDialog():Void { setAttr("inDialog", false); }
	// inDialog works on a cooldown, not the direct var
	public static inline function inDialog():Bool { return getAttr("inDialog"); }

	// Check/set movement state
	public static inline function disableMovement():Void { movement = false; }
	public static inline function enableMovement():Void { movement = true; }
	public static inline function movementIsEnabled():Bool { return movement; }
	public static inline function movementIsDisabled():Bool { return !movement; }

	// Check/set menu openable
	public static inline function disableMenu():Void { menuEnabled = false; }
	public static inline function enableMenu():Void { menuEnabled = true; }
	public static inline function menuIsEnabled():Bool { return menuEnabled; }
	public static inline function menuIsDisabled():Bool { return !menuEnabled; }

	// Check/set camera snapping
	public static inline function enableCameraSnapping():Void { snapCamera = true; }
	public static inline function disableCameraSnapping():Void { snapCamera = false; }
	public static inline function cameraSnappingEnabled():Bool { return snapCamera; }
	public static inline function cameraSnappingDisabled():Bool { return !snapCamera; }

	// Check/set char stat overlay
	public static inline function enableStatOverlay():Void { hudEnabled = true; }
	public static inline function disableStatOverlay():Void { hudEnabled = false; }
	public static inline function statOverlayEnabled():Bool { return hudEnabled; }
	public static inline function statOverlayDisabled():Bool { return !hudEnabled; }

	// Find the middle of the screen
	public static inline function getMidScreenX():Float { return (Script.getScreenWidth() / 2); }
	public static inline function getMidScreenY():Float { return (Script.getScreenHeight() / 2); }

	// Check if the game is in debug mode
	public static inline function inDebugMode():Bool { return getAttr("debugMode"); }
	// Check if the debug console has been created
	public static inline function debugConsoleHasBeenCreated():Bool {
		return getAttr("debugConsoleCreated");
	}

	public static inline var BT_XB_A:String = "€";
	public static inline var BT_XB_B:String = "†";
	public static inline var BT_XB_X:String = "‡";
	public static inline var BT_XB_Y:String = "‰";

	public static inline var BT_NT_A:String = "€";
	public static inline var BT_NT_B:String = "†";
	public static inline var BT_NT_X:String = "‡";
	public static inline var BT_NT_Y:String = "‰";

	public static var BT_PS_0:String = Script.convertToPseudoUnicode("µ");
	public static var BT_PS_1:String = Script.convertToPseudoUnicode("£");
	public static var BT_PS_2:String = Script.convertToPseudoUnicode("§");
	public static var BT_PS_3:String = Script.convertToPseudoUnicode("¶");

	public static function initGamepad():Void {
		Tail.log("| (Re)initialize gamepad...", 2);
		Input.enableJoystick();
		Input.mapJoystickButton("0, up hat", "up");
		Input.mapJoystickButton("0, down hat", "down");
		Input.mapJoystickButton("0, left hat", "left");
		Input.mapJoystickButton("0, right hat", "right");
		Input.mapJoystickButton("0, -axis 1", "up");
		Input.mapJoystickButton("0, +axis 1", "down");
		Input.mapJoystickButton("0, -axis 0", "left");
		Input.mapJoystickButton("0, +axis 0", "right");
		Input.setJoySensitivity(.25);
		// dualshock controls
		Input.mapJoystickButton("0, 0", "action1");
		Input.mapJoystickButton("0, 1", "action2");
		Input.mapJoystickButton("0, 2", "action3");
		Input.mapJoystickButton("0, 3", "menu");
		Tail.log("|> Done.", 2);
	}
	
	//public static inline function getThisType():String {
	//	var tmp:String = Std.string(typeOf(this));
	//	return tmp.substring(tmp.lastIndexOf(".") + 1, tmp.length - 1);
	//}

	// String to boolean
	public static function asBool(x:String):Bool {
		return (x == "true" || x == "t") || x == "on";
	}

	public static inline function boolAsInt(x:Bool){
		if(x) return 1;
		else return 0;
	}

	// Load all string files
	public static function loadStrings():Void {
		// Create temporary storage for string filtering
		var tempStore:Map<String, String> = new Map<String, String>();
		var raw:Array<String> = DataUtils.getTextData("locale/" + Config.get("locale") + "/gameStrings.tsd").split("\r");
		// Filter strings into tags:values
		for(stringData in raw)
			if(!(stringData.indexOf('{') == -1)) tempStore.set(stringData.substring(1, stringData.indexOf('}')), stringData.substring(stringData.indexOf('}') + 1, stringData.length));
		// Set gameattr for permanent storage
		setAttr("strings", tempStore);
		Tail.log("Tagged string data loaded.", 2);
	}

	// Switch to another scene, but with no transition (for overworld)
	public static function switchSceneImmediate(sceneName:String):Void { Script.switchScene(GameModel.get().scenes.get(Script.getIDForScene(sceneName)).getID()); }

	// Get a string from a stringGroup
	public static inline function getString(id:String):String {
		if(getAttr("strings").get(id) == null) return "!!ERROR!!";
		else return Script.convertToPseudoUnicode(getAttr("strings").get(id));
	}

	// Get a string from a stringGroup, checking for variables and replacing as necessary
	public static inline function getStringWithVar(id:String, variables:Array<String>):String {
		if(getAttr("strings").get(id) == null) return "!!ERROR!!";
		else {
			var temp:String = getAttr("strings").get(id);
			for(i in 0...variables.length){
				temp = StringTools.replace(temp, "%"+i+"%", variables[i]);
			}
			return Script.convertToPseudoUnicode(temp);
		}
	}

	// Get a user-readable timestamp
	public static function getCurrentTime():String {
		var monthShort:String;
		switch(Date.now().getMonth()){
			case 0: monthShort = "Jan";
			case 1: monthShort = "Feb";
			case 2: monthShort = "Mar";
			case 3: monthShort = "Apr";
			case 4: monthShort = "May";
			case 5: monthShort = "Jun";
			case 6: monthShort = "Jul";
			case 7: monthShort = "Aug";
			case 8: monthShort = "Sept";
			case 9: monthShort = "Oct";
			case 10: monthShort = "Nov";
			case 11: monthShort = "Dec";
			default: monthShort = "what?";
		}
		return (monthShort + " " + Date.now().getDate() + " " + Date.now().getFullYear() + " @ " + Date.now().getHours() + ":" + Date.now().getMinutes());
	}

	// Round to a specific decimal point
	public static function round(number:Float, ?precision=2):Float {
		number *= Math.pow(10, precision);
		return Math.round(number) / Math.pow(10, precision);
	}

	// Change a key name in a map
	public static function setKey(map:Map<String, Dynamic>, oldKey:String, newKey:String):Void {
		var tempData:Dynamic = map.get(oldKey);
		map.remove(oldKey);
		map.set(newKey, tempData);
	}

	public static function fadeChannelTo(channel:Int, time:Float, initVol:Float, targetVol:Float):Void {
		Actuate.update(Script.setVolumeForChannel, time, [initVol, channel], [targetVol, channel]).ease(Linear.easeNone);
	}

	// Exit with some heartwarming text
	public static function exitGame():Void {
		Tail.log("Shutting down.", 2);
		Tail.log("Thanks for playing ExaStar! <3", 2);
		Script.exitGame();
	}

	var TRANSRIGHTS:Int;
}