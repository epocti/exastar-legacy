package scripts;

import scripts.grapefruit.GF_DialogController;
import scripts.grapefruit.GF_Menu;
import scripts.grapefruit.GF_CharStatus;
import com.stencyl.behavior.SceneScript;
import com.stencyl.Engine;

import scripts.grapefruit.Grapefruit;

class Script_GrapefruitLoader extends SceneScript {
	// Grapefruit root is created, and reference is passed to modules during init in order to reference root
	var gf:Grapefruit = new Grapefruit();
	var menu:GF_Menu;
	var charStatsUi:GF_CharStatus;
	var dgController:GF_DialogController;

	public function new(dummy:Int, dummy2:Engine){ super(); }

	// ==== this script is more or less just the really cheap glue holding everything together ====

	override public function init(){
		menu = new GF_Menu(gf);
		charStatsUi = new GF_CharStatus(gf);
		dgController = new GF_DialogController(gf);
	}
}