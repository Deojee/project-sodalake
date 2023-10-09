extends Node2D


var deadZone = 100


func _input(event : InputEvent) -> void:
	
	if event is InputEventMouseMotion:
		var _target = event.position - get_viewport().size * 0.5
		if _target.length() < deadZone:
			self.position = Vector2(0,0)
		else:
			self.position = _target.normalized() * (_target.length() - deadZone) * 0.5
		print(event.position)
		print(position)


