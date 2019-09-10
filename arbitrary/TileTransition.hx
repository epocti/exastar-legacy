package scripts.gfx;

import scripts.assets.Assets;
import motion.easing.Expo;
import com.stencyl.behavior.TimedTask;
import scripts.tools.EZImgInstance;
import com.stencyl.behavior.Script.*;

class TileTransition {
	var tileX:Int = 0;
	var tileY:Int = 0;
	var tiles:Array<EZImgInstance> = new Array<EZImgInstance>();
	var i:Int = 0;
	var isOut:Bool = false;
	var randomSel:Int = 1;
	static var imgCache:Array<String> = new Array<String>();

	public function new(){}

	public function createIn():Void {
		i = 0;
		runPeriodically(60, function(timeTask:TimedTask):Void {
			if(i < 48 && !isOut){
				if(i % 2 == 0){
					playSoundOnChannel(Assets.get("sfx.tileTransition1"), 4);
					tiles.push(new EZImgInstance("g", true, "gfx.transition.tile0"));
					imgCache.push("tile0.png");
				}
				else {
					playSoundOnChannel(Assets.get("sfx.tileTransition2"), 4);
					randomSel = randomInt(1, 5);
					tiles.push(new EZImgInstance("g", true, "gfx.transition.tile" + randomSel));
					imgCache.push("tile" + randomSel + ".png");
				}
				tiles[i].setXY(tileX, tileY);
				if(i < 7){
					tiles[i].setOrigin("LEFTMID");
					tiles[i].setWidth(0);
					tileX += 60;
				}
				else if(i > 6 && i < 12){
					tiles[i].setOrigin("TOPMID");
					tiles[i].setHeight(0);
					tileY += 60;
				}
				else if(i > 11 && i < 19){
					tiles[i].setOrigin("RIGHTMID");
					tiles[i].setWidth(0);
					tileX -= 60;
				}
				else if(i > 18 && i < 23){
					tiles[i].setOrigin("BOTTOMMID");
					tiles[i].setHeight(0);
					tileY -= 60;
				}
				else if(i > 22 && i < 29){
					tiles[i].setOrigin("LEFTMID");
					tiles[i].setWidth(0);
					tileX += 60;
				}
				else if(i > 28 && i < 32){
					tiles[i].setOrigin("TOPMID");
					tiles[i].setHeight(0);
					tileY += 60;
				}
				else if(i > 31 && i < 37){
					tiles[i].setOrigin("RIGHTMID");
					tiles[i].setWidth(0);
					tileX -= 60;
				}
				else if(i > 36 && i < 39){
					tiles[i].setOrigin("BOTTOMMID");
					tiles[i].setHeight(0);
					tileY -= 60;
				}
				else if(i > 38 && i < 43){
					tiles[i].setOrigin("LEFTMID");
					tiles[i].setWidth(0);
					tileX += 60;
				}
				else if(i > 42 && i < 44){
					tiles[i].setOrigin("TOPMID");
					tiles[i].setHeight(0);
					tileY += 60;
				}
				else {
					tiles[i].setOrigin("RIGHTMID");
					tiles[i].setWidth(0);
					tileX -= 60;
				}
				tiles[i].growTo(100, 100, .15, Expo.easeOut);
				i++;
			}
		}, null);
	}

	public function createOut():Void {
		i = 0;
		isOut = true;
		runPeriodically(60, function(timeTask:TimedTask):Void {
			if(i < 48){
				if(i % 2 == 0) playSoundOnChannel(Assets.get("sfx.tileTransition1"), 4);
				else playSoundOnChannel(Assets.get("sfx.tileTransition2"), 4);

				if(i < 7){
					tiles[i].setOrigin("RIGHTMID");
					tiles[i].growTo(0, 100, .15, Expo.easeOut);
				}
				else if(i > 6 && i < 12){
					tiles[i].setOrigin("BOTTOMMID");
					tiles[i].growTo(100, 0, .15, Expo.easeOut);
				}
				else if(i > 11 && i < 19){
					tiles[i].setOrigin("LEFTMID");
					tiles[i].growTo(0, 100, .15, Expo.easeOut);
				}
				else if(i > 18 && i < 23){
					tiles[i].setOrigin("TOPMID");
					tiles[i].growTo(100, 0, .15, Expo.easeOut);
				}
				else if(i > 22 && i < 29){
					tiles[i].setOrigin("RIGHTMID");
					tiles[i].growTo(0, 100, .15, Expo.easeOut);
				}
				else if(i > 28 && i < 32){
					tiles[i].setOrigin("BOTTOMMID");
					tiles[i].growTo(100, 0, .15, Expo.easeOut);
				}
				else if(i > 31 && i < 37){
					tiles[i].setOrigin("LEFTMID");
					tiles[i].growTo(0, 100, .15, Expo.easeOut);
				}
				else if(i > 36 && i < 39){
					tiles[i].setOrigin("TOPMID");
					tiles[i].growTo(100, 0, .15, Expo.easeOut);
				}
				else if(i > 38 && i < 43){
					tiles[i].setOrigin("RIGHTMID");
					tiles[i].growTo(0, 100, .15, Expo.easeOut);
				}
				else if(i > 42 && i < 44){
					tiles[i].setOrigin("BOTTOMMID");
					tiles[i].growTo(100, 0, .15, Expo.easeOut);
				}
				else {
					tiles[i].setOrigin("LEFTMID");
					tiles[i].growTo(0, 100, .15, Expo.easeOut);
				}
				i++;
			}
		}, null);
	}

