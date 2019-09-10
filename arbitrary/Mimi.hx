/*
	This script (C) 2016 - 2019 Epocti.
	Description: Houses the complete Mimi console commandset for use with the console extension.
	Author: Kokoro
*/

package scripts.vixenkit;

import com.nmefermmmtools.debug.Console;
import scripts.tools.Util;
import com.stencyl.behavior.Script;
import com.stencyl.behavior.Script.*;
import scripts.assets.Assets;
import dialog.core.Dialog;
import motion.easing.Linear;
import com.stencyl.Engine;
import scripts.tools.Config;
import vixenkit.Tail;

class Mimi extends Script {
	var version:String = "Mimi v2.1 (ExaStar)";
	
	public function new(){
		super();
		
		Console.create();
		Util.setAttr("debugConsoleCreated", true);

		Console.writeText("Welcome to the debug console!");
		Console.writeText("Press CTRL+1 or type \"hide\" to hide, type \"help\" for help");

		Console.addCommand("hide", "Hides the console.", null, function(arguments:String):Void { Console.hide(); });

		Console.addCommand("info", "Prints system/program information.", null, function(arguments:String):Void {
			//Console.writeText("Program build date: " + Util.getBuildDate());
			Console.writeText('Program name: ExaStar');
			Console.writeText('Program version: ${Util.version}');
			Console.writeText('Console version: ${Console.VERSION}');
			Console.writeText('Commandset: $version');
			Console.writeText('OS: ${Sys.systemName()}');
			Console.writeText('Launch args: ${Sys.args()}');
			Console.writeText('Launch dir: ${Sys.getCwd()}');
			Console.writeText('CPU time: ${Sys.cpuTime()}');
			Console.writeText('Environment vars: ${Sys.environment()}');
		});

		Console.addCommand("tailconfig", "Sets configuration options for the Tail logging system. Does not affect previous messages.", "tailconfig (timestamp|cputime|fullclassname|functionname|linenumber|severity) (on|off)", function(arguments:String):Void {
			var arg:Array<String> = arguments.split(" ");
			if(arg.length == 3){
				if(arg[1] == "on" || arg[1] == "off"){
					if(arg[0] == "timestamp") Tail.writeTimestamps = Util.asBool(arg[1]);
					else if(arg[0] == "cputime") Tail.writeExecTimestamps = Util.asBool(arg[1]); 
					else if(arg[0] == "fullclassname") Tail.writeFullClassNames = Util.asBool(arg[1]);
					else if(arg[0] == "functionname") Tail.writeFunctionNames = Util.asBool(arg[1]); 
					else if(arg[0] == "linenumber") Tail.writeLineNumbers = Util.asBool(arg[1]);
					else if(arg[0] == "severity") Tail.writeSeverity = Util.asBool(arg[1]); 
					else Tail.log("Invalid argument for arg 1", 3);
				}
				else Tail.log("Invalid argument for arg 2", 3);
			}
			else if(arg.length > 4) Tail.log("Too many arguments", 3);
			else Tail.log("Too little arguments", 3);
		});

		// Toggle fullscreen
		Console.addCommand("fullscreen", "Toggles fullscreen.", null, function(arguments:String):Void { toggleFullScreen(); });

		// Reload scene
		Console.addCommand("reload", "Reloads the current scene.", null, function(arguments:String):Void { reloadCurrentScene(); });

		// Print game config
		Console.addCommand("dumpconfig", "Shows all of the current properties in the game's config file.", null, function(arguments:String):Void {
			Console.writeText(Config.asString());
		});

		// Switch scene. Can replace the scene switcher.
		Console.addCommand("scn", "Switches to the specified scene.", "scn (scenename). scenename MUST exist in the game or else it will crash.", function(arguments:String):Void {
			var arg:Array<String> = arguments.split(" ");
			if(arg.length == 2) Util.switchSceneImmediate(arg[0]);
			else if(arg.length > 2) Console.writeText("Too many arguments");
			else Console.writeText("Too little arguments");
		});

		// Get/set step size
		Console.addCommand("stepsize", "Get or set the current step size. This value is mainly used in physics calculations.", "stepsize (amt). amt is optional.", function(arguments:String):Void {
			var arg:Array<String> = arguments.split(" ");
			if(arg.length == 1) Console.writeText("" + getStepSize());
			else if(arg.length == 2) Engine.STEP_SIZE = Std.int(asNumber(arg[0]));
			else Console.writeText("Too many arguments");
		});

		// Get/set time scale
		Console.addCommand("timescale", "Get or set the current time scale. Currently unknown what this affects.", "timescale (amt). amt is optional.", function(arguments:String):Void {
			var arg:Array<String> = arguments.split(" ");
			if(arg.length == 1) Console.writeText("" + Engine.timeScale);
			else if(arg.length == 2) Engine.timeScale = asNumber(arg[0]);
			else Console.writeText("Too many arguments");
		});

		// Get/set ms per second
		Console.addCommand("mspersec", "Get or set the amount of milliseconds per second. Currently unknown what this affects.", "mspersec (amt). amt is optional.", function(arguments:String):Void {
			var arg:Array<String> = arguments.split(" ");
			if(arg.length == 1) Console.writeText("" + Engine.MS_PER_SEC);
			else if(arg.length == 2) Engine.MS_PER_SEC = Std.int(asNumber(arg[0]));
			else Console.writeText("Too many arguments");
		});

		// Go to debug menu
		Console.addCommand("dbgmenu", "Goes to the debug menu.", null, function(arguments:String):Void { Util.switchSceneImmediate("dbg_menu"); });

		// Go to asset viewer
		Console.addCommand("viewassets", "Goes to the asset viewer.", null, function(arguments:String):Void {
			if(!Assets.isDiskMode()) Util.switchSceneImmediate("dbg_assetViewer");
			else Console.writeText("Running in disk mode; no assets are loaded into the asset pool.");
		});

		// Force a gameover case
		Console.addCommand("kill", "Forces the game to do a gameover.", null, function(arguments:String):Void {
			Util.switchSceneImmediate("menu_gameover");
		});

		// Reset game (go to preload)
		Console.addCommand("reset", "Switches to the initial \"preload\" scene.", null, function(arguments:String):Void { Util.switchSceneImmediate("preload"); });

		// Debug collision drawing
		// TODO: multiple modes
		Console.addCommand("dbgdraw", "Enables debug drawing features.", "dbgdraw (collon|colloff|acton|actoff|velon|veloff|regon|regoff).", function(arguments:String):Void {
			var arg:Array<String> = arguments.split(" ");
			if(arg.length == 2){
				if(arg[0] == "collon") Script.enableDebugDrawing();
				else if(arg[0] == "colloff") Script.disableDebugDrawing();
				else if(arg[0] == "acton") setValueForScene("Script_SceneEssentials", "dbg_drawActorInfo", true);
				else if(arg[0] == "actoff") setValueForScene("Script_SceneEssentials", "dbg_drawActorInfo", false);
				else if(arg[0] == "velon") setValueForScene("Script_SceneEssentials", "dbg_drawActorVelo", true);
				else if(arg[0] == "veloff") setValueForScene("Script_SceneEssentials", "dbg_drawActorVelo", false);
				else if(arg[0] == "regon"){
					Util.showSpecialRegions = true;
					Tail.log("Please reload or move into a different scene to reflect this change!", 3);
				}
				else if(arg[0] == "regoff"){
					Util.showSpecialRegions = false;
					Tail.log("Please reload or move into a different scene to reflect this change!", 3);
				}
				else Console.writeText("Invalid argument");
			}
			else if(arg.length > 2) Console.writeText("Too many arguments");
			else Console.writeText("Too little arguments");
		});

		// Get mouse coordinates
		Console.addCommand("getmousecoords", "Returns the current screen and scene coordinates of the mouse.", null, function(arguments:String):Void {
			Console.writeText("screenX: " + getMouseX());
			Console.writeText("screenY: " + getMouseY());
			Console.writeText("worldX: " + getMouseWorldX());
			Console.writeText("worldY: " + getMouseWorldY());
		});

		// Show mouse coordinates (ingame)
		Console.addCommand("showmousecoords", "Toggles drawing the screen and scene coordinates of the mouse ingame.", null, function(arguments:String):Void {
			if(getValueForScene("Script_SceneEssentials", "dbg_drawMouseCoords")) setValueForScene("Script_SceneEssentials", "dbg_drawMouseCoords", false);
			else setValueForScene("Script_SceneEssentials", "dbg_drawMouseCoords", true);
			Console.writeText("Toggled mouse coordinate drawing.");
		});

		// Freelook
		Console.addCommand("freelook", "Toggles mouse-controlled camera to view the whole scene." , "No parameters.", function(arguments:String):Void {
			var arg:Array<String> = arguments.split(" ");
			if(arg.length == 1){
				if(getValueForScene("Script_SceneEssentials", "dbg_freelook")) setValueForScene("Script_SceneEssentials", "dbg_freelook", false);
				else setValueForScene("Script_SceneEssentials", "dbg_freelook", true);
				Console.writeText("Toggled freelook.");
			}
			else if(arg.length > 1) Console.writeText("Too many arguments");
			else Console.writeText("Too little arguments");
		});

		

		// Dump values of variables
		Console.addCommand("vardump", "Shows all global variables and their values.", null, function(arguments:String):Void {
			for(attr in Engine.engine.gameAttributes.keys()){ Console.writeText(attr + ": " + Util.getAttr(attr)); }
		});

		// Modify variables at runtime
		Console.addCommand("typeof", "Shows the type of the global variable specified.", "typeof (variable).", function(arguments:String):Void {
			var arg:Array<String> = arguments.split(" ");
			if(arg.length == 2) Console.writeText("" + Type.typeof(Util.getAttr(arg[0])));
			else if(arg.length > 2) Console.writeText("Too many arguments");
			else Console.writeText("Too little arguments");
		});

		// Dump party info
		Console.addCommand("partydump", "Shows the full information for all party members.", null, function(arguments:String):Void {
			Console.writeText("-- Active Party --");
			for(i in 0...Util.party().getMemberCount()){ Console.writeText(Util.party().getMember(i).toString()); }
			Console.writeText("-- Inactive Party --");
			for(i in 0...Util.inactiveParty().getMemberCount()){ Console.writeText(Util.inactiveParty().getMember(i).toString()); }
		});

		// Dump asset data
		Console.addCommand("assetdump", "Shows information on all loaded assets.", null, function(arguments:String):Void {
			if(Assets.isDiskMode()) Console.writeText("Running in disk mode; no assets are loaded into the asset pool.");
			else for(asset in 0...Math.round(Assets.getLoaded())){ Console.writeText(Assets.getTypeByIndex(asset) + " " + Assets.getPathByIndex(asset)); }
		});

		// List actors in game
		Console.addCommand("lsa", "Lists actors and actor types." , "lsa (game|screen).", function(arguments:String):Void {
			var arg:Array<String> = arguments.split(" ");
			if(arg.length == 2){
				if(arg[0] == "game") for(type in getAllActorTypes()) Console.writeText(type.toString());
				else if(arg[0] == "screen"){
					engine.allActors.reuseIterator = false;
					for(actorOnScreen in engine.allActors){
						if(actorOnScreen != null && !actorOnScreen.dead && !actorOnScreen.recycled && actorOnScreen.isOnScreenCache){
							Tail.log(actorOnScreen.getType().toString() + " " + actorOnScreen.getID() + " | " + actorOnScreen.getX() + ", " + actorOnScreen.getY(), 3);
						}
					}
					engine.allActors.reuseIterator = true;
				}
				else Console.writeText("Invalid argument");
			}
			else if(arg.length > 2) Console.writeText("Too many arguments");
			else Console.writeText("Too little arguments");
		});

		// List layers in scene
		Console.addCommand("lslayer", "Lists the layers that are in the current scene, from bottom to top." , "No parameters.", function(arguments:String):Void {
			var arg:Array<String> = arguments.split(" ");
			if(arg.length == 1){
				for(layer in engine.layers){
					Tail.log("Layer " + layer.ID + " - zindex " + engine.getOrderOfLayer(0, "" + layer.ID) + ", opac " + (layer.alpha * 100) + "%");
				}
			}
			else if(arg.length > 1) Console.writeText("Too many arguments");
		});

		// Toggle layer visibility
		Console.addCommand("togglelayer", "Toggles visibility for the specified layer." , "togglelayer (layerID).", function(arguments:String):Void {
			var arg:Array<String> = arguments.split(" ");
			if(arg.length == 2){
				if(getLayer(0, arg[0]) != null){
					if(getLayer(0, arg[0]).alpha > 0) hideTileLayer(0, arg[0]);
					else showTileLayer(0, arg[0]);
				}
				else Console.writeText("A layer with that ID does not exist");
			}
			else if(arg.length > 2) Console.writeText("Too many arguments");
			else Console.writeText("Too little arguments");
		});

		// Set layer alpha
		Console.addCommand("setlayeralpha", "Sets opacity for the specified layer in decimal format." , "togglelayer (layerID) (alpha).", function(arguments:String):Void {
			var arg:Array<String> = arguments.split(" ");
			if(arg.length == 3){
				if(getLayer(0, arg[0]) != null){
					getLayer(0, arg[0]).alpha = asNumber(arg[1]);
				}
				else Console.writeText("A layer with that ID does not exist");
			}
			else if(arg.length > 3) Console.writeText("Too many arguments");
			else Console.writeText("Too little arguments");
		});

		// Create actor
		Console.addCommand("spawn", "Creates an actor.", "spawn (actorType) (x) (y).", function(arguments:String):Void {
			var arg:Array<String> = arguments.split(" ");
			if(arg.length == 4) createRecycledActor(getActorTypeByName(arg[0]), asNumber(arg[1]), asNumber(arg[2]), MIDDLE);
			else if(arg.length > 4) Console.writeText("Too many arguments");
			else Console.writeText("Too little arguments");
		});

		// Slide actor
		Console.addCommand("slideto", "Slides an actor to an absolute coordinate.", "slideto (actorID) (x) (y) (duration).", function(arguments:String):Void {
			var arg:Array<String> = arguments.split(" ");
			if(arg.length == 5) getActor(Math.round(asNumber(arg[0]))).moveTo(asNumber(arg[1]), asNumber(arg[2]), asNumber(arg[3]), Linear.easeNone);
			else if(arg.length > 5) Console.writeText("Too many arguments");
			else Console.writeText("Too little arguments");
		});

		// Slide actor (rel)
		Console.addCommand("slideby", "Slides an actor by a relative coordinate.", "slideby (actorID) (+x) (+y) (duration).", function(arguments:String):Void {
			var arg:Array<String> = arguments.split(" ");
			if(arg.length == 5) getActor(Math.round(asNumber(arg[0]))).moveBy(asNumber(arg[1]), asNumber(arg[2]), asNumber(arg[3]), Linear.easeNone);
			else if(arg.length > 5) Console.writeText("Too many arguments");
			else Console.writeText("Too little arguments");
		});

		// Set anim (TODO: overloading)
		Console.addCommand("sanim", "Sets the EmotiveExtension animation for the specified character.", "sanim (cname) (emote) (dir) (iswalk) (istalk).", function(arguments:String):Void {
			var arg:Array<String> = arguments.split(" ");
			if(arg.length == 6) Script_Emotive.setAnim(arg[0], arg[1], arg[2], asBoolean(arg[3]), asBoolean(arg[4]));
			else if(arg.length > 6) Console.writeText("Too many arguments");
			else Console.writeText("Too little arguments");
		});

		// Set gravity
		Console.addCommand("grav", "Sets the scene gravity. Default is 0, 0.", "grav (x) (y).", function(arguments:String):Void {
			var arg:Array<String> = arguments.split(" ");
			if(arg.length == 3){
				setGravity(asNumber(arg[0]), asNumber(arg[1]));
			}
			else if(arg.length > 3) Console.writeText("Too many arguments");
			else Console.writeText("Too little arguments");
		});

		// Show dialog
		Console.addCommand("dg", "Shows a dialog chunk ingame.", "dg (chunkname) (msgRoute). msgRoute is optional.", function(arguments:String):Void {
			var arg:Array<String> = arguments.split(" ");
			if(arg.length == 2){
				// No msgRoute
				Dialog.cbCall(arg[0], "style_main", this, "");
			}
			else if(arg.length == 3){
				// msgRoute
				Dialog.cbCall(arg[0], "style_main", this, arg[1]);
			}
			else if(arg.length > 3) Console.writeText("Too many arguments");
			else Console.writeText("Too little arguments");
		});

		// Movement control
		Console.addCommand("movement", "Enables/disables movement.", "movement (on|off)", function(arguments:String):Void {
			var arg:Array<String> = arguments.split(" ");
			if(arg.length == 2){
				if(arg[0] == "on") Util.enableMovement();
				else if(arg[0] == "off") Util.disableMovement();
				else Console.writeText("Invalid argument");
			}
			else if(arg.length > 2) Console.writeText("Too many arguments");
			else Console.writeText("enableMovement is currently set to " + Util.movementIsEnabled());
		});

		// Movement control
		Console.addCommand("movement", "Enables/disables movement.", "movement (on|off)", function(arguments:String):Void {
			var arg:Array<String> = arguments.split(" ");
			if(arg.length == 2){
				if(arg[0] == "on") Util.enableMovement();
				else if(arg[0] == "off") Util.disableMovement();
				else Console.writeText("Invalid argument");
			}
			else if(arg.length > 2) Console.writeText("Too many arguments");
			else Console.writeText("enableMovement is currently set to " + Util.movementIsEnabled());
		});

		// Camerasnap control
		Console.addCommand("camerasnap", "Enables/disables camera snapping to the player.", "camsnap <on|off>", function(arguments:String):Void {
			var arg:Array<String> = arguments.split(" ");
			if(arg.length == 2){
				if(arg[0] == "on") Util.enableCameraSnapping();
				else if(arg[0] == "off") Util.disableCameraSnapping();
				else Console.writeText("Invalid argument");
			}
			else if(arg.length > 2) Console.writeText("Too many arguments");
			else Console.writeText("snapCamera is currently set to " + Util.cameraSnappingEnabled());
		});

		// Menu control
		Console.addCommand("menuenable", "Enables/disables the in-game menu.", "menuenable <on|off>", function(arguments:String):Void {
			var arg:Array<String> = arguments.split(" ");
			if(arg.length == 2){
				if(arg[0] == "on") Util.enableMenu();
				else if(arg[0] == "off") Util.disableMenu();
				else Console.writeText("Invalid argument");
			}
			else if(arg.length > 2) Console.writeText("Too many arguments");
			else Console.writeText("enableMenu is currently set to " + Util.menuIsEnabled());
		});

		// Sound mappings
		Console.addCommand("soundmap", "Shows each channel's currently playing sound.", "soundmap <chnum>", function(arguments:String):Void {
			var arg:Array<String> = arguments.split(" ");
			if(arg.length == 2){
				if(Std.parseInt(arg[0]) >= 0 && Std.parseInt(arg[0]) <= 31){
					if(engine.channels[Std.parseInt(arg[0])].currentClip != null) Console.writeText('Channel ${arg[0]}: ${engine.channels[Std.parseInt(arg[0])].currentClip.name}');
					else Console.writeText('Channel ${arg[0]} is not active.');
				}
				else Console.writeText("Invalid channel number; must be 0-31 inclusive.");
			}
			else if(arg.length > 2) Console.writeText("Too many arguments");
			else for(channel in engine.channels) if(channel.currentClip != null) Console.writeText('Channel ${channel.channelNum}: ${channel.currentClip.name}');
		});

		// Stop all sounds
		Console.addCommand("stopallsounds", "Stops all sounds that are currently playing.", null, function(arguments:String):Void {
			var arg:Array<String> = arguments.split(" ");
			if(arg.length >= 2){
				Console.writeText("Too many arguments");
			}
			else stopAllSounds();
		});

		// Quit the game
		Console.addCommand("quit", "Quits the game.", null, function(arguments:String):Void { Util.exitGame(); });

		// Dump asset data
		Console.addCommand("crash", "Crashes the game. But for what reason...?", null, function(arguments:String):Void {
			Util.switchSceneImmediate("lolthisscenewillneveractuallyexistsothegamewilljustcrash");
		});

		// The fabled meat plate
		Console.addCommand("meatplate", "???", "???", function(arguments:String):Void {
			Console.writeText(" ( It is a secret to all. )");
			Console.writeText("            V");
			Console.writeText("");
			Console.writeText("    _.o#####.oOOOOnnn_");
			Console.writeText("    \\________________/");
		});
	}
}

/*
	To add listeners, create a new var of type "com.stencyl.Script" named "script", then add any of the following:
	Updating: script.addWhenUpdatedListener(null, function(elapsedTime:Float, list:Array<Dynamic>):Void {});
	Drawing: script.addWhenDrawingListener(null, function(g:G, x:Float, y:Float, list:Array<Dynamic>):Void {});
*/
