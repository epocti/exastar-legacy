package scripts.grapefruit;

import motion.easing.Cubic;
import motion.Actuate;
import com.stencyl.behavior.Script;
import com.polydes.datastruct.DataStructures;
import motion.easing.Quad;
import scripts.tools.EZImgInstance;
import com.stencyl.behavior.Script;
import com.stencyl.behavior.Script.*;
import com.stencyl.models.Actor;

class GF_Enemy {
	var id:Int = 0;
	var name:String;
	var health:Int;
	var maxHealth:Int;
	var minDamage:Int;
	var maxDamage:Int;

	public var img:Actor;

	public function new(tag:String){
		id = DataStructures.get(tag).eid;
		name = DataStructures.get(tag).dName;
		maxHealth = Script.randomInt(DataStructures.get(tag).minHP, DataStructures.get(tag).maxHP);
		health = maxHealth;
		minDamage = DataStructures.get(tag).damage;
		maxDamage = DataStructures.get(tag).damage;
		// Create enemy image
		img = Script.createRecycledActorOnLayer(Script.getActorTypeByName("bttlChar_" + id), 400, 150, 1, "mid");
	}

	// get stats
	public function getId():Int { return id; }
	public function getName():String {
		return name;
	}
	public function getDamage():Int {
		return Script.randomInt(minDamage, maxDamage);
	}
	public function getHealth():Int { return health; }
	public function getMaxHealth():Int { return maxHealth; }

	// mod health
	public function setHealth(newHealth:Int):Void { health = newHealth; }
	public function decHealth(amount:Int):Void {
		var decrementTo:Int;
		decrementTo = (health - amount);
		if(decrementTo < 0) decrementTo = 0;
		Actuate.tween(this, 1, {health:decrementTo}).ease(Cubic.easeOut);
	}
	public function addHealth(amount:Int):Void {
		var addTo:Int;
		addTo = (health + amount);
		if(addTo > maxHealth) addTo = maxHealth;
		Actuate.tween(this, 1, {health:addTo}).ease(Cubic.easeOut);
	}

	public function getXPosition():Int { return Std.int(img.getX() /*+ (img.getWidth() / 2)*/); }
	public function getYPosition():Int { return Std.int(img.getY() /*+ (img.getHeight() / 2)*/); }
	public function setX(newPos:Int):Void { img.setX(newPos - (img.getWidth() / 2)); }
	public function setY(newPos:Float):Void { img.setY(Std.int(newPos - (img.getWidth() / 2))); }

	public function toString():String { return getName() + ": " + getHealth() + "/" + getMaxHealth() + " HP, screen pos: " + img.getX(); }
}