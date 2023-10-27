extends CharacterBody2D

var id = 1 #the target player's id

var speed = 100
var accel = 8

var minDistance = 150
var maxDistance = 250
var runClockwise = true
var health = 50

# Called when the node enters the scene tree for the first time.
func _ready():
	runClockwise = randf() > 0.5
	pass # Replace with function body.

var lastNavUpdateTime = -1000
var prevTargetLastShotDir 
var wasCorneredLastFrame = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	
	
	if Globals.is_server:
		
		var targetPosition = Vector2.ZERO
		var targetLastShotDir = Vector2.ZERO
		var targetJustShot = false
		
		
		var wallCounterClockwise = $wallDetects/runClockwise.is_colliding()
		var wallClockwise = $wallDetects/runCounterClockwise.is_colliding()
		var wallBehindUs = $wallDetects/cornered.is_colliding()
		var cornered = wallBehindUs  or (wallCounterClockwise and wallClockwise)
		
		for avatar in Globals.world.getLivingAvatars():
			if avatar.name == str(id):
				targetPosition = avatar.global_position
				targetLastShotDir = Vector2.RIGHT.rotated( avatar.getLastShotDir() )
				
				if prevTargetLastShotDir != targetLastShotDir:
					targetJustShot = true
					print("target just shot!")
				prevTargetLastShotDir = targetLastShotDir
		
		
		var hasLineOfSight = hasLineOfSight(targetPosition)
		
		#the direction the rat will move. Changes depending on what the rat is doing.
		var dir
		
		if hasLineOfSight:
			
			if Time.get_ticks_msec() > lastNavUpdateTime + 100:
				$NavigationAgent2D.set_target_position(targetPosition)
				lastNavUpdateTime = Time.get_ticks_msec()
		else:
			dir = to_local($NavigationAgent2D.get_next_path_position()).normalized()
		
		
		if hasLineOfSight:
			var distanceToPlayer = (global_position - targetPosition).length()
			
			if distanceToPlayer > maxDistance or !hasDirectLineOfSight(targetPosition):
				dir = to_local($NavigationAgent2D.get_next_path_position()).normalized()
				#runClockwise = !runClockwise
			else:
				
				var dirToTarget = (global_position - targetPosition).normalized()
				
				
				
				if !cornered:
					if distanceToPlayer > minDistance:
						
						
						
						if runClockwise and wallClockwise:
							runClockwise = false
						elif !runClockwise and wallCounterClockwise:
							runClockwise = true
						
						#set runclockwise to away from the last angle the target shot
						if targetJustShot:
							runClockwise = dirToTarget.angle_to(targetLastShotDir) < 0
							
						
						dir = dirToTarget.rotated(deg_to_rad(90 if runClockwise else -90))
						
						
						
						if targetJustShot and abs(dirToTarget.angle_to(targetLastShotDir)) < deg_to_rad(10):
							velocity += dir * 2000
						
					else:
						dir = dirToTarget.rotated(deg_to_rad(45 if runClockwise else -45))
					
					
					$wallDetects.rotation = dirToTarget.angle() + deg_to_rad(90)
					
				else:
					
					if not wasCorneredLastFrame:
						runClockwise = !runClockwise
					
					dir =  -dirToTarget.rotated(deg_to_rad(45 if runClockwise else -45))
					
					$wallDetects.rotation = dirToTarget.angle() + deg_to_rad(90)
					print("i'm cornered!")
				
				
				
			
		
			
		
		
		if cornered:
			velocity = lerp(velocity,dir * speed,accel * delta)
		else:
			velocity = lerp(velocity,dir * speed,accel * delta)
		
		
		
		move_and_slide()
		
		wasCorneredLastFrame = cornered
		
		var avatars =  Globals.world.getLivingAvatars()
		
		if !avatars.size() < 1:
			
			
			var shortestDistance = global_position.distance_to(avatars[0].global_position)
			var target = avatars[0]
			for avatar in avatars:
				var distance = global_position.distance_to(avatar.global_position) 
				if distance < shortestDistance:
					target = avatar
					shortestDistance = distance
					
				#var tempText = $targetId.text
				#$targetId.text = target.name 
			id = target.getId()
				
		

func takeDamage(dir,knockback,damage):
	health -= damage
	
	velocity += knockback * dir
	
	if health < 0:
		die(dir)
	pass

func die(dir):
	queue_free()

#globalPosition
func hasLineOfSight(toPos):
	var returnVal = false
	for cast in $playerDetectCasts.get_children():
		
		#check if we can even see this cast, if we can't, skip it
		cast.target_position = global_position -  cast.global_position
		cast.force_raycast_update()
		if cast.is_colliding():
			continue
		
		cast.target_position = toPos -  cast.global_position
		
		cast.force_raycast_update()
		
		if !cast.is_colliding():
			
			returnVal = true
		
	
	return returnVal

func hasDirectLineOfSight(toPos):
	var cast = $playerDetectCasts/losCheck
	
	cast.target_position = toPos -  cast.global_position
	
	cast.force_raycast_update()
	
	return !cast.is_colliding()
	
