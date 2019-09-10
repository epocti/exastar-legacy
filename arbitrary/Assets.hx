/*
	This script (C) 2017 - 2018 Epocti.
	Description: Defines a library of assets that are loaded from a manifest and categorized. These assets are then tagged and can be referenced later.
	Author: Kokoro
*/

package scripts.assets;

// 2 modes: disk mode or memory mode
// memory: load all from manifest, tagging items using asset object
// disk: load as normal, but have some sort of backwards compat by referencing file somehow

import com.stencyl.behavior.TimedTask;
import com.stencyl.behavior.Script;
import vixenkit.Tail;

class Assets {
	static var hasLoaded:Bool = false;
	static var diskMode:Bool = true;
	static var imageManifest:Array<String> = DataUtils.getTextData("img.alm").split("\r");
	static var sfxManifest:Array<String> = DataUtils.getTextData("sfx.alm").split("\r");
	static var musicManifest:Array<String> = DataUtils.getTextData("mus.alm").split("\r");
	static var assets:Array<Asset> = new Array<Asset>();

	var counter:Int = 0;
	static var imgLoaded:Bool = false;
	static var sfxLoaded:Bool = false;
	static var musLoaded:Bool = false;

	public function new(){
	}

	public function loadNext():Void {
		if(!hasLoaded){
			if(!imgLoaded){
				loadImageAsset(counter);
				if(counter == imageManifest.length - 1){
					counter = -1;
					imgLoaded = true;
				}
			}
			else if(!sfxLoaded){
				loadSfxAsset(counter);
				if(counter == sfxManifest.length - 1){
					counter = -1;
					sfxLoaded = true;
				}
			}
			else if(!musLoaded){
				loadMusicAsset(counter);
				if(counter == musicManifest.length - 1){
					counter = -1;
					musLoaded = true;
				}
			}
			if((!imgLoaded || !sfxLoaded) || !musLoaded) counter++;
			else {
				hasLoaded = true;
			}
		}
		else {
			Tail.log("Assets have already been loaded. Not loading again.", 4);
		}
	}

	public function load():Void {
		// TODO: load config beforehand
		//if(!Util.asBool(Config.get("streamAssets"))) diskMode = false;

		// Timed version (allows for the progress indicator)
		if(!diskMode){
			Script.runPeriodically(1, function(timeTask:TimedTask):Void {
				if(!hasLoaded){
					if(!imgLoaded){
						loadImageAsset(counter);
						if(counter == imageManifest.length - 1){
							counter = -1;
							imgLoaded = true;
						}
					}
					else if(!sfxLoaded){
						loadSfxAsset(counter);
						if(counter == sfxManifest.length - 1){
							counter = -1;
							sfxLoaded = true;
						}
					}
					else if(!musLoaded){
						loadMusicAsset(counter);
						if(counter == musicManifest.length - 1){
							counter = -1;
							musLoaded = true;
						}
					}
					if((!imgLoaded || !sfxLoaded) || !musLoaded) counter++;
					else {
						hasLoaded = true;
						timeTask.repeats = false;
						return;
					}
				}
				else {
					Tail.log("Assets have already been loaded. Not loading again.", 4);
					timeTask.repeats = false;
					return;
				}
			}, null);
		}
		else hasLoaded = true;
		// "Instant" version (does not allow for an indicator)
		/*
		if(!hasLoaded){
			for(asset in imageManifest){
				if(asset != null && asset != ""){
					Tail.log('Loading asset: $asset', 1);
					assets.push(new ImageAsset(asset));
				}
			}
			for(asset in sfxManifest){
				if(asset != null && asset != ""){
					Tail.log('Loading asset: ${asset.substring(0, asset.length - 4)}', 1);
					assets.push(new SoundAsset(asset.substring(0, asset.length - 4)));
				}
			}
			for(asset in musicManifest){
				if(asset != null && asset != ""){
					Tail.log('Loading asset: ${asset.substring(0, asset.length - 4)}', 1);
					assets.push(new SoundAsset(asset.substring(0, asset.length - 4)));
				}
			}
			hasLoaded = true;
		}
		else Tail.log("Assets have already been loaded. Not loading again.", 4); */
	}

	function loadImageAsset(index:Int):Void {
		if(imageManifest[index] != "" && imageManifest[index] != null){
			Tail.log('Loading asset: ${imageManifest[index]}', 1);
			assets.push(new ImageAsset(imageManifest[index]));
			Tail.log('ID for asset is: ${assets[assets.length - 1].getPath()}', 1);
		}
	}
	function loadSfxAsset(index:Int):Void {
		if(sfxManifest[index] != "" && sfxManifest[index] != null){
			Tail.log('Loading asset: ${sfxManifest[index]}', 1);
			assets.push(new SoundAsset(sfxManifest[index].substring(0, sfxManifest[index].length - 4)));
			Tail.log('ID for asset is: ${assets[assets.length - 1].getPath()}', 1);
		}
	}
	function loadMusicAsset(index:Int):Void {
		if(musicManifest[index] != "" && musicManifest[index] != null){
			Tail.log('Loading asset: ${musicManifest[index]}', 1);
			assets.push(new SoundAsset(musicManifest[index].substring(0, musicManifest[index].length - 4)));
			Tail.log('ID for asset is: ${assets[assets.length - 1].getPath()}', 1);
		}
	}

	public static function get(path:String):Dynamic {
		//if(Util.inDebugMode()) diskMode = true;
		if(diskMode){
			var tempPath:String = "";
			// Convert back into a directory path from an asset path
			for(i in 0...path.length){
				if(path.charAt(i) == '.') tempPath += "/";
				else tempPath += path.charAt(i);
			}
			// If the path has a mus or sfx directory, then it is definitely a sound
			if(tempPath.indexOf("mus/") != -1 || tempPath.indexOf("sfx/") != -1) return DataUtils.getSoundData(tempPath);
			// Otherwise it's totally an image
			else {
				tempPath += ".png";
				return Script.getExternalImage(tempPath);
			}
		}
		else {
			for(i in 0...assets.length){
				if(assets[i].getPath() == path){
					return assets[i].getData();
				}
			}
			Tail.log('Invalid asset path - $path', 5);
			return null;
		}
	}

	public static function isDiskMode():Bool {
		return diskMode;
	}

	public static function isMemoryMode():Bool {
		return !diskMode;
	}

	public static function getByIndex(index:Int):Dynamic {
		return assets[index].getData();
	}
	public static function getPathByIndex(index:Int):Dynamic {
		return assets[index].getPath();
	}
	public static function getTypeByIndex(index:Int):String {
		return assets[index].getType();
	}

	public static function isDoneLoading():Bool { return hasLoaded; }

	public static function getCurrentlyLoading():String {
		if(!imgLoaded) return "Images";
		else if(!sfxLoaded) return "SFX";
		else return "Music";
	}

	public static function getTotal():Float {
		return (imageManifest.length - 1) + (sfxManifest.length - 1) + (musicManifest.length - 1);
	}

	public static function getLoaded():Float {
		return assets.length;
	}
}

/*
	To add listeners, create a new var of type "com.stencyl.Script" named "script", then add any of the following:
	Updating: script.addWhenUpdatedListener(null, function(elapsedTime:Float, list:Array<Dynamic>):Void {});
	Drawing: script.addWhenDrawingListener(null, function(g:G, x:Float, y:Float, list:Array<Dynamic>):Void {});
*/
