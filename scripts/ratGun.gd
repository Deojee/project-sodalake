extends Node2D



# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func setType(type):
	
	params = (gun_library.getAttributes(type) as gun_attributes)
	
	$Sprite2D.texture = params.gunTexture
	$Sprite2D.offset = params.texOffset
	
	
	

func getRange():
	return params.bullet.range

var params : gun_attributes #= Globals.gunParams
var rotationSpeed = 10
var secondsUntilNextShot = 0
var bloom = 0
var shootThreshHold = 10

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
		get_parent().recoil(dir,params)
		
		#get ready for next shot
		
		bloom = min(params.bloomMax,bloom + params.bloom)
		
		
	
	
#	Globals.timeTillNextShot = secondsUntilNextShot
#	Globals.maxTimeTillNextShot = 1.0/params.fireRate
#	Globals.gunInaccuracyTotal = params.bulletSpread + bloom
#
#	if Globals.avatar != null:
#		Globals.avatar.setGunRotation(rotation,$Sprite2D.flip_v)
	

var waitingForBloomCooldown = false

func shouldShoot(targetPos,desireToShoot):
	
	if bloom < 0.1:
		waitingForBloomCooldown = false
	if bloom > 25 or bloom > params.bloomMax - 1:
		waitingForBloomCooldown = true
	
	var aimDifferenceDegrees = Vector2.RIGHT.rotated(rotation).angle_to(targetPos-global_position)
	
	var distanceToTarget = (targetPos-global_position).length()
	
	#the value of how much we like shooting
	var value = 0
	
	var dir = (targetPos - global_position).normalized()
	var pos = (dir * params.length)
	
	$wallCheck.global_rotation = 0
	$wallCheck.target_position = pos
	$wallCheck.force_raycast_update()
	
	#discourage shooting into walls
	if $wallCheck.is_colliding():
		value -= 5
	
	#discourage shooting until bloom is at 0
	if waitingForBloomCooldown:
		value -= 3 + bloom/2
	
	#encourage shooting if your target is unreasonably close
	if distanceToTarget < params.bullet.range * 0.2:
		value += 3
	
	var totalSpread = (params.bulletSpread + bloom)/2
	
	#encourage shooting if your gun is more pointed at the target
	if aimDifferenceDegrees < totalSpread:
		value += lerp(5,1,aimDifferenceDegrees/totalSpread)
	
	value *= desireToShoot
	
	return value > shootThreshHold
	

func isShootingIntoWall():
	if params.bullet.piercing:
		return false
	
	var dir = (get_global_mouse_position() - global_position).normalized()
	var pos = (dir * params.length)
	
	$wallCheck.global_rotation = 0
	$wallCheck.target_position = pos
	$wallCheck.force_raycast_update()
	
	return $wallCheck.is_colliding()
	




