package scripts;

import motion.easing.Quad;
import scripts.assets.Assets;
import scripts.saves.SaveManager;
import scripts.gfx.GFX_StakeTransition;
import scripts.gfx.GFX_WaveTransition;
import scripts.tools.EZImgInstance;
import motion.Actuate;
import motion.easing.Linear;
import scripts.id.FontID;
import openfl.events.KeyboardEvent;
import com.stencyl.graphics.G;
import com.stencyl.behavior.Script;
import com.stencyl.behavior.Script.*;
import com.stencyl.behavior.SceneScript;
import com.stencyl.behavior.TimedTask;
import com.stencyl.models.GameModel;
import com.stencyl.Engine;
import com.stencyl.utils.Utils;
import scripts.tools.Util;

class SE_titleScreen extends SceneScript {
	//var g:RetainDrawLayer;
	var logo:EZImgInstance = new EZImgInstance("g", true, "logo.exaLogoDP");
	var welcomeOpac:Float = 0;
	var drawMode:Float = 0;
	var selectedMenuEntry:Int = 0;
	var transitioning:Bool = false;
	
	var fileboxes:Array<EZImgInstance> = new Array<EZImgInstance>();
	var partyChars:Array<Array<EZImgInstance>> = new Array<Array<EZImgInstance>>();
	var selectedFile:Int = 0;
	var confirmFilebox:EZImgInstance = new EZImgInstance("g", true, "ui.titleMenu.filebox");
	var selectedPartyChars:Array<EZImgInstance> = new Array<EZImgInstance>();
	
	var nameBox:EZImgInstance = new EZImgInstance("g", true, "ui.fc.namebox.nameBox1");
	var tempFileName:String = "";
	
	var componentLogos:Array<EZImgInstance> = new Array<EZImgInstance>();

	var incompatStatus:Int = 0;

    public function new(dummy:Int, dummy2:Engine){
		super();
		addWhenUpdatedListener(null, onUpdate);
		addWhenDrawingListener(null, onDraw);
	}
	public function onUpdate(elapsedTime:Float, list:Array<Dynamic>){ update(elapsedTime); }
	public function onDraw(g:G, x:Float, y:Float, list:Array<Dynamic>){ draw(g); }
	
	// ==== Hmmm... I wonder how much code here is still left from kitsune's titleScreen that was *supposed* to unify the title screens across games... ====

	/* Drawmodes:
		0: "Press anything" screen
		1: Main
		2: New game screen
		3: File selection
		4: Continue confirm
		5: New game enter name - cannot escape from this screen.
		6: About screen
		7: File incompatibility
	 */
	
