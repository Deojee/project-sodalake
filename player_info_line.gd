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
	$PanelContainer/HBoxContainer/kdr.text = str((kills/deaths)) + " " + str(kills) + "/" + str(deaths)
	$"PanelContainer/HBoxContainer/rounds played".text = str(roundsPlayed)

func setLineString(playerName,score,wins,kdr,roundsPlayed):
	$PanelContainer/HBoxContainer/name.text = playerName
	$PanelContainer/HBoxContainer/score.text = score
	$PanelContainer/HBoxContainer/wins.text = wins
	$PanelContainer/HBoxContainer/kdr.text = kdr
	$"PanelContainer/HBoxContainer/rounds played".text = roundsPlayed

