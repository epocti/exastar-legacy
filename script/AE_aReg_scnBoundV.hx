/*
    This script (C) 2018 Epocti.
    Description: 
    Author: Kokoro
*/

package scripts;

// Stencyl Engine
import scripts.tools.Util;
import scripts.scene.SceneBoundListener;
import com.stencyl.Engine;
import com.stencyl.behavior.Script;
import com.stencyl.behavior.Script.*;
import com.stencyl.behavior.ActorScript;
// Stencyl Datatypes
import com.stencyl.models.Actor;

class AE_aReg_scnBoundV extends ActorScript {
	@:attribute("id='1' name='Left/Right - T/F' desc=''")
	var side:Bool = true;
	@:attribute("id='2' name='SquareV' desc=''")
	var squareV:Int = 0;
	@:attribute("id='3' name='Scene' desc=''")
	var scene:String;
	@:attribute("id='4' name='Target SquareH' desc=''")
	var targetSqH:Int;
	@:attribute("id='5' name='Target SquareV' desc=''")
	var targetSqV:Int;

	var tempSide:String;
	var tempSquaresH:Int;

	public function new(dummy:Int, actor:Actor, dummy2:Engine){ super(actor); }

	// ========

	override public function init(){
		// Hide this actor if not in debug mode.
		if(!Util.showSpecialRegions) actor.disableActorDrawing();

		// Based on if side is true/false, set tempSide to the respective side to be passed to SceneBoundListener later.
		if(side) tempSide = "LEFT";
		else tempSide = "RIGHT";

		// If this listener is at the left of the scene, it should be on the first horizontal square
		if(side) tempSquaresH = 0;
		// Otherwise, it will be on the last horizontal square
		else tempSquaresH = Script.getValueForScene("Script_Mapper", "squaresH");

		// Create listener
		var bound:SceneBoundListener = new SceneBoundListener(tempSide, tempSquaresH, squareV, scene, targetSqH, targetSqV);
	}
}
