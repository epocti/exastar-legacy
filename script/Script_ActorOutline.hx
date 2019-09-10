package scripts;

import com.stencyl.graphics.BitmapWrapper;
import openfl.display.Bitmap;
import com.stencyl.graphics.G;
import com.stencyl.behavior.Script.*;
import com.stencyl.behavior.ActorScript;
import com.stencyl.models.Actor;
import com.stencyl.Engine;

class Script_ActorOutline extends ActorScript {
	var aImg1:Bitmap;
	var aImg2:Bitmap;
	var aImg3:Bitmap;
	var aImg4:Bitmap;
	var aImg5:Bitmap;
	var aImg6:Bitmap;
	var aImg7:Bitmap;
	var aImg8:Bitmap;
	var aImgI1:BitmapWrapper;
	var aImgI2:BitmapWrapper;
	var aImgI3:BitmapWrapper;
	var aImgI4:BitmapWrapper;
	var aImgI5:BitmapWrapper;
	var aImgI6:BitmapWrapper;
	var aImgI7:BitmapWrapper;
	var aImgI8:BitmapWrapper;

    public function new(dummy:Int, actor:Actor, dummy2:Engine){
		super(actor);
		addWhenUpdatedListener(null, onUpdate);
		addWhenDrawingListener(null, onDraw);
	}
	public function onUpdate(elapsedTime:Float, list:Array<Dynamic>){ update(elapsedTime); }
	public function onDraw(g:G, x:Float, y:Float, list:Array<Dynamic>){ draw(g); }

	// ========

	override public function init(){
		aImgI1 = new BitmapWrapper(new Bitmap(getImageForActor(actor)));
		aImgI2 = new BitmapWrapper(new Bitmap(getImageForActor(actor)));
		aImgI3 = new BitmapWrapper(new Bitmap(getImageForActor(actor)));
		aImgI4 = new BitmapWrapper(new Bitmap(getImageForActor(actor)));
		aImgI5 = new BitmapWrapper(new Bitmap(getImageForActor(actor)));
		aImgI6 = new BitmapWrapper(new Bitmap(getImageForActor(actor)));
		aImgI7 = new BitmapWrapper(new Bitmap(getImageForActor(actor)));
		aImgI8 = new BitmapWrapper(new Bitmap(getImageForActor(actor)));
		attachImageToLayer(aImgI1, 1, "midbottom", Std.int(actor.getX() - 1), Std.int(actor.getY() - 1), 1);
		attachImageToLayer(aImgI2, 1, "midbottom", Std.int(actor.getX()), Std.int(actor.getY() - 1), 1);
		attachImageToLayer(aImgI3, 1, "midbottom", Std.int(actor.getX() + 1), Std.int(actor.getY() - 1), 1);
		attachImageToLayer(aImgI4, 1, "midbottom", Std.int(actor.getX() - 1), Std.int(actor.getY()), 1);
		attachImageToLayer(aImgI5, 1, "midbottom", Std.int(actor.getX() + 1), Std.int(actor.getY()), 1);
		attachImageToLayer(aImgI6, 1, "midbottom", Std.int(actor.getX() - 1), Std.int(actor.getY() + 1), 1);
		attachImageToLayer(aImgI7, 1, "midbottom", Std.int(actor.getX()), Std.int(actor.getY() + 1), 1);
		attachImageToLayer(aImgI8, 1, "midbottom", Std.int(actor.getX() + 1), Std.int(actor.getY() + 1), 1);
	}

	public inline function update(elapsedTime:Float){
		aImg1 = new Bitmap(getImageForActor(actor));
		aImg2 = new Bitmap(getImageForActor(actor));
		aImg3 = new Bitmap(getImageForActor(actor));
		aImg4 = new Bitmap(getImageForActor(actor));
		aImg5 = new Bitmap(getImageForActor(actor));
		aImg6 = new Bitmap(getImageForActor(actor));
		aImg7 = new Bitmap(getImageForActor(actor));
		aImg8 = new Bitmap(getImageForActor(actor));
		aImgI1.img = aImg1;
		aImgI2.img = aImg2;
		aImgI3.img = aImg3;
		aImgI4.img = aImg4;
		aImgI5.img = aImg5;
		aImgI6.img = aImg6;
		aImgI7.img = aImg7;
		aImgI8.img = aImg8;
	}

	public inline function draw(g:G){
		aImgI1.set_imgX(actor.getX() - 1);
		aImgI1.set_imgY(actor.getY() - 1);
		aImgI2.set_imgX(actor.getX());
		aImgI2.set_imgY(actor.getY() - 1);
		aImgI3.set_imgX(actor.getX() + 1);
		aImgI3.set_imgY(actor.getY() - 1);
		aImgI4.set_imgX(actor.getX() - 1);
		aImgI4.set_imgY(actor.getY());
		aImgI5.set_imgX(actor.getX() + 1);
		aImgI5.set_imgY(actor.getY());
		aImgI6.set_imgX(actor.getX() - 1);
		aImgI6.set_imgY(actor.getY() + 1);
		aImgI7.set_imgX(actor.getX());
		aImgI7.set_imgY(actor.getY() + 1);
		aImgI8.set_imgX(actor.getX() + 1);
		aImgI8.set_imgY(actor.getY() + 1);
	}
}
