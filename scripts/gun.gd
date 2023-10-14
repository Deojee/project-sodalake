extends Node2D



# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func setType(type):
	
	params = (gun_library.getAttributes(type) as gun_attributes)
	
	$Sprite2D.texture = params.gunTexture
	$Sprite2D.offset = params.texOffset
	
	bulletsLeft = params.maxAmmo
	
	if Globals.avatar != null:
		Globals.avatar.setType(type)
	

var bulletsLeft #= Globals.gunParams.maxAmmo

var params : gun_attributes #= Globals.gunParams

var secondsUntilNextShot = 0
var bloom = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Globals.avatar != null and params != null:
		Globals.avatar.setType(params.gunName)
	
	pass

func _physics_process(delta):
	
	if Globals.playerIsDead:
		queue_free()
	
	rotation = (get_global_mouse_position() - global_position).angle() # + deg_to_rad(90)
	$Sprite2D.flip_v = false
	if (rotation > deg_to_rad(90) or rotation < deg_to_rad(-90)):
		$Sprite2D.flip_v = true
	
	
	if (secondsUntilNextShot > -1):
		secondsUntilNextShot -= delta 
	if not Input.is_action_pressed("shoot"):
		bloom = max(0,bloom - params.bloomDecay * delta)

	if Input.is_action_pressed("shoot") && secondsUntilNextShot <= 0 && bulletsLeft > 0 && !isShootingIntoWall():
		
		#do all bullet math
		var dir = (get_global_mouse_position() - global_position).normalized()
		var pos = global_position + (dir * params.length)
		var offset = params.bulletSpread + bloom
		offset *= randf() - 0.5
		dir = dir.rotated(deg_to_rad(offset))
		
		#create the bullet
		params.createBulletsLambda.call(pos,dir)
		
		#have the player recoil
		Globals.player.recoil(dir,params)
		
		#get ready for next shot
		secondsUntilNextShot = 1.0/params.fireRate
		bloom = min(params.bloomMax,bloom + params.bloom)
		bulletsLeft -= 1
	elif Input.is_action_just_pressed("throw"):
		throw()
	
	
	Globals.ammo = bulletsLeft
	Globals.timeTillNextShot = secondsUntilNextShot
	Globals.maxTimeTillNextShot = 1.0/params.fireRate
	
	if Globals.avatar != null:
		Globals.avatar.setGunRotation(rotation,$Sprite2D.flip_v)
	

func isShootingIntoWall():
	if params.bullet.piercing:
		return false
	
	var dir = (get_global_mouse_position() - global_position).normalized()
	var pos = (dir * params.length)
	
	$wallCheck.global_rotation = 0
	$wallCheck.target_position = pos
	$wallCheck.force_raycast_update()
	
	return $wallCheck.is_colliding()
	
	

func throw():
	var dir = (get_global_mouse_position() - global_position ).normalized()
	Globals.world.createThrownWeapon(global_position + (dir * 30),dir,params.gunName)
	Globals.player.holdingWeapon = false
	if Globals.avatar != null:
		Globals.avatar.setType("")
	queue_free()
	
	#prints("I just shot. I am: ",Globals.multiplayerId)
	

