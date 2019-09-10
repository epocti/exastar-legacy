package scripts;

import scripts.tools.Config;
import scripts.vixenkit.Mimi;
import motion.easing.Linear;
import Type.ValueType;
import dialog.core.Dialog;
import com.nmefermmmtools.debug.Console;
import scripts.assets.Assets;
import scripts.game.QuestContainer;
import scripts.game.Party;
import scripts.tools.EZImgInstance;
import scripts.game.Inventory;
import scripts.id.FontID;
import scripts.tools.Util;
import com.stencyl.graphics.G;
import com.stencyl.graphics.BitmapWrapper;
import com.stencyl.behavior.Script;
import com.stencyl.behavior.Script.*;
import com.stencyl.behavior.SceneScript;
import com.stencyl.behavior.TimedTask;
import com.stencyl.models.Actor;
import com.stencyl.Engine;
import com.stencyl.utils.Utils;
import openfl.display.BitmapData;
import openfl.display.Bitmap;
import openfl.events.KeyboardEvent;
import motion.easing.Expo;
import vixenkit.Tail;
import scripts.gfx.GFX_StakeTransition;
import scripts.gfx.GFX_WaveTransition;

class Script_SceneEssentials extends SceneScript {
	// Menu
	@:attribute("id='2' name='Enable Scene Name Drawing' desc='Enable or disable the Scene Name tooltip that is displayed on scene start.'")
	var enableSceneNameDrawing:Bool = true;
	@:attribute("id='3' name='Scene Name' desc='The display name used for this scene when Scene Name Drawing is enabled.'")
	var sceneName:String = "!!!UNDEFINED!!!";
	var scnShotImg:EZImgInstance = new EZImgInstance("g", false, "kitsune_scnShotNotify");
	var scnShotImgOpacity:Int = 0;
	var scnNameImg:EZImgInstance = new EZImgInstance("g", true, "img_sceneNameIndicator");
	var scnNameX:Int = -160;
	// World
	@:attribute("id='4' name='X Gravity' desc='Negative goes left, positive goes right.'")
	var gravX:Int = 0;
	@:attribute("id='5' name='Y Gravity' desc='Negative goes up, positive goes down.'")
	var gravY:Int = 0;
	var depthList:Array<Dynamic>;
	// Quit indicator
	// var exitIndicBase:BitmapData;
	var exitIndic:EZImgInstance = new EZImgInstance("g", true, "img_exitIndicator");
	var quitMs:Int = 0;
	var devIndic:EZImgInstance = new EZImgInstance("g", true, "engine.protoBuildSticker");
	// Kitsune vars
	var scnshotInst:BitmapWrapper;
	var scnshot:BitmapData;
	@:attribute("id='6' name='Enable Screenshot Hotkey' desc=''")
	public var enableScnshot:Bool = true;
	@:attribute("id='7' name='Enable Transition Effect' desc=''")
	public var enableTransition:Bool = true;
	var console:Mimi;

	// Debug
	public var dbg_drawMouseCoords = false;
	public var dbg_drawActorInfo = false;
	public var dbg_drawActorVelo = false;
	public var dbg_freelook = false;

	public function new(dummy:Int, dummy2:Engine){
		super();
		addWhenUpdatedListener(null, onUpdate);
		addWhenDrawingListener(null, onDraw);
	}
	public function onUpdate(elapsedTime:Float, list:Array<Dynamic>){ update(elapsedTime); }
	public function onDraw(g:G, x:Float, y:Float, list:Array<Dynamic>){ draw(g); }

	// ==== this is everywhere ====

