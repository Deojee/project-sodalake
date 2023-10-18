extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	pass


func _on_leave_lobby_pressed():
	
	Globals.peer.close()
	
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
	
	pass # Replace with function body.


func _on_quit_game_pressed():
	get_tree().quit()
	pass # Replace with function body.
