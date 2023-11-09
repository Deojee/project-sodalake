extends Node


var statusEffects : Dictionary 

func _init():
	resetStatusEffects()

func _physics_process(delta):
	updateStatusEffects(delta)

const FIRE = "fire"
const COLD = "cold"
const ADRENALINE = "adrenaline"

func updateStatusEffects(delta):
	for effect in statusEffects.keys():
		statusEffects[effect] = max(0,statusEffects[effect] - delta)

func hasEffect(effect):
	return statusEffects[effect] > 0

func addToEffect(effect,duration):
	statusEffects[effect] = statusEffects[effect] + duration

func setEffect(effect,duration):
	statusEffects[effect] = duration

#status effects and time left in seconds
func resetStatusEffects(): 
	statusEffects = {
	ADRENALINE : 10,
	FIRE : 0,
	COLD : 0
	}


