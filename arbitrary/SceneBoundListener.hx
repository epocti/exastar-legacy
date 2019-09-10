package scripts.scene;

import scripts.tools.Util;
import com.stencyl.behavior.Script;
import com.stencyl.models.Region;
import com.stencyl.models.Actor;
import com.stencyl.models.GameModel;
import vixenkit.Tail;

class SceneBoundListener {
	var region:Region;
	var scene:String;
	var script:Script;
	//var actor:Actor;

	public function new(side:String, squareH:Int, squareV:Int, scene:String, targetSqH:Int, targetSqV:Int){
		switch(side){
			case "TOP": region = Script.createBoxRegion(squareH*480, squareV*360, 480, 1);
			case "BOTTOM": region = Script.createBoxRegion(squareH*480, squareV*360 + 359, 480, 1);
			case "LEFT": region = Script.createBoxRegion(squareH*480, squareV*360, 1, 360);
			case "RIGHT": region = Script.createBoxRegion(squareH*480 + 479, squareV*360, 1, 360);
			default: Tail.log("SceneBoundListener failed to create", 5);
		}
		this.scene = scene;
		script = new Script();
		script.addActorEntersRegionListener(region, function(a:Actor, list:Array<Dynamic>):Void {
			if(Script.sameAsAny(Script.getActorGroup(0),a.getType(),a.getGroup())){
				Util.getAttr("gs_loc").set("comingFrom", Script.getCurrentSceneName());
				Util.getAttr("gs_loc").set("comingFromSide", side);
				Util.getAttr("gs_loc").set("comingFromXinBox", Script.getValueForScene("Script_Mapper", "playerXinBox"));
				Util.getAttr("gs_loc").set("comingFromYinBox", Script.getValueForScene("Script_Mapper", "playerYinBox"));
				Util.getAttr("gs_loc").set("nextScnSqH", targetSqH);
				Util.getAttr("gs_loc").set("nextScnSqV", targetSqV);
				Util.switchSceneImmediate(this.scene);
			}
		});

	}
}
