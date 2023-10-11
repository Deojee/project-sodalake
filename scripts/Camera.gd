extends Node2D


var deadZone = 10


func _input(event : InputEvent) -> void:
	#return
	if event is InputEventMouseMotion:
		var _target = event.position - get_viewport().size * 0.5
		if _target.length() < deadZone:
			position = Vector2(0,0)
		else:
			position = _target.normalized() * (_target.length() - deadZone) * 0.5
		
		
