extends Node2D

var dangerFrames = 5
var playerId = 1
var length = 120

func setDash(pos, dir, length,shooterId):
	position = pos
	rotation = dir.angle()
	self.length = length
	playerId = shooterId
	
	
	

# Called when the node enters the scene tree for the first time.
func _ready():
	$appeared.restart()
	
	$playerDetect/CollisionShape2D.shape.size.x = length
	$playerDetect.position.x = length/2
	
	$appeared.emission_rect_extents.x = length/2
	$appeared.position.x = length/2
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	dangerFrames = max(-1,dangerFrames -1)
	if dangerFrames > 0 and $playerDetect.get_overlapping_bodies().size() > 0:
		
		for body in $playerDetect.get_overlapping_bodies():
			
			var damage = 50
			
			if (body.is_in_group("player") and Globals.multiplayerId == playerId):
				pass
			else:
				body.takeDamage(body.global_position - global_position,0,damage)
			
		
		
		dangerFrames = 0
	
	
	if $appeared.emitting == false:
		queue_free()
	pass
