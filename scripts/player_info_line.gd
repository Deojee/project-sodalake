extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	pass

var killValue = 10
var winValue = 100

func setLine(playerName,wins,kills,deaths,roundsPlayed):
	$PanelContainer/HBoxContainer/name.text = str(playerName)
	$PanelContainer/HBoxContainer/score.text = str((killValue * kills + winValue * wins))
	$PanelContainer/HBoxContainer/wins.text = str(wins)
	$PanelContainer/HBoxContainer/kdr.text = str(round_to_dec((float(kills)/float(deaths)),2)) + " " + str(kills) + "/" + str(deaths)
	$"PanelContainer/HBoxContainer/rounds played".text = str(roundsPlayed)

func round_to_dec(num, digit):
	return round(num * pow(10.0, digit)) / pow(10.0, digit)

func setLineString(playerName,score,wins,kdr,roundsPlayed):
	$PanelContainer/HBoxContainer/name.text = playerName
	$PanelContainer/HBoxContainer/score.text = score
	$PanelContainer/HBoxContainer/wins.text = wins
	$PanelContainer/HBoxContainer/kdr.text = kdr
	$"PanelContainer/HBoxContainer/rounds played".text = roundsPlayed







func _on_button_pressed():
	DisplayServer.clipboard_set($PanelContainer/HBoxContainer/name.text)
