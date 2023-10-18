extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	
	setCursorSize(20,4) 
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	
	position = get_global_mouse_position()
	
	if Globals.player.holdingWeapon == false:
		Globals.gunInaccuracyTotal = 0
	
	var bloomVal = Globals.gunInaccuracyTotal
	
	setSize(bloomVal/1.4)
	

func _input(event : InputEvent) -> void:
	
	
	if event is InputEventMouseMotion:
		position = get_global_mouse_position()
		

func setSize(num):
	$right.position.x = num
	$left.position.x = -$left.size.x - num
	$top.position.y = -$top.size.y - num
	$bottom.position.y = num
	

func setCursorSize(length,thickness):
	$right.size = Vector2(length,thickness)
	$right.position.y = -thickness/2
	
	$left.size = Vector2(length,thickness)
	$left.position.y = -thickness/2
	
	$top.size = Vector2(thickness,length)
	$top.position.x = -thickness/2
	
	$bottom.size = Vector2(thickness,length)
	$bottom.position.x = -thickness/2
	
	
