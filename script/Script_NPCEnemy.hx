package scripts;

import scripts.assets.Assets;
import scripts.gfx.GFX_DialogGrawlix;
import scripts.gfx.GFX_BattleTransition;
import scripts.tools.Util;
import com.stencyl.behavior.Script;
import com.stencyl.behavior.Script.*;
import com.stencyl.behavior.ActorScript;
import com.stencyl.behavior.TimedTask;
import com.stencyl.models.Actor;
import com.stencyl.models.Region;
import com.stencyl.models.actor.Group;
import com.stencyl.Engine;
import com.stencyl.utils.Utils;

class Script_NPCEnemy extends ActorScript {
	@:attribute("id='1' name='Enemy Tag' desc='Must match the structure name.'")
	public var _EnemyName:String = "";
	@:attribute("id='2' name='Disable Wandering' desc=''")
	public var _DisableWandering:Bool = true;
	@:attribute("id='3' name='Aggressive?' desc=''")
	public var _Aggressive:Bool = false;

	@:attribute("id='4' name='Up Animation' desc='' type='ANIMATION'")
	public var _UpAnim:String;
	@:attribute("id='5' name='Up Animation Idle' desc='' type='ANIMATION'")
	public var _UpIdleAnim:String;
	@:attribute("id='6' name='Down Animation' desc='' type='ANIMATION'")
	public var _DownAnim:String;
	@:attribute("id='7' name='Down Animation Idle' desc='' type='ANIMATION'")
	public var _DownIdleAnim:String;
	@:attribute("id='8' name='Left Animation' desc='' type='ANIMATION'")
	public var _LeftAnim:String;
	@:attribute("id='9' name='Left Animation Idle' desc='' type='ANIMATION'")
	public var _LeftIdleAnim:String;
	@:attribute("id='10' name='Right Animation' desc='' type='ANIMATION'")
	public var _RightAnim:String;
	@:attribute("id='11' name='Right Animation Idle' desc='' type='ANIMATION'")
	public var _RightIdleAnim:String;

	// Misc vars
	public var _tempChance:Float = 0;
	public var _doAction:Float = 0;
	public var _lastWalkingDir:String = "d";
	public var _drawTransition:Bool = false;
	public var _bttlRegion:Region;
	public var _chaseRegion:Region;
	public var _chaseMode:Bool = false;
	public var _grawlixActor:Actor;

	// Chasemode calculation vars
	public var _DistanceX:Float = 0;
	public var _DistanceY:Float = 0;
	public var _Distance:Float = 0;
	public var _Direction:Float = 0;

	public var disableBounding:Bool = false;
	public var hasCollided:Bool = false;

	public function new(dummy:Int, actor:Actor, dummy2:Engine){
		super(actor);
		nameMap.set("_DisableWandering", "_DisableWandering");
		nameMap.set("_Aggressive", "_Aggressive");
	}

	// ==== awa ====
	// TODO: organize

