extends Node2D


var shooterId = 0

func setType(pos, dir, type, newShooterId):
	
	params = (gun_library.getAttributes(type) as gun_attributes).bullet as bullet_attributes
	position = pos
	self.dir = dir
	
	start = pos
	
	$Icon.texture = params.bulletTexture
	$Icon.rotation = dir.angle() + deg_to_rad(90)
	
	shooterId = newShooterId
	
	pass
	

var params : bullet_attributes

var dir = Vector2.ZERO

var start



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	
	
	position += dir * params.speed * delta
	
	var collider = checkForCollider(delta) 

	if (collider != null):
		#enemy.get_parent().takeDamage(Globals.gunParams.damage,dir.normalized())
		
		var shouldIgnore = false
		
		if collider.is_in_group("player"):
			if Globals.multiplayerId == shooterId:
				shouldIgnore = true
			else:
				collider.takeDamage(dir,params)
		
		
		if !shouldIgnore:
			queue_free()
	
	
	if start.distance_to(global_position) > params.range:
		queue_free()

	pass


func checkForCollider(delta):
	
	
	$raycast.target_position = -dir * params.speed *delta
	
	$raycast.force_raycast_update()
	
	if $raycast.is_colliding():
		return $raycast.get_collider()
	
	
	return null
	