	override public function init(){
		// Debug mode is controlled by compiling to cppia
		if(#if cppia true #else false #end) Util.setAttr("debugMode", true);

		// Create debug console; you may want to comment this out if the game is crashing, as StreamGobbler will no longer work
		if(!Util.debugConsoleHasBeenCreated() && Util.inDebugMode()){
			console = new Mimi();
		}
		if(Util.inDebugMode()){
			Util.initGamepad();
		}

		// Reset controller mode in case the player switched back to keyboard input in between the last scene and now
		Util.controllerMode = false;
		// Check a for controller press to switch to controller input guides
		runLater(500, function(timeTask:TimedTask):Void {
			addAnyGamepadPressedListener(function(input:String, list:Array<Dynamic>):Void {
				if(!Util.controllerMode){
					Tail.log("Controller action detected - switching to controller mode.", 2);
					Util.controllerMode = true;
				}
			});
		}, null);
		

		if(!Util.currentSceneHasState()) Util.setCurrentSceneState(0);

		for(i in 0...32) setVolumeForChannel(1, i);
		
		// WARN: This is probably fine now that we have the debugMode check
		if(Util.inDebugMode()){
			Config.load();
			Util.loadStrings();
		}
		// WARN: temporary
		Util.setAttr("inventory", new Inventory());
		Util.setAttr("party", new Party(false));
		Util.party().add(0, 1, 100, 100, 100, 100, 0, 66);
		Util.party().add(1, 1, 100, 100, 100, 100, 0, 66);
		Util.party().add(2, 1, 100, 100, 100, 100, 0, 66);
		Util.setAttr("inactiveParty", new Party(true));
		Util.setAttr("quests", new QuestContainer());

		// TODO: this should be moved
		if(!Util.getAttr("madeAReallyCoolVar")){
			Util.setAttr("openedBoxes", new Map<String, Array<Int>>());
			Util.setAttr("madeAReallyCoolVar", true);
		}
		if(!Util.getAttr("openedBoxes").exists(getCurrentSceneName())){
			Util.getAttr("openedBoxes").set(getCurrentSceneName(), new Array<Int>());
		}

		// Image setup
		scnNameImg.drawText(sceneName, 3, 1, FontID.MAIN_WHITE);
		exitIndic.drawText(Util.getAttr("HUD_EXITGAMEINDIC"), 16, 1, FontID.MAIN_WHITE);

		// Development indicator
		devIndic.setXY(1, getScreenHeight() - devIndic.getHeight() - 1);
		devIndic.setAlpha(0);

		// Scene name img animation
		scnNameImg.setXY(-160, 20);
		scnNameImg.setAlpha(0);
		if(enableSceneNameDrawing){
			scnNameImg.setAlpha(0);
			scnNameImg.slideTo(0, 20, .75, Expo.easeOut);
			scnNameImg.fadeTo(100, .75, Expo.easeOut);
			runLater(3500, function(timeTask:TimedTask):Void {
				scnNameImg.slideTo(-160, 20, .75, Expo.easeOut);
				scnNameImg.fadeTo(0, .75, Expo.easeOut);
			}, null);
		}

		scnShotImg.setXY(Std.int((getScreenWidth() - 64)), 0);
		exitIndic.setXY(0, 20);

		Tail.log("Entered scene: " + getCurrentSceneName(), 2);

		setGravity(gravX, gravY);

		// Menu and statusbar defaults
		Util.setAttr("battleTransitionStatus", false);

		// test transition in from continue
		if(Util.getAttr("isTransitioning") && enableTransition){
			Util.setAttr("overrideAutoplace", true);
			//var transition:GFX_StakeTransition = new GFX_StakeTransition();
			var transition:GFX_WaveTransition = new GFX_WaveTransition();
			transition.createOut();
		}

		// Set last scene to the current scene for later use
		runLater(500, function(timeTask:TimedTask):Void { Util.getAttr("gs_loc").set("comingFrom", getCurrentSceneName()); }, null);

		// Input handling
		addAnyKeyPressedListener(function(event:KeyboardEvent, list:Array<Dynamic>):Void {
			// screenshot
			if(enableScnshot && event.keyCode == 220){
				scnShotImgOpacity = 0;
				scnshot = captureScreenshot();
				scnshotInst = new BitmapWrapper(new Bitmap(scnshot));
				Tail.log("Saving screenshot...", 2);
				FileSave.savePNG("screenshots/Screenshot-" + Date.now().getTime() + ".png", scnshot, function(success:Bool){
					if(success){
						Tail.log("Screenshot saved: /assets/data/screenshots/Screenshot-" + Date.now().getTime() + ".png", 2);
						scnShotImgOpacity = 100;
						runLater(1500, function(timeTask:TimedTask):Void { scnShotImgOpacity = 0; }, null);
					}
					else Tail.log("Failed to save screenshot. Check permissions for the game's \"data\" folder.", 5);
				});
			}
			// screenshot (disabled)
			else if(!enableScnshot && event.keyCode == 220) Tail.log("Hotkey disabled for this scene.", 4);
			// Fullscreen toggle
			else if(event.keyCode == 221 /* [ */){
				toggleFullScreen();
				Tail.log("Toggled fullscreen.", 2);
			}
			// Debug controls
			if(Util.inDebugMode()){
				// Debug menu
				if(event.keyCode == 192 /* ~ */){
					// Set flag for the "return" option in the debug menu
					Util.setAttr("dbgLastScene", getCurrentSceneName());
					Util.switchSceneImmediate("dbg_menu");
				}
				// Scene switcher
				else if(event.keyCode == 219 /* ] */) Util.switchSceneImmediate("dbg_sceneSwitcher");
			}
		});

		// Increase time played
		runPeriodically(1000, function(timeTask:TimedTask):Void { Util.getAttr("gs_stats").set("timePlayed", asNumber(Util.getAttr("gs_stats").get("timePlayed")) + 1); }, null);
	}

	public inline function update(elapsedTime:Float){
		// Y indexing stuff
		depthList = new Array<Dynamic>();
		engine.allActors.reuseIterator = false;
		for(actorOnScreen in engine.allActors) if(actorOnScreen != null && !actorOnScreen.dead && !actorOnScreen.recycled && actorOnScreen.isOnScreenCache) depthList.push(actorOnScreen);
		engine.allActors.reuseIterator = true;
		depthList.sort(SortY);
		for (i in 0...depthList.length) depthList[i].setZIndex(i);

		// Screenshot notifier opacity
		scnShotImg.setAlpha(scnShotImgOpacity);
		// Exit notifier
		if(isKeyDown("esc")){
			exitIndic.setAlpha(100);
			quitMs += 1;
			if(quitMs >= 150) exitGame();
		}
		else {
			exitIndic.setAlpha(0);
			quitMs = 0;
		}

		if(dbg_freelook){
			Util.disableCameraSnapping();
			engine.moveCamera(getMouseX() * (getSceneWidth() / getScreenWidth()), getMouseY() * (getSceneHeight() / getScreenHeight()));
		}
	}

	public inline function draw(g:G){
		g.setFont(getFont(FontID.MAIN_WHITE));
		// Debug mouse coord drawing
		if(dbg_drawMouseCoords){
			g.drawString("ScreenX: " + getMouseX(), getMouseX(), getMouseY());
			g.drawString("ScreenY: " + getMouseY(), getMouseX(), getMouseY() + 14);
			g.drawString("WorldX: " + getMouseWorldX(), getMouseX(), getMouseY() + 28);
			g.drawString("WorldY: " + getMouseWorldY(), getMouseX(), getMouseY() + 42);
		}
		if(dbg_drawActorInfo){
			engine.allActors.reuseIterator = false;
			for(actorOnScreen in engine.allActors){
				if(actorOnScreen != null && !actorOnScreen.dead && actorOnScreen.isOnScreenCache){
					if(actorOnScreen.hasBehavior("Script_Persistant")) g.setFont(getFont(683));
					else g.setFont(getFont(FontID.MAIN_WHITE));
					g.drawString(actorOnScreen.getType().toString() + " " + actorOnScreen.getID() + " | " + actorOnScreen.getX() + ", " + actorOnScreen.getY(), actorOnScreen.getScreenX(), actorOnScreen.getScreenY());
				}
			}
			engine.allActors.reuseIterator = true;
		}
		if(dbg_drawActorVelo){
			engine.allActors.reuseIterator = false;
			for(actorOnScreen in engine.allActors){
				if(actorOnScreen != null && !actorOnScreen.dead && actorOnScreen.isOnScreenCache){
					g.setFont(getFont(FontID.SMALL_WHITE));
					g.drawString("XV: "+ Util.round(actorOnScreen.getXVelocity()), actorOnScreen.getScreenX(), actorOnScreen.getScreenY());
					g.drawString("YV: " + Util.round(actorOnScreen.getYVelocity()), actorOnScreen.getScreenX(), actorOnScreen.getScreenY() + 10);
					g.drawString("A: " + Std.int(Utils.DEG * Math.atan2(actorOnScreen.getYVelocity(), actorOnScreen.getXVelocity())), actorOnScreen.getScreenX(), actorOnScreen.getScreenY() + 20);
				}
			}
			engine.allActors.reuseIterator = true;
		}
	}

	// Y indexing stuff
	function SortY(a:Actor, b:Actor):Int {
		//if((a.getY() + ((a.getHeight()/3) * 2) == (b.getY() + ((b.getHeight()/3) * 2)))) return 0;
		//if((a.getY() + ((a.getHeight()/3) * 2) > (b.getY() + ((b.getHeight()/3) * 2))))	return 1;

		if((a.getY() + a.getHeight()) == (b.getY() + b.getHeight())) return 0;
		if((a.getY() + a.getHeight()) > (b.getY() + b.getHeight()))	return 1;
		return -1;
	}
}