extends Node2D

var shooterID = 0


func setType(pos, dir, type, newShooterID):
	
	params = (gun_library.getAttributes(type) as gun_attributes)
	position = pos
	self.dir = dir
	
	start = pos
	
	$Icon.texture = params.gunTexture
	$Icon.rotation = dir.angle() + deg_to_rad(90)
	
	shooterID = newShooterID
	
	pass
	

var params : gun_attributes

var dir = Vector2.ZERO

var start

var rotSpeed = 10

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	
	$Icon.rotation += rotSpeed * delta
	
	position += dir * params.throwSpeed * delta
	
	var collider = checkForCollider(delta) 
	
	if (collider != null):
		#enemy.get_parent().takeDamage(Globals.gunParams.damage,dir.normalized())
		var shouldIgnore = false
		
		if collider.is_in_group("player"):
			
			print("I am " + str(Globals.multiplayerId))
			
			if Globals.multiplayerId == shooterID:
				shouldIgnore = true
				print("won't hurt: " + str(shooterID))
				
			else:
				collider.takeDamage(dir,params)
			
		
		if !shouldIgnore:
			queue_free()
		
	
	#if start.distance_to(global_position) > params.range:
	#	queue_free()

	pass


func checkForCollider(delta):
	
	
	$raycast.target_position = -dir * params.throwSpeed *delta
	
	$raycast.force_raycast_update()
	
	if $raycast.is_colliding():
		return $raycast.get_collider()
	
	
	return null
	


