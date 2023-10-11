extends Node

class_name gun_library




static func getGunList():
	
	var guns : Array
	
	guns.append( 
		gun_attributes.new(
		"pistol",
		load("res://textures/pistol.png"), # Texture2D path
		50, # Gun length
		Vector2(10, 0), # Offset vector
		10, # ammo count
		3, # Fire rate per second
		200, # Recoil
		5, # Bullet spread (degrees)
		10, # Bloom (degrees per shot)
		999, # bloom max. This is taking into account spread, not adding to it
		30, # bloom decay per second
		500, # Throw speed (pixels per second)
		50, # Throw damage
		bullet_attributes.new(
			load("res://textures/lil bullet.png"), # Texture2D path
			Vector2(0, 0), # Offset vector
			10, # Collision shape size
			20, # Bullet damage
			600, # Bullet range
			800, # Bullet speed
			2000 #knockback
			# onShootLambda function reference
			# onHitLambda function reference
		)
		#create bullets lambda
		)
	)
	
	guns.append( 
		gun_attributes.new(
		"sniper",
		load("res://textures/snooper.png"), # Texture2D path
		150, # Gun length
		Vector2(30, 0), # Offset vector
		3, # ammo count
		1, # Fire rate per second
		60, # Recoil
		0, # Bullet spread (degrees)
		0, # Bloom (degrees per shot)
		0, # bloom max. This is taking into account spread, not adding to it
		0, # bloom decay per second
		400, # Throw speed (pixels per second)
		20, # Throw damage
		bullet_attributes.new(
			load("res://textures/lil bullet.png"), # Texture2D path
			Vector2(0, 0), # Offset vector
			10, # Collision shape size
			80, # Bullet damage
			800, # Bullet range
			1800, # Bullet speed
			2000 #knockback
			# onShootLambda function reference
			# onHitLambda function reference
		)
		#create bullets lambda
		)
	)
	
	return guns
	

static func getAttributes(gunName):
	
	for gun in getGunList():
		if gun.gunName == gunName:
			return gun
	
	

static func getRandomGun():
	var list = getGunList()
	list.shuffle()
	return list[0]

static func getRandomGunName():
	var list = getGunList()
	list.shuffle()
	return list[0].gunName
