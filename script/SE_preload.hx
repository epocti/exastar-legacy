package scripts;

import scripts.tools.Config;
import scripts.saves.SaveManager;
import com.polydes.datastruct.DataStructures;
import scripts.game.Inventory;
import scripts.game.Party;
import scripts.game.QuestContainer;
import openfl.events.KeyboardEvent;
import com.stencyl.graphics.G;
import com.stencyl.behavior.Script.*;
import com.stencyl.behavior.SceneScript;
import com.stencyl.behavior.TimedTask;
import com.stencyl.models.GameModel;
import com.stencyl.Engine;
import com.stencyl.Input;
import com.stencyl.utils.Utils;
import scripts.tools.Util;
import scripts.id.FontID;
import scripts.assets.Assets;
import vixenkit.Tail;

class SE_preload extends SceneScript {
	var errCode:Int = 0;

	public function new(dummy:Int, dummy2:Engine){
		super();
		addWhenDrawingListener(null, onDraw);
	}

	public function onDraw(g:G, x:Float, y:Float, list:Array<Dynamic>){ draw(g); }

	// ==== Remember that one loading screen from Kitsune 2.2? This is them now. Feel old yet? ====

	override public function init(){
		//runLater(500, function(timeTask:TimedTask):Void {
		//	var assets:Assets = new Assets();
		//}, null);

		Tail.log("-> Starting configuration...", 2);

		// Stop all sounds just cuz
		stopAllSounds();

		// Initialize gamepad
		Util.initGamepad();

		// Load game data / initialize game save files
		Tail.log("Load save data and config...", 2);
		SaveManager.LoadConfig();
		Tail.log("|> Done.", 2);

		Tail.log("Initializing data structures...", 2);
		DataStructures.initializeMaps();
		Tail.log("|> Done.", 2);
		Tail.log("Initializing data banks...", 2);
		Util.setAttr("quests", new QuestContainer());
		Util.setAttr("inventory", new Inventory());
		Util.setAttr("party", new Party(false));
		Util.setAttr("inactiveParty", new Party(true));

		Tail.log("Checking for save data...", 2);
		if(!Util.getAttr("filesInit")){
			Tail.log("No save data found, creating now...", 4);
			Util.getAttr("kitsuneConfig").set("keymap", CustomControls.getControlConfig());
			Tail.log("✓ Applied initial keymappings", 2);
			for(i in 0...5) AttributeSaving.saveData("headerLine1", "-- No Data --", i);
			for(i in 0...5) AttributeSaving.saveData("headerLine2", "", i);
			for(i in 0...5) AttributeSaving.saveData("headerLine3", new Array<Int>(), i);
			for(i in 0...5) AttributeSaving.saveData("written", false, i);
			Tail.log("✓ Created all files", 2);
			Util.setAttr("filesInit", true);
			Tail.log("✓ Prevented resetting files on next startup", 2);
		}
		else Tail.log("Save data found!", 2);
		SaveManager.SaveConfig();
		Config.load();
		Util.loadStrings();

		Tail.log("Load finished!", 2);

		// Apply configuration
		Tail.log("Applying configuration...", 2);

		// Apply screen scaling
		// TODO: this is doing nothing??
		Engine.screenScaleX = Std.parseInt(Config.get("scaleX"));
		Tail.log("Width scale: " + Engine.screenScaleX, 1);
		Engine.screenScaleY = Std.parseInt(Config.get("scaleY"));
		Tail.log("Height scale: " + Engine.screenScaleY, 1);

		// Apply fullscreen mode
		/*
		if(Engine.engine.isInFullScreen() && Config.get("fsos") == "true") Tail.log("Already in fullscreen. Not switching.", 2);
		else if(Engine.engine.isInFullScreen() && Config.get("fsos") == "false"){
			Tail.log("We're in fullscreen, but the config says we shouldn't be, toggling...", 4);
			toggleFullScreen();
		}
		else if(!Engine.engine.isInFullScreen() && Config.get("fsos") == "true"){
			Tail.log("We're not in fullscreen, and the config says we should be, toggling...", 4);
			toggleFullScreen();
		} */

		// Apply framerate
		Engine.stage.frameRate = Std.int(Config.get("framerate"));
		Tail.log("Framerate: " + Config.get("framerate"), 2);

		// Apply controls
		CustomControls.applyControlConfig(Config.get("keymap"));
		Tail.log("Controls: " + Config.get("keymap"), 2);

		// Increment powerons for the stats
		Util.setAttr("gamePowerOns", (Util.getAttr("gamePowerOns") + 1));
		Tail.log("You have opened the game " + Util.getAttr("gamePowerOns") + " time(s), congrats", 2);

		Tail.log("|-> Configuration complete.", 2);

		// Move on to epocti logo screen
		if(errCode == 0){
			if(!Util.asBool(Config.get("skipExastart"))) runLater(1000, function(timeTask:TimedTask):Void { Util.switchSceneImmediate("logo_epocti_new"); }, null);
			else Util.switchSceneImmediate("logo_epocti_new");
		}

		addAnyKeyPressedListener(function(event:KeyboardEvent, list:Array<Dynamic>):Void { if(errCode == 0) Util.switchSceneImmediate("logo_epocti_new"); });
	}

	public inline function draw(g:G){
		g.setFont(getFont(FontID.MAIN));
		g.drawString("Loading...", 23, getScreenHeight() - 18);
		g.setFont(getFont(FontID.MAIN_WHITE));
		g.strokeSize = 0;
		g.fillColor = Utils.getColorRGB(220, 220, 220);
		g.fillCircle(10, getScreenHeight() - 10, 8);
		g.fillColor = Utils.getColorRGB(0, 0, 0);
		/* if(animCounter + ((Assets.getLoaded() / Assets.getTotal()) * 360) < 540) */ DrawCircles.drawWedge(g, true, true, 10, getScreenHeight() - 10, /*animCounter*/-90, /*animCounter*/-90 + ((Assets.getLoaded() / Assets.getTotal()) * 360), 8);
		// g.drawString(Util.getString("preload", 0), 1, (getScreenHeight() - getFont(FontID.MAIN_WHITE).getHeight() / Engine.SCALE));
		//if(errCode == 0) g.drawString(Util.getString("PL_CONFIGURE"), 2, (getScreenHeight() - getFont(FontID.MAIN_WHITE).getHeight() / Engine.SCALE));
		if(errCode == 1){
			Tail.log("Launch error 1 - Unsupported platform", 6);
			g.drawString("Error 01", 1, 1);
			g.drawString("It is currently not possible to run ExaStar on this platform.", 1, 16);
		}
		if(errCode == 2){
			Tail.log("Launch error 2 - Evaluation time over", 6);
			g.drawString("Error 02", 1, 1);
			g.drawString("This is a limited release of ExaStar.", 1, 16);
			g.drawString("The demo time is now over. Please request a new copy if need be.", 1, 32);
		}
	}
}
