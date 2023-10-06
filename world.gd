extends Node2D

var peer 
@export var player_scene : PackedScene
@onready var cam = $Camera2D
var port = 8910

# Called when the node enters the scene tree for the first time.
func _ready():
	
	multiplayer.connected_to_server.connect(connectedToServer)
	multiplayer.connection_failed.connect(failedToConnect)
	pass # Replace with function body.

func connectedToServer():
	print("connected!")
func failedToConnect():
	print("failed")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var temp = ""
	
	temp += str(multiplayer.get_default_interface()) + "\n"
	
	temp += str(multiplayer.get_peers()) + "\n"
	
	$Label.text = temp
	
	
	pass


func _on_host_button_pressed():
	peer = ENetMultiplayerPeer.new()
	
	var error = peer.create_server(port,4)
	
	print(error)
	
	multiplayer.set_multiplayer_peer(peer)
	multiplayer.peer_connected.connect(add_player)
	add_player()
	cam.enabled = false
	
	print("waiting for players!")
	
	pass # Replace with function body.


func _on_client_button_pressed():
	peer = ENetMultiplayerPeer.new()
	
	var err = peer.create_client("10.99.3.18",port)
	multiplayer.multiplayer_peer = peer
	cam.enabled = false
	
	print(err)
	
	pass # Replace with function body.


func exit_game(id):
	multiplayer.peer_disconnected.connect(del_player)
	del_player(id)

func add_player(id = 1):
	var player = player_scene.instantiate()
	player.name = str(id)
	call_deferred("add_child",player)
	

func del_player(id):
	rpc("_del_player",id)
@rpc("any_peer", "call_local") func _del_player(id):
	get_node(str(id)).queue_free()

