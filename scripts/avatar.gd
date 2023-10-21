extends Node2D


func _enter_tree():
	set_multiplayer_authority(name.to_int())
	
	if is_multiplayer_authority():
		get_tree().get_first_node_in_group("player").avatar = self
		$StaticBody2D/CollisionShape2D.disabled = true
		Globals.avatar = self
		
	
	visible = !is_multiplayer_authority()

# Called when the node enters the scene tree for the first time.
func _ready():
	$debug.text = name
	$nameTag.text = Globals.nameTag
	pass # Replace with function body.

func isDead():
	return $deadLabel.text == "true"

func setType(type):
	$gunType.text = type

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var params = gun_library.getAttributes($gunType.text)
	
	if params != null:
		$gun.texture = params.gunTexture
		$gun.offset = params.texOffset
		
	
	if is_multiplayer_authority():
		$deadLabel.text = str(Globals.playerIsDead)
		$gun.visible = Globals.player.holdingWeapon
		
	
	if isDead():
		$AnimatedSprite2D.speed_scale = 1
	
	pass

func setGunRotation(rot,flipV):
	$gun.flip_v = flipV
	$gun.rotation = rot
	

func getName():
	return $nameTag.text

func getId():
	return int(str(name))

func hurt():
	$hurtAnimPlayer.play("hurt")

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
		
	
	
	
