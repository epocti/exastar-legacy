package scripts;

import com.stencyl.behavior.Script.*;
import com.stencyl.behavior.ActorScript;
import com.stencyl.models.Actor;
import com.stencyl.models.Region;
import com.stencyl.Engine;
import motion.Actuate;
import motion.easing.Linear;

class Script_HideableActor extends ActorScript {
	@:attribute("id='1' name='AutoCollision' desc='Have this script create collisions instead.'")
	public var autoCollision:Bool = false;
	@:attribute("id='2' name='Hide Ratio' desc='What percentage from the top of this actor will hiding be activated?'")
	public var ratio:Int = 0;
	@:attribute("id='3' name='Width Percentage' desc='Percentage of width.'")
	public var width:Int = 100;
	@:attribute("id='4' name='Animation' desc='0 = Fade, 1 = Instant - will also fade to 0'")
	public var hideType:Int = 0;
	var checkRegion:Region;
	var opac:Float = 100;

	public function new(dummy:Int, actor:Actor, dummy2:Engine){ super(actor); }

	// ==== Hate how Stencyl manages object collisions and drawing? Wanna fight back? Well, now you can! ====

	override public function init(){
		if(actor.getType() == getActorType(652)) createBoxRegion(actor.getX(), actor.getY(), actor.getWidth(), ((actor.getHeight()) / 4) * 3);
		else {
			if(autoCollision) actor.addRectangularShape(0, (actor.getHeight() / 100) * ratio, actor.getWidth(), (((actor.getHeight()) / 100) * (100 - ratio)));	// TODO: this is broken
			createBoxRegion(actor.getX(), actor.getY(), actor.getWidth(), ((actor.getHeight()) / 100) * ratio);
		}
		checkRegion = getLastCreatedRegion();

		addActorEntersRegionListener(checkRegion, function(a:Actor, list:Array<Dynamic>):Void {
			if(sameAsAny(getActorGroup(0),a.getType(),a.getGroup())){
				if(hideType == 0) actor.fadeTo(.5, .3, Linear.easeNone);
				else actor.fadeTo(0, 0.01, Linear.easeNone);
			}
		});

		addActorExitsRegionListener(checkRegion, function(a:Actor, list:Array<Dynamic>):Void {
			if(sameAsAny(getActorGroup(0),a.getType(),a.getGroup())){
				if(hideType == 0) actor.fadeTo(1, .3, Linear.easeNone);
				else actor.fadeTo(1, 0.01, Linear.easeNone);
			}
		});
	}
}