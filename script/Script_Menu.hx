package scripts;

import scripts.assets.Assets;
import scripts.tools.EZImgInstance;
import scripts.id.FontID;
import scripts.tools.Util;
import com.stencyl.graphics.G;
import com.stencyl.graphics.BitmapWrapper;
import com.stencyl.behavior.Script.*;
import com.stencyl.behavior.SceneScript;
import com.stencyl.Engine;
import com.stencyl.utils.Utils;
import openfl.display.Bitmap;
import openfl.events.KeyboardEvent;
import motion.Actuate;
import motion.easing.Expo;
import motion.easing.Linear;
import vixenkit.Tail;

class Script_Menu extends SceneScript {
	var inMenu:Bool = false;
	@:attribute("id='1' name='Enable Menu by Default' desc='Enable or disable accessing the menu for this scene. Can be enabled or disabled later.'")
	var bg:EZImgInstance = new EZImgInstance("g", true, "ui.menu.bg");
	var enableMenuByDefault:Bool = true;
	var menuMode:String = "sidebar";
	var miniMenuMode:String = "none";
	var mapImg:BitmapWrapper;
	var mapImgY:Float = -480;
	var menuSelX:Int = 0;
	var menuSelY:Int = 0;
	var miniMenuSelY:Int = 0;
	var mapSelX:Float = 0;
	var mapSelY:Float = 0;
	var mapSelImg:BitmapWrapper;
	var menuOpac:Float = 0;
	var itemImgs:Array<EZImgInstance> = new Array<EZImgInstance>();
	var itemCatImgs:Array<EZImgInstance> = new Array<EZImgInstance>();
	var sidebarImgs:Array<EZImgInstance> = new Array<EZImgInstance>();

    public function new(dummy:Int, dummy2:Engine){
		super();
		addWhenUpdatedListener(null, onUpdate);
		addWhenDrawingListener(null, onDraw);
	}
	public function onUpdate(elapsedTime:Float, list:Array<Dynamic>){ update(elapsedTime); }
	public function onDraw(g:G, x:Float, y:Float, list:Array<Dynamic>){ draw(g); }

	// ========

