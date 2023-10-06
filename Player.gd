extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _enter_tree():
	set_multiplayer_authority(name.to_int())
	$Camera2D.enabled = is_multiplayer_authority()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if is_multiplayer_authority():
		if Input.is_action_pressed("ui_left"):
			position.x -= 10
		if Input.is_action_pressed("ui_right"):
			position.x += 10
		if Input.is_action_pressed("ui_up"):
			position.y -= 10
		if Input.is_action_pressed("ui_down"):
			position.y += 10
		
	pass
