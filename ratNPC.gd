extends CharacterBody2D

var id = 1 #the target player's id

var ratId = 1

var wanderSpeed = 1
var corneredSpeed = 2
var attackSpeed = 1.3
var chaseSpeed = 1.3
var fleeSpeed = 2

var baseSpeed = 200

var accel = 8

var minDistance = 0
var maxDistance = 0
var runClockwise = true

var sightDistance = 500

@export var health = 35
@export var lastHurtDir = Vector2.ZERO

var lastDodgeTime = -1000
var dodgeWaitMsecs = 1000
var dodgeVelocity = 2000

func setType(pos,numRatsSpawned, type):
	$gun.setType(type)
	position = pos
	
	name = "rat" + str(numRatsSpawned)
	
	

func getGunName():
	return $gun.type

# Called when the node enters the scene tree for the first time.
func _ready():
	
	$AnimatedSprite2D.play("default")
	
	if !Globals.is_server:
		return
	
	runClockwise = randf() > 0.5
	
	
	var range = $gun.getRange()
	minDistance = range * 0.3
	maxDistance = range * 0.6
	
	
	pass # Replace with function body.



enum STATES {WANDER, CORNERED, ATTACKING, CHASING}

var state = STATES.WANDER

var lastNavUpdateTime = -1000
var prevTargetLastShotDir 
var wasCorneredLastFrame = false
var targetPosition = Vector2.ZERO
var targetLastShotDir = Vector2.ZERO
var targetJustShot = false
var hasLineOfSight
var dir = Vector2.ZERO


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	
	if health <= 0:
		die(lastHurtDir)
	
	if !Globals.is_server:
		return
	
	updateTargetVariables()
	updateHasLineOfSight(targetPosition)
	setMinMaxDistance(targetPosition)
	var speed = 0
	
	#the method with which the rat will move. Changes depending on what the rat is doing.
	match state:
		STATES.WANDER:
			wander()
			speed = wanderSpeed
			$gun.aimAtTarget(global_position+dir*10,delta,0)
			#print("wander")
		STATES.CHASING:
			chase()
			if hasDirectLineOfSight(targetPosition):
				$gun.aimAtTarget(targetPosition,delta,1)
			else:
				$gun.aimAtTarget(global_position+dir*10,delta,0)
			speed = chaseSpeed
			#print("chase")
		STATES.ATTACKING:
			attack()
			
			$gun.aimAtTarget(targetPosition,delta,3)
			speed = attackSpeed
			#print("attacking")
		STATES.CORNERED:
			cornered()
			$gun.aimAtTarget(targetPosition,delta,5)
			speed = corneredSpeed
			#print("corn")
	
	
	
	$wallDetects.rotation = (global_position - targetPosition).angle() + deg_to_rad(90)
	
	speed *= baseSpeed
	pass
	
	velocity = lerp(velocity,dir * speed,accel * delta)
	
	#if Input.is_action_pressed("throw"):
	move_and_slide()
	
	#force the rat away from other rats
	for area in $ratAvoidanceArea.get_overlapping_areas():
		velocity += 500 * (global_position - area.global_position).normalized() * delta
		
		if state == STATES.ATTACKING:
			runClockwise =  (global_position - targetPosition).angle_to(area.global_position - targetPosition) < 0
			
		
	
	#coax the rat into not geting stuck on walls
	$dir.rotation = dir.angle()
	if $dir/antiStuckOnCornerCast.is_colliding():
		velocity += dir.rotated(deg_to_rad(45)) * -2000 * delta
	if $dir/antiStuckOnCornerCast2.is_colliding():
		velocity += dir.rotated(deg_to_rad(-45)) * -2000 * delta
	
	$AnimatedSprite2D.flip_h = dir.x < 0
	
	chooseTarget()
	bleed()
	
	
	


var lastBled = -1000
func bleed():
	
	if health > Globals.maxPlayerHealth * 0.9:
		return
	
	var bleedRate = (1.0 - float(health)/float(Globals.ratMaxHealth)) * 10
	
	
	if lastBled + (1.0/bleedRate) * 1000 < Time.get_ticks_msec():
		lastBled = Time.get_ticks_msec()
		Globals.world.createBloodSplatter(global_position,Vector2.UP,(1.0 - float(health)/float(Globals.maxPlayerHealth)) * 2,0)
	
	pass