	override public function init(){
		// TODO: Maybe replace these BitmapWrappers with EZImgs?
		mapImg = new BitmapWrapper(new Bitmap(getExternalImage("img_gameMap.png")));
		mapSelImg = new BitmapWrapper(new Bitmap(getExternalImage("img_gameMap_cursor.png")));

		// Create sidebar images
		for(i in 0...8){
			sidebarImgs.push(new EZImgInstance("g", true, "ui.menu.sidebar." + i));
			sidebarImgs[i].setAlpha(0);
			sidebarImgs[i].setXY(4, 4 + ((i - 1) * 36));
			if(i == 0) sidebarImgs[i].setXY(1, 1);
		}

		// Create inventory item images
		for(i in 0...Util.inventory().getSize("all")){
			itemImgs.push(new EZImgInstance("g", true, "ui.menu.inv.item." + Util.inventory().getItems("all")[i][0].substring(2)));
			itemImgs[i].setXY(85, (i * 16) + 29);
			itemImgs[i].setAlpha(0);
			Tail.log("Create inventory item image for " + Util.inventory().getItems("all")[i][0], 0);
		}

		// Create inventory category images
		for(i in 0...8){
			itemCatImgs.push(new EZImgInstance("g", true, "ui.menu.inv.category.tab" + i));
			itemCatImgs[i].setAlpha(0);
			itemCatImgs[i].setXY(290 + (i * 24), 4);
			if(i == 0) itemCatImgs[i].setY(1);
		}

		bg.setAlpha(0);
		menuOpac = 0;

		// Disable/enable menu
		if(enableMenuByDefault) Util.setAttr("disableMenu", false);
		else Util.setAttr("disableMenu", true);

		// Input handling
		addAnyKeyPressedListener(function(event:KeyboardEvent, list:Array<Dynamic>):Void {
			if(inMenu){
				// Decrement menu selection
				if(isKeyPressed("up")){
					if(miniMenuMode == "none"){
						if(menuMode == "sidebar" && menuSelY - 1 > -1) menuSelY--;
						else if(menuMode == "sidebar") menuSelY = 4;
						else if(menuMode == "party" && menuSelY - 1 > -1) menuSelY--;
						else if(menuMode == "party") menuSelY = Util.party().getMemberCount() - 1;
						else if(menuMode == "tasks" && menuSelY - 1 > -1) menuSelY--;
						else if(menuMode == "tasks") menuSelY = Util.quests().getSize() - 1;
						else if(menuMode == "items" && menuSelY - 1 > -1) menuSelY--;
						else if(menuMode == "items") menuSelY = Util.inventory().getSize(getInvCategory()) - 1;
					}
					else if(miniMenuMode == "itemActions"){
						if(miniMenuSelY - 1 > -1) miniMenuSelY--;
						else miniMenuSelY = getNumberOfItemActions() - 1;
					}
					playSoundOnChannel(Assets.get("sfx.menu_gen_u"), 8);
				}
				// Increment menu selection
				else if(isKeyPressed("down")){
					if(miniMenuMode == "none"){
						if(menuMode == "sidebar" && menuSelY + 1 < 5) menuSelY++;
						else if(menuMode == "sidebar") menuSelY = 0;
						else if(menuMode == "party" && menuSelY + 1 < Util.party().getMemberCount()) menuSelY++;
						else if(menuMode == "party") menuSelY = 0;
						else if(menuMode == "tasks" && menuSelY + 1 < Util.quests().getSize()) menuSelY++;
						else if(menuMode == "tasks") menuSelY = 0;
						else if(menuMode == "items" && menuSelY + 1 < Util.inventory().getSize(getInvCategory())) menuSelY++;
						else if(menuMode == "items") menuSelY = 0;
					}
					else if(miniMenuMode == "itemActions"){
						if(miniMenuSelY + 1 < getNumberOfItemActions()) miniMenuSelY++;
						else miniMenuSelY = 0;
					}
					playSoundOnChannel(Assets.get("sfx.menu_gen_d"), 8);
				}
				else if(isKeyPressed("left")){
					if(miniMenuMode == "none"){
						if(menuMode == "items" && menuSelX - 1 > -1){
							menuSelX--;
							menuSelY = 0;
							playSoundOnChannel(Assets.get("sfx.menu_inv_l"), 8);
						}
						else if(menuMode == "items"){
							menuSelX = 6;
							menuSelY = 0;
							playSoundOnChannel(Assets.get("sfx.menu_inv_l"), 8);
						}
					}
				}
				else if(isKeyPressed("right")){
					if(miniMenuMode == "none"){
						if(menuMode == "items" && menuSelX + 1 < 7){
							menuSelX++;
							menuSelY = 0;
							playSoundOnChannel(Assets.get("sfx.menu_inv_r"), 8);
						}
						else if(menuMode == "items"){
							menuSelX = 0;
							menuSelY = 0;
							playSoundOnChannel(Assets.get("sfx.menu_inv_r"), 8);
						}
					}
				}
				else if(isKeyPressed("action1")){
					if(miniMenuMode == "none"){
						if(menuMode == "sidebar" && menuSelY == 0){
							menuMode = "party";
							menuSelY = 0;
							playSoundOnChannel(Assets.get("sfx.menu_gen_enterPanel"), 8);
						}
						else if(menuMode == "sidebar" && menuSelY == 1){
							menuMode = "tasks";
							menuSelY = 0;
							playSoundOnChannel(Assets.get("sfx.menu_gen_enterPanel"), 8);
						}
						else if(menuMode == "sidebar" && menuSelY == 2){
							menuMode = "items";
							menuSelY = 0;
							showItemCatImgs();
							showItemImgs();
							playSoundOnChannel(Assets.get("sfx.menu_gen_enterPanel"), 8);
						}
						else if(menuMode == "sidebar" && menuSelY == 3) menuMode = "map";
						else if(menuMode == "sidebar" && menuSelY == 4) menuMode = "stats";
						else if(menuMode == "items" && miniMenuMode == "none"){
							miniMenuMode = "itemActions";
							playSoundOnChannel(Assets.get("sfx.menu_gen_enterPanel"), 8);
						}
					}
				}
				else if(isKeyPressed("action2")){
					if(miniMenuMode == "none"){
						if(menuMode == "sidebar") hideMenu();
						else if(menuMode == "party"){
							menuMode = "sidebar";
							menuSelY = 0;
							playSoundOnChannel(Assets.get("sfx.menu_gen_exitPanel"), 8);
						}
						else if(menuMode == "tasks"){
							menuMode = "sidebar";
							menuSelY = 1;
							playSoundOnChannel(Assets.get("sfx.menu_gen_exitPanel"), 8);
						}
						else if(menuMode == "items"){
							hideItemCatImgs();
							hideItemImgs();
							menuMode = "sidebar";
							menuSelY = 2;
							playSoundOnChannel(Assets.get("sfx.menu_gen_exitPanel"), 8);
						}
					}
					else if(miniMenuMode == "itemActions"){
						miniMenuMode = "none";
						miniMenuSelY = 0;
						playSoundOnChannel(Assets.get("sfx.menu_gen_exitPanel"), 8);
					}
				}
			}
			// open/close
			if(isKeyPressed("menu")){
				if(Util.menuIsEnabled() && !Util.inDialog()){
					// open - TODO: make this a function like hideMenu()?
					if(!engine.isPaused() && !inMenu){
						bg.fadeTo(66, .25, Linear.easeNone);
						for(i in 0...sidebarImgs.length){
							sidebarImgs[i].fadeIn(.25, Linear.easeNone);
						}
						Util.enableInDialog();
						Util.disableStatOverlay();
						Actuate.tween(this, .25, {menuOpac:100}).ease(Linear.easeNone);
						playSoundOnChannel(Assets.get("sfx.menu_gen_enter"), 8);
						for(i in 0...6) Util.fadeChannelTo(i, .5, 1, .25);
						//engine.pause();
						Util.disableMovement();
						inMenu = true;
					}
					else hideMenu();
				}
			}
		});
	}

