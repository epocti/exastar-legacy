package scripts.grapefruit;

import scripts.tools.EZImgInstance;
import com.stencyl.graphics.G;
import scripts.id.FontID;
import com.stencyl.behavior.Script;
import scripts.tools.Util;
import com.stencyl.utils.Utils;

class GF_CharStatus {
	var script:Script = new Script();
	public var gfRoot:Grapefruit;

	var uiTimer:EZImgInstance = new EZImgInstance("g", false, "bttl.ui.timerCircle");

	public function new(gfRoot:Grapefruit){
		this.gfRoot = gfRoot;
		uiTimer.attachToWorld("bttlUi", 110, 336, 1);

		script.addWhenDrawingListener(null, function(g:G, x:Float, y:Float, list:Array<Dynamic>):Void {
			Script.setDrawingLayer(1, "drawLayer");
			g.alpha = 1;
			g.fillColor = Utils.getColorRGB(0,0,0);
			g.strokeSize = 0;
			g.setFont(Script.getFont(FontID.MAIN_WHITE));

			if(gfRoot.uiMode == 0){
				// Name and level
				//g.drawString(Util.getAttr("party").getMember(gfRoot.currentMember).getName(), 317, 295);
				//g.drawString(Util.getString("GF_CHARSTAT_LEVEL") + " " + Util.getAttr("party").getMember(gfRoot.currentMember).getLevel(), 317, 307);

				/*
				// Status bars
				// Backing
				g.fillColor = Utils.getColorRGB(16, 16, 16);
				g.fillRect(340, 322, 136, 10);
				g.fillRect(340, 334, 136, 10);
				g.fillRect(340, 346, 136, 10);
				// HP
				g.fillColor = ColorConvert.getColorHSL((Util.party().getMember(gfRoot.currentMember).getHp() / Util.getAttr("party").getMember(gfRoot.currentMember).getMaxHp()) * 120, 100, 100);
				g.drawString(Util.getString("GF_CHARSTAT_HP"), 317, 319);
				g.fillRect(340, 322, (Util.party().getMember(gfRoot.currentMember).getHp() / Util.party().getMember(gfRoot.currentMember).getMaxHp()) * 136, 10);
				// MP
				g.fillColor = ColorConvert.getColorHSL(-((Util.getAttr("party").getMember(gfRoot.currentMember).getMp() / Util.getAttr("party").getMember(gfRoot.currentMember).getMaxMp()) * 120) + 360, 100, 100);
				g.drawString(Util.getString("GF_CHARSTAT_MP"), 317, 331);
				g.fillRect(340, 334, (Util.getAttr("party").getMember(gfRoot.currentMember).getMp() / Util.getAttr("party").getMember(gfRoot.currentMember).getMaxMp()) * 136, 10);
				// SP
				g.fillColor = ColorConvert.getColorHSL((Util.getAttr("party").getMember(gfRoot.currentMember).getSp() / 100) * 360, 100, 100);
				g.drawString(Util.getString("GF_CHARSTAT_SP"), 317, 343);
				g.fillRect(340, 346, (Util.getAttr("party").getMember(gfRoot.currentMember).getSp() / 100) * 136, 10);
				// Values for bars
				g.setFont(Script.getFont(613));
				g.drawString(Util.getAttr("party").getMember(gfRoot.currentMember).getHp() + "/" + Util.getAttr("party").getMember(gfRoot.currentMember).getMaxHp(), 343, 325);
				g.drawString(Util.getAttr("party").getMember(gfRoot.currentMember).getMp() + "/" + Util.getAttr("party").getMember(gfRoot.currentMember).getMaxMp(), 343, 337);
				g.drawString(Util.getAttr("party").getMember(gfRoot.currentMember).getSp() + "%", 343, 349);

				// Separator
				g.strokeSize = 1;
				g.strokeColor = Utils.getColorRGB(255,255,255);
				for(i in 298...360) if(i % 4 == 0) g.drawLine(310, i, 310, i + 1); */
			}
			// Turn timer
			g.strokeSize = 2;
			g.strokeColor = Utils.getColorRGB(255, 0, 0);
			g.setFont(Script.getFont(FontID.BTTLTIMER));
			if(gfRoot.turnTime >= 10) g.drawString("" + gfRoot.turnTime, uiTimer.getX() + 5, uiTimer.getY() + 5);
			else g.drawString("0" + gfRoot.turnTime, uiTimer.getX() + 5, uiTimer.getY() + 5);
			DrawCircles.drawArc(g, uiTimer.getX() + (uiTimer.getWidth() / 2), uiTimer.getY() + (uiTimer.getHeight() / 2), -90, -90 + ((gfRoot.turnTime / gfRoot.baseTurnTime) * 360), 9);
		});
	}
}