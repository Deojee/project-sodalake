extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	#$scalable.scale *= 0.2 * max(0.3,Globals.gunParams.bulletSize)
	start = global_position
	#$fired.play()
	#$enemyDetect.scale = Globals.gunParams.bulletSize
	pass # Replace with function body.

var translate = Vector2.ZERO

var moved = false

var start

func setTranslate(translate):
	self.translate = translate
	#$scalable/Icon.rotation = translate.angle() + deg_to_rad(90)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	
	#$scalable/Icon.rotation = translate.angle() + deg_to_rad(90)
	#$scalable/Icon.visible = true
	
	if !moved:
		start = global_position
		moved = true
	
	position += translate * delta
	
#	var enemy = checkForEnemy(delta) 
#
#	if (enemy != null):
#		enemy.get_parent().takeDamage(Globals.gunParams.damage,translate.normalized())
#		$hitSoft.play()
#
#		var particles = $hitSoft
#		remove_child(particles)
#		get_parent().add_child(particles)
#
#		queue_free()
#
#	if start.distance_to(global_position) > Globals.gunParams.bulletLifeSpan:
#		queue_free()
#
#	pass
#
#
#func checkForEnemy(delta):
#	var bodies = $scalable/enemyDetect.get_overlapping_areas()
#
#	if bodies.size() > 0:
#		return bodies[0]
#
#	$enemyCast.target_position = -translate*delta
#
#	$enemyCast.force_raycast_update()
#
#	if $enemyCast.is_colliding():
#		return $enemyCast.get_collider()
#
#
#	return null
	


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
