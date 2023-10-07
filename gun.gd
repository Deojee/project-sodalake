extends Node2D

var bulletPath = preload("res://bullet.tscn")
var fogPath = preload("res://fog.tscn")
var camera

# Called when the node enters the scene tree for the first time.
func _ready():
	camera = $Camera2D
	
	var fogDensity = 6
	
	var numCasts = 120
	
	for i in numCasts:
		
		
		var raycast = RayCast2D.new()
		raycast.enabled = true
		raycast.target_position = Vector2(1000, 0)
		
		raycast.target_position = raycast.target_position.rotated((float(i)/float(numCasts))*2*PI)
		
		$rayCastHolder.add_child(raycast)
		
		for o in fogDensity:
			var fog = fogPath.instantiate()
			#fog.visible = false
			raycast.add_child(fog)
			
			
			
			#fog.global_position = fogPosition
			#fogPosition = fogPosition.move_toward(global_position,-fogDisance)
			
		
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	
	
	var fogDisance = 80
	
	for ray in $rayCastHolder.get_children():
		
		ray = ray as RayCast2D
		var fogPosition = ray.get_collision_point() as Vector2
		for fog in ray.get_children():
			
			if ray.is_colliding():
				fog.scale = lerp(fog.scale,Vector2(1,1),1*delta)
				fog.global_position = fogPosition
				fogPosition = fogPosition.move_toward(global_position,-fogDisance)
			else:
				fog.scale = lerp(fog.scale,Vector2(0,0),1*delta)
			
		
		
		
	
	pass

func _physics_process(delta):
	
	if Input.is_action_just_pressed("shoot"):
		var velocity = (global_position - get_global_mouse_position()).normalized() * -100
		var pos = global_position
		
		get_tree().get_first_node_in_group("world").createBullet(pos,velocity)
		
	
	
	
	#setCameraPosition()
	


func setCameraPosition():
	
	var minMouseDistance = 100
	var maxMouseDistance = 500
	var interpolate = 0.2
	
	
	var adjustedMousePosition = get_global_mouse_position().move_toward(global_position,minMouseDistance)
	
	var distanceToMouse = (adjustedMousePosition - global_position).length()
	
	if distanceToMouse > maxMouseDistance:
		adjustedMousePosition.move_toward(global_position,distanceToMouse - maxMouseDistance)
	
	
	
	camera.global_position = camera.global_position.lerp(adjustedMousePosition,interpolate)
	
	
