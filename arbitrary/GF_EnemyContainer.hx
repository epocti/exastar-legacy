package scripts.grapefruit;

import scripts.id.FontID;
import com.stencyl.graphics.G;
import motion.easing.Quad;
import scripts.tools.Util;
import com.stencyl.utils.Utils;
import com.stencyl.behavior.Script;
import scripts.grapefruit.GF_Enemy;

class GF_EnemyContainer {
	var script:Script = new Script();
	var EnemyList = new Array<GF_Enemy>();
	var pos = new Array<Int>();

	public function new(autoAdd:Bool){
		if(autoAdd){
			for(i in 0...Util.getAttr("bttl_enemyParams").length){ addEnemy(new GF_Enemy(Util.getAttr("bttl_enemyParams")[i])); }
			updateXPositions();
			updateYPositions();
		}
		
		// Enemy infoboxes
		script.addWhenDrawingListener(null, function(g:G, x:Float, y:Float, list:Array<Dynamic>):Void {
			Script.setDrawingLayer(1, "drawLayer");
			g.fillColor = Utils.getColorRGB(0,0,0);
			g.strokeSize = 0;

			// Draw enemy infoboxes
			for(i in 0...getNumEnemies()){
				g.setFont(Script.getFont(FontID.SMALL_WHITE));
				g.fillColor = Utils.getColorRGB(0,0,0);
				// Backing shape shadow
				g.alpha = .33;
				g.fillRoundRect(
					getEnemy(i).getXPosition() - 15 - Script.getFont(FontID.GAUGE_WHITE).font.getTextWidth(getEnemy(i).getHealth() + "/" + getEnemy(i).getMaxHealth() + Util.getString("GF_ENEMY_HP")) - Script.getFont(FontID.SMALL_WHITE).font.getTextWidth(getEnemy(i).getName()),
					getEnemy(i).getYPosition() + Std.int(getEnemy(i).img.getHeight() / 2) - 5, 
					7 + Script.getFont(FontID.GAUGE_WHITE).font.getTextWidth(getEnemy(i).getHealth() + "/" + getEnemy(i).getMaxHealth() + Util.getString("GF_ENEMY_HP")) + Script.getFont(FontID.SMALL_WHITE).font.getTextWidth(getEnemy(i).getName()),
					13, 4
				);
				g.alpha = 1;
				// Backing shape
				g.fillRoundRect(
					getEnemy(i).getXPosition() - 13 - Script.getFont(FontID.GAUGE_WHITE).font.getTextWidth(getEnemy(i).getHealth() + "/" + getEnemy(i).getMaxHealth() + Util.getString("GF_ENEMY_HP")) - Script.getFont(FontID.SMALL_WHITE).font.getTextWidth(getEnemy(i).getName()),
					getEnemy(i).getYPosition() + Std.int(getEnemy(i).img.getHeight() / 2) - 7, 
					7 + Script.getFont(FontID.GAUGE_WHITE).font.getTextWidth(getEnemy(i).getHealth() + "/" + getEnemy(i).getMaxHealth() + Util.getString("GF_ENEMY_HP")) + Script.getFont(FontID.SMALL_WHITE).font.getTextWidth(getEnemy(i).getName()),
					13, 4
				);
				g.beginFillPolygon();
				g.addPointToPolygon(getEnemy(i).getXPosition() - 6, getEnemy(i).getYPosition() + (getEnemy(i).img.getHeight() / 2) - 3);
				g.addPointToPolygon(getEnemy(i).getXPosition() - 6, getEnemy(i).getYPosition() + (getEnemy(i).img.getHeight() / 2) + 3);
				g.addPointToPolygon(getEnemy(i).getXPosition() - 3, getEnemy(i).getYPosition() + (getEnemy(i).img.getHeight() / 2));
				g.endDrawingPolygon();
				// Enemy name
				g.drawString(
					getEnemy(i).getName(),
					getEnemy(i).getXPosition() - 11 - Script.getFont(FontID.GAUGE_WHITE).font.getTextWidth(getEnemy(i).getHealth() + "/" + getEnemy(i).getMaxHealth() + Util.getString("GF_ENEMY_HP")) - Script.getFont(FontID.SMALL_WHITE).font.getTextWidth(getEnemy(i).getName()),
					getEnemy(i).getYPosition() + Std.int(getEnemy(i).img.getHeight() / 2) - 8
				);
				// HP bar
				g.fillColor = ColorConvert.getColorHSL((getEnemy(i).getHealth() / getEnemy(i).getMaxHealth()) * 120, 100, 100);
				g.fillRect(
					getEnemy(i).getXPosition() - 11 - Script.getFont(FontID.GAUGE_WHITE).font.getTextWidth(getEnemy(i).getHealth() + "/" + getEnemy(i).getMaxHealth() + Util.getString("GF_ENEMY_HP")) - Script.getFont(FontID.SMALL_WHITE).font.getTextWidth(getEnemy(i).getName()),
					getEnemy(i).getYPosition() + Std.int(getEnemy(i).img.getHeight() / 2) + 4,
					3 + Script.getFont(FontID.GAUGE_WHITE).font.getTextWidth(getEnemy(i).getHealth() + "/" + getEnemy(i).getMaxHealth() + Util.getString("GF_ENEMY_HP")) + Script.getFont(FontID.SMALL_WHITE).font.getTextWidth(getEnemy(i).getName()),
					1
				);
				// HP text
				g.setFont(Script.getFont(FontID.GAUGE_WHITE));
				g.drawString(
					getEnemy(i).getHealth() + "/" + getEnemy(i).getMaxHealth() + Util.getString("GF_ENEMY_HP"),
					getEnemy(i).getXPosition() - 9 - Script.getFont(FontID.GAUGE_WHITE).font.getTextWidth(getEnemy(i).getHealth() + "/" + getEnemy(i).getMaxHealth() + Util.getString("GF_ENEMY_HP")),
					getEnemy(i).getYPosition() + Std.int(getEnemy(i).img.getHeight() / 2)
				);
			}
		});
	}

	public function addEnemy(enemy:GF_Enemy):Void { EnemyList.push(enemy); }

	public function removeEnemy(index:Int):GF_Enemy {
		var temp:GF_Enemy = EnemyList[index];
		EnemyList.remove(EnemyList[index]);
		return temp;
	}

	public function getEnemy(index:Int):GF_Enemy {
		// todo: check if the index is within bounds first, and if not, just make the enemy nothing
		return EnemyList[index];
	}

	public function getNumEnemies():Int { return EnemyList.length; }

	public function updateXPositions():Void {
		for(i in 0...EnemyList.length){ EnemyList[i].setX(455 - Script.randomInt(-10, 10)); }
	}
	public function updateYPositions():Void {
		for(i in 0...EnemyList.length){ EnemyList[i].setY(100 + ((i + 1) * (150 / (EnemyList.length + 1)))); }
	}

	public function toString():String {
		var temp:String = "";
		for(enemy in EnemyList){ temp = temp + enemy.toString() + "\n"; }
		return temp;
	}
}