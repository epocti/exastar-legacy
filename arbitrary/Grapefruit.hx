package scripts.grapefruit;

import scripts.assets.Assets;
import com.stencyl.behavior.TimedTask;
import com.stencyl.behavior.Script;
import scripts.tools.Util;
import vixenkit.Tail;
import scripts.gfx.GFX_StakeTransition;
import scripts.gfx.GFX_WaveTransition;

// Main battle engine script

class Grapefruit {
	var script:Script = new Script();

	public var uiMode:Int = 0;

	var transition:GFX_WaveTransition = new GFX_WaveTransition();

	public var currentMember:Int = 0;
	public var baseTurnTime:Int = 99;
	public var turnTime:Int = 99;

	public var enemies:GF_EnemyContainer = new GF_EnemyContainer(true);
	public var deck:GF_Deck = new GF_Deck();

	public var rainbowH:Int = 0;

	public function new(){
		Tail.log("Battle events initiated", 2);
		// re-enable movement for later
		Util.enableMovement();
		Util.setAttr("battleTransitionStatus", false);
		// Debug mode db creation just in case
		#if(cppia)
			Util.createTestDatabases();
		#end

		deck.hideCards(true);

		// Music
		Script.playSoundOnChannel(Assets.get("mus.battle1"), 1);
		Script.runLater(Script.getSoundLengthForChannel(1) + 400, function(timeTask:TimedTask):Void { Script.loopSoundOnChannel(Assets.get("mus.battle1_loop"), 1); }, null);

		// Turn timer
		turnTime = baseTurnTime;
		Script.runPeriodically(1000, function(timeTask:TimedTask):Void {
			if(!Util.inDialog() && turnTime - 1 >= 0) turnTime--;
		}, null);

		script.addWhenUpdatedListener(null, function(elapsedTime:Float, list:Array<Dynamic>):Void {
			// Rainbow hue control
			if(rainbowH >= 360) rainbowH = 0;
			else rainbowH += 2;
		});
		
		transition.createOutQuick();
	}
}