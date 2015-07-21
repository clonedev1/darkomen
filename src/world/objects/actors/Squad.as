package world.objects.actors 
{
	import com.rnk.animation.AnimationHolder;
	import com.rnk.math.Vector2D;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import world.Game;
	import world.objects.GameObjectManager;
	/**
	 * ...
	 * @author me
	 */
	public class Squad extends Actor
	{
		
		public var mass:Number;
		public var position:Vector2D;
		public var velocity:Vector2D;
		public var maxForce:Number;
		public var maxSpeed:Number;
		public var rot:Number;
		
		private var target:Vector2D;
		private var aiUpdate:int = 0;
		
		public var soldiers:Array = [];
		
		public function Squad(startX:Number,startY:Number) 
		{
			super(null, startX , startY );
			
			
			mass = 20;
			position = new Vector2D(x,y);
			velocity = new Vector2D();
			maxForce = 2;
			maxSpeed = 0.7;			
			rot = 0
			
			target = new Vector2D(startX, startY); 
			
			arrowSprite = new Sprite();
			addChild(arrowSprite);
			
			
		}
		
		
		override public function Init(objectManager:GameObjectManager):void 
		{
			super.Init(objectManager);
			
			stage.addEventListener(MouseEvent.CLICK, OnMouseClick, false, 0, true);
			
			//formation
			currentFormation = { w:3, h:3, type:"testudo" };
			SetFormation(currentFormation);
		}
		
		private function OnMouseClick(e:MouseEvent):void 
		{
			var newTarget:Vector2D = new Vector2D(e.stageX, e.stageY);
			var newdir:Vector2D = newTarget.subtract(position);
			var krutoiPovorot:Boolean = Math.abs(Vector2D.angleBetween(newdir, velocity)) > Math.PI / 2;
			target.x = e.stageX;
			target.y = e.stageY;
			
			if (krutoiPovorot)
			{
				arrive(target);
				var squadSize:int = soldierPositions.length;
				var offset:Number = 20;
				var sx:Number = -((squadSize-1)  * offset)/ 2;
				var an:Number = velocity.angle + Math.PI;
				for (var i:int = 0; i < squadSize; i++) 
				{
					
					var t:Vector2D = soldierPositions[i];
					t.setEqual(position);
					
					if (sx < 0)
					{
						an = velocity.angle - Math.PI/2;
					} else
					{
						an = velocity.angle + Math.PI/2;
					}
					t.x += Math.cos(an) * Math.abs(sx);
					t.y += Math.sin(an) * Math.abs(sx);
					
					sx += offset;
				}
				ReAssembleSoldiers();
			}
			
		}
		
		override public function Update():void 
		{
			super.Update();
			
			//if (aiUpdate++ > 3)
			{
				aiUpdate = 0;
				seek(target);
				//arrive(target);
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
			
			//rot
			arrowSprite.rotation = rot;
			
			//for soldiers
			var squadSize:int = soldierPositions.length;
			var offset:Number = 20;
			var sx:Number = -((squadSize-1)  * offset)/ 2;
			var an:Number = velocity.angle + Math.PI;
			for (var i:int = 0; i < squadSize; i++) 
			{
				
				var t:Vector2D = soldierPositions[i];
				t.setEqual(position);
				
				if (sx < 0)
				{
					an = velocity.angle - Math.PI/2;
				} else
				{
					an = velocity.angle + Math.PI/2;
				}
				t.x += Math.cos(an) * Math.abs(sx);
				t.y += Math.sin(an) * Math.abs(sx);
				
				sx += offset;
			}
			
			
		}
		private var slowingDistance:Number = 20;//slowing distance, you can adjust this
		private var arrowSprite:Sprite;
		private var soldierPositions:Array = [];
		private var currentFormation:Object;
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
				var vehicle:Squad = vehicles[i] as Squad;
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
		
		public function isInSight(vehicle:Squad):Boolean 
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
		
		public function isTooClose(vehicle:Squad):Boolean 
		{
			return position.distance(vehicle.position) < 80;
		}
		
		public function AssembleSoldiers():void 
		{
			soldierPositions = [];
			for (var i:int = 0; i < soldiers.length; i++) 
			{
				var targetPos:Vector2D = position.cloneVector();
				soldierPositions.push(targetPos);
				soldiers[i].target = targetPos;
			}
			
			
			//lets draw their positions
			arrowSprite.graphics.clear();
			arrowSprite.graphics.moveTo(10, 0);
			arrowSprite.graphics.lineStyle(1.0, 0xFF0000);
			arrowSprite.graphics.lineTo(30, 0);
			arrowSprite.graphics.lineTo(25, 3);
			arrowSprite.graphics.moveTo(30, 0);
			arrowSprite.graphics.lineTo(25, -3);
			
			var squadSize:int = soldierPositions.length;
			var offset:Number = 20;
			var sx:Number = -((squadSize-1)  * offset) / 2;
			arrowSprite.graphics.lineStyle(1.0, 0x00FF80, 0.5);
			for (i = 0; i < squadSize; i++) 
			{
				arrowSprite.graphics.drawCircle(0, sx, 10);
				sx += offset;
			}			
			
			var squad:Rectangle = new Rectangle(0, 0, offset, offset*(squadSize));
			arrowSprite.graphics.lineStyle(1.0, 0xFFFF00,0.3);
			arrowSprite.graphics.drawRect( -squad.width / 2, -squad.height / 2, squad.width, squad.height);
			
		}
		
		public function ReAssembleSoldiers():void
		{
			//для каждого солдата выбрать ближайшую позицию
			var freePositions:Array = soldierPositions.slice();
			for each (var soldier:Soldier in soldiers) 
			{
				var closestIdx:int = 0;
				var min:int = soldier.position.distSQ(freePositions[0]);
				for (var i:Number = 1; i < freePositions.length; i++) 
				{
					var t:Number = soldier.position.distSQ(freePositions[i]);
					if (t < min)
					{
						min = t;
						closestIdx = i;
					}
				}
				soldier.target = freePositions[closestIdx];
				freePositions.splice(closestIdx, 1);
			}
			
		}
		
		public function GetFormation():Object
		{
			return currentFormation;
		}
		
		public function SetFormation(formation:Object):void
		{
			currentFormation = formation;
			
			
			
		}
		
	}

}