/*
	This script (C) 2018 Epocti.
	Description: Scene events for the debug asset viewer scene.
	Author: Kokoro
*/

package scripts;

// Stencyl Engine
import scripts.id.FontID;
import scripts.assets.Assets;
import scripts.tools.EZImgInstance;
import com.stencyl.Engine;
import com.stencyl.Input;
import com.stencyl.utils.Utils;
import com.stencyl.graphics.G;
import com.stencyl.behavior.Script;
import com.stencyl.behavior.Script.*;
import com.stencyl.behavior.ActorScript;
import com.stencyl.behavior.SceneScript;
import com.stencyl.behavior.TimedTask;
// Stencyl Datatypes
import com.stencyl.models.Actor;
import com.stencyl.models.GameModel;
import com.stencyl.models.actor.Animation;
import com.stencyl.models.actor.ActorType;
import com.stencyl.models.actor.Collision;
import com.stencyl.models.actor.Group;
import com.stencyl.models.Scene;
import com.stencyl.models.Sound;
import com.stencyl.models.Region;
import com.stencyl.models.Font;
import com.stencyl.models.Joystick;
// Tweens
import motion.Actuate;
import motion.easing.Back;
import motion.easing.Cubic;
import motion.easing.Elastic;
import motion.easing.Expo;
import motion.easing.Linear;
import motion.easing.Quad;
import motion.easing.Quart;
import motion.easing.Quint;
import motion.easing.Sine;

class SE_dbg_assetViewer extends SceneScript {
	var imgAsset = new EZImgInstance("n", true);
	var currentAsset = 0;

	public function new(dummy:Int, dummy2:Engine){
		super();	
		addWhenUpdatedListener(null, onUpdate);
		addWhenDrawingListener(null, onDraw);
	}
	public function onUpdate(elapsedTime:Float, list:Array<Dynamic>){ update(elapsedTime); }
	public function onDraw(g:G, x:Float, y:Float, list:Array<Dynamic>){ draw(g); }

	// ========

	override public function init(){
		imgAsset.setOrigin("CENTER");
		imgAsset.centerOnScreen(true, true);
	}

	public inline function update(elapsedTime:Float){
		if(isKeyPressed("right")){
			currentAsset++;
			imgAsset.changeImageBitmap(Assets.getByIndex(currentAsset));
		}
		else if(isKeyPressed("left")){
			currentAsset--;
			imgAsset.changeImageBitmap(Assets.getByIndex(currentAsset));
		}
	}

	public inline function draw(g:G){
		g.setFont(getFont(FontID.MAIN));
		g.drawString("[" + currentAsset + "/" + Assets.getTotal() + " - " + Assets.getPathByIndex(currentAsset), 0, 344);
	}
}
