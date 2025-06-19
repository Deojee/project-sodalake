extends Node

"""This is an autoloaded singleton that all classes can access. """

var statusEffects : Dictionary 

func _init():
	resetStatusEffects()

#called ~60 times a second.
func _physics_process(delta):
	updateStatusEffects(delta)

const FIRE = "fire"
const COLD = "cold"
const ADRENALINE = "adrenaline"

"""This updates all the durations on the status effects. It's only called in physics process"""
func updateStatusEffects(delta):
	for effect in statusEffects.keys():
		statusEffects[effect] = max(0,statusEffects[effect] - delta)

"""returns whether or not an effect has remaining duration"""
func hasEffect(effect):
	return statusEffects[effect] > 0

"""Adds time to an effect"""
func addToEffect(effect,duration):
	statusEffects[effect] = statusEffects[effect] + duration

"""Sets the remaining duration of an effect"""
func setEffect(effect,duration):
	statusEffects[effect] = duration

#status effects and time left in seconds
func resetStatusEffects(): 
	statusEffects = {
	ADRENALINE : 3,
	FIRE : 0,
	COLD : 0
	}
