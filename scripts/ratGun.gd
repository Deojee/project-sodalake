extends Node2D



# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func setType(type):
	
	params = (gun_library.getAttributes(type) as gun_attributes)
	
	$Sprite2D.texture = params.gunTexture
	$Sprite2D.offset = params.texOffset
	
	
	if Globals.avatar != null:
		Globals.avatar.setType(type)
	



var params : gun_attributes #= Globals.gunParams
var rotationSpeed = 6
var secondsUntilNextShot = 0
var bloom = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	
	pass

func aimAtTarget(targetPos:Vector2,delta,desireToShoot):
	
	rotation = lerp_angle(rotation, (targetPos - global_position).angle(), rotationSpeed * delta) # + deg_to_rad(90)
	
	$Sprite2D.flip_v = false
	if (rotation > deg_to_rad(90) or rotation < deg_to_rad(-90)):
		$Sprite2D.flip_v = true
	
	var shouldShoot = shouldShoot(targetPos,desireToShoot)
	
	if (secondsUntilNextShot > -1):
		secondsUntilNextShot -= delta 
	if !shouldShoot || Globals.paused:
		bloom = max(0,bloom - params.bloomDecay * delta)

	if shouldShoot && secondsUntilNextShot <= 0 && !isShootingIntoWall():
		
		secondsUntilNextShot = 1.0/params.fireRate
		
		
		#do all bullet math
		var dir = (targetPos - global_position).normalized()
		var pos = global_position + (dir * params.length)
		var offset = params.bulletSpread + bloom
		offset *= randf() - 0.5
		dir = dir.rotated(deg_to_rad(offset))
		
		#create the bullet
		params.createBulletsLambda.call(pos,dir)
		
		#have the player recoil
		Globals.player.recoil(dir,params)
		Globals.avatar.setLastShotDir(dir)
		
		#get ready for next shot
		
		bloom = min(params.bloomMax,bloom + params.bloom)
		
		
	
	
#	Globals.timeTillNextShot = secondsUntilNextShot
#	Globals.maxTimeTillNextShot = 1.0/params.fireRate
#	Globals.gunInaccuracyTotal = params.bulletSpread + bloom
#
#	if Globals.avatar != null:
#		Globals.avatar.setGunRotation(rotation,$Sprite2D.flip_v)
	

func shouldShoot(targetPos,desireToShoot):
	
	
	
	
	pass

func isShootingIntoWall():
	if params.bullet.piercing:
		return false
	
	var dir = (get_global_mouse_position() - global_position).normalized()
	var pos = (dir * params.length)
	
	$wallCheck.global_rotation = 0
	$wallCheck.target_position = pos
	$wallCheck.force_raycast_update()
	
	return $wallCheck.is_colliding()
	




