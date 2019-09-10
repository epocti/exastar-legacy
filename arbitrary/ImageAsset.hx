/*
	This script (C) 2017 - 2018 Epocti.
	Description: Defines an asset that specifically holds image data. See Asset.hx.
	Author: Kokoro
*/

package scripts.assets;

import com.stencyl.behavior.Script;
import openfl.display.BitmapData;

class ImageAsset extends Asset {
	var imgData:BitmapData;

	public function new(imgPath:String){
		var finalizedPath = "";
		for(i in 0...imgPath.length){
			if(imgPath.charAt(i) == '/') finalizedPath += ".";
			else finalizedPath += imgPath.charAt(i);
		}
		super(finalizedPath.substring(0, finalizedPath.length - 4));
		imgData = Script.getExternalImage(imgPath);
	}

	override public function getData():BitmapData {
		var copy:BitmapData = imgData.clone();
		return copy;
	}

	override public function getType():String {
		return "ImageAsset";
	}
}

/*
	To add listeners, create a new var of type "com.stencyl.Script" named "script", then add any of the following:
	Updating: script.addWhenUpdatedListener(null, function(elapsedTime:Float, list:Array<Dynamic>):Void {});
	Drawing: script.addWhenDrawingListener(null, function(g:G, x:Float, y:Float, list:Array<Dynamic>):Void {});
*/
