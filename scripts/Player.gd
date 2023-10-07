extends CharacterBody2D

const SPEED = 400
const SPRINT_SPEED = 700
const ACCELERATION = 10
const DECCELERATION = 20

const MAX_SPRINT = 1
const SPRINT_REGEN_RATE = 0.5 #amount per second
const SPRINT_DELAY = 0.3 #delay after sprint is over in seconds
var sprint_meter = MAX_SPRINT
var delay_timer = 0
var is_sprinting = false

var avatar


var nonsense = false

func _physics_process(delta):
	
	if not is_sprinting:
		if delay_timer >= SPRINT_DELAY: 
			sprint_meter = min(sprint_meter + SPRINT_REGEN_RATE * delta, MAX_SPRINT)
		
	
	
	# Input handling
	var targetVelocity = Vector2()
	if Input.is_action_pressed("right"):
		targetVelocity.x += 1
	if Input.is_action_pressed("left"):
		targetVelocity.x -= 1
	if Input.is_action_pressed("down"):
		targetVelocity.y += 1
	if Input.is_action_pressed("up"):
		targetVelocity.y -= 1
		
	# Sprinting
	
	if targetVelocity != Vector2.ZERO && getSprintInput() && sprint_meter > 0:
		targetVelocity *= SPRINT_SPEED
		is_sprinting = true
		sprint_meter = max(sprint_meter - delta, 0)
		delay_timer = 0
	else:
		targetVelocity *= SPEED
		
		is_sprinting = false
		if delay_timer < SPRINT_DELAY:
			delay_timer = min(delay_timer + delta, SPRINT_DELAY)
		
	
	if (targetVelocity != Vector2.ZERO):
		velocity = lerp(velocity,targetVelocity,delta * ACCELERATION)
	else:
		velocity = lerp(velocity,targetVelocity,delta * DECCELERATION)
	
	move_and_slide()
	
	
	
	$ProgressBar.value = sprint_meter
	$ProgressBar.max_value = MAX_SPRINT
	
	updateAvatar()
	
	
	


var sprintToggle = false
func getSprintInput():
	if Input.is_action_just_pressed("sprint"):
		sprintToggle = true
	if Input.is_action_just_released("sprint"):
		sprintToggle = false
	
	if Input.is_action_pressed("sprint") && sprint_meter >= MAX_SPRINT:
		sprintToggle = true
	
	if sprint_meter == 0:
		sprintToggle = false
	
	return sprintToggle
	

func updateAvatar():
	if avatar != null:
		avatar.position = position
		