	public inline function update(elapsedTime:Float){
		// Inventory category
		itemCatImgs[0].slideTo((menuSelX * 24) + 311, 1, .1, Expo.easeOut);
		if(menuMode == "sidebar") sidebarImgs[0].slideTo(1, 1 + (menuSelY * 36), .1, Expo.easeOut);
		// TODO: this is super temporary and only barely does what we intend it to do
		if(inMenu){
			engine.allActors.reuseIterator = false;
			for(actorOnScreen in engine.allActors)
			{
				if(actorOnScreen != null && !actorOnScreen.dead && !actorOnScreen.recycled && actorOnScreen.isOnScreenCache)
				{
					actorOnScreen.setXVelocity(0);
					actorOnScreen.setYVelocity(0);
				}
			}
			engine.allActors.reuseIterator = true;
		}
	}

	public inline function draw(g:G){
		// Map images
		if(inMenu){
			attachImageToHUD(mapImg, 0, Std.int(mapImgY));
			// TODO: The old mapPlacementHelper no longer exists, replace this with the new one
			// attachImageToHUD(mapSelImg, Std.int((getValueForScene("mapPlacementHelper", "finalX") + mapSelX)), Std.int(((getValueForScene("mapPlacementHelper", "finalY") + mapImgY) + mapSelY)));
		}

		// Initialize main drawing colors and styles
		g.setFont(getFont(FontID.MAIN_WHITE));
		g.fillColor = Utils.getColorRGB(255,255,255);
		g.strokeColor = Utils.getColorRGB(255,255,255);
		g.strokeSize = 2;
		g.alpha = (menuOpac/100);

		if(inMenu && !(menuMode == "map")){
			// Sidebar
			g.drawLine(44, 0, 44, getScreenHeight());
			if(menuMode == "sidebar") g.drawString("koko, add the animation freezing + npc stopping", getScreenWidth() - g.font.font.getTextWidth("koko, add the animation freezing + npc stopping"), 1);

			// Party
			else if(menuMode == "party"){
				g.drawLine(45, 300, getScreenWidth(), 300);
				g.drawString("^", 74, (menuSelY * 94) + 47);
				for(i in 0...Util.party().getMemberCount()){
					g.setFont(getFont(FontID.MAIN_WHITE));
					g.strokeSize = 0;
					g.fillColor = Utils.getColorRGB(0, 127, 255);
					g.fillRoundRect(86, (i * 94) + 8, 30, 88, 8);
					// Text
					g.drawString(Util.party().getMember(i).getName() + " - " + Util.getStringWithVar("MENU_PARTY_LEVELNEW", ["" + Util.party().getMember(i).getLevel()]), 120, (i * 94) + 8);
					g.drawString(Util.getString("MENU_PARTY_HP"), 120, (i * 94) + 22);
					g.drawString(Util.getString("MENU_PARTY_MP"), 210, (i * 94) + 22);
					g.drawString(Util.getString("MENU_PARTY_SP"), 300, (i * 94) + 22);
					
					g.drawString(Util.getString("MENU_PARTY_EXP"), 210, (i * 94) + 36);
					//g.drawString(Util.getString("MENU_PARTY_EQUIPMENT"), 120, (i * 94) + 50);
					//g.drawString("W: " + Util.party().getMember(i).getWeaponName(), 120, (i * 94) + 64);
					//g.drawString("D: " + Util.party().getMember(i).getDefenseName(), 255, (i * 94) + 64);
					//g.drawString("C: " + Util.party().getMember(i).getCharmName(), 120, (i * 94) + 78);
					//g.drawString("M: " + Util.party().getMember(i).getMiscName(), 255, (i * 94) + 78);
					// Bar drawing
					g.fillColor = ColorConvert.getColorHSL((Util.party().getMember(i).getHp() / Util.party().getMember(i).getMaxHp()) * 120, 100, 100);
					g.fillRect(g.font.font.getTextWidth(Util.getString("MENU_PARTY_HP")) + 124, (i * 94) + 25, (Util.party().getMember(i).getHp() / Util.party().getMember(i).getMaxHp()) * 60, 10);
					g.fillColor = ColorConvert.getColorHSL(-((Util.party().getMember(i).getMp() / Util.party().getMember(i).getMaxMp()) * 120) + 360, 100, 100);
					g.fillRect(g.font.font.getTextWidth(Util.getString("MENU_PARTY_MP")) + 214, (i * 94) + 25, (Util.party().getMember(i).getMp() / Util.party().getMember(i).getMaxMp()) * 60, 10);
					g.fillColor = ColorConvert.getColorHSL((Util.party().getMember(i).getSp() / 100) * 360, 100, 100);
					g.fillRect(g.font.font.getTextWidth(Util.getString("MENU_PARTY_SP")) + 304, (i * 94) + 25, (Util.party().getMember(i).getSp() / 100) * 60, 10);
					g.fillColor = ColorConvert.getColorHSL(190, 100, ((Util.party().getMember(i).getXp() / Util.party().getMember(i).getToNext()) * 100) + 33);
					g.fillRect(g.font.font.getTextWidth(Util.getString("MENU_PARTY_EXP")) + 214, (i * 94) + 39, (Util.party().getMember(i).getXp() / Util.party().getMember(i).getToNext()) * 143, 10);
					g.strokeSize = 2;
					g.drawRect(g.font.font.getTextWidth(Util.getString("MENU_PARTY_HP")) + 124, (i * 94) + 25, 60, 10);
					g.drawRect(g.font.font.getTextWidth(Util.getString("MENU_PARTY_MP")) + 214, (i * 94) + 25, 60, 10);
					g.drawRect(g.font.font.getTextWidth(Util.getString("MENU_PARTY_SP")) + 304, (i * 94) + 25, 60, 10);
					g.drawRect(g.font.font.getTextWidth(Util.getString("MENU_PARTY_EXP")) + 214, (i * 94) + 39, 143, 10);
					// Bar values
					g.setFont(getFont(613));
					g.drawString(Util.party().getMember(i).getHp() + "/" + Util.party().getMember(i).getMaxHp(), g.font.font.getTextWidth(Util.getString("MENU_PARTY_HP")) + 137, (i * 94) + 28);
					g.drawString(Util.party().getMember(i).getMp() + "/" + Util.party().getMember(i).getMaxMp(), g.font.font.getTextWidth(Util.getString("MENU_PARTY_MP")) + 226, (i * 94) + 28);
					g.drawString(Util.party().getMember(i).getSp() + "/100", g.font.font.getTextWidth(Util.getString("MENU_PARTY_SP")) + 317, (i * 94) + 28);
					g.drawString(Util.party().getMember(i).getXp() + "/" + Util.party().getMember(i).getToNext(), g.font.font.getTextWidth(Util.getString("MENU_PARTY_EXP")) + 231, (i * 94) + 42);
				}
				g.setFont(getFont(FontID.MAIN_WHITE));
				g.drawString(Util.getString("MENU_PARTY_INACTIVE"), 74, 302);
				if(Util.inactiveParty().getMemberCount() == 0){
					g.drawString(Util.getString("MENU_PARTY_INACTIVEEMPTY"), 74, 316);
				}
			}

			// Tasks
			else if(menuMode == "tasks"){
				g.setFont(getFont(FontID.MAIN_WHITE));
				if(Util.quests().getSize() > 0){
					g.drawLine(70, 300, getScreenWidth(), 300);
					g.drawString("^", 74, (menuSelY * 16) + 8);
					for(i in 0...Util.quests().getSize()){
						g.drawString(Util.quests().getNameByIndex(i), 86, (i * 16) + 8);
					}
					g.drawString(Util.quests().getDescriptionByIndex(menuSelY)[0], 74, 302);
					g.drawString(Util.quests().getDescriptionByIndex(menuSelY)[1], 74, 316);
					g.drawString(Util.quests().getDescriptionByIndex(menuSelY)[2], 74, 330);
				}
				else g.drawString(Util.getString("MENU_QUEST_ALLCLEAR"), 74, 24);
			}

			// Items
			else if(menuMode == "items"){
				g.drawLine(70, 26, getScreenWidth(), 26);
				g.drawString(getInvCategory2(), 74, 4);
				if(Util.inventory().getItems(getInvCategory()).length > 0){
					g.drawString("^", 74, (menuSelY * 16) + 29);
					// Draw item list
					for(i in 0...Util.inventory().getItems(getInvCategory()).length){
						if(Util.inventory().isEquipmentByIndex(getInvCategory(), i)) g.setFont(getFont(683));
						g.drawString(Util.inventory().getNameByIndex(getInvCategory(), i) + "  x  " + Util.inventory().getAmtByIndex(getInvCategory(), i), 104, (i * 16) + 29);
						if(Util.inventory().isEquipmentByIndex(getInvCategory(), i)) g.setFont(getFont(FontID.MAIN_WHITE));
					}
					// Description
					g.drawLine(70, 300, getScreenWidth(), 300);
					g.drawString(Util.inventory().getDescriptionByIndex(getInvCategory(), menuSelY)[0], 74, 302);
					g.drawString(Util.inventory().getDescriptionByIndex(getInvCategory(), menuSelY)[1], 74, 316);
					g.drawString(Util.inventory().getDescriptionByIndex(getInvCategory(), menuSelY)[2], 74, 330);
					// Equipment description
					if(Util.inventory().isEquipmentByIndex(getInvCategory(), menuSelY)){
						g.setFont(getFont(683));
						if(Util.inventory().getCategoryByIndex(getInvCategory(), menuSelY) == "weapon") g.drawString(Util.getString("MENU_INV_DESCISWEAPON") + " " + Util.inventory().getDamageByIndex(getInvCategory(), menuSelY) + ". " + Util.inventory().getEquipmentDescByIndex(getInvCategory(), menuSelY), 74, 344);
						else if(Util.inventory().getCategoryByIndex(getInvCategory(), menuSelY) == "defense") g.drawString(Util.getString("MENU_INV_DESCISDEFENSE") + " " + Util.inventory().getDefenseByIndex(getInvCategory(), menuSelY) + ". " + Util.inventory().getEquipmentDescByIndex(getInvCategory(), menuSelY), 74, 344);
						else if(Util.inventory().getCategoryByIndex(getInvCategory(), menuSelY) == "charm") g.drawString(Util.getString("MENU_INV_DESCISCHARM") + " " + Util.inventory().getAccByIndex(getInvCategory(), menuSelY) + ". " + Util.inventory().getEquipmentDescByIndex(getInvCategory(), menuSelY), 74, 344);
						else g.drawString(Util.getString("MENU_INV_DESCISEQUIPMENT") + Util.inventory().getEquipmentDescByIndex(getInvCategory(), menuSelY), 74, 344);
						g.setFont(getFont(FontID.MAIN_WHITE));
					}
				}
				else g.drawString(Util.getString("MENU_INV_CATEMPTY"), 74, 29);
				// Minimenu divider
				if(miniMenuMode != "none"){
					g.drawLine(360, 26, 360, 300);
					g.drawString("^", 364, (miniMenuSelY * 16) + 29);
				}
				// Minimenu action drawing
				if(miniMenuMode == "itemActions"){
					if((Util.inventory().isEquipmentByIndex(getInvCategory(), menuSelY) && Util.inventory().isUsableOWByIndex(getInvCategory(), menuSelY)) && Util.inventory().isDiscardableByIndex(getInvCategory(), menuSelY)){
						g.drawString(Util.getString("MENU_INV_EQUIP"), 376, 29);
						g.drawString(Util.getString("MENU_INV_USE"), 376, 45);
						g.drawString(Util.getString("MENU_INV_DISCARD"), 376, 61);
					}
					else if(Util.inventory().isEquipmentByIndex(getInvCategory(), menuSelY) && Util.inventory().isDiscardableByIndex(getInvCategory(), menuSelY)){
						g.drawString(Util.getString("MENU_INV_EQUIP"), 376, 29);
						g.drawString(Util.getString("MENU_INV_DISCARD"), 376, 45);
					}
					else if(Util.inventory().isUsableOWByIndex(getInvCategory(), menuSelY) && Util.inventory().isDiscardableByIndex(getInvCategory(), menuSelY)){
						g.drawString(Util.getString("MENU_INV_USE"), 376, 29);
						g.drawString(Util.getString("MENU_INV_DISCARD"), 376, 45);
					}
					else if(Util.inventory().isUsableOWByIndex(getInvCategory(), menuSelY)) g.drawString(Util.getString("MENU_INV_USE"), 376, 29);
					else if(Util.inventory().isEquipmentByIndex(getInvCategory(), menuSelY)) g.drawString(Util.getString("MENU_INV_EQUIP"), 376, 29);
					else if(Util.inventory().isDiscardableByIndex(getInvCategory(), menuSelY)) g.drawString(Util.getString("MENU_INV_DISCARD"), 376, 29);
					else g.drawString(Util.getString("MENU_INV_NOACTIONS"), 376, 29);
				}
			}
			// Stats screen
			else if(menuMode == "stats"){
				g.setFont(getFont(FontID.MAIN_WHITE));
				g.drawString(Util.getString("STAT_TIMEPLAYED") + " " + TimeConversions.convertTime(Util.getAttr("gs_stats").get("timePlayed"),"s","hh:mm:ss"), 130, 10);
				g.drawString(Util.getString("STAT_LAUNCHES") + " " + Util.getAttr("gs_stats").get("powerOns") + " " + Util.getString("STAT_LAUNCHTIMES"), 130, 26);
			}
		}
		// Map info bubble
		if(inMenu && menuMode == "map"){
			g.fillColor = Utils.getColorRGB(0,0,0);
			g.alpha = .75;
			g.strokeSize = 0;
			g.fillRoundRect(getScreenWidth() - 64, getScreenHeight() - 32, 100, 100, 15);
		}
	}

