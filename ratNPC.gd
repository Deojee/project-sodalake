extends CharacterBody2D

var id = 1 #the target player's id

var wanderSpeed = 300
var corneredSpeed = 600
var attackSpeed = 400
var chaseSpeed = 400
var fleeSpeed = 600

var accel = 8

var minDistance = 150
var maxDistance = 250
var runClockwise = true
var health = 50

# Called when the node enters the scene tree for the first time.
func _ready():
	runClockwise = randf() > 0.5
	$gun.setType(gun_library.getRandomGunName())
	
	var range = $gun.getRange()
	minDistance = range/
	
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
	
	if !Globals.is_server:
		return
	
	updateTargetVariables()
	updateHasLineOfSight(targetPosition)
	
	var speed = 0
	
	#the method with which the rat will move. Changes depending on what the rat is doing.
	match state:
		STATES.WANDER:
			wander()
			speed = wanderSpeed
			$gun.aimAtTarget(global_position+dir*10,delta,0)
			print("wander")
		STATES.CHASING:
			chase()
			$gun.aimAtTarget(targetPosition,delta,1)
			speed = chaseSpeed
			print("chase")
		STATES.ATTACKING:
			attack()
			
			$gun.aimAtTarget(targetPosition,delta,3)
			speed = attackSpeed
			print("attacking")
		STATES.CORNERED:
			cornered()
			$gun.aimAtTarget(targetPosition,delta,5)
			speed = corneredSpeed
			print("corn")
	
	
	
	$wallDetects.rotation = (global_position - targetPosition).angle() + deg_to_rad(90)
	
	#speed *= 0.1
	pass
	
	velocity = lerp(velocity,dir * speed,accel * delta)
	
	#force the rat away from other rats
	for area in $ratAvoidanceArea.get_overlapping_areas():
		velocity += 500 * (global_position - area.global_position).normalized() * delta
		
		if state == STATES.ATTACKING:
			runClockwise =  (global_position - targetPosition).angle_to(area.global_position - targetPosition) < 0
			
		
	
	move_and_slide()
	
	chooseTarget()
	



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
		
		#if they shot in my general direction,dodge
		if targetJustShot:
			var degreesOff = abs(dirToTarget.angle_to(targetLastShotDir))
			print(rad_to_deg(degreesOff))
			if degreesOff < deg_to_rad(20):
				velocity += dir * 2000
		
	else:
		dir = dirToTarget.rotated(deg_to_rad(45 if runClockwise else -45))
	
	
	#check if cornered
	var wallBehindUs = $wallDetects/cornered.is_colliding()
	var cornered = wallBehindUs  or (wallCounterClockwise and wallClockwise)
	
	if cornered:
		state = STATES.CORNERED
		pass
	
	if distanceToPlayer > maxDistance or !hasLineOfSight:
		state = STATES.CHASING
	
	
	

func cornered():
	var dirToTarget = (global_position - targetPosition).normalized()
	
	if not wasCorneredLastFrame:
		runClockwise = !runClockwise
	
	wasCorneredLastFrame = true
	
	dir =  -dirToTarget.rotated(deg_to_rad(45 if runClockwise else -45))
	
	var corneredCast = $wallDetects/cornered as RayCast2D
	var hasCollided = false
	
	corneredCast.global_rotation = 0
	
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
	
#	var wallCounterClockwise = $wallDetects/runClockwise.is_colliding()
#	var wallClockwise = $wallDetects/runCounterClockwise.is_colliding()
#	var wallBehindUs = $wallDetects/cornered.is_colliding()
#	var cornered = wallBehindUs  or (wallCounterClockwise and wallClockwise)
#
#	if !wallBehindUs and !wallClockwise and !wallCounterClockwise:
#		wasCorneredLastFrame = false
#		state = STATES.ATTACKING
	
	if !hasCollided:
		wasCorneredLastFrame = false
		state = STATES.ATTACKING
	
	pass

func chase():
	
	var distanceToPlayer = (global_position - targetPosition).length()
	
	if Time.get_ticks_msec() > lastNavUpdateTime + 100 and hasLineOfSight:
		$NavigationAgent2D.set_target_position(targetPosition)
		lastNavUpdateTime = Time.get_ticks_msec()
	
	dir = to_local($NavigationAgent2D.get_next_path_position()).normalized()
	
	if velocity.length() < 10:
		velocity += dir * 100
	
	if distanceToPlayer < maxDistance and hasLineOfSight:
		state = STATES.ATTACKING
	
	if !hasLineOfSight and position.distance_to($NavigationAgent2D.get_final_position()) < 10:
		state = STATES.WANDER
	

func wander():
	
	dir = dir.rotated(sin(Time.get_ticks_msec()/1000) * randf_range(-1,1) + ((sin(Time.get_ticks_msec()/1000)-0.5) * 2) )
	
	#deciding if we should change to another state.
	if hasLineOfSight:
		state = STATES.CHASING
		$NavigationAgent2D.set_target_position(targetPosition)
	
	pass

###changes the curent target if it needs to
func chooseTarget():
	var avatars =  Globals.world.getLivingAvatars()
	if !avatars.size() < 1:
		
		var shortestDistance = global_position.distance_to(avatars[0].global_position)
		var target = avatars[0]
		for avatar in avatars:
			var distance = global_position.distance_to(avatar.global_position) 
			if distance < shortestDistance:
				target = avatar
				shortestDistance = distance
				
			#var tempText = $targetId.text
			#$targetId.text = target.name 
		id = target.getId()

func takeDamage(dir,knockback,damage):
	health -= damage
	
	velocity += knockback * dir
	
	if health < 0:
		die(dir)
	pass

func die(dir):
	queue_free()


func updateTargetVariables():
	for avatar in Globals.world.getLivingAvatars():
		if avatar.name == str(id):
			targetPosition = avatar.global_position
			targetLastShotDir = Vector2.RIGHT.rotated( avatar.getLastShotDir() )
			
			if prevTargetLastShotDir != targetLastShotDir:
				targetJustShot = true
				print("target just shot!")
			else:
				targetJustShot = false
			prevTargetLastShotDir = targetLastShotDir

#globalPosition
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

func hasDirectLineOfSight(toPos):
	var cast = $playerDetectCasts/losCheck
	
	cast.target_position = toPos -  cast.global_position
	
	cast.force_raycast_update()
	
	return !cast.is_colliding()
	
