extends Node2D

var id
var type

"""
corpse type should be "player" or "rat"
"""

func setType(pos,id,corpseType = "player"):
	position = pos
	self.id = id
	name = "corpse" + str(id)
	
	type = corpseType
	

# Called when the node enters the scene tree for the first time.
func _ready():
	
	
	match type:
		"player":
			$catCorpse.visible = true
			$catCorpse.play("default")
		"rat":
			$ratCorpse.visible = true
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	
	
	if $playerDetect.get_overlapping_bodies().size() > 0 and Globals.playerIsDead == false:
		Globals.world.playSoundFromPath("res://sounds/player noises/eatCorpse.wav",global_position)
		
		var health = 0
		match type:
			"player":
				health = Globals.maxPlayerHealth/2.0
			"rat":
				health = Globals.maxPlayerHealth/4.0
		
		Globals.world.eatCorpse(id,Globals.multiplayerId,health)
	pass
