package scripts;

import scripts.tools.Util;
import com.stencyl.behavior.Script.*;
import com.stencyl.behavior.SceneScript;
import com.stencyl.models.Actor;
import com.stencyl.Engine;

class Script_InitPlacement extends SceneScript {
	public var actor:Actor;
	public var map:Map<String,Dynamic>;

    public function new(dummy:Int, dummy2:Engine){
		super();
		map = ["default" => "217,196"];
	}

	// ==== this is also maybe deprecated ====

	override public function init(){
		if(map.exists(Engine.engine.getGameAttribute("gs_loc").get("comingFrom"))){
			//actor.setX(asNumber(("" + map.get(Util.getAttr("gs_loc").get("comingFrom"))).substring(Std.int(0), Std.int(("" + map.get(Engine.engine.getGameAttribute("gs_loc").get("comingFrom"))).indexOf(",")))));
			//actor.setY(asNumber(("" + map.get(Util.getAttr("gs_loc").get("comingFrom"))).substring(Std.int((("" + map.get(Engine.engine.getGameAttribute("gs_loc").get("comingFrom"))).indexOf(",") + 1)), Std.int(("" + map.get(Engine.engine.getGameAttribute("gs_loc").get("comingFrom"))).length))));
		}
		else if(Util.getAttr("gs_loc").get("lastScene") == "same"){
			actor.setX(Util.getAttr("gs_loc").get("lastX"));
			actor.setY(Util.getAttr("gs_loc").get("lastY"));
		}
		else {
			actor.setX(asNumber(map.get("default").substring(0, map.get("default").indexOf(","))));
			actor.setY(asNumber(map.get("default").substring(map.get("default").indexOf(",") + 1, map.get("default").length)));
		}
	}
}
