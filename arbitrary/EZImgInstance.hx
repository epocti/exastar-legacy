package scripts.tools;

import openfl.geom.Rectangle;
import scripts.assets.Assets;
import com.stencyl.models.Actor;
import motion.easing.IEasing;
import openfl.display.BlendMode;
import openfl.display.BitmapData;
import openfl.display.Bitmap;
import com.stencyl.behavior.TimedTask;
import com.stencyl.behavior.Script;
import com.stencyl.graphics.BitmapWrapper;

class EZImgInstance {
	var srcImage:Bitmap;
	var srcInstance:BitmapWrapper;
	var hasBeenAttached:Bool = false;
	var animCache:Array<Bitmap>;
	public var isLocked:Bool = false;
	
	// Modes:
	// b - bitmap (used with Assets.get)
	// a - actor
	// s - screen
	// f - external file
	// n - blank image, size of screen

	public function new(mode:String, autoAttach:Bool, assetPath:String = null, bitmap:Bitmap = null, actor:Actor = null, path:String = null){
		// Bitmap (Assets.get())
		if(mode == "g"){
			srcImage = new Bitmap(Assets.get(assetPath));
			srcInstance = new BitmapWrapper(srcImage);
			if(autoAttach){
				Script.attachImageToHUD(srcInstance, 0, 0);
				hasBeenAttached = true;
			}
		}
		// Bitmap
		else if(mode == "b"){
			srcImage = bitmap;
			srcInstance = new BitmapWrapper(srcImage);
			if(autoAttach){
				Script.attachImageToHUD(srcInstance, 0, 0);
				hasBeenAttached = true;
			}
		}
		// Actor
		else if(mode == "a"){
			srcImage = new Bitmap(Script.getImageForActor(actor));
			srcInstance = new BitmapWrapper(srcImage);
			if(autoAttach){
				Script.attachImageToHUD(srcInstance, 0, 0);
				hasBeenAttached = true;
			}
		}
		// Screen
		else if(mode == "s"){
			srcImage = new Bitmap(Script.captureScreenshot());
			srcInstance = new BitmapWrapper(srcImage);
			if(autoAttach){
				Script.attachImageToHUD(srcInstance, 0, 0);
				hasBeenAttached = true;
			}
		}
		// External image
		else if(mode == "f"){
			srcImage = new Bitmap(Script.getExternalImage(path));
			srcInstance = new BitmapWrapper(srcImage);
			if(autoAttach){
				Script.attachImageToHUD(srcInstance, 0, 0);
				hasBeenAttached = true;
			}
		}
		// Blank
		else if(mode == "n"){
			srcImage = new Bitmap(new BitmapData(Script.getScreenWidth(), Script.getScreenHeight(), true, 0x00FFFFFF));
			srcInstance = new BitmapWrapper(srcImage);
			if(autoAttach){
				Script.attachImageToHUD(srcInstance, 0, 0);
				hasBeenAttached = true;
			}
		}
		// Failsafe
		else {
			srcImage = new Bitmap(new BitmapData(Std.int(Script.getScreenWidth()), Std.int(Script.getSceneHeight()), true, 0));
			srcInstance = new BitmapWrapper(srcImage);
			if(autoAttach){
				Script.attachImageToHUD(srcInstance, 0, 0);
				hasBeenAttached = true;
			}
		}
	}

	// Attach images

	public function attachToScreen(x:Float, y:Float):Void {
		// Only attach if it hasn't already been attached to the screen
		if(!hasBeenAttached){
			Script.attachImageToHUD(srcInstance, Std.int(x), Std.int(y));
			hasBeenAttached = true;
		}
	}

	public function attachToWorld(layerName:String, x:Float, y:Float, inFront:Int):Void {
		// Only attach if it hasn't already been attached to the screen
		if(!hasBeenAttached){
			Script.attachImageToLayer(srcInstance, 1, layerName, Std.int(x), Std.int(y), inFront);
			hasBeenAttached = true;
		}
	}

	public function attachToActor(actor:Actor, x:Float, y:Float, inFront:Bool):Void {
		if(!hasBeenAttached){
			if(inFront) Script.attachImageToActor(srcInstance, actor, Std.int(x), Std.int(y), 1);
			else Script.attachImageToActor(srcInstance, actor, Std.int(x), Std.int(y), 0);
		}
	}

	public function detach():Void {
		// Only detach if it hasn't already been attached to the screen
		if(hasBeenAttached) Script.removeImage(srcInstance);
	}

	// Change images

