extends CharacterBody2D

var id = 1 #the target player's id

var speed = 200
var accel = 3

var minDistance = 400
var maxDistance = 600
var runClockwise = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

var lastNavUpdateTime = -1000

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):

	var targetPosition = Vector2.ZERO
	
	for avatar in Globals.world.getLivingAvatars():
		if avatar.name == str(id):
			targetPosition = avatar.global_position
	
	
	
	
	if Globals.is_server:
		
		
		
		
		if Time.get_ticks_msec() > lastNavUpdateTime + 100 and hasLineOfSight(targetPosition):
			$NavigationAgent2D.set_target_position(targetPosition)
			lastNavUpdateTime = Time.get_ticks_msec()
		
		var dir = to_local($NavigationAgent2D.get_next_path_position()).normalized()
		
		velocity = lerp(velocity,dir * speed,accel * delta)
		
		
		
		
		move_and_slide()
		
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
				
		

#globalPosition
func hasLineOfSight(toPos):
	
	for cast in $playerDetectCasts.get_children():
		
		#check if we can even see this cast, if we can't, skip it
		cast.target_position = global_position -  cast.global_position
		cast.force_raycast_update()
		if cast.is_colliding():
			continue
		
		cast.target_position = toPos -  cast.global_position
		
		cast.force_raycast_update()
		
		if !cast.is_colliding():
			cast.visible = true
			return true
		cast.visible = false
		
	
	return false
