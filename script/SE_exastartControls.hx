package scripts;

import scripts.tools.Util;
import openfl.events.KeyboardEvent;
import scripts.tools.EZImgInstance;
import com.stencyl.Key;
import scripts.id.FontID;
import com.stencyl.graphics.G;
import com.stencyl.behavior.Script.*;
import com.stencyl.behavior.SceneScript;
import com.stencyl.behavior.TimedTask;
import com.stencyl.models.GameModel;
import com.stencyl.models.Region;
import com.stencyl.Engine;
import com.stencyl.Input;
import com.stencyl.utils.Utils;
import motion.Actuate;
import motion.easing.Linear;
import motion.easing.Quad;

class SE_exastartControls extends SceneScript {
	var controls:Map<String, Array<Int>> = new Map<String, Array<Int>>();
	var editMode:Bool = false;
	var currentKeyEdit = 0;

	var backButton:EZImgInstance = new EZImgInstance("g", true, "settingsButton.backButton");
	var editButton:EZImgInstance = new EZImgInstance("g", true, "settingsButton.keyEdit");
	var backRegion:Region = createBoxRegion(0, 0, 128, 24);
	var editRegion:Region = createBoxRegion(0, 0, 128, 24);

	var opac:Float = 33;

    public function new(dummy:Int, dummy2:Engine){
		super();
		addWhenUpdatedListener(null, onUpdate);
		addWhenDrawingListener(null, onDraw);
	}
	public function onUpdate(elapsedTime:Float, list:Array<Dynamic>){ update(elapsedTime); }
	public function onDraw(g:G, x:Float, y:Float, list:Array<Dynamic>){ draw(g); }

	// ========

	override public function init(){
		editButton.centerOnScreen(true, false);
		editButton.setY(300);
		editRegion.setLocation(editButton.getX(), editButton.getY());
		editButton.setOrigin("CENTER");

		backButton.setXY(0, getScreenHeight() - 24);
		backRegion.setLocation(0, getScreenHeight() - 24);
		backButton.setOrigin("BOTTOMLEFT");

		// opacity fadein/out
		Actuate.tween(this, .75, {opac:66}).ease(Linear.easeNone);
		runLater(750, function(timeTask:TimedTask):Void { Actuate.tween(this, .75, {opac:33}).ease(Linear.easeNone); }, null);
		runPeriodically(1500, function(timeTask:TimedTask):Void {
			Actuate.tween(this, .75, {opac:66}).ease(Linear.easeNone);
			runLater(750, function(timeTask:TimedTask):Void { Actuate.tween(this, .75, {opac:33}).ease(Linear.easeNone); }, null);
		}, null);

		// edit button press listener
		addMouseOverActorListener(editRegion, function(mouseState:Int, list:Array<Dynamic>):Void {
			if(mouseState == 3 && editMode == false){
				editMode = true;
				editButton.growTo(85, 85, .08, Quad.easeInOut);
				runLater(80, function (timeTask:TimedTask):Void { editButton.growTo(100, 100, .08, Quad.easeInOut); }, null);
			}
		});

		// back button press listener
		addMouseOverActorListener(backRegion, function(mouseState:Int, list:Array<Dynamic>):Void {
			if(mouseState == 3 && editMode == false){
				backButton.growTo(85, 85, .08, Quad.easeInOut);
				runLater(80, function (timeTask:TimedTask):Void { switchScene(GameModel.get().scenes.get(86).getID(), null, createCrossfadeTransition(.25)); }, null);
			}
		});

		// key remapping process
		addAnyKeyPressedListener(function(event:KeyboardEvent, list:Array<Dynamic>):Void {
			if(editMode){
				if(currentKeyEdit == 0) CustomControls.setControl("action1", event.keyCode);
				if(currentKeyEdit == 1) CustomControls.setControl("action2", event.keyCode);
				if(currentKeyEdit == 2) CustomControls.setControl("action3", event.keyCode);
				if(currentKeyEdit == 3) CustomControls.setControl("menu", event.keyCode);
				if(currentKeyEdit == 4) CustomControls.setControl("up", event.keyCode);
				if(currentKeyEdit == 5) CustomControls.setControl("down", event.keyCode);
				if(currentKeyEdit == 6) CustomControls.setControl("left", event.keyCode);
				if(currentKeyEdit == 7){
					CustomControls.setControl("right", event.keyCode);
					editMode = false;
					currentKeyEdit = -1;
				}
				currentKeyEdit++;
			}
		});
	}

