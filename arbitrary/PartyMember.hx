package scripts.game;

import com.polydes.datastruct.DataStructures;
import vixenkit.Tail;

class PartyMember {
	var pcid:Int;

	var hp:Int;
	var maxHp:Int;
	var mp:Int;
	var maxMp:Int;
	var sp:Int;
	var xp:Int;
	var xpToNext:Int;
	var level:Int;

	var equipment:Array<String>;

	public function new(pcid:Int, initLevel:Int, hp:Int, maxHp:Int, mp:Int, maxMp:Int, initXp:Int, sp:Int){
		this.pcid = pcid;
		this.hp = hp;
		this.maxHp = maxHp;
		this.mp = maxMp;
		this.maxMp = maxMp;
		this.sp = sp;
		this.xp = initXp;
		this.xpToNext = 1000;	// TODO: Temporary xp curve, change later
		this.level = initLevel;
		this.equipment = new Array<String>();
		for(i in 0...4){ this.equipment.push("n"); }
	}
	public function toString():String {
		return getName() + " (L. " + level + ") [" + pcid + "]: " + hp + "/" + maxHp + " HP, " + mp + "/" + maxMp + " MP, " + sp + "% SP, " + xp + "/" + xpToNext + " EXP.\nEquipment: " + equipment.toString();
	}

	public function save():String {
		var saveData:String = "";
		saveData += pcid + ",";
		saveData += hp + ",";
		saveData += maxHp + ",";
		saveData += mp + ",";
		saveData += maxMp + ",";
		saveData += sp + ",";
		saveData += xp + ",";
		saveData += xpToNext + ",";
		saveData += level + ",";
		saveData += equipment[0] + ",";
		saveData += equipment[1] + ",";
		saveData += equipment[2] + ",";
		saveData += equipment[3];
		Tail.log(saveData, 0);
		return saveData;
	}

	public function load(saveData:Array<Dynamic>):Void {
		pcid = saveData[0];
		hp = saveData[1];
		maxHp = saveData[2];
		mp = saveData[3];
		maxMp = saveData[4];
		sp = saveData[5];
		xp = saveData[6];
		xpToNext = saveData[7];
		level = saveData[8];
		equipment = saveData[9];
	}

	public function getName():String {
		switch(pcid){
			case 0: return "Alex";
			case 1: return "Sam";
			case 2: return "Madison";
			case 3: return "Aquanna";
			case 4: return "Brandon";
			case 5: return "Nicole";
			default: return "!!ERROR!!";
		}
	}

	public function getPcid():Int { return pcid; }

	public function getHp():Int { return hp; }
	public function getMaxHp():Int { return maxHp; }
	public function setHp(newAmt:Int):Void {
		// hp overflow check, then set
		if(newAmt > maxHp) hp = maxHp;
		else if(newAmt < 0) hp = 0;
		else hp = newAmt;
	}
	public function addHp(addAmt:Int):Void {
		if(hp + addAmt > maxHp) hp = maxHp;
		else if(hp + addAmt < 0) hp = 0;
		else hp += addAmt;
	}
	public function setMaxHp(newAmt:Int):Void {
		maxHp = newAmt;
		// hp overflow check
		if(hp > maxHp) hp = maxHp;
	}

	public function getMp():Int { return mp; }
	public function getMaxMp():Int { return maxMp; }
	public function setMp(newAmt:Int):Void {
		// mp overflow check, then set
		if(newAmt > maxMp) mp = maxMp;
		else if(newAmt < 0) mp = 0;
		else mp = newAmt;
	}
	public function addMp(addAmt:Int):Void {
		if(mp + addAmt > maxMp) hp = maxMp;
		else if(mp + addAmt < 0) mp = 0;
		else mp += addAmt;
	}
	public function setMaxMp(newAmt:Int):Void {
		maxMp = newAmt;
		// mp overflow check
		if(mp > maxMp) mp = maxMp;
	}

	public function getSp():Int { return sp; }
	public function setSp(newAmt:Int):Void {
		if(newAmt > 100) sp = 100;
		else if(newAmt < 0) sp = 0;
		else sp = newAmt;
	}
	public function addSp(addAmt:Int):Void {
		if(sp + addAmt > 100) sp = 100;
		else if(sp + addAmt < 0) sp = 0;
		else sp += addAmt;
	}

	public function getLevel():Int { return level; }
	public function setLevel(newLevel:Int):Void { level = newLevel; }
	public function addLevel(addAmt:Int) { level += addAmt; }

	// TODO: how does exp even work? do we let the game handle levelling, or just automatically calculate here? how would curving work?
	public function getXp():Int { return xp; }
	public function setXp(newAmt:Int):Void {
		if(newAmt > xpToNext) xp = xpToNext;
		else if(newAmt < 0) xp = 0;
		else xp = newAmt;
	}

	public function getToNext():Int { return xpToNext; }
	public function setToNext(newAmt:Int):Void { xpToNext = newAmt; }

	public function getWeapon():String { return equipment[0]; }
	public function getDefense():String { return equipment[1]; }
	public function getCharm():String { return equipment[2]; }
	public function getMisc():String { return equipment[3]; }
	public function getWeaponName():String { if(equipment[0] != "n") return DataStructures.get(equipment[0]).dName; else return "--None--"; }
	public function getDefenseName():String { if(equipment[1] != "n") return DataStructures.get(equipment[1]).dName; else return "--None--"; }
	public function getCharmName():String { if(equipment[2] != "n") return DataStructures.get(equipment[2]).dName; else return "--None--"; }
	public function getMiscName():String { if(equipment[3] != "n") return DataStructures.get(equipment[3]).dName; else return "--None--"; }
	public function setWeapon(equip:String):Void { equipment[0] = equip; }
	public function setDefense(equip:String):Void { equipment[1] = equip; }
	public function setCharm(equip:String):Void { equipment[2] = equip; }
	public function setMisc(equip:String):Void { equipment[3] = equip; }
}