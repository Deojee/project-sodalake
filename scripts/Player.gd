extends CharacterBody2D

const SPEED = 300
const ACCELERATION = 10
const DECCELERATION = 20

var dashDistance = 120
var dashSpeed = 1800
var dashStart = Vector2.ZERO
var isDashing = false
var dashDirection = Vector2.ZERO

var DASHCOOLDOWN = 0.1 #seconds
var dashWait = 0.2
var MAXDASHES = 2
var dashes = 2
var DASHRECHARGE = 0.9 #seconds
var dashRechargeProgress = 0 #seconds

var avatar

var holdingWeapon = true
var nonsense = false
var health = 100

var dead = true

func _ready():
	
	$debug.text = str(Globals.multiplayerId)
	
	
	
	Globals.player = self
	

func _physics_process(delta):
	
	if dashes < MAXDASHES:
		dashRechargeProgress += delta
		if dashRechargeProgress >= DASHRECHARGE:
			dashes += 1
			dashRechargeProgress = 0
	
	
	
	if dead:
		Globals.playerIsDead = true
		
		holdingWeapon = false
		
		updateAnimation(velocity,dead)
		updateAvatar()
		
		Globals.playerHealth = health
		Globals.playerDashes = dashes
		Globals.dashRechargePercet = dashRechargeProgress/DASHRECHARGE
		Globals.dashCool = dashWait/DASHCOOLDOWN
		
		return
	
	if Globals.resetting || Globals.commandLineOpen:
		updateAnimation(velocity,dead)
		updateAvatar()
		return
	
	
	dashWait = max(dashWait-delta,-1)
	
	var targetVelocity = Vector2()
	if Input.is_action_pressed("right"):
		targetVelocity.x += 1
	if Input.is_action_pressed("left"):
		targetVelocity.x -= 1
	if Input.is_action_pressed("down"):
		targetVelocity.y += 1
	if Input.is_action_pressed("up"):
		targetVelocity.y -= 1
	
	updateAnimation(targetVelocity,dead)
	
	if Input.is_action_just_pressed("dash") and dashWait <= 0 and dashes > 0:
		dashes -= 1
		dashDirection = targetVelocity # get_global_mouse_position()-global_position
		if dashDirection != Vector2.ZERO:
			dashStart = global_position
			isDashing = true
			
	
	# Input handling
	if !isDashing:
		#targetVelocity = targetVelocity.rotated((global_position-get_global_mouse_position()).angle() - deg_to_rad(90))
		
		targetVelocity *= SPEED
		
		if (targetVelocity != Vector2.ZERO):
			velocity = lerp(velocity,targetVelocity,delta * ACCELERATION)
		else:
			velocity = lerp(velocity,targetVelocity,delta * DECCELERATION)
		
		move_and_slide()
	else:
		velocity = dashDirection.normalized() * dashSpeed
		var dashDistanceTraveled = (dashStart-global_position).length()
		
		if move_and_slide() || dashDistanceTraveled > dashDistance:
			isDashing = false
			dashWait = DASHCOOLDOWN
			velocity = velocity.normalized() * SPEED
			Globals.world.createDashAttack(global_position,-dashDirection,dashDistanceTraveled,Globals.multiplayerId)
		
	
	updateAvatar()
	updateZIndex()
	$AnimatedSprite2D.material.set_shader_parameter("bloodAmount", 1.0 - float(Globals.playerHealth)/float(Globals.maxPlayerHealth))
	
	Globals.playerHealth = health
	Globals.playerDashes = dashes
	Globals.dashRechargePercet = dashRechargeProgress/DASHRECHARGE
	Globals.dashCool = dashWait/DASHCOOLDOWN
	

#makes the character appear above or below tiles depending on if it is above or below them.
func updateZIndex():
	if $shouldRaiseZIndex.is_colliding():
		$AnimatedSprite2D.z_index = 4
	elif $shouldLowerZIndex.is_colliding():
		$AnimatedSprite2D.z_index = 1



func updateAnimation(vel,isDead):
	
	if isDead:
		$AnimatedSprite2D.speed_scale = 1
		$walkAnimations.play("RESET")
		if $AnimatedSprite2D.animation != StringName("die"):
			$AnimatedSprite2D.play("die")
		
	else:
		if $AnimatedSprite2D.animation == StringName("die"):
			$AnimatedSprite2D.play("walkHorizontal")
		
		if vel.x == 0 && vel.y == 0:
			$walkAnimations.play("RESET")
			$AnimatedSprite2D.speed_scale = 0
		else:
			$walkAnimations.play("bounce")
			$AnimatedSprite2D.speed_scale = 1
		
		if vel.x < 0:
			$AnimatedSprite2D.flip_h = false
		elif vel.x > 0:
			$AnimatedSprite2D.flip_h = true
		
		if vel.x != 0:
			$AnimatedSprite2D.play("walkHorizontal")
		else:
			if vel.y > 0:
				$AnimatedSprite2D.play("walkDown")
			elif vel.y < 0:
				$AnimatedSprite2D.play("walkUp")
		
	
	if avatar != null:
		avatar.updateAnimation(vel,isDead)
	
	pass

func updateAvatar():
	if avatar != null:
		avatar.position = position
		

var gunPath = preload("res://scenes/gun.tscn")
func pickUpGun(type):
	if holdingWeapon:
		return
	
	var newGun = gunPath.instantiate()
	newGun.setType(type)
	
	add_child(newGun)
	
	holdingWeapon = true
	
	$gunPickUp.play()
	

func takeParamDamage(dir,projectile):
	
	if projectile is bullet_attributes:
		health -= projectile.damage
		velocity += dir.normalized() * projectile.knockback
	elif projectile is gun_attributes:
		health -= projectile.throwDamage
	else:
		return
	
	Globals.playerHealth = health
	
	if health <= 0:
		if !dead:
			Globals.world.died()
		dead = true
	
	#print(health)
	

func takeDamage(dir,knockback,damage,shooterId):
	
	if dead:
		return
	
	health -=damage
	velocity += dir.normalized() * knockback
	
	avatar.hurt()
	$hurtAnimPlayer.play("hurt")
	
	Globals.world.createHurt(global_position + Vector2(randf_range(-10,10),randf_range(-20,-35)),damage)
	Globals.world.createBloodSplatter(global_position,dir,damage,knockback,"shot")
	Globals.playerHealth = health
	
	if health <= 0:
		if !dead:
			Globals.world.died(shooterId)
			Globals.deaths += 1
		dead = true
		Globals.playerIsDead = true
	
	#print(health)
	

func resetStart():
	
	#getting rid of your gun
	var gun = get_node_or_null("gun")
	if gun != null:
		gun.queue_free()
	for child in get_children():
		if child.is_in_group("gun"):
			child.queue_free()
	
	avatar.rotation = 0
	$Icon.rotation = 0
	
	health = Globals.maxPlayerHealth
	
	Globals.resetting = true
	holdingWeapon = false
	dead = false
	

func resetEnd():
	resetStart()
	
	Globals.resetting = false
	

func goToPosition(pos):
	
	
	resetStart()
	updateAvatar()
	
	var tween = get_tree().create_tween()
	tween.tween_property(self,"position", position, 1)
	tween.tween_property(self,"position", pos, 2).set_ease(Tween.EASE_IN_OUT)
	tween.tween_callback(resetEnd)
	

func recoil(dir,gun : gun_attributes):
	velocity -= dir.normalized() * gun.recoil


