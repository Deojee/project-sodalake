extends Node2D

var port = 8910

@export var gameScene : PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	port = $port.value
	
	match OS.get_name():
		"Windows":
			$address.text = IP.resolve_hostname(str(OS.get_environment("COMPUTERNAME")),1)
		"macOS":
			$address.text = "10.135.16.251"
			#IP.resolve_hostname(str(OS.get_environment("HOSTNAME")),1)
			#print(str(OS.get_environment("HOST")))
		
	
	#print(OS.get_name())
	
	
	
	multiplayer.connected_to_server.connect(connectedToServer)
	multiplayer.connection_failed.connect(failedToConnect)
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

var setUpConnections = false
func _on_client_pressed():
	
	Globals.peer = ENetMultiplayerPeer.new()
	
	var err = Globals.peer.create_client($address.text,port)
	multiplayer.multiplayer_peer = Globals.peer
	
	$awaiting.text = "Awaiting connection on port " + str(port) + " at " + $address.text
	

func connectedToServer():
	Globals.multiplayerId = multiplayer.get_unique_id()
	get_tree().change_scene_to_packed(gameScene)
	Globals.is_server = false

func failedToConnect():
	print("server does not exist")

func _on_port_value_changed(value):
	port = value
	pass # Replace with function body.



