extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	setType("pistol")
	pass

func setType(type:String):
	
	print(type)
	
	params = (gun_library.getAttributes(type) as gun_attributes)
	
	
	
	$weaponSprite.texture = params.gunTexture
	$weaponSprite.offset = params.texOffset
	
	$changed.restart()
	
	secondsUntilNextShot = 0
	bloom = 0
	

var shouldShoot = false

func shoot(time : float):
	
	shouldShoot = true
	
	
	
	await get_tree().create_timer(time).timeout
	
	
	#makes it so that the next shot will work.
	secondsUntilNextShot = 0
	shouldShoot = false
	



var params : gun_attributes #= Globals.gunParams
var secondsUntilNextShot = 0
var bloom = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	
	pass

func _physics_process(delta):
	
	$weaponSprite.flip_v = false
	if (rotation > deg_to_rad(90) or rotation < deg_to_rad(-90)):
		$weaponSprite.flip_v = true
	
	rotation = global_position.angle_to_point(Globals.player.global_position)
	
	
	if (secondsUntilNextShot > -1):
		secondsUntilNextShot -= delta 
	if !shouldShoot || Globals.paused:
		bloom = max(0,bloom - params.bloomDecay * delta)

	if shouldShoot && secondsUntilNextShot <= 0:
		
		secondsUntilNextShot = 1.0/params.fireRate
		
		
		#do all bullet math
		var dir = (Vector2.RIGHT.rotated(rotation)).normalized()
		var pos = global_position + (dir * params.length)
		var offset = params.bulletSpread + bloom
		offset *= randf() - 0.5
		dir = dir.rotated(deg_to_rad(offset))
		
		#create the bullet
		
		params.createBulletsLambda.call(pos,dir)
		
		#have the player recoil
		
		
		#get ready for next shot
		
		bloom = min(params.bloomMax,bloom + params.bloom)
		
		
	
	
#	Globals.timeTillNextShot = secondsUntilNextShot
#	Globals.maxTimeTillNextShot = 1.0/params.fireRate
#	Globals.gunInaccuracyTotal = params.bulletSpread + bloom
#
#	if Globals.avatar != null:
#		Globals.avatar.setGunRotation(rotation,$Sprite2D.flip_v)
	




#func isShootingIntoWall():
#	if params.bullet.piercing:
#		return false
#
#	var dir = (get_global_mouse_position() - global_position).normalized()
#	var pos = (dir * params.length)
#
#	$wallCheck.global_rotation = 0
#	$wallCheck.target_position = pos
#	$wallCheck.force_raycast_update()
#
#	return $wallCheck.is_colliding()
#
