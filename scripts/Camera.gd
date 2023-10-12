extends Node2D


var deadZone = 10

func _ready():
	
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
	pass


func _process(delta):
	
	$Health.value = Globals.playerHealth
	$Health.max_value = Globals.maxPlayerHealth
	
	

func _input(event : InputEvent) -> void:
	#return
	if event is InputEventMouseMotion:
		var _target = event.position - get_viewport().size * 0.5
		
		_target = get_global_mouse_position() - global_position
		
		
		
		if _target.length() < deadZone:
			position = Vector2(0,0)
		else:
			position = _target.normalized() * (min(600,_target.length()) - deadZone) * 0.5
		
		
