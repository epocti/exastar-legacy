package scripts;

import scripts.assets.Assets;
import scripts.id.FontID;
import scripts.tools.Util;
import openfl.events.KeyboardEvent;
import com.stencyl.graphics.G;
import com.stencyl.behavior.Script.*;
import com.stencyl.behavior.SceneScript;
import com.stencyl.models.GameModel;
import com.stencyl.Engine;

class SE_dbg_sceneSwitcher extends SceneScript {
	public var _ms:Float = 0;
	public var _input:String = "";

    public function new(dummy:Int, dummy2:Engine){
		super();
		addWhenDrawingListener(null, onDraw);
	}

	public function onDraw(g:G, x:Float, y:Float, list:Array<Dynamic>){ draw(g); }

	// ========

	override public function init(){
		showKeyboard();
		addAnyKeyPressedListener(function(event:KeyboardEvent, list:Array<Dynamic>):Void {
			if(event.keyCode == 8){
				playSoundOnChannel(Assets.get("sfx.key_backspace"), 1);
				_input = _input.substring(0, _input.length - 1);
			}
			else if(event.keyCode == 13){
				hideKeyboard();
				switchScene(GameModel.get().scenes.get(getIDForScene(_input)).getID());
			}
			else if(!(event.keyCode == 8) && !(event.keyCode == 13)){
				playSoundOnChannel(Assets.get("sfx.key" + randomInt(1,5)), 1);
				_input = _input + charFromCharCode(event.charCode);
			}
		});
	}

	public inline function draw(g:G){
		_ms += .5;
		g.alpha = 1;
		g.strokeSize = 0;
		g.setFont(getFont(FontID.MAIN));
		g.fillColor = ColorConvert.getColorHSL(_ms, 100, 120);
		g.fillRect(0, 0, getScreenWidth(), getScreenHeight());
		g.drawString("Scene Switcher", Util.getMidScreenX() - (g.font.font.getTextWidth("Scene Switcher")/Engine.SCALE / 2), 64);
		g.drawString("(Enter a valid scene name and press ENTER)", Util.getMidScreenX() - (g.font.font.getTextWidth("(Enter a valid scene name and press ENTER)")/Engine.SCALE / 2), 80);
		g.drawString(_input, Util.getMidScreenX() - (g.font.font.getTextWidth(_input)/Engine.SCALE / 2), 130);
	}
}