	public inline function update(elapsedTime:Float){
		controls = Input.getControlMap();
		Util.getAttr("kitsuneConfig").set("keymap", CustomControls.getControlConfig());
	}

	public inline function draw(g:G){
		g.setFont(getFont(FontID.MAIN));
		g.strokeSize = 2;
		g.strokeColor = Utils.getColorRGB(0, 0, 0);

		g.drawString(Util.getString("EXASTART_CONTROLS_TITLE"), (getScreenWidth() - 24) - g.font.font.getTextWidth(Util.getString("EXASTART_CONTROLS_TITLE")), 12);

		g.drawString(Util.getString("EXASTART_CONTROLS_ACTION1"), 36, 32);
		g.drawLine(36, 52, getScreenWidth() - 36, 52);
		g.drawString(Util.getString("EXASTART_CONTROLS_ACTION2"), 36, 64);
		g.drawLine(36, 84, getScreenWidth() - 36, 84);
		g.drawString(Util.getString("EXASTART_CONTROLS_ACTION3"), 36, 96);
		g.drawLine(36, 116, getScreenWidth() - 36, 116);
		g.drawString(Util.getString("EXASTART_CONTROLS_MENU"), 36, 128);
		g.drawLine(36, 148, getScreenWidth() - 36, 148);
		g.drawString(Util.getString("EXASTART_CONTROLS_UP"), 36, 160);
		g.drawLine(36, 180, getScreenWidth() - 36, 180);
		g.drawString(Util.getString("EXASTART_CONTROLS_DOWN"), 36, 192);
		g.drawLine(36, 212, getScreenWidth() - 36, 212);
		g.drawString(Util.getString("EXASTART_CONTROLS_LEFT"), 36, 224);
		g.drawLine(36, 244, getScreenWidth() - 36, 244);
		g.drawString(Util.getString("EXASTART_CONTROLS_RIGHT"), 36, 256);

		g.drawString(Key.nameOfKey(controls.get("action1")[0]), (getScreenWidth() - 36) - getFont(FontID.MAIN).font.getTextWidth(Key.nameOfKey(controls.get("action1")[0])), 32);
		g.drawString(Key.nameOfKey(controls.get("action2")[0]), (getScreenWidth() - 36) - getFont(FontID.MAIN).font.getTextWidth(Key.nameOfKey(controls.get("action2")[0])), 64);
		g.drawString(Key.nameOfKey(controls.get("action3")[0]), (getScreenWidth() - 36) - getFont(FontID.MAIN).font.getTextWidth(Key.nameOfKey(controls.get("action3")[0])), 96);
		g.drawString(Key.nameOfKey(controls.get("menu")[0]), (getScreenWidth() - 36) - getFont(FontID.MAIN).font.getTextWidth(Key.nameOfKey(controls.get("menu")[0])), 128);
		g.drawString(Key.nameOfKey(controls.get("up")[0]), (getScreenWidth() - 36) - getFont(FontID.MAIN).font.getTextWidth(Key.nameOfKey(controls.get("up")[0])), 160);
		g.drawString(Key.nameOfKey(controls.get("down")[0]), (getScreenWidth() - 36) - getFont(FontID.MAIN).font.getTextWidth(Key.nameOfKey(controls.get("down")[0])), 192);
		g.drawString(Key.nameOfKey(controls.get("left")[0]), (getScreenWidth() - 36) - getFont(FontID.MAIN).font.getTextWidth(Key.nameOfKey(controls.get("left")[0])), 224);
		g.drawString(Key.nameOfKey(controls.get("right")[0]), (getScreenWidth() - 36) - getFont(FontID.MAIN).font.getTextWidth(Key.nameOfKey(controls.get("right")[0])), 256);

		if(editMode){
			g.strokeSize = 0;
			g.alpha = opac / 100;
			g.fillColor = Utils.getColorRGB(255, 255, 127);
			g.fillRect(35, 21 + (currentKeyEdit * 32), getScreenWidth() - 70, 30);
		}
	}
}
