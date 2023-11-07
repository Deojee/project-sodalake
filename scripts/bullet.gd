extends damageInflicter


func setType(pos, dir, type, newShooterId):
	
	params = (gun_library.getAttributes(type) as gun_attributes).bullet as bullet_attributes
	position = pos
	self.dir = dir
	
	start = pos
	
	$Icon.texture = params.bulletTexture
	$Icon.rotation = dir.angle()
	
	shooterId = newShooterId
	
	if params.piercing:
		
		$raycast.set_collision_mask_value(1,false)
		$raycast.set_collision_mask_value(6,false)
		$raycast2.set_collision_mask_value(1,false)
		$raycast2.set_collision_mask_value(6,false)
		$raycast3.set_collision_mask_value(1,false)
		$raycast3.set_collision_mask_value(6,false)
		
	
	#print(params.firedNoise)
	if params.firedNoise != null:
		$fired.stream = params.firedNoise
		
		
		
		#print(params.firedNoise)
		
	
	#$fired.stream.add_stream(0, Globals.world.genericShoot, 1 )
	
	pass
	

var params : bullet_attributes

var dir = Vector2.ZERO

var start

func _ready():
	params.onShootLambda.call(shooterId,self)
	
	var noise = $fired
	remove_child(noise)
	Globals.safePlaySound(noise,global_position)
	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	
	$debug.text = str(shooterId)
	
	position += dir * params.speed * delta
	
	var collider = checkForCollider(delta) 

	if (collider != null):
		#enemy.get_parent().takeDamage(Globals.gunParams.damage,dir.normalized())
		
		var shouldIgnore = false
		
		if collider.is_in_group("takeDamage"):
			if Globals.multiplayerId == shooterId and collider.is_in_group("player"):
				shouldIgnore = true
			else:
				
				var damage = params.damage
				if shooterId == Globals.RATSHOOTERID:
					damage *= 0.5
				
				dealDamage(collider,dir,params.knockback,damage)
		
		
		if !shouldIgnore:
			params.onHitLambda.call(shooterId,collider,self)
			
			var hitNoise = $hit
			remove_child(hitNoise)
			Globals.safePlaySound(hitNoise,global_position)
			
			queue_free()
	
	
	if start.distance_to(global_position) > params.range:
		params.onHitLambda.call(shooterId,null,self)
		queue_free()
	
	
	pass


func checkForCollider(delta):
	
	
	$raycast.target_position = -dir * params.speed *delta
	
	$raycast.force_raycast_update()
	
	if $raycast.is_colliding():
		return $raycast.get_collider()
	
	var raycast2offset = dir.rotated(deg_to_rad(90)) * params.collisionShapeSize/2
	$raycast2.position = raycast2offset
	$raycast2.target_position = (-dir * params.speed *delta) 
	
	$raycast2.force_raycast_update()
	
	if $raycast2.is_colliding():
		return $raycast2.get_collider()
	
	
	$raycast3.position = -raycast2offset
	$raycast3.target_position = (-dir * params.speed *delta) 
	
	$raycast3.force_raycast_update()
	
	if $raycast3.is_colliding():
		return $raycast3.get_collider()
	
	return null
	