	function hideMenu(){
		if((/*engine.isPaused() && */inMenu) && menuMode == "sidebar"){
			// Actuate.tween(this, .25, {bgOpac:0}).ease(Linear.easeNone);
			bg.fadeOut(.25, Linear.easeNone);
			for(i in 0...sidebarImgs.length){
				sidebarImgs[i].fadeOut(.25, Linear.easeNone);
			}
			Util.enableStatOverlay();
			Actuate.tween(this, .25, {menuOpac:0}).ease(Linear.easeNone);
			Actuate.tween(this, .25, {mapImgY:-480}).ease(Linear.easeNone);
			playSoundOnChannel(Assets.get("sfx.menu_gen_exit"), 8);
			for(i in 0...6) Util.fadeChannelTo(i, .5, .25, 1);
			//engine.unpause();
			Util.disableInDialog();
			Util.enableMovement();
			inMenu = false;
		}
	}

	// Return inventory category
	function getInvCategory():String {
		if(menuSelX == 0) return "all";
		else if(menuSelX == 1) return "usable";
		else if(menuSelX == 2) return "status";
		else if(menuSelX == 3) return "weapon";
		else if(menuSelX == 4) return "defense";
		else if(menuSelX == 5) return "charm";
		else if(menuSelX == 6) return "key";
		else return "all";
	}
	// Return user-readable category
	function getInvCategory2():String {
		if(menuSelX == 0) return Util.getString("MENU_INV_CAT_ALL");
		else if(menuSelX == 1) return Util.getString("MENU_INV_CAT_USABLE");
		else if(menuSelX == 2) return Util.getString("MENU_INV_CAT_STATUS");
		else if(menuSelX == 3) return Util.getString("MENU_INV_CAT_WEAPON");
		else if(menuSelX == 4) return Util.getString("MENU_INV_CAT_DEFENSE");
		else if(menuSelX == 5) return Util.getString("MENU_INV_CAT_CHARM");
		else if(menuSelX == 6) return Util.getString("MENU_INV_CAT_KEY");
		else return "all";
	}
	function getNumberOfItemActions():Int {
		if((Util.inventory().isEquipmentByIndex(getInvCategory(), menuSelY) && Util.inventory().isUsableOWByIndex(getInvCategory(), menuSelY)) && Util.inventory().isDiscardableByIndex(getInvCategory(), menuSelY))
			return 3;
		else if(Util.inventory().isEquipmentByIndex(getInvCategory(), menuSelY) && Util.inventory().isDiscardableByIndex(getInvCategory(), menuSelY)) return 2;
		else if(Util.inventory().isUsableOWByIndex(getInvCategory(), menuSelY) && Util.inventory().isDiscardableByIndex(getInvCategory(), menuSelY)) return 2;
		else if(Util.inventory().isUsableOWByIndex(getInvCategory(), menuSelY)) return 1;
		else if(Util.inventory().isEquipmentByIndex(getInvCategory(), menuSelY)) return 1;
		else if(Util.inventory().isDiscardableByIndex(getInvCategory(), menuSelY)) return 1;
		else return 0;
	}
	function showItemImgs():Void { for(i in 0...itemImgs.length) itemImgs[i].setAlpha(100); Tail.log("Inventory item images shown", 0); }
	function hideItemImgs():Void { for(i in 0...itemImgs.length) itemImgs[i].setAlpha(0); Tail.log("Inventory item images hidden", 0); }
	function hideItemCatImgs():Void { for(i in 0...8) itemCatImgs[i].setAlpha(0); }
	function showItemCatImgs():Void { for(i in 0...8) itemCatImgs[i].setAlpha(100); }
}
