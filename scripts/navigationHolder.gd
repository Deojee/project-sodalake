extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	
	generate(%TileMap)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

var shown = false


func generate(tilemap : TileMap):
	
	var usedRect = tilemap.get_used_rect()
	prints(usedRect.position,usedRect.size)
	print("starting generation of map")
	
	var markerMap = []
	
	var indiceNum = 0
	
	var nonCollisionId = -1
	var layer = 0
	var cellSize = tilemap.tile_set.tile_size.x * tilemap.scale.x
	
	#0 means untested.
	#1 means filled with nav
	#2 means not filled with nav and shouldn't be
	for x in usedRect.size.x:
		markerMap.append([])
		for y in usedRect.size.y:
			markerMap[x].append(0)
	
	
	for y in usedRect.size.y:
		y += usedRect.position.y
		for x in usedRect.size.x:
			x += usedRect.position.x
			
			
			if tilemap.get_cell_alternative_tile(layer,Vector2i(x,y)) != nonCollisionId:
				markerMap[x-usedRect.position.x][y-usedRect.position.y] = 1
			else:
				
				if markerMap[x-usedRect.position.x][y-usedRect.position.y] == 2:
#					var rect = ColorRect.new()
#					rect.size.x = cellSize/2.0
#					rect.size.y = cellSize/2.0
#					rect.position.x = x * cellSize + cellSize/4.0
#					rect.position.y = y * cellSize + cellSize/4.0
#					rect.z_index = 5
#					rect.color = Color.RED
#
#					add_child(rect)
#
#					await get_tree().create_timer(0.01).timeout
					
					continue
				
				var width = 0
				var height = 1
				
				var tempX = x
				var tempY = y
				
				print("hey")
				
				while (
						markerMap[tempX-usedRect.position.x][tempY-usedRect.position.y] == 0
						and 
						tilemap.get_cell_alternative_tile(layer,Vector2i(tempX,tempY)) == nonCollisionId
					): #this loop is fine
					
					print("in the first loop")
					
					
					markerMap[tempX-usedRect.position.x][tempY-usedRect.position.y] = 2
					
					
					tempX += 1
					width += 1
					
					if usedRect.position.x + usedRect.size.x - 1 < tempX:
						#not hapening right now
						break
					
					
				
				print("escaped first loop")
				
				
				#print(markerMap[tempX-usedRect.position.x][tempY-usedRect.position.y] == 0)
				#print(tilemap.get_cell_alternative_tile(layer,Vector2i(tempX,tempY)) == nonCollisionId)
				
				pass
				
				
				print("starting that second loop")
				var flag = true
				while flag: #we do escape this
					print(Time.get_ticks_msec())
					tempY += 1
					
					if usedRect.position.y + usedRect.size.y - 1 < tempY:
						break
					
					#markerMap[tempX-usedRect.position.x][tempY-usedRect.position.y] = 2
					
					for tempTempX in width:
						if tilemap.get_cell_alternative_tile(layer,Vector2i(x + tempTempX,tempY)) != nonCollisionId:
							flag = false
						
					
					if flag:
						height += 1
						for tempTempX in width:
							markerMap[x + tempTempX - usedRect.position.x][tempY-usedRect.position.y] = 2
#							var rect = ColorRect.new()
#							rect.size.x = cellSize/2
#							rect.size.y = cellSize/2
#							rect.position.x = x * cellSize + tempTempX * cellSize + cellSize/4
#							rect.position.y = tempY * cellSize + cellSize/4
#							rect.color = Color.YELLOW
#							rect.z_index = 2
#							add_child(rect)
						
				
				
				if !shown:
					
					var inset = 6
					
					var vertices = PackedVector2Array(
						[Vector2(x * cellSize + inset, y * cellSize + inset), 
						Vector2((x + width) * cellSize - inset, y * cellSize + inset),
						Vector2((x + width) * cellSize - inset, (y + height) * cellSize - inset),
						Vector2((x) * cellSize + inset, (y + height) * cellSize -inset)
						]
					)
					
					var newNav = NavigationRegion2D.new()
					newNav.navigation_polygon = NavigationPolygon.new()
					newNav.navigation_polygon.add_outline(vertices)
					
					
					#newNav.navigation_polygon.make_polygons_from_outlines() //depreciated
					
					newNav.navigation_polygon.parse_source_geometry_data() 
					newNav.navigation_polygon.bake_from_source_geometry_data() 
					
					add_child(newNav)
					
	
	
	
	print("finished this code")
