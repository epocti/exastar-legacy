/*
	This script (C) 2018 Epocti.
	Description: Defines a storage container that abstracts the game's 2 config files (both in config.sol and exaConfig.ini)
	Author: Kokoro
*/

package scripts.tools;

import com.stencyl.utils.Utils;

class Config {
	static var data:Map<String, Dynamic> = new Map<String, Dynamic>();

	public function new(){
	} // Do we need to initialize this?

	public static function load(){
		// Copy from kitsuneConfig first, which can then be overrode by exaConfig
		data = Utils.copyMap(Util.getAttr("kitsuneConfig"));

		// Rename kitsuneConfig values to newer names
		Util.setKey(data, "fsOnStart", "fsos");
		Util.setKey(data, "effectLevel", "effects");
		Util.setKey(data, "shaderLevel", "shaders");
		Util.setKey(data, "frameCount", "framerate");
		Util.setKey(data, "music", "enableMusic");
		Util.setKey(data, "sfx", "enableSfx");

		data.set("scaleX", 2);
		data.set("scaleY", 2);

		// Load exaConfig.ini
		var iniData:Array<String> = DataUtils.getTextData("exaConfig.ini").split("\r");

		// Apply ini settings
		for(value in getCleanedIni(iniData)){
			data.set(value.substring(0, value.indexOf("=")), value.substring(value.indexOf("=") + 1, value.length));
		}
	}

	public static function get(property:String):Dynamic {
		return data.get(property);
	}

	// Remove comments, empty lines, and headers from the ini data
	public static function getCleanedIni(iniData:Array<String>):Array<String> {
		var cleanedIni:Array<String> = new Array<String>();
		for(line in iniData){
			if(!(line.indexOf(";") == 0 || line.indexOf("[") == 0) && !(line == null || line == "")) cleanedIni.push(line);
		}
		return cleanedIni;
	}

	public static function asString():String {
		var temp:String = "";
		for(property in data.keys()){
			temp += property + ": " + data.get(property) + "\n";
		}
		return temp;
	}
}
