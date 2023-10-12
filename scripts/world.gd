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
	

var bulletPath = preload("res://scenes/bullet.tscn")
func createBullet(pos,dir,type):
	rpc("_createBullet",pos,dir,type)
@rpc("any_peer", "call_local") func _createBullet(pos,dir,type):
	
	var bullet = bulletPath.instantiate()
	
	bullet.setType(pos, dir, type)
	
	#get_tree().get_first_node_in_group("objectHolder").add_child(bullet,true)
	
	var objectHolder = get_tree().get_first_node_in_group("objectHolder")
	
	objectHolder.call_deferred("add_child",bullet,true)


var thrownWeaponPast = preload("res://scenes/thrownWeapon.tscn")
func createThrownWeapon(pos,dir,type):
	rpc("_createThrownWeapon",pos,dir,type)
@rpc("any_peer", "call_local") func _createThrownWeapon(pos,dir,type):
	
	var weapon = thrownWeaponPast.instantiate()
	weapon.setType(pos, dir, type)
	
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
	print("gunPickup" + str(gunId))
	for child in objectHolder.get_children():
		print("child: " + child.name)
	
	var child = objectHolder.get_node("gunPickup" + str(gunId))
	if child != null:
		child.queue_free()
	


func del_player(id):
	rpc("_del_player",id)
@rpc("any_peer", "call_local") func _del_player(id):
	get_node(str(id)).queue_free()