	// Change the image that is in the instance - try not to make the new image larger than the first image that was displayed by the instance, it might cut off parts of the image
	public function changeImage(newImagePath:String):Void {
		Script.clearImage(srcImage.bitmapData);
		Script.drawImageOnImage(Assets.get(newImagePath), srcImage.bitmapData, 0, 0, BlendMode.NORMAL);
	}
	// Same as above, just skip AssetLoader
	public function changeImageBitmap(newImage:Bitmap):Void {
		Script.clearImage(srcImage.bitmapData);
		Script.drawImageOnImage(newImage.bitmapData, srcImage.bitmapData, 0, 0, BlendMode.NORMAL);
	}
	// Note: this one is an alternate method that deletes the previous canvas. Use only when initializing!
	public function changeImageBitmap2(bitmap:Bitmap){
		srcImage = bitmap;
		srcInstance = new BitmapWrapper(srcImage);
	}
	// Go straight to making a new bitmap from an external image when changing
	public function changeImageExt(dir:String):Void {
		var newImage:Bitmap = new Bitmap(Script.getExternalImage(dir));
		Script.clearImage(srcImage.bitmapData);
		Script.drawImageOnImage(newImage.bitmapData, srcImage.bitmapData, 0, 0, BlendMode.NORMAL);
	}
	// Go straight to making a new bitmap from the screen when changing
	public function changeImageScreen():Void {
		var newImage:Bitmap = new Bitmap(Script.captureScreenshot());
		Script.clearImage(srcImage.bitmapData);
		Script.drawImageOnImage(newImage.bitmapData, srcImage.bitmapData, 0, 0, BlendMode.NORMAL);
	}

	// Animation for instances
	// NOTE: Frame duration is in milliseconds - this function does not automatically convert to seconds like Stencyl's code gen does
	// Also, animations start with the initial frame ending in a "1". This is mainly due to the fact that aseprite exports animations starting with 1...
	public function enableAnimation(baseName:String, frames:Int, frameDuration:Int, looping:Bool):Void {
		var currentFrame:Int = 1;
		Script.runPeriodically(frameDuration, function(timeTask:TimedTask):Void {
			changeImage(baseName + currentFrame);
			if(looping){
				if(currentFrame + 1 > frames) currentFrame = 1;
				else currentFrame++;
			}
			else if(!looping){
				if(currentFrame + 1 > frames) currentFrame = frames;
				else currentFrame++;
			}
		}, null);
	}
	// Use an animation strip instead of individual frames
	public function enableAnimationStrip(stripDir:String, frames:Int, frameDuration:Int, looping:Bool):Void {
		var currentFrame:Int = 0;
		var tempStrip:BitmapWrapper = new BitmapWrapper(new Bitmap(Assets.get(stripDir)));

		// load in frames
		animCache = new Array<Bitmap>();
		for(i in 0...frames){
			animCache.push(new Bitmap(Script.getSubImage(tempStrip.img.bitmapData, Std.int((tempStrip.width / frames) * i), 0, Std.int(tempStrip.width / frames), Std.int(tempStrip.height))));
		}
		// changeImageBitmap(animCache[0]);

		if(looping){
			Script.runPeriodically(frameDuration, function(timeTask:TimedTask):Void {
				changeImageBitmap(animCache[currentFrame]);
				if(looping){
					if(currentFrame + 1 > frames - 1) currentFrame = 0;
					else currentFrame++;
				}
				else {
					if(currentFrame + 1 > frames - 1) currentFrame = frames - 1;
					else currentFrame++;
				}
			}, null);
		}
	}

	// Position
	public function getX():Float { return Std.int(srcInstance.x); }
	public function getY():Float { return Std.int(srcInstance.y); }
	public function getFloatX():Float { return srcInstance.x; }
	public function getFloatY():Float { return srcInstance.y; }
	public function setX(x:Float):Void { Script.setXForImage(srcInstance, Std.int(x)); }
	public function setY(y:Float):Void { Script.setYForImage(srcInstance, Std.int(y)); }
	public function setXY(x:Float, y:Float):Void {
		Script.setXForImage(srcInstance, Std.int(x));
		Script.setYForImage(srcInstance, Std.int(y));
	}
	public function centerOnScreen(horizontally:Bool, vertically:Bool){
		if(horizontally) setX(Std.int(Util.getMidScreenX() - (getWidth() / 2)));
		if(vertically) setY(Std.int(Util.getMidScreenY() - (getHeight() / 2)));
	}

	// Set size
	public function getWidth():Int { return Std.int(srcInstance.width); }
	public function getHeight():Int { return Std.int(srcInstance.height); }
	public function setWidth(width:Float):Void { srcInstance.scaleX = (width / 100); }
	public function setHeight(height:Float):Void { srcInstance.scaleY = (height / 100); }

