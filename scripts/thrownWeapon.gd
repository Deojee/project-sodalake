extends damageInflicter

func setType(pos, dir, type, newShooterID):
	
	params = (gun_library.getAttributes(type) as gun_attributes)
	position = pos
	self.dir = dir
	
	start = pos
	
	$Icon.texture = params.gunTexture
	$"shatter particles".texture = params.gunTexture
	$Icon.rotation = dir.angle() + deg_to_rad(90)
	$collisionDetect/CollisionShape2D.shape.radius = params.length/2
	
	shooterId = newShooterID
	
	pass
	

var params : gun_attributes

var dir = Vector2.ZERO

var start

var rotSpeed = 10

func _ready():
	var noise = $thrown
	remove_child(noise)
	Globals.safePlaySound(noise,global_position)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	
	$debug.text = str(shooterId)
	
	$Icon.rotation += rotSpeed * delta
	
	position += dir * params.throwSpeed * delta
	
	var collider = checkForCollider(delta) 
	
	if (collider != null):
		#enemy.get_parent().takeDamage(Globals.gunParams.damage,dir.normalized())
		var shouldIgnore = false
		
		#print("I am " + str(Globals.multiplayerId) + " colliding with: " + str(collider))
		
		if collider.is_in_group("takeDamage"):
			
			
			if collider.is_in_group("player") and Globals.multiplayerId == shooterId:
				shouldIgnore = true
				#print("won't hurt: " + str(shooterId))
				
			else:
				dealDamage(collider,dir,500,params.throwDamage)
		
		if collider.is_in_group("avatar"):
			
			if collider.get_parent().name == str(shooterId):
				shouldIgnore = true
				
			
		
		if !shouldIgnore:
			var noise = $shatter
			remove_child(noise)
			Globals.safePlaySound(noise,global_position)
			
			var particles = $"shatter particles"
			
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



func checkForCollider(delta):
	
	
	$raycast.target_position = -dir * params.throwSpeed *delta
	
	$raycast.force_raycast_update()
	
	if $raycast.is_colliding():
		return $raycast.get_collider()
	
	var raycast2offset = dir.rotated(deg_to_rad(90)) * params.length/2
	$raycast2.position = raycast2offset
	$raycast2.target_position = (-dir * params.throwSpeed *delta) 
	
	$raycast2.force_raycast_update()
	
	if $raycast2.is_colliding():
		return $raycast2.get_collider()
	
	
	$raycast3.position = -raycast2offset
	$raycast3.target_position = (-dir * params.throwSpeed *delta) 
	
	$raycast3.force_raycast_update()
	
	if $raycast3.is_colliding():
		return $raycast3.get_collider()
	
	return null
	