	public function createOutQuick():Void {
		i = 0;
		isOut = true;
		runPeriodically(30, function(timeTask:TimedTask):Void {
			if(i < 48){
				if(i % 2 == 0) playSoundOnChannel(Assets.get("sfx.tileTransition1"), 4);
				else playSoundOnChannel(Assets.get("sfx.tileTransition2"), 4);

				if(i < 7){
					tiles[i].setOrigin("RIGHTMID");
					tiles[i].growTo(0, 100, .1, Expo.easeOut);
				}
				else if(i > 6 && i < 12){
					tiles[i].setOrigin("BOTTOMMID");
					tiles[i].growTo(100, 0, .1, Expo.easeOut);
				}
				else if(i > 11 && i < 19){
					tiles[i].setOrigin("LEFTMID");
					tiles[i].growTo(0, 100, .1, Expo.easeOut);
				}
				else if(i > 18 && i < 23){
					tiles[i].setOrigin("TOPMID");
					tiles[i].growTo(100, 0, .1, Expo.easeOut);
				}
				else if(i > 22 && i < 29){
					tiles[i].setOrigin("RIGHTMID");
					tiles[i].growTo(0, 100, .1, Expo.easeOut);
				}
				else if(i > 28 && i < 32){
					tiles[i].setOrigin("BOTTOMMID");
					tiles[i].growTo(100, 0, .1, Expo.easeOut);
				}
				else if(i > 31 && i < 37){
					tiles[i].setOrigin("LEFTMID");
					tiles[i].growTo(0, 100, .1, Expo.easeOut);
				}
				else if(i > 36 && i < 39){
					tiles[i].setOrigin("TOPMID");
					tiles[i].growTo(100, 0, .1, Expo.easeOut);
				}
				else if(i > 38 && i < 43){
					tiles[i].setOrigin("RIGHTMID");
					tiles[i].growTo(0, 100, .1, Expo.easeOut);
				}
				else if(i > 42 && i < 44){
					tiles[i].setOrigin("BOTTOMMID");
					tiles[i].growTo(100, 0, .1, Expo.easeOut);
				}
				else {
					tiles[i].setOrigin("LEFTMID");
					tiles[i].growTo(0, 100, .1, Expo.easeOut);
				}
				i++;
			}
		}, null);
	}

	public function immediate(preserveCache:Bool):Void {
		for(i in 0...48){
			if(i < 48 && !isOut){
				tiles.push(new EZImgInstance("g", true, "gfx.transition." + imgCache[i]));
				tiles[i].setXY(tileX, tileY);
				if(i < 7){
					tiles[i].setOrigin("LEFTMID");
					tileX += 60;
				}
				else if(i > 6 && i < 12){
					tiles[i].setOrigin("TOPMID");
					tileY += 60;
				}
				else if(i > 11 && i < 19){
					tiles[i].setOrigin("RIGHTMID");
					tileX -= 60;
				}
				else if(i > 18 && i < 23){
					tiles[i].setOrigin("BOTTOMMID");
					tileY -= 60;
				}
				else if(i > 22 && i < 29){
					tiles[i].setOrigin("LEFTMID");
					tileX += 60;
				}
				else if(i > 28 && i < 32){
					tiles[i].setOrigin("TOPMID");
					tileY += 60;
				}
				else if(i > 31 && i < 37){
					tiles[i].setOrigin("RIGHTMID");
					tileX -= 60;
				}
				else if(i > 36 && i < 39){
					tiles[i].setOrigin("BOTTOMMID");
					tileY -= 60;
				}
				else if(i > 38 && i < 43){
					tiles[i].setOrigin("LEFTMID");
					tileX += 60;
				}
				else if(i > 42 && i < 44){
					tiles[i].setOrigin("TOPMID");
					tileY += 60;
				}
				else {
					tiles[i].setOrigin("RIGHTMID");
					tileX -= 60;
				}
			}
		}
		// Dispose of cache to make way for a new transition
		if(!preserveCache) imgCache = [];
	}
}