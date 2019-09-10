/*
    This script (C) 2018 Epocti.
    Description: Events for the scene editor-based dialog zone
    Author: kokoscript
*/

package scripts;

// Stencyl Engine
import scripts.game.PremadeDialogZone;
import scripts.game.DialogZone;
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

import scripts.tools.Util;

class AE_aReg_dialogZone extends ActorScript {
	@:attribute("id='1' name='Dialog Chunk' desc=''")
	var chunk:String = "generalError";
	@:attribute("id='2' name='Disable Movement' desc=''")
	var disableMovement:Bool = true;
	@:attribute("id='3' name='Direction' desc=''")
	var direction:String = "u";
	@:attribute("id='4' name='X Scale' desc='Should be the scale that is set above.'")
	var xScale:Float = 1;
	@:attribute("id='5' name='Y Scale' desc='Should be the scale that is set above.'")
	var yScale:Float = 1;


	public function new(dummy:Int, actor:Actor, dummy2:Engine){
		super(actor);
		addWhenUpdatedListener(null, onUpdate);
		addWhenDrawingListener(null, onDraw);
	}
	public function onUpdate(elapsedTime:Float, list:Array<Dynamic>){ update(elapsedTime); }
	public function onDraw(g:G, x:Float, y:Float, list:Array<Dynamic>){ draw(g); }
	
	// ========

	override public function init(){
		if(!Util.showSpecialRegions) actor.disableActorDrawing();
		//var dgZone:DialogZone = new DialogZone("generalError", actor.getX(), actor.getY(), actor.getWidth(), actor.getHeight(), true, "u");

		var region:Region = createBoxRegion(actor.getXCenter() - ((actor.getWidth() * xScale) / 2), actor.getYCenter() - ((actor.getHeight() * yScale) / 2), actor.getWidth() * xScale, actor.getHeight() * yScale);
		var dgZone:PremadeDialogZone = new PremadeDialogZone(chunk, region, true, direction);
	}

	public inline function update(elapsedTime:Float){
	}

	public inline function draw(g:G){
	}
}
