package scripts;

import com.stencyl.behavior.ActorScript;
import com.stencyl.models.Actor;
import com.stencyl.Engine;
import scripts.tools.Util;

class Script_Emotive extends ActorScript {
	@:attribute("id='1' name='Internal Character Name' desc=''")
	public var internalName:String;

	public function new(dummy:Int, actor:Actor, dummy2:Engine){ 
		super(actor);
		addWhenUpdatedListener(null, onUpdate);
		nameMap.set("internalName", "internalName");
	}
	public function onUpdate(elapsedTime:Float, list:Array<Dynamic>){ update(elapsedTime); }

	// ==== Don't you love it when you have to add at least 12 animations just for an NPC? Me too! ====

	override public function init(){}

	public inline function update(elapsedTime:Float){
		// If walking and talking
		if(getAnimWalkState(internalName) && getAnimTalkState(internalName)){
			if(actor.getAnimation() != getAnimEmote(internalName) + "_" + getAnimDir(internalName) + "_w_t") actor.setAnimation(getAnimEmote(internalName) + "_" + getAnimDir(internalName) + "_w_t");
		}
		// If only walking
		else if(getAnimWalkState(internalName)){
			if(actor.getAnimation() != getAnimEmote(internalName) + "_" + getAnimDir(internalName) + "_w") actor.setAnimation(getAnimEmote(internalName) + "_" + getAnimDir(internalName) + "_w");
		}
		// If only talking
		else if(getAnimTalkState(internalName)){
			if(actor.getAnimation() != getAnimEmote(internalName) + "_" + getAnimDir(internalName) + "_t") actor.setAnimation(getAnimEmote(internalName) + "_" + getAnimDir(internalName) + "_t");
		}
		// If doing neither
		else {
			if(actor.getAnimation() != getAnimEmote(internalName) + "_" + getAnimDir(internalName)) actor.setAnimation(getAnimEmote(internalName) + "_" + getAnimDir(internalName));
		}
	}

	// Setters
	public static function setAnim(char:String, emote:String, direction:String, walk:Bool, talk:Bool):Void {
		Util.getAttr("emote").set(char, emote);
		Util.getAttr("dir").set(char, direction);
		if(walk) Util.getAttr("walk").set(char, "t");
		else Util.getAttr("walk").set(char, "f");
		if(talk) Util.getAttr("talk").set(char, "t");
		else Util.getAttr("talk").set(char, "f");
	}
	public static function setEmote(char:String, emote:String):Void { Util.getAttr("emote").set(char, emote); }
	public static function setDirection(char:String, direction:String):Void { Util.getAttr("dir").set(char, direction); }
	public static function setWalk(char:String, walk:Bool):Void {
		if(walk) Util.getAttr("walk").set(char, "t");
		else Util.getAttr("walk").set(char, "f");
	}
	public static function setTalk(char:String, talk:Bool):Void {
		if(talk) Util.getAttr("talk").set(char, "t");
		else Util.getAttr("talk").set(char, "f");
	}

	public static function pointTowards(char:String, deg:Float, limit:Bool = false):Void {
		if(!limit){
			if(deg > -22.5 && deg < 22.5) Util.getAttr("dir").set(char, "r");
			else if(deg > 22.5 && deg < 67.5) Util.getAttr("dir").set(char, "dr");
			else if(deg > 67.5 && deg < 112.5) Util.getAttr("dir").set(char, "d");
			else if(deg > 112.5 && deg < 157.5) Util.getAttr("dir").set(char, "dl");
			else if((deg > 157.5 && deg <= 180) || (deg >= -180 && deg < -157.5)) Util.getAttr("dir").set(char, "l");
			else if(deg > -157.5 && deg < -112.5) Util.getAttr("dir").set(char, "ul");
			else if(deg > -112.5 && deg < -67.5) Util.getAttr("dir").set(char, "u");
			else if(deg > -67.5 && deg < -22.5) Util.getAttr("dir").set(char, "ur");
		}
	}

	public static function resetAll():Void {
		for(char in cast(Util.getAttr("emote"), Map<Dynamic, Dynamic>).keys()) Util.getAttr("emote").set(char, "n");
		for(char in cast(Util.getAttr("dir"), Map<Dynamic, Dynamic>).keys()) Util.getAttr("dir").set(char, "d");
		for(char in cast(Util.getAttr("walk"), Map<Dynamic, Dynamic>).keys()) Util.getAttr("walk").set(char, "f");
		for(char in cast(Util.getAttr("talk"), Map<Dynamic, Dynamic>).keys()) Util.getAttr("talk").set(char, "f");
	}
	
	// Getters
	public static function getAnimEmote(char:String):String { return Util.getAttr("emote").get(char); }
	public static function getAnimDir(char:String):String { return Util.getAttr("dir").get(char); }
	public static function getAnimWalkState(char:String):Bool {
		if(Util.getAttr("walk").get(char) == "t") return true;
		else return false;
	}
	public static function getAnimTalkState(char:String):Bool {
		if(Util.getAttr("talk").get(char) == "t" || (Util.getAttr("dgpc").get("char") == char && Util.getAttr("dgpc").get("talk") == "true")) return true;
		else return false;
	}
}