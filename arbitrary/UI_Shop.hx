package scripts.ui;

/*
	ShopUI needs the following:
	- Shopworker image (DONE), with text bubble
	- Menu backing image (animated somehow - could be multiple ezimgs) (DONE)
	- Item images (DONE)
	- Shop's item+price list (DONE)
	- Interaction (duh) (DONE-ISH)
	- Purchasing screen, choosable amounts
 */

import com.stencyl.behavior.TimedTask;
import motion.easing.Linear;
import com.stencyl.graphics.G;
import com.polydes.datastruct.DataStructures;
import motion.easing.Expo;
import com.stencyl.behavior.Script;
import scripts.tools.EZImgInstance;
import scripts.tools.Util;
import scripts.id.FontID;

class UI_Shop {
	var menuSel:Int = 0;
	var script:Script = new Script();
	// Images
	var backingImg:EZImgInstance = new EZImgInstance("g", true, "ui.shop.menuBacking");
	var backingImgFX:Array<EZImgInstance> = new Array<EZImgInstance>();
	var itemImgs:Array<EZImgInstance> = new Array<EZImgInstance>();
	var shopw:EZImgInstance = new EZImgInstance("g", true, "ui.shop.shopw.n");
	var shopwBubble:EZImgInstance = new EZImgInstance("g", true, "ui.shop.shopwBubble");
	var shopwBubblePreview:EZImgInstance = new EZImgInstance("g", true, "ui.menu.inv.item.test");
	var itemList:Array<String> = new Array<String>();
	// todo: this should be retrieved via se_shopX or something
	var shopName:String = "alshire";

	public function new(){
		// TODO: Move a lot of this to the show() function when it is made
		itemList = DataStructures.get("shop_" + shopName).itemList;

		// Menu backing
		backingImg.setX(480);
		backingImg.slideTo(240, 0, .75, Expo.easeOut);

		// Menu backing effect
		for(i in 0...Std.int(Script.getScreenHeight() / 32) + 1){
			backingImgFX.push(new EZImgInstance("g", true, "ui.shop.backingEffect"));
			backingImgFX[i].setXY(480, i * 32);
			backingImgFX[i].slideTo(208, i * 32, .75, Expo.easeOut);
			backingImgFX[i].enableAnimationStrip("ui.shop.backingEffect", 32, 33, true);
		}

		// ShopWorker slidein
		shopw.setXY(24, 360);
		shopw.slideBy(0, -204, .75, Expo.easeOut);

		// Bubble creation
		initBubble();
		initBubblePreview();

		// Interaction
		script.addWhenUpdatedListener(null, function(elapsedTime:Float, list:Array<Dynamic>):Void {
			if(Script.isKeyPressed("up")){
				a_squeezeBubble();
				a_shopw1();
				shopwBubblePreview.changeImage("ui.menu.inv.item." + itemList[menuSel]);
				if(menuSel > 0) menuSel--;
				else if(menuSel == 0) menuSel = itemList.length - 1;
			}
			if(Script.isKeyPressed("down")){
				a_squeezeBubble();
				a_shopw1();
				shopwBubblePreview.changeImage("ui.menu.inv.item." + itemList[menuSel]);
				if(menuSel < itemList.length - 1) menuSel++;
				else if(menuSel == itemList.length - 1) menuSel = 0;
			}
		});

		// Draw calls
		script.addWhenDrawingListener(null, function(g:G, x:Float, y:Float, list:Array<Dynamic>):Void {
			g.setFont(Script.getFont(684));
			g.drawString(Util.getString("SHOPUI_TITLE"), 244, 0);
			g.setFont(Script.getFont(FontID.MAIN));
			g.drawString(Util.getString("SHOPUI_HASCURRENCY") + " " + Util.getAttr("pynts"), Script.getScreenWidth() - 4 - g.font.font.getTextWidth("$ " + Util.getAttr("pynts")), 0);
			for(i in 0...itemList.length){
				g.drawString(DataStructures.get("i_" + itemList[i]).dName, 274, (i * 16) + 32);
				g.drawString(Util.getString("SHOPUI_PRICECURRENCY") + " " + DataStructures.get("i_" + itemList[i]).price, 480 - g.font.font.getTextWidth("$ " + DataStructures.get("i_" + itemList[i]).price) - 4, (i * 16) + 32);
			}
			g.drawString("^", 244, (menuSel * 16) + 32);

			// Bubble
			g.drawString(DataStructures.get("i_" + itemList[menuSel]).dName, shopwBubble.getX() + 28, shopwBubble.getY() + 6);
			g.drawString(DataStructures.get("i_" + itemList[menuSel]).shopDescription[0], shopwBubble.getX() + 9, shopwBubble.getY() + 23);
		});

		for(i in 0...itemList.length){
			itemImgs.push(new EZImgInstance("g", true, "ui.menu.inv.item." + itemList[i]));
			itemImgs[i].setXY(255, (i * 16) + 32);
		}
	}

	function initBubble(){
		// Bubble creation
		shopwBubble.setOrigin("TOPLEFT");
		shopwBubble.setWidth(.01);
		shopwBubble.setHeight(.01);
		shopwBubble.setXY(0, 23);
		shopwBubble.spinTo(-1, .01, Linear.easeNone);
		shopwBubble.growTo(100, 100, .75, Expo.easeOut);
	}

	function initBubblePreview(){
		// Bubble preview creation
		shopwBubble.setZIndex(999);
		shopwBubblePreview.changeImage("ui.menu.inv.item." + itemList[0]);
		shopwBubblePreview.setXY(shopwBubble.getX() + 9, shopwBubble.getY() + 6);
	}

	function a_slideShopw(){
		shopw.slideTo(24, 170, .2, Expo.easeOut);
		Script.runLater(225, function(timeTask:TimedTask):Void { shopw.slideTo(24, 156, .2, Expo.easeOut); }, null);
	}

	function a_shopw1(){
		shopw.changeImage("ui.shop.shopw.c");
		a_slideShopw();
		Script.runLater(225, function(timeTask:TimedTask):Void { shopw.changeImage("ui.shop.shopw.n"); }, null);
	}

	function a_squeezeBubble():Void {
		shopwBubble.spinTo(0, .15, Expo.easeOut);
		Script.runLater(200, function(timeTask:TimedTask):Void {
			shopwBubble.spinTo(-1, .15, Expo.easeOut);
		}, null);
	}
}