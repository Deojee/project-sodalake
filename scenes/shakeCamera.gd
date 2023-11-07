extends Camera2D

@export var decay = 0.8  # How quickly the shaking stops [0, 1].
@export var max_offset = Vector2(1, 0.75)  # Maximum hor/ver shake base.
@export var max_roll = 0.1  # Maximum rotation in radians (use sparingly).

var shakeTime = 0.0  # time left in seconds
var shakeStrength = 0.0 # max offset in pixels


var trauma_power = 2  # Trauma exponent. Use [2, 3].

@export var noise = FastNoiseLite.new()
var noise_y = 0

func _ready():
	randomize()
	#noise.seed = randi()
	#noise.period = 4
	#noise.octaves = 2

func set_trauma(amount,strength):
	shakeStrength = strength
	shakeTime = amount

func _process(delta):
#	if target:
#		global_position = get_node(target).global_position
	if shakeTime != 0:
		shakeTime = max(shakeTime - delta, 0)
		shake()
	
#	if Input.is_action_just_pressed("shoot"):
#		set_trauma(0.5,50)
	
	


func shake():
	var amount = shakeStrength * (shakeTime if shakeTime < 0.5 else 1)
	noise_y += 1
	rotation = max_roll * amount * noise.get_noise_2d(noise.seed + 5, noise_y)
	offset.x = max_offset.x * amount * noise.get_noise_2d(noise.seed + 5 *2, noise_y)
	offset.y = max_offset.y * amount * noise.get_noise_2d(noise.seed + 5 *3, noise_y)
