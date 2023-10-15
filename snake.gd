extends CharacterBody2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

var speed = 100
var accel = 60

var lastTime = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if Time.get_ticks_msec() > lastTime + 2:
		$NavigationAgent2D.set_target_position(Globals.player.position)
		lastTime = Time.get_ticks_msec()
	
	var dir = to_local($NavigationAgent2D.get_next_path_position()).normalized()
	
	velocity = lerp(velocity,dir * speed,accel * delta)
	
	move_and_slide()
	
	pass
