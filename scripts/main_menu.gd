extends Node2D

var port = 8910

@export var gameScene : PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	port = $port.value
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_host_pressed():
	
	Globals.peer = ENetMultiplayerPeer.new()
	
	var error = Globals.peer.create_server(port,16)
	
	print(error)
	
	multiplayer.set_multiplayer_peer(Globals.peer)
	
	get_tree().change_scene_to_packed(gameScene)
	
	Globals.is_server = true
	
	pass # Replace with function body.

func _on_client_pressed():
	
	Globals.peer = ENetMultiplayerPeer.new()
	
	var err = Globals.peer.create_client(IP.resolve_hostname(str(OS.get_environment("COMPUTERNAME")),1),port)
	multiplayer.multiplayer_peer = Globals.peer
	
	Globals.multiplayerId = multiplayer.get_unique_id()
	
	get_tree().change_scene_to_packed(gameScene)
	Globals.is_server = false
	
	pass # Replace with function body.

func _on_port_value_changed(value):
	port = value
	pass # Replace with function body.



