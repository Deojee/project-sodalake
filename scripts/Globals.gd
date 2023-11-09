extends Node

#multiplayer stuff
var peer 
var is_server = false
var multiplayerId = 1
var nameTag = ""
var internalAddress
var commandLineOpen

var world

var player
var avatar
var playerCamera

var resetting = false


const RATSHOOTERID = -154
#player UI

var playerHealth = 100
var maxPlayerHealth = 100
var playerDashes = 3
var dashRechargePercet = 1
var dashCool = 1
var ammo
var timeTillNextShot = 0
var maxTimeTillNextShot = 0
var playerIsDead = false





var gunInaccuracyTotal = 0

var lastRoundStart = 0

var gunTracking : Dictionary = {}

var gunList = null

var kills = 0
var deaths = 1
var roundsPlayed = 1
var wins = 0

var pickupSpawner

var ratMaxHealth = 35

var playersInServer : Dictionary = { #name tags and IDs
	
}

var playerScores = {
	
}

var paused = false

var timeLastDied = 0


var gunSpawnsPerPersonAtStart = 1
var gunSpawnRatePerPerson = 0.2

#whethor or not all players are invincible
var invincible = false
var invincibilityLeft = 0
var invincibilitySeconds = 5

#call with an audiostreamplayer 2d or similar. Plays the sound and then deletes it.
#will not work if the sound is longer than 5 seconds
#make sure to remove the child first
func safePlaySound(soundPlayer,pos = Vector2.ZERO):
	soundPlayer.position = pos
	get_tree().get_first_node_in_group("soundHolder").add_child(soundPlayer)
	soundPlayer.play()
	var killTween = get_tree().create_tween()
	killTween.tween_callback(soundPlayer.queue_free).set_delay(5)
	
	pass
	
