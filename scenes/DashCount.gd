extends FlowContainer


# Called when the node enters the scene tree for the first time.
func _ready():
	
	dictionary = {
		#$TextureRect3 : true,
		$TextureRect4 : true,
		$TextureRect2 : true
	}
	
	pass # Replace with function body.

var dictionary = {}

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Globals.playerDashes > count:
		add()
	if Globals.playerDashes < count:
		subtract()
	
	
	#print(count)
	pass

var max = 2
var count = 2

func add():
	if count == max:
		return
	count += 1
	for child in get_children():
		if !dictionary[child]:
			dictionary[child] = true
			appear(child)
			break
		

func subtract():
	if count == 0:
		return
	count -= 1
	var arr = get_children()
	arr.reverse()
	for child in arr:
		if dictionary[child]:
			dictionary[child] = false
			disapear(child)
			break
		

func disapear(node):
	
	var tween = get_tree().create_tween()
	
	tween.tween_property(node,"modulate", Color(1,1,1,0), 0.1)
	#tween.tween_callback(func (): node.visible = false)
	
	pass

func appear(node):
	print(node.visible)
	var tween = get_tree().create_tween()
	
	#node.visible = true
	#tween.tween_callback(func (): node.visible = true)
	tween.tween_property(node,"modulate", Color(1,1,1,1), 0.1)
	
	
	pass