	override public function init(){
		//actor.makeAlwaysSimulate();
		// Create battle activation region
		createBoxRegion(actor.getX() - 16, ((actor.getY() + (actor.getHeight())) - 16), ((actor.getWidth()) + 32), 32);
		_bttlRegion = getLastCreatedRegion();
		// Create chase activation region
		createCircularRegion((actor.getWidth()/2), (actor.getHeight()), 128);
		_chaseRegion = getLastCreatedRegion();

		runPeriodically(1500, function(timeTask:TimedTask):Void {
			if(!_DisableWandering && !Util.inDialog()){
				_tempChance = randomInt(Math.floor(0), Math.floor(3));
				_doAction = randomInt(Math.floor(0), Math.floor(7));
				if(_tempChance == 0){
					if(_doAction == 0){
						actor.setAnimation(_UpAnim);
						_lastWalkingDir = "u";
						actor.setXVelocity(0);
						actor.setYVelocity(-4);
					}
					else if(_doAction == 1){
						actor.setAnimation(_DownAnim);
						_lastWalkingDir = "d";
						actor.setXVelocity(0);
						actor.setYVelocity(4);
					}
					else if(_doAction == 2){
						actor.setAnimation(_LeftAnim);
						_lastWalkingDir = "l";
						actor.setXVelocity(-4);
						actor.setYVelocity(0);
					}
					else if(_doAction == 3){
						actor.setAnimation(_RightAnim);
						_lastWalkingDir = "r";
						actor.setXVelocity(4);
						actor.setYVelocity(0);
					}
					else {
						if(_lastWalkingDir == "u") actor.setAnimation(_UpIdleAnim);
						else if(_lastWalkingDir == "d") actor.setAnimation(_DownIdleAnim);
						else if(_lastWalkingDir == "l") actor.setAnimation(_LeftIdleAnim);
						else actor.setAnimation(_RightIdleAnim);
						actor.setXVelocity(0);
						actor.setYVelocity(0);
					}
				}
				else {
					if(_lastWalkingDir == "u") actor.setAnimation(_UpIdleAnim);
					else if(_lastWalkingDir == "d") actor.setAnimation(_DownIdleAnim);
					else if(_lastWalkingDir == "l") actor.setAnimation(_LeftIdleAnim);
					else actor.setAnimation(_RightIdleAnim);
					actor.setXVelocity(0);
					actor.setYVelocity(0);
				}
			}
		}, actor);

		// Battle listener
		addActorEntersRegionListener(_bttlRegion, function(a:Actor, list:Array<Dynamic>):Void {
			if(sameAsAny(getActorType(371), a.getType(), a.getGroup())){
				
			}
		});

		// Chase listener
		addActorEntersRegionListener(_chaseRegion, function(a:Actor, list:Array<Dynamic>):Void {
			if(sameAsAny(getActorType(371), a.getType(), a.getGroup())){
				// Stop wandering, start chasing
				if(_Aggressive && (!Util.getAttr("battleTransitionStatus") && !Util.inDialog())){
					_DisableWandering = true;
					_chaseMode = true;
					playSound(Assets.get("sfx.enemyDetect"));
					// Grawlix animation below
					createRecycledActor(getActorType(452), actor.getX() - 24, actor.getY() - 24, Script.FRONT);
					_grawlixActor = getLastCreatedActor();
					runPeriodically(1, function(timeTask:TimedTask):Void {
						if(_grawlixActor.isAlive()){
							_grawlixActor.setX((actor.getX() - (_grawlixActor.getWidth())));
							_grawlixActor.setY((actor.getY() - (_grawlixActor.getHeight())));
						}
					}, actor);
				}
			}
		});

		// Chase exit listener
		addActorExitsRegionListener(_chaseRegion, function(a:Actor, list:Array<Dynamic>):Void {
			if(sameAsAny(getActorType(371), a.getType(), a.getGroup())){
				// If the player leaves the chase region, then stop chasing and start wandering again
				_DisableWandering = false;
				_chaseMode = false;
			}
		});

		addWhenUpdatedListener(null, function(elapsedTime:Float, list:Array<Dynamic>):Void {
			for(actorInGroup in cast(getActorGroup(0), Group).list){
				if(actorInGroup != null && !actorInGroup.dead && !actorInGroup.recycled){
					if(isInRegion(actorInGroup, _bttlRegion)){
						if(!Util.inDialog()){
							// TODO: fix enemy list emptying before the other enemies can be added
							// Stop chasing, start... wandering?
							_chaseMode = false;
							_DisableWandering = true;
							hasCollided = true;
		
							if(actor.getAnimation() == _UpAnim) actor.setAnimation(_UpIdleAnim);
							else if(actor.getAnimation() == _DownAnim) actor.setAnimation(_DownIdleAnim);
							else if(actor.getAnimation() == _LeftAnim) actor.setAnimation(_LeftIdleAnim);
							else actor.setAnimation(_RightIdleAnim);
							
							// Disable movement once the battle region is activated
							// TODO: for some reason, the enemies sometimes still move? this might be fixed since we updated the enemy collision groups
							runPeriodically(1, function(timeTask:TimedTask):Void {
								actor.setXVelocity(0);
								actor.setYVelocity(0);
							}, actor);
		
							// If the battle transition is not already going, start it
							if(!Util.getAttr("battleTransitionStatus")){
								for(i in 0...4) pauseSoundOnChannel(i);
								playSoundOnChannel(Assets.get("mus.battleStart"), 4);
								var transition:GFX_BattleTransition = new GFX_BattleTransition();
								Util.setAttr("battleTransitionStatus", true);
								Util.disableMovement();
								Utils.clear(Util.getAttr("bttl_enemyParams"));
							}
							Util.getAttr("bttl_enemyParams").push(_EnemyName);
						}
					}
				}
			}
			
			if(_chaseMode){
				// if this is an individual enemy chasing the player, start following
				for(actorOfType in getActorsOfType(getActorType(371))){
					if(actorOfType != null && !actorOfType.dead && !actorOfType.recycled){
						_DistanceX = asNumber(actorOfType.getXCenter() - actor.getXCenter());
						_DistanceY = asNumber(actorOfType.getYCenter() - actor.getYCenter());
					}
				}
				_Direction = asNumber(Utils.DEG * Math.atan2(_DistanceY, _DistanceX));
				if(_Direction >= -45 && _Direction <= 45) actor.setAnimation(_RightAnim);
				else if(_Direction >= 45 && _Direction <= 135) actor.setAnimation(_DownAnim);
				else if(_Direction >= -135 && _Direction <= -45) actor.setAnimation(_UpAnim);
				else actor.setAnimation(_LeftAnim);
				actor.setVelocity(_Direction, 15);
			}

			else if(Util.getAttr("battleTransitionStatus") && !hasCollided){
				// same procedure as above, however slow down the enemy a bit if they were triggered by the battle being activated
				for(actorOfType in getActorsOfType(getActorType(371))){
					if(actorOfType != null && !actorOfType.dead && !actorOfType.recycled){
						_DistanceX = asNumber(actorOfType.getXCenter() - actor.getXCenter());
						_DistanceY = asNumber(actorOfType.getYCenter() - actor.getYCenter());
					}
				}
				_Direction = asNumber(Utils.DEG * Math.atan2(_DistanceY, _DistanceX));
				if(_Direction >= -45 && _Direction <= 45) actor.setAnimation(_RightAnim);
				else if(_Direction >= 45 && _Direction <= 135) actor.setAnimation( _DownAnim);
				else if(_Direction >= -135 && _Direction <= -45) actor.setAnimation(_UpAnim);
				else actor.setAnimation(_LeftAnim);
				actor.setVelocity(_Direction, 6);
			}

			// Always make sure that this enemy's regions are updated to the current location of the enemy
			_bttlRegion.setLocation(actor.getX() - 16, (actor.getY() + actor.getHeight()) - 16);
			_chaseRegion.setLocation(((actor.getX() + (actor.getWidth()/2)) - (_chaseRegion.getWidth() / 2)), ((actor.getY() + (actor.getHeight())) - (_chaseRegion.getWidth() / 2)));

			// Stop enemy from going out of bounds
			if(!disableBounding){
				if(actor.getX() < 0){
					actor.setX(0);
					actor.setXVelocity(0);
				}
				if(actor.getY() < 0){
					actor.setY(0);
					actor.setYVelocity(0);
				}
				if(actor.getX() + actor.getWidth() > getSceneWidth()){
					actor.setX(getSceneWidth() - actor.getWidth());
					actor.setXVelocity(0);
				}
				if(actor.getY() + actor.getHeight() > getSceneHeight()){
					actor.setY(getSceneHeight() - actor.getHeight());
					actor.setYVelocity(0);
				}
			}
		});
	}
}