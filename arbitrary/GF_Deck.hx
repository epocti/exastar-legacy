/*
	This script (C) 2018 Epocti.
	Description: Defines the deck of cards in battle. Also provides the graphical view.
	Author: Kokoro
*/

package scripts.grapefruit;

import motion.easing.Quad;
import motion.easing.Linear;
import scripts.tools.EZImgInstance;
import vixenkit.Tail;

class GF_Deck {
	var cards:Array<GF_Card> = new Array<GF_Card>();
	var imgs:Array<EZImgInstance> = new Array<EZImgInstance>();

	public function new(){
		// todo: initialize based on party data somehow - for now just add manually
		add("c_test1");
		add("c_test2");
		add("c_test3");
		add("c_test4");
	}

	public function add(tag:String):Void {
		cards.push(new GF_Card(tag));
		imgs.push(new EZImgInstance("g", true, "bttl.card." + tag));
		updateImages(false);
	}

	public function remove(index:Int):Void {
		if(index >= 0 && index <= cards.length){
			cards.remove(cards[index]);
			updateImages(false);
		}
		else Tail.log("Error in deck: Card removal index over/underflow", 5);
	}

	public function getSize():Int {
		return cards.length;
	}

	public function get(index):GF_Card {
		return cards[index];
	}

	public function hideCards(immediate:Bool):Void {
		if(immediate){
			for(i in 0...imgs.length){
				imgs[i].setAlpha(0);
				imgs[i].setXY((30 * i) + 3, 236);
			}
		}
		else {
			for(i in 0...imgs.length){
				imgs[i].fadeTo(0, .2, Linear.easeNone);
				imgs[i].slideTo((30 * i) + 3, 236, .2, Quad.easeInOut);
			}
		}
	}

	public function showCards(immediate:Bool):Void {
		if(immediate){
			for(i in 0...imgs.length){
				imgs[i].setAlpha(100);
				imgs[i].setXY((30 * i) + 3, 232);
			}
		}
		else {
			for(i in 0...imgs.length){
				imgs[i].fadeTo(100, .2, Linear.easeNone);
				imgs[i].slideTo((30 * i) + 3, 232, .2, Quad.easeInOut);
			}
		}
	}

	function updateImages(immediate:Bool):Void {
		for(i in 0...imgs.length){
			if(!immediate) imgs[i].slideTo((30 * i) + 3, 232, .2, Quad.easeInOut);
			else imgs[i].setXY((30 * i) + 3, 232);
		}
	}
}

/*
	To add listeners, create a new var of type "com.stencyl.Script" named "script", then add any of the following:
	Updating: script.addWhenUpdatedListener(null, function(elapsedTime:Float, list:Array<Dynamic>):Void {});
	Drawing: script.addWhenDrawingListener(null, function(g:G, x:Float, y:Float, list:Array<Dynamic>):Void {});
*/
