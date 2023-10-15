extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	generate(%TileMap)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func generate(tilemap : TileMap):
	
	var usedRect = tilemap.get_used_rect()
	var markerMap = []
	
	var collisionId = 0
	var layer = 0
	var cellSize = 32
	
	#0 means untested.
	#1 means filled with nav
	#2 means not filled with nav and shouldn't be
	for x in usedRect.size.x:
		markerMap.append([])
		for y in usedRect.size.y:
			markerMap[x].append(0)
	
	for x in usedRect.size.x:
		x += usedRect.position.x
		for y in usedRect.size.y:
			y += usedRect.position.y
			
			if tilemap.get_cell_alternative_tile(layer,Vector2i(x,y)) == collisionId:
				markerMap[x-usedRect.position.x][y-usedRect.position.y] = 2
			else:
				
				var width = 1
				var height = 1
				
				var tempX = x
				var tempY = y
				
				while tilemap.get_cell_alternative_tile(layer,Vector2i(tempX,tempY)) != collisionId:
					tempX += 1
					markerMap[tempX-usedRect.position.x][tempY-usedRect.position.y] = 1
					width += 1
				
				var flag = true
				while flag:
					tempY += 1
					
					markerMap[tempX-usedRect.position.x][tempY-usedRect.position.y] = 1
					
					for tempTempX in width:
						if tilemap.get_cell_alternative_tile(layer,Vector2i(tempTempX,tempY)) == collisionId:
							flag = false
					
					if flag:
						height += 1
					
				
				var newNavRegion = NavigationRegion2D.new()
				newNavRegion.navigation_polygon = NavigationPolygon.new()
				newNavRegion.navigation_polygon.add_outline(PackedVector2Array(
					[Vector2(x * cellSize, y * cellSize), 
					Vector2((x + width) * cellSize, y * cellSize),
					Vector2((x + width) * cellSize, (y + height) * cellSize),
					Vector2((x) * cellSize, (y + width) * cellSize)
					])
				)
				
			
			
	
	
	
	
