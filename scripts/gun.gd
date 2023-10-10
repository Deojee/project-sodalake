extends Node2D


enum State {
	HELD,
	AIRBORNE,
	PICKUP
}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func setType(type):
	
	print(gun_library.getAttributes("pistol"))
	
	params = (gun_library.getAttributes(type) as gun_attributes)
	
	$Sprite2D.texture = params.gunTexture
	$Sprite2D.offset = params.texOffset
	
	bulletsLeft = params.maxAmmo
	


var bulletsLeft #= Globals.gunParams.maxAmmo

var params : gun_attributes #= Globals.gunParams

var secondsUntilNextShot = 0
var bloom = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	
	pass

func _physics_process(delta):
	
	
	
	if Input.is_action_just_pressed("shoot"):
		var velocity = (global_position - get_global_mouse_position()).normalized() * -100
		var pos = global_position
		
		#get_tree().get_first_node_in_group("world").createBullet(pos,velocity)
		
	
	
	rotation = (get_global_mouse_position() - global_position).angle() # + deg_to_rad(90)
	
	
	
	if (secondsUntilNextShot > -1):
		secondsUntilNextShot -= delta 
	if not Input.is_action_pressed("shoot"):
		bloom = max(0,bloom - params.bloomDecay * delta)

	if Input.is_action_pressed("shoot") && secondsUntilNextShot <= 0 && bulletsLeft > 0:
		
		var dir = (global_position - get_global_mouse_position()).normalized()
		
		var pos = global_position + (dir * params.length)
		
		var offset = params.bulletSpread + bloom
		offset *= randf() - 0.5
		
		dir = dir.rotated(deg_to_rad(offset))
		
		params.createBulletsLambda.call(pos,dir)
		
		secondsUntilNextShot = 1.0/params.fireRate
		
		bloom = max(params.bloomMax,bloom + params.bloom)
		
		bulletsLeft -= 1
	
	
	pass
	
	
	
	