	override public function init(){
		// Music
		loopSoundOnChannel(Assets.get("mus.title"), 0);

		Util.setAttr("controllerMode", false);
		drawMode = 0;

		logo.centerOnScreen(true, false);
		logo.setY(76);

		confirmFilebox.centerOnScreen(true, true);
		confirmFilebox.setAlpha(0);

		// Create fileboxes
		for(i in 0...5){
			fileboxes.push(new EZImgInstance("g", true, "ui.titleMenu.filebox"));
			fileboxes[i].setAlpha(0);
			fileboxes[i].setX(Std.int(((getScreenWidth() / 8) + ((getScreenWidth() / 8) / 10))) + 20);
			fileboxes[i].setY(24 + (i * (fileboxes[i].getHeight() + 2)));
		}

		// Party character images (headerLine3)
		for(i in 0...5){
			partyChars.push(new Array<EZImgInstance>());
			// Run only if there are actually party characters in the header
			if(AttributeSaving.loadData("headerLine3", i).length > 0){
				// Push images
				for(j in 0...AttributeSaving.loadData("headerLine3", i).length){ partyChars[i].push(new EZImgInstance("g", true, "ui.titleMenu." + AttributeSaving.loadData("headerLine3", i)[j])); }
				// Set locations
				for(j in 0...partyChars[i].length){ partyChars[i][j].setXY(90 + (j * 17), fileboxes[i].getY() + 36); }
			}
		}
		hideAllPartyChars();

		// Namebox defaults
		nameBox.setAlpha(0);
		nameBox.setOrigin("CENTER");
		nameBox.centerOnScreen(true, true);
		nameBox.enableAnimation("ui.fc.namebox.nameBox", 3, 100, true);

		// Engine component logos
		componentLogos.push(new EZImgInstance("g", true, "engine.component.stencylLogo"));
		componentLogos.push(new EZImgInstance("g", true, "engine.component.oflLogo"));
		componentLogos.push(new EZImgInstance("g", true, "engine.component.haxeLogo"));
		componentLogos.push(new EZImgInstance("g", true, "engine.component.vixenLogo"));
		for(i in 0...componentLogos.length){
			componentLogos[i].setXY(Std.int(((getScreenWidth() / 8) + ((getScreenWidth() / 8) / 10))) + 20, 190 + (i * 38));
			componentLogos[i].setAlpha(0);
		}

		// Press any button on controller
		addAnyGamepadPressedListener(function(input:String, list:Array<Dynamic>):Void {
			if(drawMode == 0){
				drawMode = 1;
				Util.setAttr("controllerMode", true);
			}
		});

		// Keycontrol
		addAnyKeyPressedListener(function(event:KeyboardEvent, list:Array<Dynamic>):Void {
			// Simple decrement/increment using arrow keys
			if(isKeyPressed("up")) {
				// Main screen
				if(drawMode == 1){
					if((selectedMenuEntry - 1) <= -1) selectedMenuEntry = 6;
					else selectedMenuEntry -= 1;
				}
				// New game
				else if(drawMode == 2 && !transitioning){
					if((selectedMenuEntry - 1) <= -1) selectedMenuEntry = 1;
					else selectedMenuEntry -= 1;
				}
				// File select
				else if(drawMode == 3){
					if((selectedMenuEntry - 1) <= -1) selectedMenuEntry = 5;
					else selectedMenuEntry -= 1;
				}
				// Confirm continue
				else if(drawMode == 4 && !transitioning){
					if((selectedMenuEntry - 1) <= -1) selectedMenuEntry = 1;
					else selectedMenuEntry -= 1;
				}
				// About
				else if(drawMode == 6){
					if((selectedMenuEntry - 1) <= -1) selectedMenuEntry = 4;
					else selectedMenuEntry -= 1;
				}
			}
			if(isKeyPressed("down")){
				// Main screen
				if(drawMode == 1){
					if((selectedMenuEntry + 1) >= 7) selectedMenuEntry = 0;
					else selectedMenuEntry += 1;
				}
				// New game
				else if(drawMode == 2 && !transitioning){
					if((selectedMenuEntry + 1) >= 2) selectedMenuEntry = 0;
					else selectedMenuEntry += 1;
				}
				// File select
				else if(drawMode == 3){
					if((selectedMenuEntry + 1) >= 6) selectedMenuEntry = 0;
					else selectedMenuEntry += 1;
				}
				// Confirm continue
				else if(drawMode == 4 && !transitioning){
					if((selectedMenuEntry + 1) >= 2) selectedMenuEntry = 0;
					else selectedMenuEntry += 1;
				}
				// About
				else if(drawMode == 6){
					if((selectedMenuEntry + 1) >= 5) selectedMenuEntry = 0;
					else selectedMenuEntry += 1;
				}
			}
			// Menu item selection
			if(isKeyPressed("action1")){
				// Main screen
				if(drawMode == 1){
					// Continue selected
					if(selectedMenuEntry == 0) toScreen(3);
					// New game selected
					else if(selectedMenuEntry == 1) toScreen(2);
					// About selected
					else if(selectedMenuEntry == 3) toScreen(6);
					// Feedback selected
					else if (selectedMenuEntry == 4) openURLInBrowser("redacted");
					// Bug report selected
					else if(selectedMenuEntry == 5) openURLInBrowser("redacted");
					// Quit selected
					else if(selectedMenuEntry == 6) Util.exitGame();
				}
				// New game screen
				else if(drawMode == 2){
					// Begin new game
					if(selectedMenuEntry == 0) toScreen(5);
					// Cancel and go back
					else if(selectedMenuEntry == 1) toScreen(1);
				}
				// File selection screen
				else if(drawMode == 3){
					// Select file
					if(selectedMenuEntry != 5) toScreen(4);
					// Cancel
					else toScreen(1);
				}
				// Continue confirm screen
				else if(drawMode == 4){
					// Continue game
					if(selectedMenuEntry == 0){
						if(SaveManager.LoadFile(selectedFile) == 0){
							transitioning = true;
							Util.setAttr("isTransitioning", true);
							fadeOutSoundOnChannel(2, 2);
							stopSoundOnChannel(0);
							//var trans:GFX_StakeTransition = new GFX_StakeTransition();
							var trans:GFX_WaveTransition = new GFX_WaveTransition();
							trans.createIn();
							SaveManager.LoadFile(selectedFile);
							Util.setAttr("currentFile", selectedFile);
							Util.setAttr("bufferTransfer", "savegame");
							runLater(4000, function(timeTask:TimedTask):Void {
								for(i in 0...3) stopSoundOnChannel(i);
								Util.switchSceneImmediate("buffer");
							}, null);
						}
						else {
							incompatStatus = SaveManager.LoadFile(selectedFile);
							toScreen(7);
						}
						
					}
					// Back to file select
					else toScreen(3);
				}
				// About back to main
				else if(drawMode == 6){
					if(selectedMenuEntry == 0) openURLInBrowser("http://stencyl.com");
					else if(selectedMenuEntry == 1) openURLInBrowser("http://openfl.org");
					else if(selectedMenuEntry == 2) openURLInBrowser("https://haxe.org");
					else if(selectedMenuEntry == 3) openURLInBrowser("about:blank");
					else if(selectedMenuEntry == 4) toScreen(1);
				}
				else if(drawMode == 7) toScreen(3);
			}
			if((isKeyPressed("action2") && ((drawMode == 2 || drawMode == 3) || drawMode == 6)) && !transitioning) toScreen(1);
			else if((isKeyPressed("action2") && (drawMode == 4 || drawMode == 7)) && !transitioning) toScreen(3);
			
			// press any key thing
			if(drawMode == 0) drawMode = 1;

			if(drawMode == 5 && !transitioning){
				if(event.keyCode == 8){
					playSoundOnChannel(Assets.get("sfx.key_backspace"), 1);
					tempFileName = tempFileName.substring(0, tempFileName.length - 1);
				}
				else if(event.keyCode == 13 && tempFileName != ""){
					playSoundOnChannel(Assets.get("sfx.key_enter"), 1);
					transitioning = true;
					Util.setAttr("fileName", tempFileName);
					Util.setAttr("bufferTransfer", "prologue");
					playSoundOnChannel(Assets.get("mus.newGameStart"), 0);
					switchScene(GameModel.get().scenes.get(66).getID(), createFadeOut(6.5, Utils.getColorRGB(255,255,255)), createFadeIn(.01, Utils.getColorRGB(0,0,0)));
				}
				else if((!(event.keyCode == 8) && !(event.keyCode == 13)) && (tempFileName.length <= 17)){
					if(event.keyCode == 32)
						playSoundOnChannel(Assets.get("sfx.key_space"), 1);
					else
						playSoundOnChannel(Assets.get("sfx.key" + randomInt(1,5)), 1);
					tempFileName = tempFileName + ("" + charFromCharCode(event.charCode));
				}
			}
		});

		// Text flash
		Actuate.tween(this, .5, {welcomeOpac:100}).ease(Linear.easeNone);
		runLater(1000, function(timeTask:TimedTask):Void { Actuate.tween(this, .5, {welcomeOpac:0}).ease(Linear.easeNone); }, null);
		runPeriodically(2000, function(timeTask:TimedTask):Void {
			Actuate.tween(this, .5, {welcomeOpac:100}).ease(Linear.easeNone);
			runLater(1000, function(timeTask:TimedTask):Void { Actuate.tween(this, .5, {welcomeOpac:0}).ease(Linear.easeNone); }, null);
		}, null);
	}

