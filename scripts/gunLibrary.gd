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
		10, # Fire rate (per second)
		10, # ammo count
		2, # Recoil
		5, # Bullet spread (degrees)
		3, # Bloom (degrees per shot)
		50, # bloom max. This is taking into account spread, not adding to it
		50, # bloom decay per second
		15, # Throw speed (pixels per second)
		20, # Throw damage
		bullet_attributes.new(
			load("res://textures/lil bullet.png"), # Texture2D path
			Vector2(0, 0), # Offset vector
			10, # Collision shape size
			20, # Bullet damage
			100, # Bullet range
			200, # Bullet speed
			20 #knockback
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
	
	

