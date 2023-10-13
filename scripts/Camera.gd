extends Node2D


var deadZone = 10

func _ready():
	
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
	
	$address.text = Globals.internalAddress
	$CheckBox.visible = Globals.is_server
	pass


func _process(delta):
	
	$Health.value = Globals.playerHealth
	$Health.max_value = Globals.maxPlayerHealth
	
	$bulletIndicator.text = "Bullets left: " + str(Globals.ammo)
	$bulletIndicator.visible = Globals.player.holdingWeapon
	
	$reload.value = Globals.maxTimeTillNextShot-Globals.timeTillNextShot
	$reload.max_value = Globals.maxTimeTillNextShot
	$reload.visible = Globals.player.holdingWeapon
	
	if Input.is_action_just_pressed("escape"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	if Input.is_action_just_pressed("shoot"):
		Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
	
	if Globals.playerIsDead:
		var targetVelocity = Vector2()
		if Input.is_action_pressed("right"):
			targetVelocity.x += 1
		if Input.is_action_pressed("left"):
			targetVelocity.x -= 1
		if Input.is_action_pressed("down"):
			targetVelocity.y += 1
		if Input.is_action_pressed("up"):
			targetVelocity.y -= 1
		
		position += targetVelocity * 20
	
	if Globals.resetting:
		position = Vector2.ZERO
	

func _input(event : InputEvent) -> void:
	
	if Globals.playerIsDead:
		return
	
	if event is InputEventMouseMotion:
		var _target = event.position - get_viewport().size * 0.5
		
		_target = get_global_mouse_position() - global_position
		
		
		
		if _target.length() < deadZone:
			position = Vector2(0,0)
		else:
			position = _target.normalized() * (min(600,_target.length()) - deadZone) * 0.5
		
		


func _on_check_box_toggled(button_pressed):
	$address.visible = button_pressed
	pass # Replace with function body.
