/*
	This script (C) 2017 - 2018 Epocti.
	Description: Defines an asset that can hold data that is usable by the game. Also includes an identifier to reference.
	Author: Kokoro
*/

package scripts.assets;

import com.stencyl.behavior.Script;

class Asset {
	var path:String;

	public function new(path:String){
		this.path = path;
	}

	public function getPath():String {
		return path;
	}

	public function getData():Dynamic {
		return Script.getExternalImage("engine/error.png");
	}

	public function getType():String {
		return "None";
	}
}
/*
	To add listeners, create a new var of type "com.stencyl.Script" named "script", then add any of the following:
	Updating: script.addWhenUpdatedListener(null, function(elapsedTime:Float, list:Array<Dynamic>):Void {});
	Drawing: script.addWhenDrawingListener(null, function(g:G, x:Float, y:Float, list:Array<Dynamic>):Void {});
*/
