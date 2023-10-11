extends Node2D




func setType(pos, dir, type):
	
	params = (gun_library.getAttributes(type) as gun_attributes).bullet as bullet_attributes
	position = pos
	self.dir = dir
	
	start = pos
	
	$Icon.texture = params.bulletTexture
	$Icon.rotation = dir.angle() + deg_to_rad(90)
	
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
		
		if collider.is_in_group("player"):
			
			collider.takeDamage(dir,params)
		
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
	


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
