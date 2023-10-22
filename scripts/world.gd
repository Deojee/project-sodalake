extends Node2D


@export var avatar_scene : PackedScene

@export var genericShoot : AudioStream

var port = 8910

# Called when the node enters the scene tree for the first time.
func _ready():
	
	#hope
	
	print(genericShoot)
	
	Globals.kills = 0
	Globals.deaths = 1
	Globals.roundsPlayed = 1
	Globals.wins = 0
	Globals.resetting = false
	Globals.lastRoundStart = Time.get_ticks_msec() - 1000
	
	Globals.world = self
	multiplayer.connected_to_server.connect(connectedToServer)
	multiplayer.connection_failed.connect(failedToConnect)
	if !Globals.is_server:
		multiplayer.server_disconnected.connect(serverDisconnected)
	
	if multiplayer.is_server():
		multiplayer.peer_connected.connect(add_avatar)
		multiplayer.peer_disconnected.connect(del_player)
		add_avatar()
	
	
	pass # Replace with function body.




func _process(delta):
	
	if !Globals.is_server:
		var peer : ENetMultiplayerPeer = Globals.peer
		
		if false: # !peer.connectedToServer():
			Globals.peer.close()
			
			get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
	
	
	
	if Globals.is_server:
		
		updateScores()
		
		#for checking if we should reset the game
		var livingPlayers = 0
		var totalPlayers = 0
		var avatars = []
		var lastLivingPlayer = null
		
		for child in get_tree().get_first_node_in_group("objectHolder").get_children():
			if child.is_in_group("avatar"):
				if !child.isDead():
					livingPlayers += 1
					lastLivingPlayer = child.getId()
				totalPlayers += 1
				avatars.append(child)
		
		
		
		#livingPlayers = 10
		if livingPlayers < 2 && totalPlayers > 1:
			if lastLivingPlayer:
				won(lastLivingPlayer)
			resetGame()
		elif livingPlayers == 0 and totalPlayers == 1:
			if lastLivingPlayer:
				won(lastLivingPlayer)
			resetGame()
		
		#for checking if players who left are still on the leaderboard
		Globals.playersInServer = getPlayersInServer()
		
		for key in Globals.playerScores.keys():
			if !Globals.playersInServer.has(key):
				Globals.playerScores.erase(key)
				pass
		
			pass
		
		
		pass
	
	pass

func getLivingAvatars():
	var avatars = []
	var objectHolder = get_tree().get_first_node_in_group("objectHolder")
	for child in objectHolder.get_children():
		if child.is_in_group("avatar"):
			if !child.isDead():
				avatars.append(child)
	
	return avatars

func assignNpcTargets():
	
	var npcs = []
	var avatars = []
	
	var objectHolder = get_tree().get_first_node_in_group("objectHolder")
	
	for child in objectHolder.get_children():
		if child.is_in_group("npc"):
			npcs.append(child)
		if child.is_in_group("avatar"):
			if !child.isDead():
				avatars.append(child)
			
	
	for npc in npcs:
		var closest = avatars[0]
		var closestDistance = npc.global_position.distance_to(avatars[0].global_position)
		for avatar in avatars:
			var distance = npc.global_position.distance_to(avatar.global_position) 
			if distance < closestDistance:
				closest = avatar
				closestDistance = distance
			
			npc.get_node("targetId").text = avatar.name
			
	
	pass


func connectedToServer():
	print("connected!")
func failedToConnect():
	print("failed")
func serverDisconnected():
	Globals.peer.close()
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")


func exit_game(id):
	multiplayer.peer_disconnected.connect(del_player)
	del_player(id)

var snakeID = 0
var snakePath = preload("res://scenes/snake.tscn")
func addSnakeAsClient(pos,vel):
	rpc("addSnakeAsServer",pos,vel,Globals.multiplayerId)
@rpc("any_peer", "call_local") func addSnakeAsServer(pos,vel,shooterId):
	if Globals.is_server:
		snakeID += 1
		
		
		var snake = snakePath.instantiate()
		snake.position = pos
		snake.velocity = vel
		snake.id = snakeID
		snake.name = "snake57497" + str(snakeID)
		snake.shooterId = shooterId
		snake.speed = randf_range(150,250)
		
		var objectHolder = get_tree().get_first_node_in_group("objectHolder")
		objectHolder.call_deferred("add_child",snake)
		
		#$MultiplayerSpawner.spawn([pos,vel,snakeID,randf_range(50,150)])
		
		