	public inline function update(elapsedTime:Float){
		// Resize the textbox if the text tries to escape
		nameBox.growTo(Std.int((getFont(FontID.MAIN).font.getTextWidth(tempFileName)/Engine.SCALE * 100) / 64) + 60, 100, .15, Quad.easeOut);
	}
	
	public inline function draw(g:G){
		// menu backing
		setDrawingLayerToSceneLayer();
		setDrawingLayer(0, "2");
		g.alpha = .6;
		g.fillColor = Utils.getColorRGB(0,0,0);
		g.strokeSize = 0;
		g.fillRect(((getScreenWidth() / 8) + ((getScreenWidth() / 8) / 10)), 0, (getScreenWidth() - (((getScreenWidth() / 8) + ((getScreenWidth() / 8) / 10)) * 2)), getScreenHeight());
		// Other menu stuff
		g.setFont(getFont(FontID.MAIN_WHITE));
		g.translateToScreen();
		Script.setDrawingLayerToSceneLayer();
		g.alpha = (welcomeOpac / 100);
		// "Press a key" thing
		if(drawMode == 0){
			g.drawString(Util.getString("TITLE_BEGIN"), ((getScreenWidth() / 2) - (getFont(FontID.MAIN_WHITE).font.getTextWidth(Util.getString("TITLE_BEGIN"))/Engine.SCALE / 2)), (((getScreenHeight() / 3) * 2) - (getFont(FontID.MAIN_WHITE).getHeight()/Engine.SCALE / 2)));
		}
		g.alpha = 1;
		// Main
		if(drawMode == 1){
			var strList:Array<String> = ["CONTINUE", "NEWGAME", "SETTINGS", "ABOUT", "ALPHAFEEDBACK", "ALPHABUGREP", "EXITGAME"];
			// draw menu elements
			for(i in 0...7) g.drawString(Util.getString("TITLE_" + strList[i]), (Util.getMidScreenX() - (getFont(FontID.MAIN_WHITE).font.getTextWidth(Util.getString("TITLE_" + strList[i]))/Engine.SCALE / 2)), (((getScreenHeight() / 3) + 48) + (i * 20)));
			// draw selector
			g.drawString("^", (Util.getMidScreenX() - 60), (((getScreenHeight() / 3) + 48) + (20 * selectedMenuEntry)));
		}
		// New game
		else if(drawMode == 2){
			g.drawString(Util.getString("TITLE_NEWGAMEHEAD"), (Util.getMidScreenX() - (getFont(FontID.MAIN_WHITE).font.getTextWidth(Util.getString("TITLE_NEWGAMEHEAD"))/Engine.SCALE / 2)), 4);
			g.strokeSize = 2;
			g.strokeColor = Utils.getColorRGB(255,255,255);
			g.drawLine(((getScreenWidth() / 8) + ((getScreenWidth() / 8) / 8)), 20, (getScreenWidth() - ((getScreenWidth() / 8) + ((getScreenWidth() / 8) / 8))), 20);
			g.drawString(Util.getString("TITLE_NEWGAMEQUESTION"), (Util.getMidScreenX() - (getFont(FontID.MAIN_WHITE).font.getTextWidth(Util.getString("TITLE_NEWGAMEQUESTION"))/Engine.SCALE / 2)), (getScreenWidth() / 3));
			g.drawString(Util.getString("TITLE_NEWGAMEQUESTION2"), (Util.getMidScreenX() - (getFont(FontID.MAIN_WHITE).font.getTextWidth(Util.getString("TITLE_NEWGAMEQUESTION2"))/Engine.SCALE / 2)), ((getScreenWidth() / 3) + 16));
			g.drawString(Util.getString("TITLE_YES"), ((getScreenWidth() / 2) - (getFont(FontID.MAIN_WHITE).font.getTextWidth(Util.getString("TITLE_YES"))/Engine.SCALE / 2)), ((getScreenHeight() / 3) * 2));
			g.drawString(Util.getString("TITLE_CANCEL"), ((getScreenWidth() / 2) - (getFont(FontID.MAIN_WHITE).font.getTextWidth(Util.getString("TITLE_CANCEL"))/Engine.SCALE / 2)), (((getScreenHeight() / 3) * 2) + 16));
			g.drawString("^", (Util.getMidScreenX() - 60), (((getScreenHeight() / 3) * 2) + (16 * selectedMenuEntry)));
		}
		else if(drawMode == 3){
			// Draw file numbers
			for(i in 0...5){
				g.drawString(AttributeSaving.loadData("headerLine1", i), fileboxes[0].getX() + 6, fileboxes[i].getY() + 6);
				g.drawString(AttributeSaving.loadData("headerLine2", i), fileboxes[0].getX() + 6, fileboxes[i].getY() + 22);
				g.drawString("" + (i + 1), 396, 48 + (i * (fileboxes[i].getHeight() + 1)));
			}
			g.drawString("< " + Util.getString("TITLE_BACK"), fileboxes[0].getX(), getScreenHeight() - 16);
			if(selectedMenuEntry <= 4) g.drawString("^", ((getScreenWidth() / 8) + ((getScreenWidth() / 8) / 10)) + 6, 48 + (selectedMenuEntry * (fileboxes[selectedMenuEntry].getHeight() + 1)));
			else g.drawString("^", ((getScreenWidth() / 8) + ((getScreenWidth() / 8) / 10)) + 6, 340);
		}
		else if(drawMode == 4){
			g.drawString(AttributeSaving.loadData("headerLine1", selectedFile), confirmFilebox.getX() + 6, confirmFilebox.getY() + 6);
			g.drawString(AttributeSaving.loadData("headerLine2", selectedFile), confirmFilebox.getX() + 6, confirmFilebox.getY() + 22);
			g.drawString("" + (selectedFile + 1), 390, confirmFilebox.getY() + 25);
			g.drawString(Util.getString("TITLE_CONTINUECONFIRM"), ((getScreenWidth() / 2) - (getFont(FontID.MAIN_WHITE).font.getTextWidth(Util.getString("TITLE_CONTINUECONFIRM"))/Engine.SCALE / 2)), ((getScreenHeight() / 3) * 2));
			g.drawString(Util.getString("TITLE_FILENAME"), ((getScreenWidth() / 2) - (getFont(FontID.MAIN_WHITE).font.getTextWidth(Util.getString("TITLE_FILENAME"))/Engine.SCALE / 2)), (((getScreenHeight() / 3) * 2) + 16));
			g.drawString(Util.getString("TITLE_FILEERASE"), ((getScreenWidth() / 2) - (getFont(FontID.MAIN_WHITE).font.getTextWidth(Util.getString("TITLE_FILEERASE"))/Engine.SCALE / 2)), ((getScreenHeight() / 3) * 2) + 32);
			g.drawString(Util.getString("TITLE_CANCEL"), ((getScreenWidth() / 2) - (getFont(FontID.MAIN_WHITE).font.getTextWidth(Util.getString("TITLE_CANCEL"))/Engine.SCALE / 2)), (((getScreenHeight() / 3) * 2) + 48));
			g.drawString("^", (Util.getMidScreenX() - 60), (((getScreenHeight() / 3) * 2) + (16 * selectedMenuEntry)));
		}
		else if(drawMode == 5){
			g.drawString(Util.getString("TITLE_NEWGAMEHEAD"), (Util.getMidScreenX() - (getFont(FontID.MAIN_WHITE).font.getTextWidth(Util.getString("TITLE_NEWGAMEHEAD"))/Engine.SCALE / 2)), 4);
			g.strokeSize = 2;
			g.strokeColor = Utils.getColorRGB(255,255,255);
			g.drawLine(((getScreenWidth() / 8) + ((getScreenWidth() / 8) / 8)), 20, (getScreenWidth() - ((getScreenWidth() / 8) + ((getScreenWidth() / 8) / 8))), 20);

			g.drawString(Util.getString("FC_ENTERNAME"), ((getScreenWidth() / 2) - (g.font.font.getTextWidth(Util.getString("FC_ENTERNAME")) / Engine.SCALE / 2)), (getScreenHeight() / 3));
			if(Util.getAttr("controllerMode")) g.drawString(Util.getString("FC_ENTERNAME_CONTROLLERMODE"), (Util.getMidScreenX() - (g.font.font.getTextWidth(Util.getString("FC_ENTERNAME_CONTROLLERMODE"))/Engine.SCALE / 2)), (getScreenHeight() / 3) + 18);
			g.setFont(getFont(FontID.MAIN));
			g.drawString(tempFileName, (Util.getMidScreenX() - (g.font.font.getTextWidth(tempFileName)/Engine.SCALE / 2)), ((Util.getMidScreenY() - (g.font.getHeight()/Engine.SCALE / 2)) + 1));
			g.setFont(getFont(FontID.MAIN_WHITE));
		}
		else if(drawMode == 6){
			g.drawString(Util.getString("TITLE_ABOUTHEAD"), (Util.getMidScreenX() - (getFont(FontID.MAIN_WHITE).font.getTextWidth(Util.getString("TITLE_ABOUTHEAD"))/Engine.SCALE / 2)), 4);
			g.strokeSize = 2;
			g.strokeColor = Utils.getColorRGB(255,255,255);
			g.drawLine(((getScreenWidth() / 8) + ((getScreenWidth() / 8) / 8)), 20, (getScreenWidth() - ((getScreenWidth() / 8) + ((getScreenWidth() / 8) / 8))), 20);

			g.drawString(Util.getString("ABOUT_TITLE"), (Util.getMidScreenX() - (getFont(FontID.MAIN_WHITE).font.getTextWidth(Util.getString("ABOUT_TITLE"))/Engine.SCALE / 2)), 22);
			g.drawString(Util.getString("ABOUT_MADEBYEPOCTI"), (Util.getMidScreenX() - (getFont(FontID.MAIN_WHITE).font.getTextWidth(Util.getString("ABOUT_MADEBYEPOCTI"))/Engine.SCALE / 2)), 36);

			g.drawString(Util.getString("ABOUT_LIBS"), componentLogos[0].getX(), componentLogos[0].getY() - 16);
			for(i in 0...componentLogos.length){
				g.drawString(Util.getString("ABOUT_LIB" + (i + 1)), componentLogos[i].getX() + componentLogos[i].getWidth() + 3, componentLogos[i].getY() + 8);
			}
			g.drawString("< " + Util.getString("TITLE_BACK"), componentLogos[0].getX(), getScreenHeight() - 16);

			if(selectedMenuEntry <= 3) g.drawString("^", ((getScreenWidth() / 8) + ((getScreenWidth() / 8) / 10)) + 6, componentLogos[selectedMenuEntry].getY() + 8);
			else if(selectedMenuEntry == 4) g.drawString("^", ((getScreenWidth() / 8) + ((getScreenWidth() / 8) / 10)) + 6, 340);
		}
		// File incompatibility
		else if(drawMode == 7){
			if(incompatStatus == 1){
				g.drawString(Util.getString("TITLE_CONTINUEUNSUPPORTEDFILEOLDER"), (Util.getMidScreenX() - (getFont(FontID.MAIN_WHITE).font.getTextWidth(Util.getString("TITLE_CONTINUEUNSUPPORTEDFILEOLDER"))/Engine.SCALE / 2)), (getScreenWidth() / 3) - 32);
				g.drawString(Util.getString("TITLE_CONTINUEUNSUPPORTEDFILEOLDER2"), (Util.getMidScreenX() - (getFont(FontID.MAIN_WHITE).font.getTextWidth(Util.getString("TITLE_CONTINUEUNSUPPORTEDFILEOLDER2"))/Engine.SCALE / 2)), (getScreenWidth() / 3) - 16);
			}
			else {
				g.drawString(Util.getString("TITLE_CONTINUEUNSUPPORTEDFILENEWER"), (Util.getMidScreenX() - (getFont(FontID.MAIN_WHITE).font.getTextWidth(Util.getString("TITLE_CONTINUEUNSUPPORTEDFILENEWER"))/Engine.SCALE / 2)), (getScreenWidth() / 3) - 32);
				g.drawString(Util.getString("TITLE_CONTINUEUNSUPPORTEDFILENEWER2"), (Util.getMidScreenX() - (getFont(FontID.MAIN_WHITE).font.getTextWidth(Util.getString("TITLE_CONTINUEUNSUPPORTEDFILENEWER2"))/Engine.SCALE / 2)), (getScreenWidth() / 3) - 16);
			}
			g.drawString(Util.getString("TITLE_CONTINUEUNSUPPORTEDFILEHELP"), (Util.getMidScreenX() - (getFont(FontID.MAIN_WHITE).font.getTextWidth(Util.getString("TITLE_CONTINUEUNSUPPORTEDFILEHELP"))/Engine.SCALE / 2)), (getScreenWidth() / 3));
			g.drawString(Util.getString("TITLE_CONTINUEUNSUPPORTEDFILEHELP2"), (Util.getMidScreenX() - (getFont(FontID.MAIN_WHITE).font.getTextWidth(Util.getString("TITLE_CONTINUEUNSUPPORTEDFILEHELP2"))/Engine.SCALE / 2)), ((getScreenWidth() / 3) + 16));
			g.drawString(Util.getString("TITLE_CONTINUEUNSUPPORTEDFILEINFO") + AttributeSaving.loadData("saveVersion", selectedFile), (Util.getMidScreenX() - (getFont(FontID.MAIN_WHITE).font.getTextWidth(Util.getString("TITLE_CONTINUEUNSUPPORTEDFILEINFO") + AttributeSaving.loadData("saveVersion", selectedFile))/Engine.SCALE / 2)), ((getScreenWidth() / 3) + 40));
			g.drawString(Util.getString("TITLE_OK"), ((getScreenWidth() / 2) - (getFont(FontID.MAIN_WHITE).font.getTextWidth(Util.getString("TITLE_YES"))/Engine.SCALE / 2)), ((getScreenHeight() / 3) * 2));
			g.drawString("^", (Util.getMidScreenX() - 60), (((getScreenHeight() / 3) * 2) + (16 * selectedMenuEntry)));
		}
		// Draw build and copyright
		if(drawMode <= 1){
			g.setFont(getFont(683));
			g.drawString("© Epocti Technologies 2010-2019.".substring(1), (Util.getMidScreenX() - (g.font.font.getTextWidth("© Epocti Technologies 2010-2019.".substring(1))/Engine.SCALE / 2)), (getScreenHeight() - 16));
			g.setFont(getFont(FontID.MAIN_WHITE));
			if(!Util.inDebugMode()) g.drawString(Util.version, (Util.getMidScreenX() - (g.font.font.getTextWidth(Util.version)/Engine.SCALE) / 2), (getScreenHeight() - 34));
			else g.drawString(Util.version + " + debug mode", (Util.getMidScreenX() - (g.font.font.getTextWidth(Util.version + " + debug mode")/Engine.SCALE) / 2), (getScreenHeight() - 34));
		}
		// Draw titlebar (continue drawmodes)
		if((drawMode == 3 || drawMode == 4) || drawMode == 7){
			g.drawString(Util.getString("TITLE_CONTINUEHEAD"), (Util.getMidScreenX() - (getFont(FontID.MAIN_WHITE).font.getTextWidth(Util.getString("TITLE_CONTINUEHEAD"))/Engine.SCALE / 2)), 4);
			g.strokeSize = 2;
			g.strokeColor = Utils.getColorRGB(255,255,255);
			g.drawLine(((getScreenWidth() / 8) + ((getScreenWidth() / 8) / 8)), 20, (getScreenWidth() - ((getScreenWidth() / 8) + ((getScreenWidth() / 8) / 8))), 20);
		}
	}
	