	// Fades
	public function setAlpha(amount:Float):Void { srcInstance.alpha = amount / 100; }
	public function fadeTo(alpha:Float, time:Float, curve:IEasing){ Script.fadeImageTo(srcInstance, alpha / 100, time, curve); }
	public function fadeIn(time:Float, curve:IEasing):Void { fadeTo(100, time, curve); }
	public function fadeOut(time:Float, curve:IEasing):Void { fadeTo(0, time, curve); }

	// Tweens
	public function growTo(width:Float, height:Float, time:Float, curve:IEasing):Void { Script.growImageTo(srcInstance, width / 100, height / 100, time, curve); }
	public function slideTo(x:Float, y:Float, time:Float, curve:IEasing):Void { Script.moveImageTo(srcInstance, x, y, time, curve); }
	public function slideBy(x:Float, y:Float, time:Float, curve:IEasing):Void { Script.moveImageBy(srcInstance, x, y, time, curve); }
	public function spinTo(amount:Float, time:Float, curve:IEasing):Void { Script.spinImageTo(srcInstance, amount, time, curve); }
	public function spinBy(amount:Float, time:Float, curve:IEasing):Void { Script.spinImageBy(srcInstance, amount, time, curve); }

	public function setOrigin(originLocation:String):Void {
		if(originLocation == "CENTER") srcInstance.setOrigin(getWidth() / 2, getHeight() / 2);
		else if (originLocation == "TOPLEFT") srcInstance.setOrigin(0, 0);
		else if (originLocation == "TOPMID") srcInstance.setOrigin(getWidth() / 2, 0);
		else if (originLocation == "RIGHTMID") srcInstance.setOrigin(getWidth(), getHeight() / 2);
		else if (originLocation == "BOTTOMMID") srcInstance.setOrigin(getWidth() / 2, getHeight());
		else if (originLocation == "LEFTMID") srcInstance.setOrigin(0, getHeight() / 2);
		else if (originLocation == "BOTTOMLEFT") srcInstance.setOrigin(0, getHeight());
		else if (originLocation == "BOTTOMRIGHT") srcInstance.setOrigin(getWidth(), getHeight());
		else srcInstance.setOrigin(0, 0);
	}

	public function setZIndex(index:Int):Void { Script.setOrderForImage(srcInstance, index); }
	public function sendToBack():Void { Script.bringImageToBack(srcInstance); }
	public function sendToFront():Void { Script.bringImagetoFront(srcInstance); }

	public function lock():Void {
		srcImage.bitmapData.lock();
		isLocked = true;
	}
	public function unlock():Void {
		srcImage.bitmapData.unlock();
		isLocked = false;
	}
	//public function setPixel(x:Float, y:Float, color:Int):Void { Script.imageSetPixel32(srcImage.bitmapData, Std.int(x), Std.int(y), color); }

	public function paste(imageData:BitmapData, x:Float, y:Float):Void { Script.drawImageOnImage(imageData, srcImage.bitmapData, Std.int(x), Std.int(y), BlendMode.ADD); }
	public function drawText(text:String, x:Float, y:Float, fontID:Int):Void { Script.drawTextOnImage(srcImage.bitmapData, text, Std.int(x), Std.int(y), Script.getFont(fontID)); }

	public function flipHorizontal():Void { Script.flipImageHorizontal(srcImage.bitmapData); }
	public function flipVertical():Void { Script.flipImageVertical(srcImage.bitmapData); }
	public function swapColor(from:Int, to:Int):Void { Script.imageSwapColor(srcImage.bitmapData, from, to); }

	public function mask(maskingImage:BitmapData, x:Float, y:Float, retainMode:Bool, clipAway:Bool):Void {
		if(retainMode) Script.retainImageUsingMask(srcImage.bitmapData, maskingImage, Std.int(x), Std.int(y));
		else Script.clearImageUsingMask(srcImage.bitmapData, maskingImage, Std.int(x), Std.int(y));
		//if(clipAway){
		//	Script.clearImagePartially(srcImage.bitmapData, maskingImage.width, 0, Std.int(srcImage.width) - maskingImage.width, Std.int(srcImage.height));
		//	Script.clearImagePartially(srcImage.bitmapData, 0, maskingImage.height, Std.int(srcImage.width), Std.int(srcImage.height) - maskingImage.height);
		//}
	}

	public function clear():Void { Script.clearImage(srcImage.bitmapData); }

	public function toString():String { return Script.imageToText(srcImage.bitmapData); }
}