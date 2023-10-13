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
			100, # Collision shape size
			20, # Bullet damage
			600, # Bullet range
			1200, # Bullet speed
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
		100, # Gun length
		Vector2(30, 0), # Offset vector
		3, # ammo count
		3, # Fire rate per second
		160, # Recoil
		0, # Bullet spread (degrees)
		0, # Bloom (degrees per shot)
		0, # bloom max. This is taking into account spread, not adding to it
		0, # bloom decay per second
		900, # Throw speed (pixels per second)
		50, # Throw damage
		bullet_attributes.new(
			load("res://textures/lil bullet.png"), # Texture2D path
			Vector2(0, 0), # Offset vector
			10, # Collision shape size
			40, # Bullet damage
			800, # Bullet range
			2400, # Bullet speed
			6000 #knockback
			# onShootLambda function reference
			# onHitLambda function reference
		)
		#create bullets lambda
		)
	)
	
	guns.append( 
		gun_attributes.new(
		"miniGun",
		load("res://textures/minigun.png"), # Texture2D path
		50, # Gun length
		Vector2(10, 0), # Offset vector
		40, # ammo count
		20, # Fire rate per second
		10, # Recoil
		15, # Bullet spread (degrees)
		10, # Bloom (degrees per shot)
		45, # bloom max. This is taking into account spread, not adding to it
		30, # bloom decay per second
		300, # Throw speed (pixels per second)
		50, # Throw damage
		bullet_attributes.new(
			load("res://textures/lil bullet.png"), # Texture2D path
			Vector2(0, 0), # Offset vector
			10, # Collision shape size
			5, # Bullet damage
			600, # Bullet range
			1600, # Bullet speed
			200 #knockback
			# onShootLambda function reference
			# onHitLambda function reference
		)
		#create bullets lambda
		)
	)
	
	guns.append( 
		gun_attributes.new(
		"shotGun",
		load("res://textures/shotegun.png"), # Texture2D path
		50, # Gun length
		Vector2(30, 0), # Offset vector
		5, # ammo count
		2, # Fire rate per second
		6000, # Recoil
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
			1800, # Bullet speed
			300 #knockback
			# onShootLambda function reference
			# onHitLambda function reference
		),
		#create bullets lambda
		func(pos,dir): Globals.world.createBullet(pos,dir,"shotGun"); Globals.world.createBullet(pos,dir.rotated(deg_to_rad(5)),"shotGun"); Globals.world.createBullet(pos,dir.rotated(deg_to_rad(-5)),"shotGun"); Globals.world.createBullet(pos,dir.rotated(deg_to_rad(10)),"shotGun"); Globals.world.createBullet(pos,dir.rotated(deg_to_rad(-10)),"shotGun")
		
		)
	)
	
	return guns
	

var shotGunBulletsLambda : Callable = func(pos, dir):
	pass
	#Globals.world.createBullet(pos,dir,gunName)

static func getAttributes(gunName):
	
	for gun in getGunList():
		if gun.gunName == str(gunName):
			return gun
	
	

static func getRandomGun():
	var list = getGunList()
	list.shuffle()
	return list[0]

static func getRandomGunName():
	var list = getGunList()
	list.shuffle()
	return list[0].gunName
