/*
	This script (C) 2017 - 2018 Epocti.
	Description: Defines an asset that specifically holds sound data. See Asset.hx.
	Author: Kokoro
*/

package scripts.assets;

import com.stencyl.models.Sound;

class SoundAsset extends Asset {
	var soundData:Sound;

	public function new(soundPath:String){
		var finalizedPath = "";
		for(i in 0...soundPath.length){
			if(soundPath.charAt(i) == '/') finalizedPath += ".";
			else finalizedPath += soundPath.charAt(i);
		}
		super(finalizedPath);
		soundData = DataUtils.getSoundData(soundPath);
	}

	override public function getData():Sound {
		return soundData;
	}

	override public function getType():String {
		return "SoundAsset";
	}
}

/*
	To add listeners, create a new var of type "com.stencyl.Script" named "script", then add any of the following:
	Updating: script.addWhenUpdatedListener(null, function(elapsedTime:Float, list:Array<Dynamic>):Void {});
	Drawing: script.addWhenDrawingListener(null, function(g:G, x:Float, y:Float, list:Array<Dynamic>):Void {});
*/