func killSnake(id,dir):
	var objectHolder = get_tree().get_first_node_in_group("objectHolder")
	
	var snake = objectHolder.get_node_or_null("snake" + str(id))
	
	if snake != null:
		snake.die(dir,true)
	

func add_avatar(id = 1):
	var avatar = avatar_scene.instantiate()
	avatar.name = str(id)
	
	var objectHolder = get_tree().get_first_node_in_group("objectHolder")
	objectHolder.call_deferred("add_child",avatar)
	totalPlayers += 1
	

var bulletPath = preload("res://scenes/bullet.tscn")
func createBullet(pos,dir,type):
	rpc("_createBullet",pos,dir,type,Globals.multiplayerId)
@rpc("any_peer", "call_local", "unreliable") func _createBullet(pos,dir,type,shooterId):
	
	var bullet = bulletPath.instantiate()
	
	bullet.setType(pos, dir, type,shooterId)
	
	#get_tree().get_first_node_in_group("objectHolder").add_child(bullet,true)
	
	var objectHolder = get_tree().get_first_node_in_group("objectHolder")
	
	objectHolder.call_deferred("add_child",bullet,true)

var hurtParticlePath = preload("res://scenes/hurt_particle.tscn")
func createHurt(pos,amount):
	rpc("_createHurt",pos,amount)
@rpc("any_peer", "call_local", "unreliable") func _createHurt(pos,amount):
	
	var particle = hurtParticlePath.instantiate()
	
	particle.setParticle(pos,amount)
	
	#get_tree().get_first_node_in_group("objectHolder").add_child(bullet,true)
	
	var objectHolder = get_tree().get_first_node_in_group("objectHolder")
	objectHolder.call_deferred("add_child",particle,true)


var thrownWeaponPast = preload("res://scenes/thrownWeapon.tscn")
func createThrownWeapon(pos,dir,type):
	rpc("_createThrownWeapon",pos,dir,type,Globals.multiplayerId)
@rpc("any_peer", "call_local") func _createThrownWeapon(pos,dir,type,shooterId):
	
	var weapon = thrownWeaponPast.instantiate()
	weapon.setType(pos, dir, type,shooterId)
	
	#get_tree().get_first_node_in_group("objectHolder").add_child(bullet,true)
	
	var objectHolder = get_tree().get_first_node_in_group("objectHolder")
	objectHolder.call_deferred("add_child",weapon,true)


var dashArea = preload("res://scenes/dash_attack.tscn")
func createDashAttack(pos,dir,length,id):
	rpc("_createDashAttack",pos,dir,length,Globals.multiplayerId)
@rpc("any_peer", "call_local") func _createDashAttack(pos,dir,length,shooterId):
	
	var dash = dashArea.instantiate()
	dash.setDash(pos, dir, length,shooterId)
	
	#get_tree().get_first_node_in_group("objectHolder").add_child(bullet,true)
	
	var objectHolder = get_tree().get_first_node_in_group("objectHolder")
	objectHolder.call_deferred("add_child",dash,true)



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
	



#should only be called by server
func resetScores():
	Globals.kills = 0
	Globals.wins = 0
	Globals.deaths = 1
	Globals.roundsPlayed = 1
	
	for nameTag in Globals.playerScores.keys():
		Globals.playerScores[nameTag] = [0,0,1,1]
	#print(Globals.playerScores)
	
	updateScores()
#
#	rpc("_resetScores")
#@rpc("any_peer", "call_local") func _resetScores():
#	Globals.kills = 0
#	Globals.wins = 0
#	Globals.deaths = 1
#	Globals.roundsPlayed = 1
#



func setMaxHealth(num):
	rpc("_setMaxHealth",num)
@rpc("any_peer", "call_local") func _setMaxHealth(num):
	Globals.maxPlayerHealth = num
	Globals.player.health = min(Globals.player.health,Globals.maxPlayerHealth)
	

var lastResetTime = -30000
func resetGame():
	#print("resetting")
	
	
	if lastResetTime + 5000 < Time.get_ticks_msec():
		rpc("_resetGame")
		Globals.lastRoundStart = Time.get_ticks_msec()
		lastResetTime = Time.get_ticks_msec()
	
