extends CharacterBody2D

var health = 10

var dumbFrames = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	$snakeBody/AnimatedSprite2D.play("exist")
	
	
	pass # Replace with function body.

var speed = 100
var accel = 6
var maxAccel = 60

var id = 0

var lastTime = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	
	set_multiplayer_authority(int($targetId.text))
	
	
	pass

func _physics_process(delta):
	
	$snakeBody.rotation = velocity.angle()
	
	if dumbFrames > 0:
		dumbFrames -= 1
		move_and_slide()
		
		return
	
	if is_multiplayer_authority():
		accel = move_toward(accel,maxAccel, 60 * delta) 
		
		if Time.get_ticks_msec() > lastTime + 100:
			$NavigationAgent2D.set_target_position(Globals.player.position)
			lastTime = Time.get_ticks_msec()
		
		var dir = to_local($NavigationAgent2D.get_next_path_position()).normalized()
		
		velocity = lerp(velocity,dir * speed,accel * delta)
		
		if global_position.distance_to(Globals.player.global_position) < 160:
			$AnimationPlayer.play("attack")
		
		move_and_slide()
	

func takeDamage(dir,knockBack,damage):
	
	health -= damage
	
	velocity += knockBack * dir
	
	if health < 0:
		die(dir)
	

func damagePlayer():
	if is_multiplayer_authority():
		Globals.player.takeDamage(global_position.direction_to(Globals.player.global_position).normalized(),-400,10)
	

func setTarget(id):
	$targetId.text = str(id)
	set_multiplayer_authority(id)

func die(dir,isWorld = false):
	
	if !isWorld:
		Globals.world.killSnake(id,dir)
	
	var particles = get_node_or_null("deathParticles")
	
	if particles != null:
		remove_child(particles)
		get_parent().add_child(particles)
		particles.global_position = global_position
		particles.rotation = dir.angle()
		particles.restart()
	
	queue_free()
	
	pass
