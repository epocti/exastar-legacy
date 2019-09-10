package scripts.game;

import scripts.assets.Assets;
import com.polydes.datastruct.DataStructures;
import motion.easing.Expo;
import com.stencyl.behavior.TimedTask;
import com.stencyl.behavior.Script;
import scripts.tools.EZImgInstance;
import vixenkit.Tail;

class QuestContainer {
	var quests:Array<Array<Dynamic>>;
	var notifier:EZImgInstance;
	var structureList:Map<String, Dynamic>;

	public function new(){
		// Debug mode check to create dbs
		#if(cppia)
			DataStructures.initializeMaps();
		#end

		quests = new Array<Array<Dynamic>>();
		structureList = DataStructures.nameMap;
		// Load all defined item structures into the item entry list
		// Cppia calls structures by identifier, native calls by name
		#if(cppia){
			for(key in structureList.keys()) if(structureList.get(key) == "scripts.ds.Quest") quests.push([key, true]);
		}
		#elseif (linux || windows || mac) {
			for(key in structureList.keys()) if(structureList.get(key) == "Quest") quests.push([key, true]);
		}
		#end
		// ^^^ Define with an initial state of not being in the list ^^^
		// Then sort by quest type
		var tempStore:Array<Array<Dynamic>> = new Array<Array<Dynamic>>();
		for (i in 0...quests.length) if(DataStructures.get(quests[i][0]).type == "story") tempStore.push([quests[i][0], quests[i][1]]);
		for (i in 0...quests.length) if(DataStructures.get(quests[i][0]).type == "limited") tempStore.push([quests[i][0], quests[i][1]]);
		for (i in 0...quests.length) if(DataStructures.get(quests[i][0]).type == "side") tempStore.push([quests[i][0], quests[i][1]]);
		quests = tempStore;
	}

	public function save():Array<Array<Dynamic>> { return quests; }
	// Save data loader
	public function load(saveData:Array<Array<Dynamic>>):Void { quests = saveData; }

	// Returns an array with only the available quests
	public function getQuests():Array<Array<Dynamic>> {
		var temp:Array<Array<Dynamic>> = new Array<Array<Dynamic>>();
		for(i in 0...quests.length) if(quests[i][1]) temp.push([quests[i][0], quests[i][1]]);
		return temp;
	}

	public function getSize():Int { return getQuests().length; }
	public function getNameByIndex(index:Int):String { return DataStructures.get(getQuests()[index][0]).dName; }
	public function getDescriptionByIndex(index:Int):Array<String> {
		return [DataStructures.get(getQuests()[index][0]).description1, DataStructures.get(getQuests()[index][0]).description2, DataStructures.get(getQuests()[index][0]).description3];
	}

	public function add(qid:String):Void {
		var addedSuccessfully:Bool = false;
		for(i in 0...getSize()){
			if(getQuests()[i][0] == "q_" + qid){
				getQuests()[i][1] = true;
				addedSuccessfully = true;
			}
		}
		if(addedSuccessfully){
			// Notifier animation
			notifier = new EZImgInstance("g", true, "ui.newTaskBox.newTaskBox1");
			notifier.setX(Script.getScreenWidth());
			notifier.enableAnimation("ui.newTaskBox.newTaskBox", 4, 100, true);
			notifier.slideBy(-96, 0, .75, Expo.easeOut);
			Script.runLater(3000, function(timeTask:TimedTask):Void {
				notifier.slideBy(96, 0, .75, Expo.easeOut);
				Script.runLater(750, function(timeTask:TimedTask):Void { notifier = null; }, null);
			}, null);
		}
		else Tail.log('Tried to add unknown quest: $qid', 5);
	}
}
