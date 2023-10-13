extends Node2D


@export var avatar_scene : PackedScene

var port = 8910

# Called when the node enters the scene tree for the first time.
func _ready():
	
	
	Globals.world = self
	multiplayer.connected_to_server.connect(connectedToServer)
	multiplayer.connection_failed.connect(failedToConnect)
	
	if multiplayer.is_server():
		multiplayer.peer_connected.connect(add_avatar)
		add_avatar()
	
	
	pass # Replace with function body.

func _process(delta):
	
	var livingPlayers = 0
	var totalPlayers = 0
	
	for child in get_tree().get_first_node_in_group("objectHolder").get_children():
		if child.is_in_group("avatar"):
			if !child.isDead():
				livingPlayers += 1
			totalPlayers += 1
	
	if livingPlayers < 2 && totalPlayers > 1:
		resetGame()
	
	if livingPlayers == 0 and totalPlayers == 1:
		resetGame()
	
	pass

func connectedToServer():
	print("connected!")
func failedToConnect():
	print("failed")



func exit_game(id):
	multiplayer.peer_disconnected.connect(del_player)
	del_player(id)

func add_avatar(id = 1):
	var avatar = avatar_scene.instantiate()
	avatar.name = str(id)
	
	var objectHolder = get_tree().get_first_node_in_group("objectHolder")
	objectHolder.call_deferred("add_child",avatar)
	totalPlayers += 1
	

var bulletPath = preload("res://scenes/bullet.tscn")
func createBullet(pos,dir,type):
	rpc("_createBullet",pos,dir,type,Globals.multiplayerId)
@rpc("any_peer", "call_local") func _createBullet(pos,dir,type,shooterId):
	
	var bullet = bulletPath.instantiate()
	
	bullet.setType(pos, dir, type,shooterId)
	
	#get_tree().get_first_node_in_group("objectHolder").add_child(bullet,true)
	
	var objectHolder = get_tree().get_first_node_in_group("objectHolder")
	
	objectHolder.call_deferred("add_child",bullet,true)


var thrownWeaponPast = preload("res://scenes/thrownWeapon.tscn")
func createThrownWeapon(pos,dir,type):
	rpc("_createThrownWeapon",pos,dir,type,Globals.multiplayerId)
@rpc("any_peer", "call_local") func _createThrownWeapon(pos,dir,type,shooterId):
	
	var weapon = thrownWeaponPast.instantiate()
	weapon.setType(pos, dir, type,shooterId)
	
	#get_tree().get_first_node_in_group("objectHolder").add_child(bullet,true)
	
	var objectHolder = get_tree().get_first_node_in_group("objectHolder")
	objectHolder.call_deferred("add_child",weapon,true)


var weaponsSpawned = 0
var weaponSpawn = preload("res://scenes/weapon_spawn.tscn")
func createGunPickup(pos,type):
	weaponsSpawned += 1
	rpc("_createGunPickup",pos,weaponsSpawned,type)
@rpc("any_peer", "call_local") func _createGunPickup(pos,weaponPickupId,type):
	
	var weapon = weaponSpawn.instantiate()
	
	weapon.setType(pos,weaponPickupId, type)
	
	#get_tree().get_first_node_in_group("objectHolder").add_child(bullet,true)
	
	var objectHolder = get_tree().get_first_node_in_group("objectHolder")
	
	objectHolder.call_deferred("add_child",weapon,true)


func gunPickup(id,type):
	rpc("_gunPickup",id,Globals.multiplayerId,type)
@rpc("any_peer", "call_local") func _gunPickup(gunId,playerId,type):
	
	if Globals.multiplayerId == playerId:
		if !Globals.player.holdingWeapon:
			
			Globals.player.pickUpGun(type)
			
	
	var objectHolder = get_tree().get_first_node_in_group("objectHolder")
	
	var child = objectHolder.get_node_or_null("gunPickup" + str(gunId))
	if child != null:
		child.queue_free()
	

func resetGame():
	rpc("_resetGame",)
@rpc("any_peer", "call_local") func _resetGame():
	#Globals.player.reset()
	
	
	for child in get_tree().get_first_node_in_group("objectHolder").get_children():
		if !child.is_in_group("avatar"):
			child.queue_free()
		else:
			goToResetPos(int(str(child.name)),randi_range(0,$spawnPoints.get_child_count()-3))
	
	print("reset the game")
	

func goToResetPos(id,pos : int):
	rpc("_goToResetPos",id,pos)
@rpc("any_peer", "call_local") func _goToResetPos(id,pos : int):
	Globals.playerIsDead = false
	
	if Globals.multiplayerId == id:
		var place = $spawnPoints.get_child(pos)
		
		Globals.player.goToPosition(place.position)
	
	pass
	

var totalPlayers = 0
var livingPlayers = 0
func died():
	rpc("_died",)
@rpc("any_peer", "call_local") func _died():
	
	return
	if Globals.is_server:
		livingPlayers -= 1
		
		if livingPlayers <= 1:
			livingPlayers = totalPlayers
			resetGame()
		
		prints("total ",totalPlayers)
		print("living ",livingPlayers)
		
	

func del_player(id):
	rpc("_del_player",id)
@rpc("any_peer", "call_local") func _del_player(id):
	get_node(str(id)).queue_free()
	totalPlayers -= 1