	function toScreen(newDrawMode:Int){
		// Main to new game
		if(drawMode == 1 && newDrawMode == 2){
			drawMode = 2;
			selectedMenuEntry = 0;
			logo.setAlpha(0);
		}
		// Main to continue
		else if(drawMode == 1 && newDrawMode == 3){
			loopSoundOnChannel(Assets.get("mus.continue1"), 1);
			loopSoundOnChannel(Assets.get("mus.continue2"), 2);
			setVolumeForChannel(0, 0);
			setVolumeForChannel(0, 2);
			drawMode = 3;
			logo.setAlpha(0);
			for(box in fileboxes){ box.setAlpha(100); }
			showAllPartyChars();
		}
		// New game to main
		else if(drawMode == 2 && newDrawMode == 1){
			drawMode = 1;
			selectedMenuEntry = 1;
			logo.setAlpha(100);
		}
		// Continue to main
		else if(drawMode == 3 && newDrawMode == 1){
			if(drawMode == 2) selectedMenuEntry = 1;
			else if(drawMode == 3) selectedMenuEntry = 0;
			drawMode = 1;
			logo.setAlpha(100);
			for(box in fileboxes) box.setAlpha(0);
			hideAllPartyChars();
			fadeInSoundOnChannel(0, 1);
			fadeOutSoundOnChannel(1, 1);
			fadeOutSoundOnChannel(2, 1);
			//setVolumeForChannel(1, 0);
			//stopSoundOnChannel(1);
			//stopSoundOnChannel(2);
		}
		// Continue to confirm
		else if(drawMode == 3 && newDrawMode == 4){
			selectedFile = selectedMenuEntry;
			selectedMenuEntry = 0;
			hideAllPartyChars();
			for(box in fileboxes){ box.setAlpha(0); }
			confirmFilebox.setAlpha(100);
			// Create party characters
			for(i in 0...AttributeSaving.loadData("headerLine3", selectedFile).length){ selectedPartyChars.push(new EZImgInstance("g", true, "ui.titleMenu." + AttributeSaving.loadData("headerLine3", selectedFile)[i])); }
			for(i in 0...selectedPartyChars.length) selectedPartyChars[i].setXY(83 + (i * 17), confirmFilebox.getY() + 36);
			setVolumeForChannel(1, 2);
			setVolumeForChannel(0, 1);
			drawMode = 4;
		}
		// Confirm to continue
		else if(drawMode == 4 && newDrawMode == 3){
			selectedMenuEntry = selectedFile;
			confirmFilebox.setAlpha(0);
			for(img in selectedPartyChars) img.detach();
			selectedPartyChars = [];
			drawMode = 3;
			for(box in fileboxes) box.setAlpha(100);
			showAllPartyChars();
			setVolumeForChannel(1, 1);
			setVolumeForChannel(0, 2);
		}
		// Confirm to incompat
		else if(drawMode == 4 && newDrawMode == 7){
			confirmFilebox.setAlpha(0);
			for(img in selectedPartyChars) img.detach();
			selectedPartyChars = [];
			drawMode = 7;
			selectedMenuEntry = 0;
		}
		// Incompat to continue
		else if(drawMode == 7 && newDrawMode == 3){
			selectedMenuEntry = selectedFile;
			drawMode = 3;
			for(box in fileboxes) box.setAlpha(100);
			showAllPartyChars();
			setVolumeForChannel(1, 1);
			setVolumeForChannel(0, 2);
		}
		// New game to name enter
		else if(drawMode == 2 && newDrawMode == 5){
			drawMode = 5;
			Util.setAttr("fileName", "");
			nameBox.setAlpha(100);
		}
		// Main to about
		else if(drawMode == 1 && newDrawMode == 6){
			drawMode = 6;
			showAllComponentLogos();
			logo.setAlpha(0);
			selectedMenuEntry = 0;
		}
		// About to main
		else if(drawMode == 6 && newDrawMode == 1){
			hideAllComponentLogos();
			drawMode = 1;
			logo.setAlpha(100);
			selectedMenuEntry = 2;
		}
	}

	function hideAllComponentLogos():Void { for(i in 0...componentLogos.length) componentLogos[i].setAlpha(0); }
	function showAllComponentLogos():Void { for(i in 0...componentLogos.length) componentLogos[i].setAlpha(100); }
	function hideAllPartyChars():Void { for(i in 0...5){ if(AttributeSaving.loadData("headerLine3", i).length > 0){ for(j in 0...partyChars[i].length){ partyChars[i][j].setAlpha(0); } } } }
	function showAllPartyChars():Void { for(i in 0...5){ if(AttributeSaving.loadData("headerLine3", i).length > 0){ for(j in 0...partyChars[i].length){ partyChars[i][j].setAlpha(100); } } } }
}