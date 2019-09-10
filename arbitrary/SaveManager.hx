package scripts.saves;

import com.stencyl.behavior.Script;
import scripts.tools.Util;
import vixenkit.Tail;

class SaveManager {
	static inline var saveVersion:Int = 1;
	
	public static function SaveFile(fileNum:Float):Void {
		// Loads all applicable local data into the specified save file.
		AttributeSaving.saveData("gs_loc", Util.getAttr("gs_loc"), fileNum);
		AttributeSaving.saveData("gs_stats", Util.getAttr("gs_stats"), fileNum);
		AttributeSaving.saveData("sceneStates", Util.getAttr("sceneStates"), fileNum);
		AttributeSaving.saveData("storyFlags", Util.getAttr("storyFlags"), fileNum);
		AttributeSaving.saveData("pynts", Util.getAttr("pynts"), fileNum);
		AttributeSaving.saveData("bufferTransfer", Util.getAttr("bufferTransfer"), fileNum);
		AttributeSaving.saveData("fileName", Util.getAttr("fileName"), fileNum);
		AttributeSaving.saveData("savedLocation", Script.getCurrentSceneName(), fileNum);
		AttributeSaving.saveData("inventory", Util.inventory().save(), fileNum);
		AttributeSaving.saveData("party", Util.party().save(), fileNum);
		AttributeSaving.saveData("inactiveParty", Util.inactiveParty().save(), fileNum);
		AttributeSaving.saveData("quests", Util.quests().save(), fileNum);
		AttributeSaving.saveData("openedBoxes", Util.getAttr("openedBoxes"), fileNum);
		// Header data
		AttributeSaving.saveData("headerLine1", Util.getAttr("fileName") + " - " + Util.getCurrentTime(), fileNum);
		AttributeSaving.saveData("headerLine2", "Chapter " + Util.getFlag("chapter") + ", Act " + Util.getFlag("act") + " - " + Util.getAttr("saveLocationName"), fileNum);
		AttributeSaving.saveData("headerLine3", [0], fileNum);
		AttributeSaving.saveData("written", true, fileNum);
		AttributeSaving.saveData("saveVersion", saveVersion, fileNum);
	}

	public static function LoadFile(fileNum:Float):Int {
		// Rudimentary save file compatibility check. Obviously later on the 'older' check will contain functions needed to add/modify necessary variables to the save file.
		// Returns 1 if file is an older format that is unsupported, 2 if file is a newer format that is unsupported, and 0 if correct version
		// saveVersion is older
		if(AttributeSaving.loadData("saveVersion", fileNum) < saveVersion){
			return 1;
		}
		// saveVersion is newer
		else if(AttributeSaving.loadData("saveVersion", fileNum) > saveVersion){
			return 2;
		}
		// Otherwise saveVersion matches
		else {
			// Loads all applicable save file data into local data.
			Util.setAttr("gs_loc", AttributeSaving.loadData("gs_loc", fileNum));
			Tail.log("loaded gs_loc", 1);
			Util.setAttr("gs_stats", AttributeSaving.loadData("gs_stats", fileNum));
			Tail.log("loaded gs_stats", 1);
			Util.setAttr("sceneStates", AttributeSaving.loadData("sceneStates", fileNum));
			Tail.log("loaded sceneStates", 1);
			Util.setAttr("storyFlags", AttributeSaving.loadData("storyFlags", fileNum));
			Tail.log("loaded storyFlags", 1);
			Util.setAttr("pynts", AttributeSaving.loadData("pynts", fileNum));
			Tail.log("loaded pynts", 1);
			Util.setAttr("bufferTransfer", AttributeSaving.loadData("bufferTransfer", fileNum));
			Tail.log("loaded bufferTransfer", 1);
			Util.setAttr("fileName", AttributeSaving.loadData("fileName", fileNum));
			Tail.log("loaded fileName", 1);
			Util.setAttr("savedLocation", AttributeSaving.loadData("savedLocation", fileNum));
			Tail.log("loaded savedLocation", 1);
			Util.inventory().load(AttributeSaving.loadData("inventory", fileNum));
			Tail.log("loaded inventory", 1);
			Util.party().load(AttributeSaving.loadData("party", fileNum));
			Tail.log("loaded party", 1);
			Util.inactiveParty().load(AttributeSaving.loadData("inactiveParty", fileNum));
			Tail.log("loaded inactiveParty", 1);
			Util.quests().load(AttributeSaving.loadData("quests", fileNum));
			Tail.log("loaded quests", 1);
			Util.setAttr("openedBoxes", AttributeSaving.loadData("openedBoxes", fileNum));
			Tail.log("loaded openedBoxes", 1);
			return 0;
		}
		
	}

	public static function fileIsWritten(fileNum:Int):Bool {
		return AttributeSaving.loadData("written", fileNum);
	}

	public static function SaveConfig():Void {
		AttributeSaving.saveData("config", Util.getAttr("kitsuneConfig"), "config");
		AttributeSaving.saveData("filesInit", Util.getAttr("filesInit"), "config");
	}

	public static function LoadConfig():Void {
		if(!(AttributeSaving.loadData("config", "config") == null)) Util.setAttr("kitsuneConfig", AttributeSaving.loadData("config", "config"));
		Util.setAttr("filesInit", AttributeSaving.loadData("filesInit", "config"));
	}
}