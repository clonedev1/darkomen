package world.objects.actors 
{
	import com.rnk.animation.AnimationHolder;
	import com.rnk.math.Vector2D;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import world.Game;
	import world.objects.GameObjectManager;
	/**
	 * ...
	 * @author me
	 */
	public class Soldier extends Actor
	{
		private static const ANIM_STAND:String = "stand";
		private static const ANIM_RUN:String = "run";
		private static const ANIM_FIGHT:String = "fight";
		private static const ANIM_DIE:String = "die";
		
		
		public var mass:Number;
		public var position:Vector2D;
		public var velocity:Vector2D;
		public var maxForce:Number;
		public var maxSpeed:Number;
		public var rot:Number;
		
		private var animsprite:AnimationHolder;
		private var animDirection:Boolean = true;
		public var target:Vector2D;
		private var aiUpdate:int=0;
		
		public function Soldier(startX:Number,startY:Number) 
		{
			super(Assets.GetAnimation(Assets.SOLDIER), startX , startY );
			
			animsprite = sprite as AnimationHolder;
			
			mass = 2;
			position = new Vector2D(x,y);
			velocity = new Vector2D();
			maxForce = 2;
			maxSpeed = 1.5;			
			rot = 0
			
			target = new Vector2D(startX, startY); 
			
			arrowSprite = new Sprite();
			addChild(arrowSprite);
			arrowSprite.graphics.lineStyle(1.0, 0xFF0000);
			arrowSprite.graphics.lineTo(20, 0);
			arrowSprite.graphics.lineTo(15, 3);
			arrowSprite.graphics.moveTo(20, 0);
			arrowSprite.graphics.lineTo(15, -3);
			
			aiUpdate = Math.random() * 3.0;
			animsprite.scaleX = -1.0;
		}
		
		
		override public function Init(objectManager:GameObjectManager):void 
		{
			super.Init(objectManager);
			
			/*var rand:Array = [ANIM_STAND, ANIM_RUN, ANIM_FIGHT, ANIM_DIE];
			var r:String = rand[Math.floor(Math.random() * rand.length)];
			animsprite.play(r,true,Math.floor(Math.random()*animsprite.animations[r].totalFrames));*/
			animsprite.play(ANIM_RUN,true,Math.random()*10);
			
			//stage.addEventListener(MouseEvent.CLICK, OnMouseClick, false, 0, true);
		}
		
		private function OnMouseClick(e:MouseEvent):void 
		{
			
			target.x = e.stageX;
			target.y = e.stageY;
		}
		
		override public function Update():void 
		{
			super.Update();
			
			//if (aiUpdate++ > 3)
			{
				aiUpdate = 0;
				//arrive(target);
				if (target)
					seek(target);
				else
					stop();
				//flock(papa.objects);
			}
			
			// keep it witin its max speed
			velocity.truncate(maxSpeed);
			 
			// move it
			position = position.add(velocity);
			 
			// keep it on screen
			
			if(position.x > Main.SCREEN_WIDTH) position.x = 0;
			if(position.x < 0) position.x = stage.stageWidth;
			if(position.y > Main.SCREEN_HEIGHT) position.y = 0;
			if(position.y < 0) position.y = stage.stageHeight;
			
			 
			// set the x and y, using the super call to avoid this class's implementation
			x = position.x;
			y = position.y;
			 
			// rotation = the velocity's angle converted to degrees
			rot = velocity.angle * 180 / Math.PI;
			
			//anim dir
			var newAnimDir:Boolean = velocity.x >= 0;
			if (animDirection != newAnimDir)
			{
				animsprite.scaleX = newAnimDir?-1.0: 1.0;
				animDirection = newAnimDir;
			}
			
			//rot
			arrowSprite.rotation = rot;
			
		}
		
		private function stop():void 
		{
			if (velocity.lengthSquared > 1)
				velocity.divide(2);
			else
				velocity.x = velocity.y = 0;
		}
		
		private var slowingDistance:Number = 20;//slowing distance, you can adjust this
		private var arrowSprite:Sprite;
		private var running:Boolean;
		public function arrive(target:Vector2D):void 
		{
			var desiredVelocity:Vector2D = target.cloneVector().subtract(position).normalize();//find the straight path and normalize it
			var distance:Number = position.distance(target);//find the distance
			if (distance > slowingDistance)
			{//if its still too far away
				desiredVelocity.multiply(maxSpeed);//go at full speed
			} else 
			{
				desiredVelocity.multiply(maxSpeed * distance/slowingDistance);//if not, slow down
			}
			 
			var force:Vector2D = desiredVelocity.subtract(velocity).truncate(maxForce);//keep the force within the max
			velocity.add(force);//apply the force
		}
		
		public function seek(target:Vector2D):void 
		{
			var desiredVelocity:Vector2D = target.cloneVector().subtract(position).normalize(); 
			//subtract the position from the target to get the vector from the vehicles position to the target. 
			//Normalize it then multiply by max speed to get the maximum velocity from your position to the target.
			
			var distance:Number = position.distance(target);//find the distance
			if (distance > slowingDistance)
			{//if its still too far away
				desiredVelocity.multiply(maxSpeed);//go at full speed
			} else 
			{
				desiredVelocity.multiply(maxSpeed * distance/slowingDistance);//if not, slow down
			}			
			
			 
			var steeringForce:Vector2D = desiredVelocity.subtract(velocity).truncate(maxForce);
			//subtract velocity from the desired velocity 
			//to get the force vector
			
			if (distance > slowingDistance)
				velocity.add(steeringForce.divide(mass)); 
			else
				velocity.add(steeringForce); 
			//divide the steeringForce by the mass(which makes it the acceleration), then add it to velocity 
			//to get the new velocity
			
			if (velocity.lengthSquared < 0.01)
			{
				SetAnimation(false);
			} else
			{
				SetAnimation(true);
			}
		 
		}
		
		private function SetAnimation(newrunning:Boolean):void 
		{
			if (newrunning != running)
			{
				running = newrunning;
				animsprite.play(running?ANIM_RUN:ANIM_STAND);
			}
			
		}
		
		public function flee(target:Vector2D):void 
		{
			var desiredVelocity:Vector2D = target.cloneVector().subtract(position).normalize().multiply(maxSpeed);
			
			var steeringForce:Vector2D = desiredVelocity.subtract(velocity);
			
			velocity.add(steeringForce.divide(mass).multiply(-1));
		 
		}
		public function flock(vehicles:*):void 
		{
			var averageVelocity:Vector2D = velocity.cloneVector(); // used for alignment.
			//starting with the current vehicles velocity keeps the vehicles from stopping
			var averagePosition:Vector2D = new Vector2D(); //used for cohesion
			var counter:int = 0;//used for cohesion
			for (var i:int = 0; i < vehicles.length; i++) 
			{//for each vehicle
				var vehicle:Soldier = vehicles[i] as Soldier;
				if (vehicle != this && isInSight(vehicle)) 
				{//if it is not the current vehicle
					//and it is in sight
					averageVelocity.add(vehicle.velocity); //add its velocity to the average velocity
					averagePosition.add(vehicle.position);//add its position to the average position
					if (isTooClose(vehicle)) 
					{//if it is too close
						flee(vehicle.position);//flee it, this is separation
					}
					counter++;//increase the counter to use for finding the average
				}
			}
			if (counter > 0) 
			{//if there are vehicles around
				averageVelocity.divide(counter);//divide to find average
				averagePosition.divide(counter);//divide to find average
				seek(averagePosition);//seek the average, this is cohesion
				velocity.add(averageVelocity.subtract(velocity).divide(mass).truncate(maxForce));
				//add the average velocity to the velocity after adjusting the force
				//this is alignment
			}
		}
		
		public function isInSight(vehicle:Soldier):Boolean 
		{
			if (position.distance(vehicle.position) > 120) 
			{//this is changed based on the desired flocking style
				return false;//you are too far away, do nothing
			}
			var direction:Vector2D = velocity.cloneVector().normalize();//get the direction
			var difference:Vector2D = vehicle.position.cloneVector().subtract(position);//find the difference of the two positions
			var dotProd:Number = difference.dotProduct(direction);//dotProduct
			 
			if (dotProd < 0) 
			{
				return false;//you are too far away and not facing the right direction
			}
			
			return true;//you are in sight.
		}
		
		public function isTooClose(vehicle:Soldier):Boolean 
		{
			return position.distance(vehicle.position) < 80;
		}
		
		
	}

}