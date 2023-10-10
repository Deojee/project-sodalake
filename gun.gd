extends Node2D

var bulletPath = preload("res://bullet.tscn")
var fogPath = preload("res://fog.tscn")
var camera

# Called when the node enters the scene tree for the first time.
func _ready():
	camera = $Camera2D
	
#	var fogDensity = 6
#
#	var numCasts = 120
#
#	for i in numCasts:
#
#
#		var raycast = RayCast2D.new()
#		raycast.enabled = true
#		raycast.target_position = Vector2(1000, 0)
#
#		raycast.target_position = raycast.target_position.rotated((float(i)/float(numCasts))*2*PI)
#
#		$rayCastHolder.add_child(raycast)
#
#		for o in fogDensity:
#			var fog = fogPath.instantiate()
#			#fog.visible = false
#			raycast.add_child(fog)
#
#
#
#			#fog.global_position = fogPosition
#			#fogPosition = fogPosition.move_toward(global_position,-fogDisance)
#
#
	
	pass # Replace with function body.

var bulletsLeft #= Globals.gunParams.maxAmmo

var params #= Globals.gunParams

var secondsUntilNextShot = 0
var secondsUntilReload = 0
var secondsUntilNextReload = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	
	pass

func _physics_process(delta):
	
	
	
	if Input.is_action_just_pressed("shoot"):
		var velocity = (global_position - get_global_mouse_position()).normalized() * -100
		var pos = global_position
		
		#get_tree().get_first_node_in_group("world").createBullet(pos,velocity)
		
	
	
	rotation = (get_global_mouse_position() - global_position).angle() + deg_to_rad(90)
	
	
	
#	if (secondsUntilNextShot > -1):
#		secondsUntilNextShot -= delta 
#
#	if Input.is_action_pressed("shoot") && secondsUntilNextShot <= 0 && params.bulletsPerShot > 0:
#		#shoot()
#		secondsUntilNextShot = 1.0/params.fireRate
#	elif secondsUntilReload < 0:
#		if secondsUntilNextReload < 0 && bulletsLeft < params.maxAmmo:
#			bulletsLeft += 1
#			secondsUntilNextReload = 1.0/params.reloadPerSecond
#
#	params.remainingAmmo = bulletsLeft
#
#	pass
	
	
	
	

var deadZone = 100

func _input(event : InputEvent) -> void:
	return
	if event is InputEventMouseMotion:
		var _target = event.position - get_viewport().size * 0.5
		if _target.length() < deadZone:
			$Node2D.position = Vector2(0,0)
		else:
			position = _target.normalized() * (_target.length() - deadZone) * 0.5
		
		prints("real target " , _target)
		prints("real pos ", _target.normalized() * (_target.length() - deadZone) * 0.5)
		
