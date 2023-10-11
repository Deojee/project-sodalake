extends Node2D

var peer 
@export var avatar_scene : PackedScene

var port = 8910

# Called when the node enters the scene tree for the first time.
func _ready():
	Globals.world = self
	multiplayer.connected_to_server.connect(connectedToServer)
	multiplayer.connection_failed.connect(failedToConnect)
	pass # Replace with function body.

func connectedToServer():
	print("connected!")
func failedToConnect():
	print("failed")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	
	pass


func _on_host_button_pressed():
	peer = ENetMultiplayerPeer.new()
	
	var error = peer.create_server(port,4)
	
	print(error)
	
	multiplayer.set_multiplayer_peer(peer)
	multiplayer.peer_connected.connect(add_avatar)
	add_avatar()
	
	print("waiting for players!")
	
	pass # Replace with function body.


func _on_client_button_pressed():
	peer = ENetMultiplayerPeer.new()
	
	var err = peer.create_client(IP.resolve_hostname(str(OS.get_environment("COMPUTERNAME")),1),port)
	multiplayer.multiplayer_peer = peer
	
	#print(err)
	
	pass # Replace with function body.


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
var weaponSpawn = preload("res://weapon_spawn.tscn")
func createGunPickup(pos,type):
	weaponsSpawned += 1
	rpc("_createGunPickup",pos,weaponsSpawned,type)
@rpc("any_peer", "call_local") func _createGunPickup(pos,weaponPickupId,type):
	
	var weapon = weaponSpawn.instantiate()
	
	weapon.setType(pos,weaponPickupId, type)
	
	#get_tree().get_first_node_in_group("objectHolder").add_child(bullet,true)
	
	var objectHolder = get_tree().get_first_node_in_group("objectHolder")
	
	objectHolder.call_deferred("add_child",weapon,true)



func gunPickup(id):
	pass

func del_player(id):
	rpc("_del_player",id)
@rpc("any_peer", "call_local") func _del_player(id):
	get_node(str(id)).queue_free()

