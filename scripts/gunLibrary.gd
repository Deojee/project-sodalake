extends Node

class_name gun_library




static func getGunList():
	
	if Globals.gunList != null:
		return Globals.gunList
	
	var explosionPath = preload("res://scenes/explosion.tscn")
	var destructinatorBeamPath = preload("res://beam.tscn")
	var blackHolePath = preload("res://scenes/black_hole.tscn")
	var guns : Array
	
	guns.append( 
		gun_attributes.new(
		"pistol",
		100, #commoness
		preload("res://textures/Weapons and Ammo/Pistol.png"), # Texture2D path
		75, # Gun length
		Vector2(30, 0), # Offset vector
		10, # ammo count
		3, # Fire rate per second
		200, # Recoil
		5, # Bullet spread (degrees)
		10, # Bloom (degrees per shot)
		999, # bloom max. This is taking into account spread, not adding to it
		30, # bloom decay per second
		1100, # Throw speed (pixels per second)
		50, # Throw damage
		bullet_attributes.new(
			preload("res://textures/Weapons and Ammo/Pistol.Bullet.png"), # Texture2D path
			preload("res://sounds/gun noises/genericShoot.wav"), # shoot noise
			Vector2(0, 0), # Offset vector
			5, # Collision shape size
			30, # Bullet damage
			600, # Bullet range
			1200, # Bullet speed
			2000, #knockback
			false #piercing
			# onShootLambda function reference
			# onHitLambda function reference
			)
		#create bullets lambda
		)
	)
	
	guns.append( 
		gun_attributes.new(
		"musketRifle",
		100, #commoness
		preload("res://textures/Weapons and Ammo/Musket.Rifle.png"), # Texture2D path
		140, # Gun length
		Vector2(45, 0), # Offset vector
		3, # ammo count
		3, # Fire rate per second
		160, # Recoil
		0, # Bullet spread (degrees)
		0, # Bloom (degrees per shot)
		0, # bloom max. This is taking into account spread, not adding to it
		0, # bloom decay per second
		800, # Throw speed (pixels per second)
		50, # Throw damage
		bullet_attributes.new(
			preload("res://textures/Weapons and Ammo/Musket.Ball.png"), # Texture2D path
			preload("res://sounds/gun noises/musketShoot.wav"), # shoot noise
			Vector2(0, 0), # Offset vector
			5, # Collision shape size
			40, # Bullet damage
			800, # Bullet range
			2400, # Bullet speed
			6000, #knockback
			false #piercing
			# onShootLambda function reference
			# onHitLambda function reference
		)
		#create bullets lambda
		)
	)
	
	guns.append( 
		gun_attributes.new(
		"minigun",
		100, #commoness
		preload("res://textures/Weapons and Ammo/Standard.Minigun.png"), # Texture2D path
		80, # Gun length
		Vector2(30, 0), # Offset vector
		40, # ammo count
		20, # Fire rate per second
		10, # Recoil
		10, # Bullet spread (degrees)
		3, # Bloom (degrees per shot)
		20, # bloom max. This is taking into account spread, not adding to it
		30, # bloom decay per second
		500, # Throw speed (pixels per second)
		50, # Throw damage
		bullet_attributes.new(
			preload("res://textures/Weapons and Ammo/StandardBullet.png"), # Texture2D path
			preload("res://sounds/gun noises/minigunShoot.wav"), # shoot noise
			Vector2(0, 0), # Offset vector
			10, # Collision shape size
			12, # Bullet damage
			700, # Bullet range
			1600, # Bullet speed
			200, #knockback
			false #piercing
			# onShootLambda function reference
			# onHitLambda function reference
		)
		#create bullets lambda
		)
	)
	
	guns.append( 
		gun_attributes.new(
		"shotGun",
		100, #commoness
		preload("res://textures/Weapons and Ammo/Standard.Shotgun.png"), # Texture2D path
		85, # Gun length
		Vector2(30, 0), # Offset vector
		5, # ammo count
		1.7, # Fire rate per second
		6000, # Recoil
		5, # Bullet spread (degrees)
		15, # Bloom (degrees per shot)
		999, # bloom max. This is taking into account spread, not adding to it
		6, # bloom decay per second
		900, # Throw speed (pixels per second)
		50, # Throw damage
		bullet_attributes.new(
			preload("res://textures/Weapons and Ammo/StandardBullet.png"), # Texture2D path
			preload("res://sounds/gun noises/shotGunShoot2.wav"), # shoot noise
			Vector2(0, 0), # Offset vector
			10, # Collision shape size
			15, # Bullet damage
			600, # Bullet range
			1800, # Bullet speed
			300, #knockback
			false #piercing
			# onShootLambda function reference
			# onHitLambda function reference
		),
		#create bullets lambda
		func(pos,dir): 
		Globals.world.createBullet(pos,dir,"shotGun"); 
		Globals.world.createBullet(pos,dir.rotated(deg_to_rad(5)),"silentShotgun"); 
		Globals.world.createBullet(pos,dir.rotated(deg_to_rad(-5)),"silentShotgun"); 
		Globals.world.createBullet(pos,dir.rotated(deg_to_rad(10)),"silentShotgun"); 
		Globals.world.createBullet(pos,dir.rotated(deg_to_rad(-10)),"silentShotgun")
		
		)
	)
	
	#helper gun for shotgun
	guns.append( 
		gun_attributes.new(
		"silentShotgun",
		0, #commoness
		preload("res://textures/Weapons and Ammo/Standard.Shotgun.png"), # Texture2D path
		0, # Gun length
		Vector2(0, 0), # Offset vector
		0, # ammo count
		0, # Fire rate per second
		0, # Recoil
		0, # Bullet spread (degrees)
		0, # Bloom (degrees per shot)
		0, # bloom max. This is taking into account spread, not adding to it
		0, # bloom decay per second
		0, # Throw speed (pixels per second)
		0, # Throw damage
		bullet_attributes.new(
			preload("res://textures/Weapons and Ammo/StandardBullet.png"), # Texture2D path
			null, # shoot noise
			Vector2(0, 0), # Offset vector
			10, # Collision shape size
			15, # Bullet damage
			600, # Bullet range
			1800, # Bullet speed
			300, #knockback
			false #piercing
			# onShootLambda function reference
			# onHitLambda function reference
		),
		#create bullets lambda
		
		)
	)
	
	guns.append( 
		gun_attributes.new(
		"rayGun",
		50, #commoness
		preload("res://textures/Weapons and Ammo/Raygun.png"), # Texture2D path
		115, # Gun length
		Vector2(35, 0), # Offset vector
		15, # ammo count
		8, # Fire rate per second
		20, # Recoil
		5, # Bullet spread (degrees)
		10, # Bloom (degrees per shot)
		999, # bloom max. This is taking into account spread, not adding to it
		30, # bloom decay per second
		600, # Throw speed (pixels per second)
		50, # Throw damage
		bullet_attributes.new(
			preload("res://textures/Weapons and Ammo/Raygun.Projectile.png"), # Texture2D path
			preload("res://sounds/gun noises/rayGunShoot.wav"), # shoot noise
			Vector2(0, 0), # Offset vector
			5, # Collision shape size
			20, # Bullet damage
			1500, # Bullet range
			450, # Bullet speed
			20, #knockback
			true #piercing
			# onShootLambda function reference
			# onHitLambda function reference
			)
		#create bullets lambda
		)
	)
	
	guns.append( 
		gun_attributes.new(
		"deagle",
		20, #commoness
		preload("res://textures/Weapons and Ammo/Pistol.Deagle.png"), # Texture2D path
		75, # Gun length
		Vector2(30, 0), # Offset vector
		6, # ammo count
		6, # Fire rate per second
		200, # Recoil
		5, # Bullet spread (degrees)
		60, # Bloom (degrees per shot)
		999, # bloom max. This is taking into account spread, not adding to it
		120, # bloom decay per second
		1200, # Throw speed (pixels per second)
		50, # Throw damage
		bullet_attributes.new(
			preload("res://textures/Weapons and Ammo/Pistol.Bullet.png"), # Texture2D path
			preload("res://sounds/gun noises/deagleShoot.mp3"), # shoot noise
			Vector2(0, 0), # Offset vector
			5, # Collision shape size
			60, # Bullet damage
			600, # Bullet range
			1800, # Bullet speed
			4000, #knockback
			false #piercing
			# onShootLambda function reference
			# onHitLambda function reference
			)
		#create bullets lambda
		)
	)
	
	
	guns.append( 
		gun_attributes.new(
		"rpg",
		10, #commoness
		preload("res://textures/Weapons and Ammo/RPG-7.png"), # Texture2D path
		70, # Gun length
		Vector2(15, 0), # Offset vector
		1, # ammo count
		1, # Fire rate per second
		600, # Recoil
		2, # Bullet spread (degrees)
		0, # Bloom (degrees per shot)
		0, # bloom max. This is taking into account spread, not adding to it
		0, # bloom decay per second
		300, # Throw speed (pixels per second)
		50, # Throw damage
		bullet_attributes.new(
			preload("res://textures/Weapons and Ammo/RPG-7.Projectile.png"), # Texture2D path
			preload("res://sounds/gun noises/rpgShoot.wav"), # shoot noise
			Vector2(0, 0), # Offset vector
			10, # Collision shape size
			40, # Bullet damage
			600, # Bullet range
			1200, # Bullet speed
			2000, #knockback
			false, #piercing
			# onShootLambda function reference
			func(shooter,caller): pass,
			# onHitLambda function reference
			func(shooter,target,caller): 
			var explosion = explosionPath.instantiate(); 
			explosion.position = caller.global_position; 
			explosion.shooterId = caller.shooterId
			caller.get_parent().add_child(explosion)
			)
		#create bullets lambda
		)
	)
	
	guns.append( 
		gun_attributes.new(
		"rainBowgun",
		15, #commoness
		preload("res://textures/Weapons and Ammo/rainbowGun.png"), # Texture2D path
		115, # Gun length
		Vector2(35, 0), # Offset vector
		15, # ammo count
		8, # Fire rate per second
		200, # Recoil
		5, # Bullet spread (degrees)
		10, # Bloom (degrees per shot)
		999, # bloom max. This is taking into account spread, not adding to it
		30, # bloom decay per second
		500, # Throw speed (pixels per second)
		50, # Throw damage
		bullet_attributes.new(
			preload("res://textures/Weapons and Ammo/rainbowGun.png"), # Texture2D path
			preload("res://sounds/gun noises/genericShoot.wav"), # shoot noise
			Vector2(0, 0), # Offset vector
			30, # Collision shape size
			50, # Bullet damage
			900, # Bullet range
			1600, # Bullet speed
			3000, #knockback
			false #piercing
			# onShootLambda function reference
			# onHitLambda function reference
		),
		#create bullets lambda
		func(pos,dir): 
		Globals.world.createBullet(pos,dir,gun_library.getRandomGunName()); 
		
		)
	)
	
	guns.append( 
		gun_attributes.new(
		"destructinator",
		5, #commoness
		preload("res://textures/Weapons and Ammo/SelfDestructinator.Improved.png"), # Texture2D path
		140, # Gun length
		Vector2(45, 0), # Offset vector
		12, # ammo count
		1.5, # Fire rate per second
		0, # Recoil
		2, # Bullet spread (degrees)
		0, # Bloom (degrees per shot)
		0, # bloom max. This is taking into account spread, not adding to it
		0, # bloom decay per second
		400, # Throw speed (pixels per second)
		50, # Throw damage
		bullet_attributes.new(
			preload("res://textures/Weapons and Ammo/SelfDestructinator.Beam.png"), # Texture2D path
			preload("res://sounds/gun noises/genericShoot.wav"), # shoot noise
			Vector2(0, 0), # Offset vector
			0, # Collision shape size
			0, # Bullet damage
			0, # Bullet range
			0, # Bullet speed
			0, #knockback
			false, #piercing
			# onShootLambda function reference
			func(shooter,caller):
			var beam = destructinatorBeamPath.instantiate(); 
			beam.position = caller.global_position; 
			beam.rotation = caller.dir.angle()
			beam.shooterId = caller.shooterId
			caller.get_parent().add_child(beam)
			caller.queue_free()
			pass
			# onHitLambda function reference
			
			#create bullets lambda
			)
		)
	)
	
	guns.append( 
		gun_attributes.new(
		"snakeGun",
		5, #commoness
		preload("res://textures/Weapons and Ammo/Snake.Gun.png"), # Texture2D path
		115, # Gun length
		Vector2(35, 0), # Offset vector
		10, # ammo count
		4, # Fire rate per second
		200, # Recoil
		0, # Bullet spread (degrees)
		0, # Bloom (degrees per shot)
		0, # bloom max. This is taking into account spread, not adding to it
		30, # bloom decay per second
		500, # Throw speed (pixels per second)
		50, # Throw damage
		bullet_attributes.new(
			preload("res://textures/Weapons and Ammo/Snake.Gun.png"), # Texture2D path
			preload("res://sounds/gun noises/genericShoot.wav"), # shoot noise
			Vector2(0, 0), # Offset vector
			30, # Collision shape size
			50, # Bullet damage
			900, # Bullet range
			1600, # Bullet speed
			3000, #knockback
			false #piercing
			# onHitLambda function reference
			),
		#create bullets lambda
		func(pos,dir): 
		Globals.world.playSoundFromPath("res://sounds/gun noises/snakeGunShoot.wav",pos)
		Globals.world.addSnakeAsClient(pos,dir * 2500); 
		
		)
	)
	
	guns.append( 
		gun_attributes.new(
		"snakePistol",
		5, #commoness
		preload("res://textures/Weapons and Ammo/snakePistol.png"), # Texture2D path
		115, # Gun length
		Vector2(35, 0), # Offset vector
		12, # ammo count
		8, # Fire rate per second
		200, # Recoil
		8, # Bullet spread (degrees)
		10, # Bloom (degrees per shot)
		50, # bloom max. This is taking into account spread, not adding to it
		50, # bloom decay per second
		1100, # Throw speed (pixels per second)
		50, # Throw damage
		bullet_attributes.new(
			preload("res://textures/Weapons and Ammo/snakePistol.png"), # Texture2D path
			preload("res://sounds/gun noises/genericShoot.wav"), # shoot noise
			Vector2(0, 0), # Offset vector
			30, # Collision shape size
			50, # Bullet damage
			900, # Bullet range
			1600, # Bullet speed
			3000, #knockback
			false #piercing
			# onHitLambda function reference
			),
		#create bullets lambda
		func(pos,dir): 
		Globals.world.playSoundFromPath("res://sounds/gun noises/snakePistolShoot.wav",pos)
		Globals.world.addSnakeAsClient(pos,dir * 2300); 
		
		)
	)
	
	guns.append( 
		gun_attributes.new(
		"snakeShotgun",
		5, #commoness
		preload("res://textures/Weapons and Ammo/Snake.Musket.png"), # Texture2D path
		90, # Gun length
		Vector2(25, 0), # Offset vector
		5, # ammo count
		2, # Fire rate per second
		2000, # Recoil
		15, # Bullet spread (degrees)
		15, # Bloom (degrees per shot)
		40, # bloom max. This is taking into account spread, not adding to it
		10, # bloom decay per second
		700, # Throw speed (pixels per second)
		50, # Throw damage
		bullet_attributes.new(
			preload("res://textures/Weapons and Ammo/Snake.Musket.png"), # Texture2D path
			preload("res://sounds/gun noises/genericShoot.wav"), # shoot noise
			Vector2(0, 0), # Offset vector
			30, # Collision shape size
			50, # Bullet damage
			900, # Bullet range
			1600, # Bullet speed
			3000, #knockback
			false #piercing
			# onHitLambda function reference
			),
		#create bullets lambda
		func(pos,dir): 
		var startFromGun = 30
		var rotationOffset = 15
		Globals.world.playSoundFromPath("res://sounds/gun noises/snakeShotgunShoot.wav",pos)
		Globals.world.addSnakeAsClient(pos + dir.rotated(deg_to_rad(rotationOffset)) * startFromGun,dir.rotated(deg_to_rad(rotationOffset)) * 1500); 
		Globals.world.addSnakeAsClient(pos + dir.rotated(deg_to_rad(-rotationOffset)) * startFromGun,dir.rotated(deg_to_rad(-rotationOffset)) * 1500); 
		Globals.world.addSnakeAsClient(pos + dir * startFromGun,dir * 1500); 
		
		)
	)
	
	guns.append( 
		gun_attributes.new(
		"blinkRifle",
		10, #commoness
		preload("res://textures/Weapons and Ammo/portal.gun.png"), # Texture2D path
		70, # Gun length
		Vector2(20, 0), # Offset vector
		10, # ammo count
		1, # Fire rate per second
		200, # Recoil
		10, # Bullet spread (degrees)
		5, # Bloom (degrees per shot)
		25, # bloom max. This is taking into account spread, not adding to it
		20, # bloom decay per second
		600, # Throw speed (pixels per second)
		50, # Throw damage
		bullet_attributes.new(
			preload("res://textures/Weapons and Ammo/portalProjectile.png"), # Texture2D path
			preload("res://sounds/gun noises/genericShoot.wav"), # shoot noise
			Vector2(0, 0), # Offset vector
			10, # Collision shape size
			0, # Bullet damage
			600, # Bullet range
			2200, # Bullet speed
			-1000, #knockback
			false, #piercing
			# onShootLambda function reference
			func(shooter,caller): pass,
			# onHitLambda function reference
			func(shooter,target,caller): 
			if shooter == Globals.multiplayerId:
				Globals.player.position = caller.global_position - caller.dir * 30
				Globals.world.createDashAttack(caller.global_position,-caller.dir,(caller.start - caller.global_position).length(),caller.shooterId)
			)
		#create bullets lambda
		)
	)
	
	guns.append( 
		gun_attributes.new(
		"blackHoleGun",
		1, #commoness
		preload("res://textures/Weapons and Ammo/Beamgun.png"), # Texture2D path
		70, # Gun length
		Vector2(20, 0), # Offset vector
		1, # ammo count
		1, # Fire rate per second
		1600, # Recoil
		2, # Bullet spread (degrees)
		0, # Bloom (degrees per shot)
		0, # bloom max. This is taking into account spread, not adding to it
		0, # bloom decay per second
		500, # Throw speed (pixels per second)
		50, # Throw damage
		bullet_attributes.new(
			preload("res://textures/Weapons and Ammo/Grenade.Stack.png"), # Texture2D path
			preload("res://sounds/gun noises/genericShoot.wav"), # shoot noise
			Vector2(0, 0), # Offset vector
			10, # Collision shape size
			80, # Bullet damage
			500, # Bullet range
			600, # Bullet speed
			200, #knockback
			true, #piercing
			# onShootLambda function reference
			func(shooter,caller): pass,
			# onHitLambda function reference
			func(shooter,target,caller): 
			var blackHole = blackHolePath.instantiate(); 
			blackHole.position = caller.global_position; 
			blackHole.shooterId = caller.shooterId
			caller.get_parent().add_child(blackHole)
			)
		#create bullets lambda
		)
	)
	
	Globals.gunList = guns
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
	
	var maxRarity = 0
	for gun in list:
		maxRarity += gun.commoness
	
	var gunToPick = randf_range(0,maxRarity)
	var num = 0
	for gun in list:
		num += gun.commoness
		if num >= gunToPick:
			#print(gun.gunName)
			return gun
	
	

static func getTrulyRandomGun():
	var list = getGunList()
	list.shuffle()
	return list[0]

static func getRandomGunName():
	var list = getGunList()
	
	var maxRarity = 0
	for gun in list:
		maxRarity += gun.commoness
	
	var gunToPick = randf_range(0,maxRarity)
	var num = 0
	for gun in list:
		num += gun.commoness
		if num >= gunToPick:
			
			if Globals.gunTracking.has(gun.gunName):
				Globals.gunTracking[gun.gunName] = Globals.gunTracking[gun.gunName] + 1
			else:
				Globals.gunTracking[gun.gunName] = 1
			
			#prints(gun.gunName , " ",Globals.gunTracking[gun.gunName])
			
			return gun.gunName
	