#makes the rat try to be closer to you if it's below you so it will not leave the screen
func setMinMaxDistance(targetPosition):
	
	var dirToTarget = abs(rad_to_deg((global_position - targetPosition).angle()))
	var dif = min(abs(dirToTarget - 0),abs(dirToTarget - 180))
	
	var range = $gun.getRange()
	var multiplier = lerp(1.0,0.5,dif/90.0)
	
	minDistance = range * 0.3 * multiplier
	maxDistance = range * 0.6 * multiplier
	
	
	pass


"""
has the rat circle the player and shoot at them.
Can cause state to change to CORNERED or CHASE
"""
func attack():
	var wallCounterClockwise = $wallDetects/runClockwise.is_colliding()
	var wallClockwise = $wallDetects/runCounterClockwise.is_colliding()
	
	var dirToTarget = (global_position - targetPosition).normalized()
	var distanceToPlayer = (global_position - targetPosition).length()
	
	if distanceToPlayer > minDistance:
		
		if runClockwise and wallClockwise:
			runClockwise = false
		elif !runClockwise and wallCounterClockwise:
			runClockwise = true
		
		#set runclockwise to away from the last angle the target shot
		if targetJustShot:
			runClockwise = dirToTarget.angle_to(targetLastShotDir) < 0
			
		
		dir = dirToTarget.rotated(deg_to_rad(90 if runClockwise else -90))
		
		#this code is so that the rat will try to be between the min and max distance from the player
		var middleDistance = (minDistance + maxDistance)/2
		#0-1. 1 means very far from the middle, 0 mean on the middle
		var distToMidDistance = (distanceToPlayer-middleDistance)/(middleDistance-minDistance)
		var skewToMid = lerp(0.0,deg_to_rad(45),distToMidDistance)
		dir = dir.rotated((skewToMid if runClockwise else -skewToMid))
		#print((distToMidDistance))
		#print(rad_to_deg(skewToMid))
		
		#if they shot in my general direction,dodge
		if targetJustShot and Time.get_ticks_msec() > lastDodgeTime + dodgeWaitMsecs:
			lastDodgeTime = Time.get_ticks_msec()
			var degreesOff = abs(dirToTarget.angle_to(targetLastShotDir))
			#print(rad_to_deg(degreesOff))
			if degreesOff < deg_to_rad(20):
				velocity += dir * dodgeVelocity
		
	else:
		dir = dirToTarget.rotated(deg_to_rad(45 if runClockwise else -45))
	
	
	#check if cornered
	var wallBehindUs = $wallDetects/cornered.is_colliding()
	var cornered = wallBehindUs  or (wallCounterClockwise and wallClockwise)
	
	if cornered:
		state = STATES.CORNERED
		pass
	
	if distanceToPlayer > maxDistance or !hasDirectLineOfSight(targetPosition):
		state = STATES.CHASING
	
	
	

"""
Causes the rat to try to escape corners by following walls until it is not cornered.
Can switch to attack.
"""
func cornered():
	var dirToTarget = (global_position - targetPosition).normalized()
	
	if not wasCorneredLastFrame:
		runClockwise = !runClockwise
	
	wasCorneredLastFrame = true
	
	dir =  -dirToTarget.rotated(deg_to_rad(45 if runClockwise else -45))
	
	var corneredCast = $wallDetects/cornered as RayCast2D
	var hasCollided = false
	
	corneredCast.global_rotation = 0
	
	#basically, check with directions have walls
	for i in 4:
		corneredCast.target_position = corneredCast.target_position.rotated(deg_to_rad(90 if runClockwise else -90))
		corneredCast.force_raycast_update()
		
		if corneredCast.is_colliding():
			dir =  corneredCast.target_position.rotated(deg_to_rad(110 if runClockwise else -110))
			hasCollided = true
		else:
			
			if hasCollided:
				break
		
	
	dir = dir.normalized()
	
	corneredCast.rotation = 0
	corneredCast.target_position = Vector2(0,-corneredCast.target_position.length())
	
	if !hasCollided:
		wasCorneredLastFrame = false
		state = STATES.ATTACKING
	
	pass

