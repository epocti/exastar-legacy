package scripts.game;

import vixenkit.Tail;

class Party {
	var members:Array<PartyMember> = new Array<PartyMember>();
	var isInactiveParty:Bool;
	public function new(inactiveParty:Bool){}

	public function add(pcid:Int, level:Int, hp:Int, maxHp:Int, mp:Int, maxMp:Int, initXp:Int, sp:Int):Void { members.push(new PartyMember(pcid, level, hp, maxHp, mp, maxMp, initXp, sp)); }

	public function save():Array<String> {
		var saveData:Array<String> = new Array<String>();
		for(i in 0...getMemberCount()){
			saveData.push(getMember(i).save());
		}
		Tail.log(""+saveData, 0);
		return saveData;
	}
	public function load(saveData:Array<String>):Void {
		var tempArray = new Array<Dynamic>();
		var str;
		for(i in 0...getMemberCount()){
			tempArray = new Array<Dynamic>();
			str = saveData[i];
			for(i in 0...9){
				if(i == 0){
					// tempArray.push(str.charAt(0));
					// tempArray.push(str.substring(saveData));
				}
			}

			getMember(i).load(tempArray);
		}
	}

	public function isInactive():Bool {
		if(isInactiveParty) return true;
		else return false;
	}

	public function contains(pcid:Int):Bool {
		for(member in members) if(member.getPcid() == pcid) return true;
		return false;
	}

	public function getMemberCount():Int { return members.length; }
	public function getMember(index:Int):PartyMember { return members[index]; }

	// public function swap(otherParty:Party, )
}
