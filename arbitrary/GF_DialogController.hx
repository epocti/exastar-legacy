package scripts.grapefruit;

class GF_DialogController {
	var gfRoot:Grapefruit;

	public function new(gfRoot:Grapefruit){
		this.gfRoot = gfRoot;
		// Intro text
		dialog.core.Dialog.globalCall(getIntroText() + "<but><end>", "style_battle", this, "");
		//dialog.core.Dialog.cbCall("dg_btltut_intro", "style_battle", this, "");
	}

	function getIntroText():String {
		if(gfRoot.enemies.getNumEnemies() == 1) return '<glyph glyph_en_${getEnId(0)}> ${getEnName(0)} appears!';
		else if(gfRoot.enemies.getNumEnemies() == 2) return '<glyph glyph_en_${getEnId(0)}> ${getEnName(0)} and <glyph glyph_en_${getEnId(1)}> ${getEnName(1)} appear!';
		else if(gfRoot.enemies.getNumEnemies() == 3) return '<glyph glyph_en_${getEnId(0)}> ${getEnName(0)}, <glyph glyph_en_${getEnId(1)}> ${getEnName(1)}, and <glyph glyph_en_${getEnId(2)}> ${getEnName(2)} appear!';
		else if(gfRoot.enemies.getNumEnemies() == 4) return '<glyph glyph_en_${getEnId(0)}> ${getEnName(0)}, <glyph glyph_en_${getEnId(1)}> ${getEnName(1)}, <glyph glyph_en_${getEnId(2)}> ${getEnName(2)}, and <glyph glyph_en_${getEnId(3)}> ${getEnName(3)} appear!';
		else return "A whole lot of enemies appeared! There shouldn't actually be this many, this is a bug!";
	}

	function getEnName(index:Int):String {
		return gfRoot.enemies.getEnemy(index).getName();
	}
	function getEnId(index:Int):Int {
		return gfRoot.enemies.getEnemy(index).getId();
	}
}