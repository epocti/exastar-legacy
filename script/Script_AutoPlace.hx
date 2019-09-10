/*
	This script (C) 201X - 20XX Epocti.
	Description: 
	Author: 
*/

package scripts;

// Stencyl Engine
import scripts.tools.Util;
import com.stencyl.Engine;
import com.stencyl.behavior.Script.*;
import com.stencyl.behavior.SceneScript;
// Stencyl Datatypes
import com.stencyl.models.Actor;


class Script_AutoPlace extends SceneScript {
	@:attribute("id='1' name='Actor to Check' desc=''")
	var actorToCheck:Actor;
	@:attribute("id='2' name='AutoPlace Locations' desc='Key: Scene name, Value: Init location - X,Y' type='map'")
	var locationMap:Map<String,Dynamic> = new Map<String,Dynamic>();

	public function new(dummy:Int, dummy2:Engine){ super(); }

	// ========

	override public function init(){
		for(key in locationMap.keys()){
			if(Util.getAttr("gs_loc").get("comingFrom") == key && Util.getAttr("gs_loc").get("comingFrom") != ""){
				actorToCheck.setX(asNumber(locationMap.get(key).substring(0, locationMap.get(key).indexOf(","))));
				actorToCheck.setY(asNumber(locationMap.get(key).substring(locationMap.get(key).indexOf(",") + 1, locationMap.get(key).length)));
			}
		}
	}
}
