extends Node2D


func setParticle(pos,value):
	value = int(value)
	$Label.text = str(value)
	position = pos

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("float away")
	await  $AnimationPlayer.animation_finished
	queue_free()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
