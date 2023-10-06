extends Node2D

@export var isServer = true
# Called when the node enters the scene tree for the first time.
func _ready():
	
	# Create server.
	if isServer:
		var peer = ENetMultiplayerPeer.new()
		peer.create_server(0, 10)
		multiplayer.multiplayer_peer = peer
	
	else:
		var peer = ENetMultiplayerPeer.new()
		peer.create_client("136.228.38.11", 0)
		multiplayer.multiplayer_peer = peer
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (Input.is_action_just_pressed("ui_accept")):
		$subWorld.add_child(load("res://player.tscn").instantiate())
	pass
