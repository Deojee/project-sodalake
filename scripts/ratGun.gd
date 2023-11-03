extends Node2D



# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func setType(type):
	self.type = type
	params = (gun_library.getAttributes(type) as gun_attributes)
	
	$Sprite2D.texture = params.gunTexture
	$Sprite2D.offset = params.texOffset
	

var type = ""

func getType():
	return type

func getRange():
	return params.bullet.range

var params : gun_attributes #= Globals.gunParams

var secondsUntilNextShot = 0
var bloom = 0
var shootThreshHold = 10

var lerpRotationSpeed = 2
var staticRotationSpeed = 15

const RAT_INNACURACY = 5

var gunRotVelocity = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	
	pass

func aimAtTarget(targetPos:Vector2,delta,desireToShoot):
	
	var targetAngle = (targetPos - global_position).angle()
	
#	rotation = lerp_angle(rotation, targetAngle, lerpRotationSpeed * delta) # + deg_to_rad(90)
#
	var aimDifferenceDegrees = rad_to_deg(Vector2.RIGHT.rotated(rotation).angle_to(targetPos-global_position))
#	#print(aimDifferenceDegrees)
#	if abs(aimDifferenceDegrees) < (staticRotationSpeed * delta):
#
#		rotation = targetAngle
#	else:
#		rotate(deg_to_rad(staticRotationSpeed * delta * sign(aimDifferenceDegrees)))
	
	
	var p = 1.2
	var p2 = 0.2
	
	if sign(gunRotVelocity) != sign(aimDifferenceDegrees) and abs(gunRotVelocity) > 1 and abs(gunRotVelocity * 4) > abs(aimDifferenceDegrees):
		gunRotVelocity += -p2 * gunRotVelocity
	else:
		gunRotVelocity += aimDifferenceDegrees * p
	
	rotation_degrees += gunRotVelocity * delta
	#print(gunRotVelocity)
	
	
	rotation = Vector2.RIGHT.rotated(rotation).angle()
	$Sprite2D.flip_v = false
	if (rotation > deg_to_rad(90) or rotation < deg_to_rad(-90)):
		$Sprite2D.flip_v = true
	
	var shouldShoot = shouldShoot(targetPos,desireToShoot)
	
	if (secondsUntilNextShot > -1):
		secondsUntilNextShot -= delta 
	if !shouldShoot || Globals.paused:
		bloom = max(0,bloom - params.bloomDecay * delta)

	if shouldShoot && secondsUntilNextShot <= 0 && !isShootingIntoWall():
		
		#we divide firerate by 2 to make the rats shoot slower
		var adjustedFireRate = params.fireRate
		if adjustedFireRate > 20:
			pass
		elif adjustedFireRate > 10:
			adjustedFireRate *= 0.8
		elif adjustedFireRate > 5:
			adjustedFireRate *= 0.6
		else:
			adjustedFireRate *= 0.3
		
		secondsUntilNextShot = 1.0/params.fireRate * 1.5
		
		
		#do all bullet math
		var dir = Vector2.RIGHT.rotated(rotation)
		var pos = global_position + (dir * params.length)
		var offset = params.bulletSpread + bloom + RAT_INNACURACY
		offset *= randf() - 0.5
		dir = dir.rotated(deg_to_rad(offset))
		
		#create the bullet
		params.createBulletsLambda.call(pos,dir)
		
		#have the player recoil
		get_parent().recoil(dir,params)
		gunRotVelocity += params.recoil * randf_range(-1,1) * 0.2
		
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
	
	var aimDifferenceDegrees = rad_to_deg(Vector2.RIGHT.rotated(rotation).angle_to(targetPos-global_position))
	
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
	
	var totalSpread = (params.bulletSpread + bloom + RAT_INNACURACY)/2 
	
	#encourage shooting if your gun is more pointed at the target
	if aimDifferenceDegrees < totalSpread:
		value += lerp(5,1,aimDifferenceDegrees/totalSpread)
		#print(lerp(5,1,aimDifferenceDegrees/totalSpread))
	
	
	
	value *= desireToShoot
	#print(value)
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
	




