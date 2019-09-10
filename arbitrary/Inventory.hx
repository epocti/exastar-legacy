package scripts.game;

import com.polydes.datastruct.DataStructures;
import vixenkit.Tail;

class Inventory {
	var items:Array<Array<Dynamic>>;
	var structureList:Map<String, Dynamic>;

	public function new(){
		// Debug mode check to create dbs
		#if(cppia)
			DataStructures.initializeMaps();
		#end

		items = new Array<Array<Dynamic>>();
		structureList = DataStructures.nameMap;
		// Load all defined item structures into the item entry list
		#if(cppia){
			for(key in structureList.keys()) if(structureList.get(key) == "scripts.ds.Item") items.push([key, 1]);
		}
		#elseif (linux || windows || mac) {
			for(key in structureList.keys()) if(structureList.get(key) == "Item") items.push([key, 1]);
		}
		#end
		// ^^^ Define with an initial amount of 0 ^^^
		// Then sort by item id
		var tempStore:Array<Dynamic>;
		for (i in 0...items.length - 1){
			for (j in 0...items.length - 1){
				if(getId(items[j + 1][0]) < getId(items[j][0])){
					tempStore = items[j + 1];
					items[j + 1] = items[j];
					items[j] = tempStore;
				}
			}
		}
	}

	public function save():Array<Array<Dynamic>> { return items; }
	public function load(saveData:Array<Array<Dynamic>>):Void { items = saveData; }

	// Get an array consisting of the item name along with the amount, only if the item has a quantity > 0
	public function getItems(category:String):Array<Array<Dynamic>> {
		var temp:Array<Array<Dynamic>> = new Array<Array<Dynamic>>();
		if(category != "all"){
			for(i in 0...getSize("all")) if(DataStructures.get(items[i][0]).category == category && items[i][1] > 0) temp.push(items[i]);
			return temp;
		}
		else {
			for(i in 0...getSize("all")) if(items[i][1] > 0) temp.push(items[i]);
			return temp;
		}
	}

	// Get the amount of unique items stored
	public function getSize(category:String):Int {
		var size:Int = 0;
		for(i in 0...items.length){
			// If the category is all, then get every item entry that has a quantity > 0
			if(category == "all" && items[i][1] > 0) size++;
			// If the category is specific, then get every item entry that has a quantity > 0
			else if(DataStructures.get(items[i][0]).category == category && items[i][1] > 0) size++;
		}
		return size;
	}

	public function addItem(iname:String, amt:Int):Void {
		var ranSuccessfully:Bool = false;
		for(i in 0...items.length){
			if(items[i][0] == iname){
				if(items[i][1] + amt <= 99) items[i][1] += amt;
				else if(items[i][1] + amt > 99) items[i][1] = 99;
				ranSuccessfully = true;
			}
		}
		if(!ranSuccessfully) Tail.log('Tried to reference an unknown item of name \" $iname \" - check to see if the item structure exists.', 5);
	}

	public function discard(iname:String, amt:Int):Void {
		var ranSuccessfully:Bool = false;
		for(i in 0...items.length){
			if(items[i][0] == iname){
				if(items[i][1] - amt >= 0) items[i][1] -= amt;
				else if(items[i][1] - amt < 0) items[i][1] = 0;
				ranSuccessfully = true;
			}
		}
		if(!ranSuccessfully) Tail.log('Tried to reference an unknown item of name \" $iname \" - check to see if the item structure exists.', 5);
	}

	// VALUES BY INDEX

	// Get item name
	public function getNameByIndex(category:String, index:Int):String { return DataStructures.get(getItems(category)[index][0]).dName; }
	// Get quantity stored
	public function getAmtByIndex(category:String, index:Int):Int { return getItems(category)[index][1]; }
	// Get the 3 description lines for an item, as an array
	public function getDescriptionByIndex(category:String, index:Int):Array<String> { return [DataStructures.get(getItems(category)[index][0]).description1, DataStructures.get(getItems(category)[index][0]).description2, DataStructures.get(getItems(category)[index][0]).description3]; }
	// Get item category - note that this is only for the "all" category
	public function getCategoryByIndex(category:String, index:Int):String { return DataStructures.get(getItems(category)[index][0]).category; }
	// Check if item is usable in overworld
	public function isUsableOWByIndex(category:String, index:Int):Bool { return DataStructures.get(getItems(category)[index][0]).usableInOverworld; }
	// Check if item is equipment
	public function isEquipmentByIndex(category:String, index:Int):Bool { return DataStructures.get(getItems(category)[index][0]).isEquipment; }
	// Check if item is equipment
	public function isDiscardableByIndex(category:String, index:Int):Bool { return DataStructures.get(getItems(category)[index][0]).discardable; }
	// Get item's equipment description
	public function getEquipmentDescByIndex(category:String, index:Int):String { return DataStructures.get(getItems(category)[index][0]).equipDesc; }
	// Get item's damage stat (weapons)
	public function getDamageByIndex(category:String, index:Int):Int { return DataStructures.get(getItems(category)[index][0]).baseDamage; }
	// Get item's defense stat (defense items)
	public function getDefenseByIndex(category:String, index:Int):Int { return DataStructures.get(getItems(category)[index][0]).baseDefense; }
	// Get item's accuracy stat (charms)
	public function getAccByIndex(category:String, index:Int):Int { return DataStructures.get(getItems(category)[index][0]).charmRatio; }

	// VALUES BY INAME

	// Get item id
	public function getId(iname:String):Int { return DataStructures.get(iname).iid; }
}