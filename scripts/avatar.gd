extends Node2D


func _enter_tree():
	set_multiplayer_authority(name.to_int())
	
	if is_multiplayer_authority():
		get_tree().get_first_node_in_group("player").avatar = self
		$StaticBody2D/CollisionShape2D.disabled = true
	
	visible = !is_multiplayer_authority()

# Called when the node enters the scene tree for the first time.
func _ready():
	$debug.text = name
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	
	
	
	pass
