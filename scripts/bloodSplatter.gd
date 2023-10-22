extends Node2D

var type = ""

var emitter : CPUParticles2D

func setType(pos,dir,damage,knockback,type):
	position = pos
	rotation = dir.angle()
	emitter = $modulate/shot
	
	emitter.amount = int(damage * 2) + 1
	emitter.spread = 360 * pow(1.01,-0.25 * knockback)
	emitter.initial_velocity_max = (damage * knockback)/300 + 100
	
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	#setType(position,Vector2(1,0),30,1000,"")
	$modulate/shot.restart()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_timer_timeout():
	emitter.set_process(false)
	emitter.set_process_input(false)
	emitter.set_process_internal(false)
	emitter.set_process_shortcut_input(false)
	emitter.set_process_unhandled_input(false)
	emitter.set_process_unhandled_key_input(false)
	emitter.set_physics_process(false)
	
	
	$AnimationPlayer.play("fade")
	pass # Replace with function body.
