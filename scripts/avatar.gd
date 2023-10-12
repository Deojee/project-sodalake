extends Node2D


func _enter_tree():
	set_multiplayer_authority(name.to_int())
	
	if is_multiplayer_authority():
		get_tree().get_first_node_in_group("player").avatar = self
		$StaticBody2D/CollisionShape2D.disabled = true
		Globals.avatar = self
		
	
	visible = !is_multiplayer_authority()

# Called when the node enters the scene tree for the first time.
func _ready():
	$debug.text = name
	
	pass # Replace with function body.

func isDead():
	return $deadLabel.text == "true"

func setType(type):
	$gunType.text = type

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var params = gun_library.getAttributes($gunType.text)
	
	if params != null:
		$gun.texture = params.gunTexture
		$gun.offset = params.texOffset
		$gun.visible = true
	else:
		$gun.visible = false
	
	if is_multiplayer_authority():
		$deadLabel.text = str(Globals.playerIsDead)
	
	pass

func setGunRotation(rot,flipH):
	$gun.flip_h = flipH
	$gun.rotation = rot
	
