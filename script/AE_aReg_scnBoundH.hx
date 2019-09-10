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

class AE_aReg_scnBoundH extends ActorScript {
	@:attribute("id='1' name='Top/Bottom - T/F' desc=''")
	var side:Bool = true;
	@:attribute("id='2' name='SquareH' desc=''")
	var squareH:Int = 0;
	@:attribute("id='3' name='Scene' desc=''")
	var scene:String;
	@:attribute("id='4' name='Target SquareH' desc=''")
	var targetSqH:Int;
	@:attribute("id='5' name='Target SquareV' desc=''")
	var targetSqV:Int;

	var tempSide:String;
	var tempSquaresV:Int;

	public function new(dummy:Int, actor:Actor, dummy2:Engine){ super(actor); }

	// ========

	override public function init(){
		// Hide this actor if not in debug mode.
		if(!Util.showSpecialRegions) actor.disableActorDrawing();

		// Based on if side is true/false, set tempSide to the respective side to be passed to SceneBoundListener later.
		if(side) tempSide = "TOP";
		else tempSide = "BOTTOM";

		// If this listener is at the top of the scene, it should be on the first vertical square
		if(side) tempSquaresV = 0;
		// Otherwise, it will be on the last vertical square
		else tempSquaresV = Script.getValueForScene("Script_Mapper", "squaresV");

		// Create listener
		var bound:SceneBoundListener = new SceneBoundListener(tempSide, squareH, tempSquaresV, scene, targetSqH, targetSqV);
	}
}
