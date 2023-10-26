extends Node2D


func _enter_tree():
	set_multiplayer_authority(name.to_int())
	
	if is_multiplayer_authority():
		get_tree().get_first_node_in_group("player").avatar = self
		$StaticBody2D/CollisionShape2D.disabled = true
		Globals.avatar = self
		
	
	visible = !is_multiplayer_authority()
	visible = true

# Called when the node enters the scene tree for the first time.
func _ready():
	$debug.text = name
	
	pass # Replace with function body.

func isDead():
	return $deadLabel.text == "true"

func setType(type):
	$gunType.text = type

#indicates whether or not the die animation has been played since any other animation has been played.
var shouldDie = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var params = gun_library.getAttributes($gunType.text)
	
	if params != null:
		$gun.texture = params.gunTexture
		$gun.offset = params.texOffset
		
	
	if is_multiplayer_authority():
		$nameTag.text = Globals.nameTag
		$deadLabel.text = str(Globals.playerIsDead)
		$gun.visible = Globals.player.holdingWeapon
		
		$bloodAmount.text = str( 1.0 - float(Globals.playerHealth)/float(Globals.maxPlayerHealth))
		
		$AnimatedSprite2D.material.set_shader_parameter("bloodAmount", $bloodAmount.text.to_float())
	else:
		if $AnimatedSprite2D.animation != StringName("die"):
			$AnimatedSprite2D.play($AnimatedSprite2D.animation)
			shouldDie = true
		else:
			if !shouldDie:
				$AnimatedSprite2D.play("die")
				shouldDie = false
			
		
		$StaticBody2D/CollisionShape2D.set_deferred("disabled",isDead())
		
		$AnimatedSprite2D.material.set_shader_parameter("bloodAmount", $bloodAmount.text.to_float())
		
	
	if isDead():
		$AnimatedSprite2D.speed_scale = 1
	
	
	
	updateZIndex()
	$invincibility.emitting = Globals.invincible
	
	pass

#makes the character appear above or below tiles depending on if it is above or below them.
func updateZIndex():
	if $shouldRaiseZIndex.is_colliding():
		$AnimatedSprite2D.z_index = 4
	elif $shouldLowerZIndex.is_colliding():
		$AnimatedSprite2D.z_index = 1


func setGunRotation(rot,flipV):
	$gun.flip_v = flipV
	$gun.rotation = rot
	

func getName():
	return $nameTag.text

func getId():
	return int(str(name))

func hurt():
	$hurtAnimPlayer.play("hurt")

func setLastShotDir(dir:Vector2):
	$lastShotDir.rotation = dir.angle()

#as a vector
func getLastShotDir():
	return $lastShotDir.rotation

var crownTween
func setCrown(on):
	if crownTween:
		crownTween.kill()
	crownTween = create_tween()
	
	if on:
		crownTween.tween_property($WinnerCrown,"modulate", Color(1,1,1,1), 0.5).set_ease(Tween.EASE_OUT)
	else:
		crownTween.tween_property($WinnerCrown,"modulate", Color(1,1,1,0), 2).set_ease(Tween.EASE_IN)
	

func updateAnimation(vel,isDead):
	
	if isDead:
		#print($AnimatedSprite2D.animation)
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
		
	
	
	
