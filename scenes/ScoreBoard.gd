extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	container = $Panel/ScrollContainer/VBoxContainer
	pass # Replace with function body.


var playerInfoLinePath = preload("res://scenes/player_info_line.tscn")
var container : Control

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	visible = Input.is_action_pressed("tab") || Globals.paused || Globals.resetting
	
	if Globals.playerScores.keys.size() > container.get_children().size():
		
		pass
	
	pass
	


