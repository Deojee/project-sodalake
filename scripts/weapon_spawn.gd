extends Node2D

var id
var type

var instant = false

func setType(pos,id,newType,instant = false):
	position = pos
	self.id = id
	name = "gunPickup" + str(id)
	type = (gun_library.getAttributes(newType) as gun_attributes)
	$appearance/gun.texture = type.gunTexture
	
	self.instant = instant
	

# Called when the node enters the scene tree for the first time.
func _ready():
	
	$appearance/gun.rotation = randf() * 2 * PI
	
	if !instant:
		$appearance/AnimationPlayer.play("start")
	else:
		$appearance/gun.visible = true
		$appearance/gun.self_modulate = Color(1,1,1,1)
		$appearance/appeared.restart()
		
		
	
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if $appearance/AnimationPlayer.is_playing():
		return
	
	if $playerDetect.get_overlapping_bodies().size() > 0 && Globals.player.holdingWeapon == false && Globals.resetting == false:
		
		Globals.world.gunPickup(id,type.gunName)
	pass


