extends Node2D

var id
var type


func setType(pos,id):
	position = pos
	self.id = id
	name = "corpse" + str(id)
	
	

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite2D.play("default")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if $AnimatedSprite2D.is_playing():
		return
	
	if $playerDetect.get_overlapping_bodies().size() > 0 and Globals.playerIsDead == false:
		Globals.world.playSoundFromPath("res://sounds/player noises/eatCorpse.wav",global_position)
		Globals.world.eatCorpse(id,Globals.multiplayerId)
	pass
