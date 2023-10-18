extends Node2D

var dangerFrames = 5
# Called when the node enters the scene tree for the first time.
func _ready():
	
	$AnimationPlayer.play("shoot")
	
	pass # Replace with function body.

var hit = false
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	dangerFrames = max(-1,dangerFrames -1)
	if !hit and $appeared.emitting and $playerDetect.get_overlapping_bodies().size() > 0:
		
		var damage = 100
		
		for body in $playerDetect.get_overlapping_bodies():
			body.takeDamage(Vector2.ZERO,0,damage)
		
		
		dangerFrames = 0
		
		hit = true
	
	
	if !$AnimationPlayer.is_playing() and dangerFrames <= 0:
		queue_free()
	pass
