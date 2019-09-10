package scripts.ui;

import scripts.assets.Assets;
import scripts.id.FontID;
import com.polydes.datastruct.DataStructures;
import motion.easing.Quad;
import scripts.tools.Util;
import com.stencyl.behavior.TimedTask;
import com.stencyl.behavior.Script;
import motion.easing.Linear;
import motion.easing.Expo;
import scripts.tools.EZImgInstance;

class UI_ItemGet {
	var script:Script = new Script();
	var banner:EZImgInstance = new EZImgInstance("g", false, "ui.itemGet.banner");
	var sc:EZImgInstance = new EZImgInstance("g", false, "ui.itemGet.showcase");	// Showcase
	var scs:EZImgInstance = new EZImgInstance("g", false, "ui.itemGet.showcaseShadow");	// Showcase shadow
	var sci:EZImgInstance;	// Showcase item
	var indic:EZImgInstance;
	var enableOut:Bool = false;
	var out:Bool = false;

	public function new(itemGot:String, amount:Int){
		for(i in 0...6) Util.fadeChannelTo(i, .5, 1, .25);
		if(DataStructures.get("i_" + itemGot).category == "key") Script.playSoundOnChannel(Assets.get("mus.keyItemGet"), 7);
		else Script.playSoundOnChannel(Assets.get("mus.itemGet"), 7);

		sci = new EZImgInstance("g", false, "ui.menu.inv.item." + itemGot);

		// Banner anim
		if(amount == 1) banner.drawText(DataStructures.get("i_" + itemGot).dName, 392 - Script.getFont(FontID.MAIN_WHITE).font.getTextWidth(DataStructures.get("i_" + itemGot).dName), 48, FontID.MAIN_WHITE);
		else banner.drawText(amount + " x " + DataStructures.get("i_" + itemGot).dName, 392 - Script.getFont(FontID.MAIN_WHITE).font.getTextWidth(amount + " x " + DataStructures.get("i_" + itemGot).dName), 48, FontID.MAIN_WHITE);
		banner.drawText(DataStructures.get("i_" + itemGot).tagline, 392 - Script.getFont(683).font.getTextWidth(DataStructures.get("i_" + itemGot).tagline), 60, 683);
		banner.attachToScreen(-banner.getWidth(), 24);
		banner.slideTo(-9, 24, .8, Expo.easeOut);

		// Attach showcase
		scs.attachToScreen(388, 72 - 300);
		sc.attachToScreen(390, 70 - 300);
		sci.attachToScreen(416, 96 - 300);

		// Slide in showcase
		sc.slideBy(0, 300, .8, Expo.easeOut);
		scs.slideBy(0, 300, .8, Expo.easeOut);
		sci.slideBy(0, 300, .8, Expo.easeOut);

		// Showcase item anim
		sci.growTo(200, 200, .01, Linear.easeNone);
		sci.setOrigin("CENTER");
		sci.spinBy(-8, 2, Quad.easeInOut);
		Script.runLater(2000, function(timeTask:TimedTask):Void { sci.spinBy(16, 2, Quad.easeInOut); }, null);
		Script.runPeriodically(4000, function(timeTask:TimedTask):Void {
			sci.spinBy(-16, 2, Quad.easeInOut);
			Script.runLater(2000, function(timeTask:TimedTask):Void { sci.spinBy(16, 2, Quad.easeInOut); }, null);
		}, null);

		// Showcase anim
		sc.setOrigin("CENTER");
		scs.setOrigin("CENTER");
		sc.spinBy(360, 4, Linear.easeNone);
		scs.spinBy(360, 4, Linear.easeNone);
		Script.runPeriodically(4000, function(timeTask:TimedTask):Void {
			sc.spinBy(360, 4, Linear.easeNone);
			scs.spinBy(360, 4, Linear.easeNone);
		}, null);

		// Add item
		Util.inventory().addItem("i_" + itemGot, amount);

		// Player attribute setting
		Script_Emotive.setAnim("alex", "itemGet", "d", false, false);
		Util.disableMovement();
		Util.disableStatOverlay();

		Script.runLater(2000, function(timeTask:TimedTask):Void {
			enableOut = true;
			indic = new EZImgInstance("g", true, "ui.waitIndic1");
			indic.setXY(460, 26);
			indic.enableAnimation("ui.waitIndic", 14, 100, true);
		}, null);

		// Out
		script.addWhenUpdatedListener(null, function(elapsedTime:Float, list:Array<Dynamic>):Void {
			if((Script.isKeyPressed("action1") && !out) && enableOut){
				out = true;
				for(i in 0...6) Util.fadeChannelTo(i, .5, .25, 1);
				banner.slideTo(Script.getScreenWidth(), 24, .8, Expo.easeOut);
				sc.slideBy(0, -300, .8, Expo.easeOut);
				scs.slideBy(0, -300, .8, Expo.easeOut);
				sci.slideBy(0, -300, .8, Expo.easeOut);
				indic.setAlpha(0);
				Util.enableMovement();
				Util.disableInDialog();
				Util.enableStatOverlay();
				Script_Emotive.setAnim("alex", "n", "d", false, false);
			}
		});
	}
}