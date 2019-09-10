package scripts;

import com.stencyl.behavior.Script.*;
import com.stencyl.behavior.SceneScript;
import com.stencyl.Engine;
import scripts.assets.Assets;
import scripts.tools.Util;

class Script_MessageRouter extends SceneScript {
	public function new(dummy:Int, dummy2:Engine){ super(); }

	// ==== When calling functions from the dialog extension isn't enough, you tunnel it through this ====

	override public function init(){}

	// General functions
	public function shockShake(){
		startShakingScreen(.01, .25);
		playSoundOnChannel(Assets.get("sfx.shockSnd"), 4);
	}

	public function enableMovement()
		Util.enableMovement();
	public function disableMovement()
		Util.disableMovement();

	public function fc_retryName():Void
		shoutToScene("retryName");
	public function fc_retryDifficulty():Void
		shoutToScene("retryDifficulty");
	public function fc_showDifficulty():Void
		shoutToScene("showDifficulty");
	public function fc_hideDifficulty():Void
		shoutToScene("hideDifficulty");
	public function fc_finish():Void
		shoutToScene("finish");

	public function storyTell_incSlide():Void
		shoutToScene("incrementSlide");

	// Alien
	public function _customEvent_alien_lab_addZeno():Void
		shoutToScene("_customEvent_addZeno");
	public function _customEvent_ow_57_156_nTaskFestTents():Void
		shoutToScene("_customEvent_nTaskFestTents");

	// Shop
	public function initShopUI():Void
		shoutToScene("initShopUI");

	// tutorial intro cutscene
	public function ow_12_153_alexFall():Void
		shoutToScene("alexFall");
	public function ow_12_153_stopKeriiShaking():Void
		shoutToScene("stopKeriiShaking");
	public function ow_12_153_cueMusic():Void
		shoutToScene("cueMusic");
	public function ow_12_153_spamDgSnd():Void
		shoutToScene("spamDialogSnd");
}