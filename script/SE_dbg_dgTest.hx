package scripts;

import scripts.assets.Assets;
import scripts.id.FontID;
import openfl.events.KeyboardEvent;
import scripts.tools.Util;
import com.stencyl.graphics.G;
import com.stencyl.behavior.Script.*;
import com.stencyl.behavior.SceneScript;
import com.stencyl.Engine;

class SE_dbg_dgTest extends SceneScript {
	public var ms:Float = 0;
	public var input:String = "";

    public function new(dummy:Int, dummy2:Engine){
		super();
		addWhenDrawingListener(null, onDraw);
	}
	public function onDraw(g:G, x:Float, y:Float, list:Array<Dynamic>){ draw(g); }

	// ========

	override public function init(){
		addAnyKeyPressedListener(function(event:KeyboardEvent, list:Array<Dynamic>):Void {
			if(!Util.inDialog()){
				if(event.keyCode == 8){
					playSoundOnChannel(Assets.get("sfx.key_backspace"), 1);
					input = input.substring(0, input.length - 1);
				}
				else if(event.keyCode == 13) dialog.core.Dialog.cbCall(input, "style_main", this, "");
				else if(!(event.keyCode == 8) && !(event.keyCode == 13)){
					playSoundOnChannel(Assets.get("sfx.key" + randomInt(1,5)), 1);
					input = input + charFromCharCode(event.charCode);
				}
			}
		});
	}

	public inline function draw(g:G){
		ms += .5;
		g.alpha = 1;
		g.strokeSize = 0;
		g.setFont(getFont(FontID.MAIN));
		g.fillColor = ColorConvert.getColorHSL(ms, 100, 120);
		g.fillRect(0, 0, getScreenWidth(), getScreenHeight());
		g.drawString("Dialog Tester", Util.getMidScreenX() - ((g.font.font.getTextWidth("Dialog Tester")/Engine.SCALE) / 2), 64);
		g.drawString("(Enter a valid dialog chunk name and press ENTER)", Util.getMidScreenX() - (g.font.font.getTextWidth("(Enter a valid dialog chunk name and press ENTER)")/Engine.SCALE / 2), 80);
		g.drawString(input, Util.getMidScreenX() - (g.font.font.getTextWidth(input)/Engine.SCALE / 2), 130);
	}
}
