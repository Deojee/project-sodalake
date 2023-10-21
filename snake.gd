extends CharacterBody2D

var health = 10

var shooterId = -10000
#snakes currently won't say who shot them when they kill someone


var dumbFrames = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	$snakeBody/AnimatedSprite2D.play("exist")
	
	#prints("snake ", name, " ", Globals.multiplayerId)
	
	set_multiplayer_authority(1)
	pass # Replace with function body.

var speed = 100
var accel = 6
var maxAccel = 60

var id = 0

var lastTime = 0

var playerDamageRange = 160

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	
	
	var prevId = id
	id = int($targetId.text)
	
	#if id != prevId and id == Globals.multiplayerId:
		#$MultiplayerSynchronizer.set_visibility_public (true)
	
	#if (int($targetId.text) == 1):
	#	$snakeBody/AnimatedSprite2D.rotation += 0.1
	
	#print(is_multiplayer_authority())
	
	pass

func _physics_process(delta):
	
	#prints(Globals.multiplayerId,int(id))
	
	var targetPosition = Vector2.ZERO
	
	for avatar in Globals.world.getLivingAvatars():
		if avatar.name == str(id):
			targetPosition = avatar.global_position
	
	if global_position.distance_to(targetPosition) < playerDamageRange:
		if dumbFrames <= 1:
			$AnimationPlayer.play("attack")
		else:
			velocity += (targetPosition - global_position).normalized() * 30 * delta
		
	
	
	if Globals.is_server:
		
		$snakeBody.rotation = velocity.angle()
		
		
		
		
		if dumbFrames > 0:
			dumbFrames -= 1
			if move_and_slide():
				velocity /= 2
			return
		
		#$MultiplayerSynchronizer.set_visibility_public (true)
		
		accel = move_toward(accel,maxAccel, 60 * delta) 
		
		if Time.get_ticks_msec() > lastTime + 100:
			$NavigationAgent2D.set_target_position(targetPosition)
			lastTime = Time.get_ticks_msec()
		
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
				$targetId.text = target.name 
			#if $targetId.text != tempText:
				#$MultiplayerSynchronizer.set_visibility_public (false)
		
	

func takeDamage(dir,knockBack,damage):
	
	health -= damage
	
	velocity += knockBack * dir
	
	if health < 0:
		die(dir)
	

func damagePlayer():
	if id == Globals.multiplayerId and global_position.distance_to(Globals.player.global_position) < playerDamageRange:
		Globals.player.takeDamage(global_position.direction_to(Globals.player.global_position).normalized(),-400,5,shooterId)
	

func setTarget(id):
	if Globals.is_server:
		$targetId.text = str(id)
	else:
		$targetId.text = "1"
	#self.id = id
	#set_multiplayer_authority(id)

func die(dir,isWorld = false):
	
	if !isWorld:
		Globals.world.killSnake(id,dir)
	
	var particles = get_node_or_null("deathParticles")
	
	if particles != null:
		remove_child(particles)
		var parent = get_parent()
		
		if parent != null:
			parent.add_child(particles)
			particles.global_position = global_position
			particles.rotation = dir.angle()
			particles.restart()
	
	queue_free()
	
	pass
