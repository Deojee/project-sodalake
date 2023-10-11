extends Node2D

var id

func setType(pos,id,type):
	position = pos
	id = id
	name = "gunPickup" + str(id)
	type = (gun_library.getAttributes(type) as gun_attributes)
	$appearance/gun.texture = type.gunTexture

# Called when the node enters the scene tree for the first time.
func _ready():
	$appearance/AnimationPlayer.play("start")
	$appearance/gun.rotation = randf() * 2 * PI
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if $playerDetect.get_overlapping_bodies().size() > 0 && Globals.player.holdingWeapon == false:
		Globals.world.gunPickup(id)
	pass


