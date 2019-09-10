/*
	This script (C) 2018 Epocti.
	Description: Defines a card in battle.
	Author: Kokoro
*/

package scripts.grapefruit;

import com.polydes.datastruct.DataStructures;

class GF_Card {
	public var id:String;
	public var name:String;
	public var description:Array<String>;
	public var tier:Int;

	public function new(tag:String){
		id = tag;
		name = DataStructures.get(tag).eid;
		description = [DataStructures.get(tag).descriptionLine1, DataStructures.get(tag).descriptionLine2, DataStructures.get(tag).descriptionLine3];

		switch(DataStructures.get(tag).tier){
			case "tier1": tier = 1;
			case "tier2": tier = 2;
			case "tier3": tier = 3;
			case "tier4": tier = 4;
			default: tier = 0;
		}
	}
}
