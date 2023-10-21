extends Node2D

var id
var type


func setType(pos,id,newType):
	position = pos
	self.id = id
	name = "gunPickup" + str(id)
	type = (gun_library.getAttributes(newType) as gun_attributes)
	$appearance/gun.texture = type.gunTexture
	

# Called when the node enters the scene tree for the first time.
func _ready():
	$appearance/AnimationPlayer.play("start")
	$appearance/gun.rotation = randf() * 2 * PI
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if $appearance/AnimationPlayer.is_playing():
		return
	
	if $playerDetect.get_overlapping_bodies().size() > 0 && Globals.player.holdingWeapon == false && Globals.resetting == false:
		
		Globals.world.gunPickup(id,type.gunName)
	pass


