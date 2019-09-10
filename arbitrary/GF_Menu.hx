package scripts.grapefruit;

// This module handles the drawing of the menu as well as the controls.

import com.stencyl.graphics.G;
import com.stencyl.behavior.Script;
import scripts.tools.Util;
import scripts.id.FontID;
import scripts.tools.EZImgInstance;
import openfl.geom.Point;

class GF_Menu {
	var script:Script = new Script();
	var gfRoot:Grapefruit;

	public var menuMode = "main";
	var menuBack:EZImgInstance = new EZImgInstance("g", false, "bttl.ui.uiMain");
	var menuImgs:Array<EZImgInstance> = new Array<EZImgInstance>();
	var menuHeaderImgs:Array<EZImgInstance> = new Array<EZImgInstance>();
	var menuItems:Array<Array<String>> = new Array<Array<String>>();
	var menuSel:Int = 0;
	var tempAction:Int = -1;
	var scndPt:Point = new Point(147, 292);
	var lastSetDesc:String = "";
	var descriptionLines:Array<String> = new Array<String>();

	public function new(gfRoot:Grapefruit){
		this.gfRoot = gfRoot;
		menuBack.attachToWorld("bttlUi", 0, 0, 0);

		// Init menu structure
		menuItems.push(["battle", "defend", "arcane", "card", "item", "pass", "run"]);
		menuHeaderImgs.push(new EZImgInstance("g", false, "bttl.ui.main_charHeader"));
		menuHeaderImgs[0].attachToWorld("bttlUi", 0, 0, 1);
		
		// Create main menu item images
		for(i in 0...menuItems[0].length){
			menuImgs.push(new EZImgInstance("g", false, "bttl.ui.main_" + menuItems[0][i]));
			if(i <= 5) menuImgs[i].attachToWorld("bttlUi", 0, 42 + (i * 32), 1);
			else menuImgs[i].attachToWorld("bttlUi", 0, 26 + (i * 32), 1);	// "run" item needs to be nudged up a bit
		}

		// Init description area array
		for(i in 0...5) descriptionLines.push("");

		// Input
		script.addWhenUpdatedListener(null, function(elapsedTime:Float, list:Array<Dynamic>):Void {
			if(!Util.inDialog()){
				// Selection key pressed
				/*
				if(Script.isKeyPressed("action1")){
					if(menuMode == "main"){
						if(menuSel == 0) menuMode = "comb";
						else if(menuSel == 1){
							menuMode = "card";
							gfRoot.deck.showCards(false);
						}
						else if(menuSel == 2) menuMode = "sp";
						else if(menuSel == 4) menuMode = "action";
						menuSel = 0;
					}
					else if(menuMode == "comb"){
						if(menuSel == 0) menuMode = "attk";
						else menuMode = "def";
						menuSel = 0;
					}
					else if(menuMode == "attk"){
						if(tempAction == 1){
							// do the thing
						}
					}
				}
				// Back key pressed
				else if(Script.isKeyPressed("action2")){
					if(menuMode == "comb"){
						menuMode = "main";
						menuSel = 0;
					}
					else if(menuMode == "attk"){
						menuMode = "comb";
						menuSel = 0;
					}
					else if(menuMode == "card"){
						gfRoot.deck.hideCards(false);
						menuMode = "main";
						menuSel = 1;
					}
					else if(menuMode == "sp"){
						menuMode = "main";
						menuSel = 2;
					}
					else if(menuMode == "action"){
						menuMode = "main";
						menuSel = 4;
					}
				}*/
				// Up pressed
				if(Script.isKeyPressed("up")){
					if(menuMode == "main" && menuSel - 1 > -1) menuSel--;
					else if(menuMode == "main") menuSel = 4;
				}
				// Down pressed
				else if(Script.isKeyPressed("down")){
					if(menuMode == "main" && menuSel + 1 < 5) menuSel++;
					else if(menuMode == "main") menuSel = 0;
				}
			}
		});

		// Drawing
		script.addWhenDrawingListener(null, function(g:G, x:Float, y:Float, list:Array<Dynamic>):Void {
			Script.setDrawingLayer(1, "drawLayer");
			// Draw menu
			g.setFont(Script.getFont(FontID.MAIN_WHITE));

			for(i in 0...descriptionLines.length){
				g.drawString(descriptionLines[i], scndPt.x, scndPt.y + (i * 14));
			}
			
			if(!Util.inDialog()) g.drawString("^", 4, 0); // Selector
			// Main
			
			if(menuMode == "main"){
				// Description drawing
				if(!Util.inDialog()){
					if(menuSel == 0) setDescText("GF_MENU_DESC_COMBAT");
					else if(menuSel == 1) setDescText("GF_MENU_DESC_CARDS");
					else if(menuSel == 2) setDescText("GF_MENU_DESC_SPECIAL");
					else if(menuSel == 3) setDescText("GF_MENU_DESC_ITEMS");
					else if(menuSel == 4) setDescText("GF_MENU_DESC_ACTIONS");
				}
			}
			// Attack
			else if(menuMode == "attk"){
				for(i in 0...gfRoot.enemies.getNumEnemies()) g.drawString(gfRoot.enemies.getEnemy(i).getName(), 17, 0); // Required lineY
				// Selection in enemy view
				g.strokeSize = 2;
				g.strokeColor = ColorConvert.getColorHSL(gfRoot.rainbowH, 200, 160);
				g.alpha = .75;
				g.drawRoundRect(gfRoot.enemies.getEnemy(menuSel).img.getX() - 7, gfRoot.enemies.getEnemy(menuSel).img.getY() - 7, gfRoot.enemies.getEnemy(menuSel).img.getWidth() + 14, gfRoot.enemies.getEnemy(menuSel).img.getHeight() + 14, 8);
			}
			// Special
			else if(menuMode == "sp"){
				/*
				g.drawString(Util.getString("GF_MENU_SPECIAL_MAKET34"), 17, lineY[0]);
				g.drawString(Util.getString("GF_MENU_SPECIAL_CLEARDECK"), 17, lineY[1]);
				g.drawString(Util.getString("GF_MENU_SPECIAL_RANDOMIZE"), 17, lineY[2]);
				g.drawString(Util.getString("GF_MENU_SPECIAL_TRADEDECKS"), 17, lineY[3]);
				g.drawString(Util.getString("GF_MENU_SPECIAL_TRANSAMP"), 17, lineY[4]);
				// Description drawing
				if(menuSel == 0) g.drawString(Util.getString("GF_MENU_DESC_SPECIAL_MAKET34"), 17, 225);
				else if(menuSel == 1) g.drawString(Util.getString("GF_MENU_DESC_SPECIAL_CLEARDECK"), 17, 225);
				else if(menuSel == 2) g.drawString(Util.getString("GF_MENU_DESC_SPECIAL_RANDOMIZE"), 17, 225);
				else if(menuSel == 3) g.drawString(Util.getString("GF_MENU_DESC_SPECIAL_TRADEDECKS"), 17, 225);
				else if(menuSel == 4) g.drawString(Util.getString("GF_MENU_DESC_SPECIAL_TRANSAMP"), 17, 225); */
			}
		});
	}

	function setDescText(tag:String){
		if(lastSetDesc != tag){
			lastSetDesc = tag;
			for(i in 0...5) descriptionLines[i] = "";
			var currentLine:Int = 0;
			var words:Array<String> = Util.getString(tag).split(" ");
			var limitWidth:Int = 330;
			var i:Int = 0;
			
			while (i < words.length){
				if(Script.getFont(FontID.MAIN_WHITE).font.getTextWidth(descriptionLines[currentLine] + words[i]) < limitWidth){
					descriptionLines[currentLine] += (words[i] + " ");
					i++;
				}
				else currentLine++;
			}
		}
	}
}