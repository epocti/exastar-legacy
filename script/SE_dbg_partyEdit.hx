/*
	This script (C) 2018 Epocti.
	Description: Scene events for the debug party data editor.
	Author: Kokoro
*/

package scripts;

// Stencyl Engine
import scripts.id.FontID;
import scripts.tools.Util;
import com.stencyl.Engine;
import com.stencyl.Input;
import com.stencyl.utils.Utils;
import com.stencyl.graphics.G;
import com.stencyl.behavior.Script;
import com.stencyl.behavior.Script.*;
import com.stencyl.behavior.ActorScript;
import com.stencyl.behavior.SceneScript;
import com.stencyl.behavior.TimedTask;
// Stencyl Datatypes
import com.stencyl.models.Actor;
import com.stencyl.models.GameModel;
import com.stencyl.models.actor.Animation;
import com.stencyl.models.actor.ActorType;
import com.stencyl.models.actor.Collision;
import com.stencyl.models.actor.Group;
import com.stencyl.models.Scene;
import com.stencyl.models.Sound;
import com.stencyl.models.Region;
import com.stencyl.models.Font;
import com.stencyl.models.Joystick;
// Tweens
import motion.Actuate;
import motion.easing.Back;
import motion.easing.Cubic;
import motion.easing.Elastic;
import motion.easing.Expo;
import motion.easing.Linear;
import motion.easing.Quad;
import motion.easing.Quart;
import motion.easing.Quint;
import motion.easing.Sine;

class SE_dbg_partyEdit extends SceneScript {
	var currMenuSel:Int = 0;
	var currPartyMem:Int = 0;

	public function new(dummy:Int, dummy2:Engine){
		super();
		addWhenUpdatedListener(null, onUpdate);
		addWhenDrawingListener(null, onDraw);
	}
	public function onUpdate(elapsedTime:Float, list:Array<Dynamic>){ update(elapsedTime); }
	public function onDraw(g:G, x:Float, y:Float, list:Array<Dynamic>){ draw(g); }

	// ========

	override public function init(){
	}

	public inline function update(elapsedTime:Float){
		// Going through the menu
		if(isKeyPressed("down")){
			if(currMenuSel == 7 && currPartyMem < 3){
				currMenuSel = 0;
				currPartyMem++;
			}
			else if(currMenuSel < 7){
				currMenuSel++;
			}
		}
		else if(isKeyPressed("up")){
			if(currMenuSel == 0 && currPartyMem > 0){
				currMenuSel = 7;
				currPartyMem--;
			}
			else if(currMenuSel > 0){
				currMenuSel--;
			}
		}

		else if(isKeyPressed("right")){
			switch(currMenuSel){
				case 0: Util.party().getMember(currPartyMem).setHp(Util.party().getMember(currPartyMem).getHp() + 1);
				case 1: Util.party().getMember(currPartyMem).setMaxHp(Util.party().getMember(currPartyMem).getMaxHp() + 1);
				case 2: Util.party().getMember(currPartyMem).setMp(Util.party().getMember(currPartyMem).getMp() + 1);
				case 3: Util.party().getMember(currPartyMem).setMaxMp(Util.party().getMember(currPartyMem).getMaxMp() + 1);
			}
		}
	}

	public inline function draw(g:G){
		g.setFont(getFont(FontID.MAIN));
		g.alpha = 1;

		g.drawString("^", 1, 32 + (currPartyMem * 116) + (currMenuSel * 14));

		for(i in 0...Util.party().getMemberCount()){
			g.drawString(Util.party().getMember(i).getName(), 16, 20 + (i * 116));
			for(j in 0...8){
				switch(j){
					case 0: g.drawString("HP: " + Util.party().getMember(i).getHp(), 16, 32 + (i * 116) + (j * 12));
					case 1: g.drawString("MaxHP: " + Util.party().getMember(i).getMaxHp(), 16, 32 + (i * 116) + (j * 12));
					case 2: g.drawString("MP: " + Util.party().getMember(i).getMp(), 16, 32 + (i * 116) + (j * 12));
					case 3: g.drawString("MaxMP: " + Util.party().getMember(i).getMaxMp(), 16, 32 + (i * 116) + (j * 12));
					case 4: g.drawString("XP: " + Util.party().getMember(i).getXp(), 16, 32 + (i * 116) + (j * 12));
					case 5: g.drawString("XPtoNext: " + Util.party().getMember(i).getToNext(), 16, 32 + (i * 116) + (j * 12));
					case 6: g.drawString("Level: " + Util.party().getMember(i).getLevel(), 16, 32 + (i * 116) + (j * 12));
					case 7: g.drawString("SP: " + Util.party().getMember(i).getSp(), 16, 32 + (i * 116) + (j * 12));
				}
			}
		}
	}
}