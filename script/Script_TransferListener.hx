package scripts;

import scripts.tools.Util;
import com.stencyl.behavior.Script.*;
import com.stencyl.behavior.SceneScript;
import com.stencyl.models.Actor;
import com.stencyl.models.Region;
import com.stencyl.Engine;

class Script_TransferListener extends SceneScript {
	@:attribute("id='1' name='Actor to Check' desc=''")
	public var actor:Actor;
	@:attribute("id='2' name='Target Scenes' desc='These should correspond to the regions below.' type='LIST'")
	public var scenes:Array<Dynamic> = new Array<Dynamic>();
	@:attribute("id='3' name='Region 1' desc=''")
	public var reg1:Region;
	@:attribute("id='4' name='Region 2' desc=''")
	public var reg2:Region;
	@:attribute("id='5' name='Region 3' desc=''")
	public var reg3:Region;

    public function new(dummy:Int, dummy2:Engine){ super(); }

	// ==== this script is probably very deprecated ====

	override public function init(){
		addActorEntersRegionListener(reg1, function(a:Actor, list:Array<Dynamic>):Void { if(sameAs(actor, a)) Util.switchSceneImmediate("" + scenes[0]); });
		addActorEntersRegionListener(reg2, function(a:Actor, list:Array<Dynamic>):Void { if(sameAs(actor, a)) Util.switchSceneImmediate("" + scenes[1]); });
		addActorEntersRegionListener(reg3, function(a:Actor, list:Array<Dynamic>):Void { if(sameAs(actor, a)) Util.switchSceneImmediate("" + scenes[2]); });
	}
}
