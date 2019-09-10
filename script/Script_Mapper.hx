package scripts;

import scripts.tools.Util;
import com.stencyl.graphics.G;
import com.stencyl.behavior.Script.*;
import com.stencyl.behavior.SceneScript;
import com.stencyl.models.Actor;
import com.stencyl.Engine;
import com.stencyl.utils.Utils;

class Script_Mapper extends SceneScript {
	var debugDraw:Bool = false;
	var squaresH:Int;
	var squaresV:Int;
	@:attribute("id='1' name='Actor to Check' desc=''")
	public var player:Actor;
	var playerX:Float;
	var playerY:Float;
	var playerSqH:Int;
	var playerSqV:Int;
	var playerXinBox:Float;
	var playerYinBox:Float;
	var autoPlace:Bool;
	@:attribute("id='2' name='AutoPlace Override scenes' desc='Only if coming from these scenes, AutoPlace will not activate. Acts like a blacklist. Make this empty to always enable AutoPlace, or make the first value to ALL to completely disable.' type='LIST'")
	var blacklistedScenes:Array<Dynamic>;
	@:attribute("id='3' name='Prefer Selective AutoPlace' desc='Only if coming from the below scenes, AutoPlace WILL activate. Acts like a whitelist.'")
	var preferSelectiveAutoPlace:Bool;
	@:attribute("id='4' name='Whitelisted Scenes' desc='' type='LIST'")
	var whitelistedScenes:Array<Dynamic>;

	public function new(dummy:Int, dummy2:Engine){
		super();
		addWhenUpdatedListener(null, onUpdate);
		addWhenDrawingListener(null, onDraw);
		nameMap.set("player", "player");
	}
	public function onUpdate(elapsedTime:Float, list:Array<Dynamic>){ update(elapsedTime); }
	public function onDraw(g:G, x:Float, y:Float, list:Array<Dynamic>){ draw(g); }

	// ==== none of this code was commented and yet it plays an integral role in exastar, help ====

	override public function init(){
		// Get amount of scene squares (starting at 0 for 1)
		squaresH = Std.int(getSceneWidth() / 480) - 1;
		squaresV = Std.int(getSceneHeight() / 360) - 1;

		// Blacklist/whitelist autoplace
		if(blacklistedScenes.length == 0 && !preferSelectiveAutoPlace) autoPlace = true;
		else if(blacklistedScenes[0] == "ALL" && !preferSelectiveAutoPlace) autoPlace = false;
		else if(!preferSelectiveAutoPlace && lastSceneIsBlacklisted()) autoPlace = false;
		else if(preferSelectiveAutoPlace && lastSceneIsWhitelisted()) autoPlace = true;
		else autoPlace = false;

		// Autoplace
		if(autoPlace){
			// Coming from the top (move to bottom)
			if(Util.getAttr("gs_loc").get("comingFromSide") == "TOP"){
				player.setX((Util.getAttr("gs_loc").get("nextScnSqH") * 480) + (Util.getAttr("gs_loc").get("comingFromXinBox") - (player.getWidth() / 2)));
				player.setY((Util.getAttr("gs_loc").get("nextScnSqV") * 360) + 360 - player.getHeight() - 3);
			}
			// Coming from the bottom (move to top)
			else if(Util.getAttr("gs_loc").get("comingFromSide") == "BOTTOM"){
				player.setX((Util.getAttr("gs_loc").get("nextScnSqH") * 480) + (Util.getAttr("gs_loc").get("comingFromXinBox") - (player.getWidth() / 2)));
				player.setY((Util.getAttr("gs_loc").get("nextScnSqV") * 360));
			}
			// Coming from the left (move to right)
			else if(Util.getAttr("gs_loc").get("comingFromSide") == "LEFT"){
				player.setX((Util.getAttr("gs_loc").get("nextScnSqH") * 480) + 480 - player.getWidth() - 3);
				player.setY((Util.getAttr("gs_loc").get("nextScnSqV") * 360) + (Util.getAttr("gs_loc").get("comingFromYinBox") - player.getHeight()));
			}
			// Coming from the right (move to left)
			else if(Util.getAttr("gs_loc").get("comingFromSide") == "RIGHT"){
				player.setX((Util.getAttr("gs_loc").get("nextScnSqH") * 480) + 3);
				player.setY((Util.getAttr("gs_loc").get("nextScnSqV") * 360) + (Util.getAttr("gs_loc").get("comingFromYinBox") - player.getHeight()));
			}
		}
	}

	public inline function update(elapsedTime:Float){
		// Update player location (current square and location in current square)
		playerX = player.getX() + (player.getWidth() / 2);
		playerY = player.getY() + player.getHeight();
		playerSqH = Std.int(playerX / 480);
		playerSqV = Std.int(playerY / 360);
		playerXinBox = playerX - (playerSqH * 480);
		playerYinBox = playerY - (playerSqV * 360);
	}

	public inline function draw(g:G){
		// debug drawing
		if(debugDraw){
			g.setFont(getFont(674));
			g.alpha = 1;
			g.strokeSize = 2;
			for(i in 0...squaresV + 1){
				for(j in 0...squaresH + 1){
					g.drawString(j + "/" + i, (j * 40) + 26, (i * 30) + 26);
					if(i == playerSqV && j == playerSqH) g.strokeColor = Utils.getColorRGB(255, 0, 0);
					else g.strokeColor = Utils.getColorRGB(0, 0, 0);
					g.drawRect((j * 40) + 24, (i * 30) + 24, 40, 30);
				}
			}
			g.strokeColor = Utils.getColorRGB(0, 255, 0);
			for(region in getAllRegions()){ g.drawRect((region.getX() / 12) + 24, (region.getY() / 12) + 24, region.getWidth() / 12, region.getHeight() / 12); }
			g.drawString("SQUARESH " + squaresH, 24, ((squaresV + 1) * 30) + 26);
			g.drawString("SQUARESV " + squaresH, 24, ((squaresV + 1) * 30) + 32);
			g.drawString("CURR " + playerSqH + "/" + playerSqV, 24, ((squaresV + 1) * 30) + 38);
			g.drawString("PLAYERX IN SQ " + playerXinBox, 24, ((squaresV + 1) * 30) + 44);
			g.drawString("PLAYERY IN SQ " + playerYinBox, 24, ((squaresV + 1) * 30) + 50);
			g.drawString("LAST SCN " + Util.getAttr("gs_loc").get("comingFrom").toUpperCase(), 24, ((squaresV + 1) * 30) + 56);
			g.strokeColor = Utils.getColorRGB(255, 0, 0);
			g.drawCircle((playerX / 12) + 24, (playerY / 12) + 24, 1);
		}
	}

	function lastSceneIsWhitelisted():Bool {
		for(scene in whitelistedScenes){ if(Util.getAttr("gs_loc").get("lastScene") == scene) return true; }
		return false;
	}

	function lastSceneIsBlacklisted():Bool {
		for(scene in blacklistedScenes){ if(Util.getAttr("gs_loc").get("lastScene") == scene) return true; }
		return false;
	}
}
