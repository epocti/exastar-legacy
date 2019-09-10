package scripts;

import scripts.tools.Util;
import com.stencyl.graphics.G;
import com.stencyl.behavior.Script.*;
import com.stencyl.behavior.SceneScript;
import com.stencyl.Engine;
import com.stencyl.utils.Utils;
import com.stencyl.graphics.shaders.BasicShader;
import com.stencyl.graphics.shaders.GrayscaleShader;
import com.stencyl.graphics.shaders.SepiaShader;
import com.stencyl.graphics.shaders.InvertShader;
import com.stencyl.graphics.shaders.GrainShader;
import com.stencyl.graphics.shaders.ExternalShader;
import com.stencyl.graphics.shaders.InlineShader;
import com.stencyl.graphics.shaders.BlurShader;
import com.stencyl.graphics.shaders.SharpenShader;
import com.stencyl.graphics.shaders.ScanlineShader;
import com.stencyl.graphics.shaders.CSBShader;
import com.stencyl.graphics.shaders.HueShader;
import com.stencyl.graphics.shaders.TintShader;
import com.stencyl.graphics.shaders.BloomShader;

class Script_ColorCorrection extends SceneScript {
	@:attribute("id='1' name='Color' desc='' type='COLOR'")
	public var color:Int;
	@:attribute("id='2' name='Opacity' desc=''")
	public var opac:Float = 20;
	@:attribute("id='3' name='Special Instance Name' desc='Used if a certain combination of shaders is needed.' default='cc_none'")
	public var instance:String = "cc_none";
	var compatMode = false;

	public function new(dummy:Int, dummy2:Engine){
		super();
		addWhenDrawingListener(null, onDraw);
	}
	public function onDraw(g:G, x:Float, y:Float, list:Array<Dynamic>){ draw(g); }

	// ==== ====

	override public function init(){
		// Check config for compatiblity mode, and set accordingly
		if(Util.getAttr("kitsuneConfig").get("compat")) compatMode = true;
		// Filter mode
		if(!compatMode){
			if((instance == "cc_none" || instance == "") || instance == null){ new TintShader(color, opac/100).enable(); }
			else if(instance == "cc_alienOutside"){ new TintShader(color, opac/100).combine(new GrainShader()).enable(); }
		}
	}

	public inline function draw(g:G){
		// Compatibility mode
		if(compatMode){
			g.fillColor = color;
			g.alpha = (opac/100);
			g.fillRect(0, 0, getScreenWidth(), getScreenHeight());
		}
	}
}