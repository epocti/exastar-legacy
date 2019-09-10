package scripts;

import scripts.assets.Assets;
import scripts.id.FontID;
import scripts.tools.Util;
import openfl.events.KeyboardEvent;
import com.stencyl.graphics.G;
import com.stencyl.behavior.Script.*;
import com.stencyl.behavior.SceneScript;
import com.stencyl.Engine;

class SE_dbg_menu extends SceneScript {
	public var ms:Float = 0;
	public var menuItems:Array<Dynamic> = ["1. Scene switcher", "2. Dialog tester", "3. Custom dialog", "4. Custom battle", "5. Enter a test scene", "6. View loaded assets", "7. Return to last scene", "8. Restart game"];
	public var selectedMenuEntry:Float = 0;

	public function new(dummy:Int, dummy2:Engine){
		super();
		addWhenDrawingListener(null, onDraw);
	}
	public function onDraw(g:G, x:Float, y:Float, list:Array<Dynamic>){ draw(g); }

	// ========

	override public function init(){
		addAnyKeyPressedListener(function(event:KeyboardEvent, list:Array<Dynamic>):Void {
			if(isKeyPressed("up")){
				if(selectedMenuEntry - 1 <= -1) selectedMenuEntry = menuItems.length;
				else selectedMenuEntry -= 1;
			}
			if(isKeyPressed("down")){
				if(selectedMenuEntry + 1 > menuItems.length) selectedMenuEntry = 0;
				else selectedMenuEntry += 1;
			}
			// Menu item selection
			if(isKeyPressed("action1")){
				// Scene switcher
				if(selectedMenuEntry == 0) Util.switchSceneImmediate("dbg_sceneSwitcher");
				// Dialog tester
				else if(selectedMenuEntry == 1) Util.switchSceneImmediate("dbg_dgTest");
				// TODO: Dialog editor
				else if(selectedMenuEntry == 2) Util.switchSceneImmediate("dbg_dgEdit");
				// TODO: Custom battle
				else if(selectedMenuEntry == 3) Util.switchSceneImmediate("dbg_customBattle");
				// TODO: Test rooms
				else if(selectedMenuEntry == 4) Util.switchSceneImmediate("dbg_testScenes");
				// Asset viewer
				else if(selectedMenuEntry == 5 && Assets.isMemoryMode()) Util.switchSceneImmediate("dbg_assetViewer");
				// Return
				else if(selectedMenuEntry == 6) Util.switchSceneImmediate(Util.getAttr("dbgLastScene"));
				// Restart game
				else if(selectedMenuEntry == 7) Util.switchSceneImmediate("preload");
			}
		});
	}

	public inline function draw(g:G){
		ms += .5;
		g.alpha = 1;
		g.strokeSize = 0;
		g.setFont(getFont(FontID.MAIN));
		g.fillColor = ColorConvert.getColorHSL(ms, 100, 160);
		g.fillRect(0, 0, getScreenWidth(), getScreenHeight());
		g.drawString("Debug Menu", Util.getMidScreenX() - (g.font.font.getTextWidth("Debug Menu")/Engine.SCALE / 2), 8);
		for(i in 0...menuItems.length) g.drawString(menuItems[i], 16, (i * 16) + 32);
		g.drawString("^", 2, (selectedMenuEntry * 16) + 32);
		// Warning if assets are not cached into memory
		if(selectedMenuEntry == 6 && Assets.isDiskMode()){ g.drawString("Cannot enter AssetViewer - not in memory caching mode", 1, getScreenHeight() - 16); }
	}
}
