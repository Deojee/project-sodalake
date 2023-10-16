extends Node2D

var dangerFrames = 5
# Called when the node enters the scene tree for the first time.
func _ready():
	$appeared.restart()
	
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	dangerFrames = max(-1,dangerFrames -1)
	if dangerFrames > 0 and $playerDetect.get_overlapping_bodies().size() > 0:
		
		for body in $playerDetect.get_overlapping_bodies():
			var distanceToBody = global_position.distance_to(body.global_position)
			
			var damage = 120*(pow(1.05,-0.1*distanceToBody))
			
			body.takeDamage(body.global_position - global_position,damage*100,damage)
			
		
		
		dangerFrames = 0
	
	
	if $appeared.emitting == false:
		queue_free()
	pass
