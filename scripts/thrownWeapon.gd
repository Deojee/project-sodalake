extends Node2D

var shooterId = 0


func setType(pos, dir, type, newShooterID):
	
	params = (gun_library.getAttributes(type) as gun_attributes)
	position = pos
	self.dir = dir
	
	start = pos
	
	$Icon.texture = params.gunTexture
	$Icon.rotation = dir.angle() + deg_to_rad(90)
	$collisionDetect/CollisionShape2D.shape.radius = params.length
	
	shooterId = newShooterID
	
	pass
	

var params : gun_attributes

var dir = Vector2.ZERO

var start

var rotSpeed = 10

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
		
		if collider.is_in_group("player"):
			
			if Globals.multiplayerId == shooterId:
				shouldIgnore = true
				#print("won't hurt: " + str(shooterId))
				
			else:
				collider.takeDamage(dir,params)
		
		if collider.is_in_group("avatar"):
			
			if collider.get_parent().name == str(shooterId):
				shouldIgnore = true
				
			
		
		if !shouldIgnore:
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
	


