extends Node2D


func _process(delta):
	
	scale += Vector2(1,1) * delta
	
	if $playerDetect.get_overlapping_bodies().size() > 0:
		
		for body in $playerDetect.get_overlapping_bodies():
			var distanceToBody = global_position.distance_to(body.global_position)
			
			var damage = (pow(1.05,-0.1*(distanceToBody/scale.x))) 
			
			if body.is_in_group("player"):
				body.takeDamage(body.global_position - global_position,-damage*100,damage)
			elif Globals.is_server:
				body.takeDamage(body.global_position - global_position,-damage*100,damage)
			
		
		
		
	
	
	
	pass