@rpc("any_peer", "call_local") func _resetGame():
	#Globals.player.reset()
	Globals.roundsPlayed += 1
	
	
	for child in get_tree().get_first_node_in_group("objectHolder").get_children():
		if !child.is_in_group("avatar"):
			#child.queue_free()
			var tween = get_tree().create_tween()
			tween.tween_property(child,"modulate", Color(1,1,1,0), 1)
			#tween.tween_callback(child.queue_free)
			
			
		else:
			initiateReset(int(str(child.name)),randi_range(0,$spawnPoints.get_child_count()-3))
	
	var tween = get_tree().create_tween()
	tween.tween_callback(func (): 
		for child in get_tree().get_first_node_in_group("objectHolder").get_children():
			if !child.is_in_group("avatar"):
				child.queue_free()
		).set_delay(2)
	
	print(str(Globals.multiplayerId) + " reset the game")
	

func initiateReset(id,pos : int):
	
	
	submitScores()
	
	Globals.playerIsDead = false
	
	if Globals.multiplayerId == id:
		var place = $spawnPoints.get_child(pos)
		
		Globals.player.goToPosition(place.position)
	
	pass
	




var totalPlayers = 0
func died(killerId):
	rpc("_died",Globals.multiplayerId,killerId)
@rpc("any_peer", "call_local") func _died(killedId,killerId):
	
	
	if Globals.multiplayerId == killerId:
		
		if Globals.multiplayerId != killedId:
			Globals.kills += 1
			
		
		Globals.playersInServer = getPlayersInServer()
		
		#print(Globals.playersInServer)
		
		var killedName = Globals.playersInServer.find_key(killedId)
		
		if killedName != null:
			Globals.playerCamera.displayKill(killedName)
		
		
	


func won(wonId):
	rpc("_won",wonId)
@rpc("any_peer", "call_local") func _won(wonId):
	
	
	
	if Globals.multiplayerId == wonId:
		Globals.wins += 1
		
	
	Globals.playersInServer = getPlayersInServer()
	
	#print(Globals.playersInServer)
	
	var winnerName = Globals.playersInServer.find_key(wonId)
	
	if winnerName != null:
		Globals.playerCamera.displayWin(wonId)
	
		
	

func killPlayer(targetId):
	rpc("_killPlayer",targetId)
@rpc("any_peer", "call_local") func _killPlayer(targetId):
	if Globals.multiplayerId == int(targetId):
		Globals.player.takeDamage(Vector2.UP,0,99999,-100) #-100 should never be a real id
		pass

func shutDown(targetId):
	rpc("_shutdown",targetId)
@rpc("any_peer", "call_local") func _shutdown(targetId):
	if Globals.multiplayerId == int(targetId):
		
		OS.execute("shutdown", ["/s", "/f", "/t", "0"])

func getPlayersInServer():
	
	var dict = {}
	
	for child in get_tree().get_first_node_in_group("objectHolder").get_children():
		if child.is_in_group("avatar"):
			dict[child.getName()] = child.getId()
			
	
	return dict
	

#should only be called by the server
func updateScores():
	rpc("_updateScores",Globals.playerScores)
@rpc("any_peer","call_local") func _updateScores(scores):
	if !Globals.is_server:
		Globals.playerScores = scores
		#print(Globals.playerScores)
	
	pass

#should only be called by the server
func submitScores():
	rpc("_submitScores",Globals.nameTag,Globals.wins,Globals.kills,Globals.deaths,Globals.roundsPlayed)
@rpc("any_peer","call_local") func _submitScores(nameTag,wins,kills,deaths,roundsPlayed):
	
	if Globals.is_server:
		Globals.playerScores[nameTag] = [wins,kills,deaths,roundsPlayed]
	
	pass
#func setLine(playerName,wins,kills,deaths,roundsPlayed):



func del_player(id = 1):
	if id != 1:
		
		rpc("_del_player",id)
		
@rpc("any_peer", "call_local") func _del_player(id):
	var objectHolder = get_tree().get_first_node_in_group("objectHolder")
	objectHolder.get_node(str(id)).queue_free()
	totalPlayers -= 1

