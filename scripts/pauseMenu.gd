extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	mainMenuPath = preload("res://scenes/main_menu.tscn")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

var mainMenuPath

func _on_leave_lobby_pressed():
	
	Globals.peer = null
	multiplayer.set_multiplayer_peer(OfflineMultiplayerPeer.new())
	
	get_tree().change_scene_to_packed(mainMenuPath)
	
	pass # Replace with function body.


func _on_quit_game_pressed():
	pass # Replace with function body.
