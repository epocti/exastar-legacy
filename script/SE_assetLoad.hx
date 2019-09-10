/*
	This script (C) 201X - 20XX Epocti.
	Description: Scene event script for the initial loading screen, where all assets in the data directory are loaded into memory.
	Author: 
*/

package scripts;

// Stencyl Engine
import scripts.tools.Util;
import scripts.tools.EZImgInstance;
import scripts.id.FontID;
import scripts.assets.Assets;
import scripts.assets.Asset;
import com.stencyl.Engine;
import com.stencyl.Input;
import com.stencyl.utils.Utils;
import com.stencyl.graphics.G;
import com.stencyl.behavior.Script;
import com.stencyl.behavior.Script.*;
import com.stencyl.behavior.ActorScript;
import com.stencyl.behavior.SceneScript;
import com.stencyl.behavior.TimedTask;

class SE_assetLoad extends SceneScript {
	// vars go here
	var assetLoad:Assets = new Assets();
	//var animCounter:Int = 0;
	//var loaderImg:EZImgInstance = new EZImgInstance("f", true, null, null, null, "engine/load/load1.png");

	public function new(dummy:Int, dummy2:Engine){
		super();
		addWhenUpdatedListener(null, onUpdate);
		addWhenDrawingListener(null, onDraw);
	}
	public function onUpdate(elapsedTime:Float, list:Array<Dynamic>){ update(elapsedTime); }
	public function onDraw(g:G, x:Float, y:Float, list:Array<Dynamic>){ draw(g); }

	// ========

	override public function init(){
		//loaderImg.setXY(0, getScreenHeight() - loaderImg.getHeight());
		assetLoad.load();
	}

	public inline function update(elapsedTime:Float){
		if(Assets.isDoneLoading()) Util.switchSceneImmediate("preload");
		//if(isKeyPressed("action1")) assetLoad.loadNext();

		//if(animCounter + 1 < 360) animCounter++;
		//else animCounter = 0;
	}

	public inline function draw(g:G){
		g.strokeSize = 0;
		g.fillColor = Utils.getColorRGB(220, 220, 220);
		g.fillCircle(10, getScreenHeight() - 10, 8);
		g.fillColor = Utils.getColorRGB(0, 0, 0);
		g.setFont(getFont(FontID.MAIN));
		g.drawString("Loading...", 23, getScreenHeight() - 18);
		DrawCircles.drawWedge(g, true, true, 10, getScreenHeight() - 10, /*animCounter*/-90, /*animCounter*/-90 + ((Assets.getLoaded() / Assets.getTotal()) * 360), 8);

		//g.drawString(Assets.getCurrentlyLoading() + " | " + Math.round((Assets.getLoaded() / Assets.getTotal()) * 100) + "%", getScreenWidth() - g.font.font.getTextWidth(Assets.getCurrentlyLoading() + " | " + Math.round((Assets.getLoaded() / Assets.getTotal()) * 100) + "%") - 2, getScreenHeight() - g.font.font.getFontHeight());
	}
}
