package scripts;

import scripts.assets.Assets;
import scripts.id.FontID;
import scripts.gfx.GFX_Letterbox;
import scripts.tools.Util;
import scripts.Script_Emotive;
import com.stencyl.graphics.BitmapWrapper;
import openfl.display.Bitmap;
import com.stencyl.graphics.G;
import com.stencyl.behavior.Script;
import com.stencyl.behavior.Script.*;
import com.stencyl.behavior.SceneScript;
import com.stencyl.behavior.TimedTask;
import com.stencyl.models.GameModel;
import com.stencyl.Engine;
import com.stencyl.utils.Utils;
import motion.Actuate;
import motion.easing.Linear;

class SE_c0_expositionEnd extends SceneScript {
	public var _camY:Float = 180;
	public var _opac:Float = 0;
	public var _textY:Float = Util.getMidScreenY() - 30;
	public var _drawMode:Float = 0;
	public var _imgLogo:BitmapWrapper;
	public var bars:GFX_Letterbox = new GFX_Letterbox(false);

	public function new(dummy:Int, dummy2:Engine){ super(); }

	override public function init(){
		Util.disableMovement();
		Util.disableCameraSnapping();
		playSoundOnChannel(Assets.get("mus.expositionEnd"), 0);
		Script_Emotive.setAnim("alex", "fall", "r", false, false);
		getActor(1).disableBehavior("Script_CameraFollow");
		Util.setAttr("disableStatOverlay", true);
		Util.setAttr("disableShadows", true);
		getActor(1).spinBy(-75, .01, Linear.easeNone);
		getActor(1).moveBy(0, 640, 15, Linear.easeNone);
		Actuate.tween(this, 20, {_camY:640}).ease(Linear.easeNone);
		_imgLogo = new BitmapWrapper(new Bitmap(getExternalImage("logo/exaLogoInverted.png")));

		runLater(4000, function(timeTask:TimedTask):Void {
			Actuate.tween(this, 3, {_opac:100}).ease(Linear.easeNone);
			Actuate.tween(this, 3, {_textY:(Util.getMidScreenY() - (getFont(FontID.MAIN).getHeight() / 2))}).ease(Linear.easeNone);
		}, null);
		// Particles
		runLater(9600, function(timeTask:TimedTask):Void {
			createRecycledActor(getActorType(642), (getActor(1).getXCenter() - 10), getActor(1).getYCenter(), Script.FRONT);
			getLastCreatedActor().moveBy(-48, -48, 3.5, Linear.easeNone);
			createRecycledActor(getActorType(642), (getActor(1).getXCenter() - 10), getActor(1).getYCenter(), Script.FRONT);
			getLastCreatedActor().moveBy(-24, -72, 3.5, Linear.easeNone);
			createRecycledActor(getActorType(642), (getActor(1).getXCenter() - 10), getActor(1).getYCenter(), Script.FRONT);
			getLastCreatedActor().moveBy(24, -72, 3.5, Linear.easeNone);
			createRecycledActor(getActorType(642), (getActor(1).getXCenter() - 10), getActor(1).getYCenter(), Script.FRONT);
			getLastCreatedActor().moveBy(48, -48, 3.5, Linear.easeNone);
		}, null);
		runLater(12000, function(timeTask:TimedTask):Void {
			Actuate.tween(this, 3, {_opac:0}).ease(Linear.easeNone);
			Actuate.tween(this, 3, {_textY:(Util.getMidScreenY() - 30)}).ease(Linear.easeNone);
		}, null);
		runLater(15000, function(timeTask:TimedTask):Void {
			_drawMode = 1;
			attachImageToHUD(_imgLogo, 0, Std.int(_textY));
			setXForImage(_imgLogo, (Util.getMidScreenX() - (_imgLogo.width/Engine.SCALE / 2)));
			_textY = asNumber(Util.getMidScreenY());
			Actuate.tween(this, 10, {_opac:100}).ease(Linear.easeNone);
			Actuate.tween(this, 10, {_textY:(Util.getMidScreenY() - (_imgLogo.height/Engine.SCALE / 2))}).ease(Linear.easeNone);
		}, null);
		runLater(25000, function(timeTask:TimedTask):Void { _drawMode = 2; }, null);
		runLater(40000, function(timeTask:TimedTask):Void {
			Util.setAttr("bufferTransfer", "c0_expositionEnd");
			switchScene(GameModel.get().scenes.get(66).getID(), createFadeOut(2, Utils.getColorRGB(255,255,255)), createFadeIn(0.01, Utils.getColorRGB(255,255,255)));
		}, null);

		addWhenDrawingListener(null, function(g:G, x:Float, y:Float, list:Array<Dynamic>):Void {
			g.alpha = (_opac/100);
			g.setFont(getFont(FontID.MAIN));
			if(_drawMode == 0) g.drawString(Util.getString("EXPOSITIONEND_EPOCTI"), Util.getMidScreenX() - (g.font.font.getTextWidth("Epocti presents") / 2), _textY);
			else {
				setYForImage(_imgLogo, _textY);
				_imgLogo.alpha = (_opac/100);
			}
		});

		runPeriodically(200, function(timeTask:TimedTask):Void {
			if(_drawMode == 1) createRecycledActor(getActorType(638), randomInt(Math.floor(_imgLogo.x/Engine.SCALE), Math.floor(((_imgLogo.x/Engine.SCALE + _imgLogo.width/Engine.SCALE) - 16))), (randomInt(Math.floor(_imgLogo.y/Engine.SCALE), Math.floor(((_imgLogo.y/Engine.SCALE + _imgLogo.height/Engine.SCALE) - 16))) + getScreenY()), Script.FRONT);
		}, null);

		addWhenUpdatedListener(null, function(elapsedTime:Float, list:Array<Dynamic>):Void { engine.moveCamera(0, _camY); });
	}
}
