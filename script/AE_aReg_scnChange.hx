/*
    This script (C) 201X - 20XX Epocti.
    Description: 
    Author: 
*/

package scripts;

// Stencyl Engine
import scripts.tools.Util;
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

class AE_aReg_scnChange extends ActorScript {
	@:attribute("id='1' name='Target Scene' desc='Should be the scale that is set above.'")
	var scene:String = "";
	@:attribute("id='2' name='X Scale' desc='Should be the scale that is set above.'")
	var xScale:Float = 1;
	@:attribute("id='3' name='Y Scale' desc='Should be the scale that is set above.'")
	var yScale:Float = 1;

	var region:Region;

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
		
		// Create region
		region = createBoxRegion(actor.getXCenter() - ((actor.getWidth() * xScale) / 2), actor.getYCenter() - ((actor.getHeight() * yScale) / 2), actor.getWidth() * xScale, actor.getHeight() * yScale);

		// Detect if actor from group "players" is in the region
		addActorEntersRegionListener(region, function(a:Actor, list:Array<Dynamic>):Void {
			if(sameAsAny(getActorGroup(0), a.getType(), a.getGroup())){
				Util.switchSceneImmediate(scene);
			}
		});
	}

	public inline function update(elapsedTime:Float){
	}

	public inline function draw(g:G){
	}
}
