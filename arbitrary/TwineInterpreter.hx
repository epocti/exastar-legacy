/*
	This script (C) 2018 Epocti.
	Description: Interpreter class for Twinescript (.vkt) files.
	Author: Kokoro
*/

package scripts.vixenkit;

import com.stencyl.Engine;
import vixenkit.Tail;

class TwineInterpreter {
	// vars go here

	public function new(){
	}

	public static function run(scriptLocation:String){
		var scriptData:Array<String> = DataUtils.getTextData(scriptLocation).split("\r");
		for(i in 0...scriptData.length){
			Tail.log(scriptData[i], 0);
		}
	}
}

/*
	To add listeners, create a new var of type "com.stencyl.Script" named "script", then add any of the following:
	Updating: script.addWhenUpdatedListener(null, function(elapsedTime:Float, list:Array<Dynamic>):Void {});
	Drawing: script.addWhenDrawingListener(null, function(g:G, x:Float, y:Float, list:Array<Dynamic>):Void {});
*/
