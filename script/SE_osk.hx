/*
	This script (C) 2018 Epocti.
	Description: Script for onscreen keyboard scene
	Author: Kokoro
*/

package scripts;

// Stencyl Engine
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

import scripts.tools.Util;
import scripts.id.FontID;

class SE_osk extends SceneScript {
	var charSelectionState:Array<Bool> = new Array<Bool>();
	var chars:Array<String> = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", ".", ",", "!", "?", "/", "\\", "|", "\"", "\'", ":", ";", "+", "-", "*", "<", ">", "=", "[", "]", "(", ")"];

	public function new(dummy:Int, dummy2:Engine){
		super();	
		addWhenUpdatedListener(null, onUpdate);
		addWhenDrawingListener(null, onDraw);
	}
	public function onUpdate(elapsedTime:Float, list:Array<Dynamic>){ update(elapsedTime); }
	public function onDraw(g:G, x:Float, y:Float, list:Array<Dynamic>){ draw(g); }

	// ========

	override public function init(){
		for(i in 0...52){
			charSelectionState.push(false);
		}
	}

	public inline function update(elapsedTime:Float){
	}

	public inline function draw(g:G){
		g.setFont(getFont(FontID.MAIN_WHITE));
		// Draw uppercase letterset
		for(i in 0...26){
			/* rows 1-4 */ if(i <= 20) g.drawString(chars[i], 153 + (i % 7) * 20, 112 + (Std.int((i / 7)) * 24));
			/* row 5 */ else if(i <= 25) g.drawString(chars[i], 173 + (i % 7) * 20, 112 + (Std.int((i / 7)) * 24));
		}
		// Draw lowercase letterset
		for(i in 0...26){
			/* rows 1-4 */ if(i <= 20) g.drawString(chars[i + 26], 153 + (i % 7) * 20, 211 + (Std.int((i / 7)) * 21));
			/* row 5 */ else if(i <= 25) g.drawString(chars[i + 26], 173 + (i % 7) * 20, 211 + (Std.int((i / 7)) * 21));
		}
		// Draw numbers
		for(i in 0...10){
			g.drawString(chars[i + 52], 156 + (i * 13), 297);
		}
		// Draw symbols
		for(i in 0...21){
			g.drawString(chars[i + 62], 153 + (i % 7) * 20, 317 + (Std.int((i / 7)) * 18));
		}
	}
}