#goes in the direction the player was last seen
"""
Causes the rat to pathfind to the last place the player was seen
Can switch to attack or wander
"""
func chase():
	
	var distanceToPlayer = (global_position - targetPosition).length()
	
	if Time.get_ticks_msec() > lastNavUpdateTime + 100 and hasLineOfSight:
		$NavigationAgent2D.set_target_position(targetPosition)
		lastNavUpdateTime = Time.get_ticks_msec()
	
	dir = to_local($NavigationAgent2D.get_next_path_position()).normalized()
	
	if velocity.length() < 10:
		velocity += dir * 100
	
	if distanceToPlayer < maxDistance and hasDirectLineOfSight(targetPosition):
		state = STATES.ATTACKING
	
	if !hasLineOfSight and position.distance_to($NavigationAgent2D.get_final_position()) < 10:
		state = STATES.WANDER
	


"""
Causes the rat to go to random positions on the map.
can switch to chase.
"""
#makes the rat go to a random position on the map if they chased the player and didn't find them.
func wander():
	
	if position.distance_to($NavigationAgent2D.get_final_position()) < 10:
		
		if Globals.pickupSpawner == null or $NavigationAgent2D == null:
			return
		
		$NavigationAgent2D.set_target_position(Globals.pickupSpawner.getRandomPosition())
		lastNavUpdateTime = Time.get_ticks_msec()
	
	dir = to_local($NavigationAgent2D.get_next_path_position()).normalized()
	
	#deciding if we should change to another state.
	if hasLineOfSight:
		state = STATES.CHASING
		$NavigationAgent2D.set_target_position(targetPosition)
	
	pass

#changes the curent target if it needs to
"""
sets the target id to the nearest player
later should be updated to only target players it can see
"""
func chooseTarget():
	var avatars =  Globals.world.getLivingAvatars()
	if !avatars.size() < 1:
		
		var shortestDistance = global_position.distance_to(avatars[0].global_position)
		var target = avatars[0]
		for avatar in avatars:
			var distance = global_position.distance_to(avatar.global_position) 
			if distance < shortestDistance and distance < sightDistance and hasDirectLineOfSight(avatar.global_position):
				target = avatar
				shortestDistance = distance
				
		id = target.getId()

"""
called by other classes. Causes the rat to take damage.
"""
func takeDamage(dir,knockback,damage):
	if !Globals.is_server:
		return
	
	health -= damage
	
	velocity += knockback * dir
	
	
	pass


var alreadyDied = false
"""
makes the rat die and drop their weapon. Will be called on all clients.
"""
func die(dir):
	
	if alreadyDied:
		return
	
	if Globals.is_server:
		Globals.world.createGunPickup(global_position,getGunName())
	
	var particles = get_node_or_null("deathParticles")
	
	if particles != null:
		remove_child(particles)
		var parent = get_parent()
		
		if parent != null:
			parent.add_child(particles)
			particles.global_position = global_position
			particles.rotation = dir.angle()
			particles.restart()
	
	queue_free()

func recoil(dir,gun : gun_attributes):
	velocity -= dir.normalized() * gun.recoil

"""
updates the target's position,the direction they last shot in, and wether or not they just shot
"""
func updateTargetVariables():
	for avatar in Globals.world.getLivingAvatars():
		if avatar.name == str(id):
			targetPosition = avatar.global_position
			targetLastShotDir = Vector2.RIGHT.rotated( avatar.getLastShotDir() )
			
			if prevTargetLastShotDir != targetLastShotDir:
				targetJustShot = true
				#print("target just shot!")
			else:
				targetJustShot = false
			prevTargetLastShotDir = targetLastShotDir

#globalPosition
"""
updates all variables related to line of site
"""
func updateHasLineOfSight(toPos):
	var returnVal = false
	for cast in $playerDetectCasts.get_children():
		
		#check if we can even see this cast, if we can't, skip it
		cast.target_position = global_position -  cast.global_position
		cast.force_raycast_update()
		if cast.is_colliding():
			continue
		
		cast.target_position = toPos -  cast.global_position
		
		cast.force_raycast_update()
		
		if !cast.is_colliding():
			
			returnVal = true
		
	
	hasLineOfSight = returnVal

"""
checks if the rat has direct line of sight to the player
"""
func hasDirectLineOfSight(toPos):
	var cast = $playerDetectCasts/losCheck
	
	cast.target_position = toPos -  cast.global_position
	
	cast.force_raycast_update()
	
	return !cast.is_colliding()
	
