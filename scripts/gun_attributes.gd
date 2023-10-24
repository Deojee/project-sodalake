extends Node

class_name gun_attributes

var gunName 

var commoness = 100

var gunTexture : Texture2D
var length
var texOffset


var maxAmmo = 0
var fireRate = 0
var recoil = 0
var bulletSpread = 0

var bloom = 0
var bloomMax = 0
var bloomDecay = 0

var throwSpeed = 0
var throwDamage = 0



var bullet

var createBulletsLambda : Callable = func(pos, dir):
	Globals.world.createBullet(pos,dir,gunName)


func _init(
	gunName,
	commoness,
	texture: Texture2D,
	gunLength,
	offset,
	ammoCount,
	rate,
	recoil,
	spread,
	bloom,
	bloomMax,
	bloomDecay,
	speed,
	damage,
	
	bulletType,
	_createBulletsLambda = createBulletsLambda
):
	self.gunName = gunName
	self.commoness = commoness
	gunTexture = texture
	texOffset = offset
	maxAmmo = ammoCount
	fireRate = rate
	self.recoil = recoil
	bulletSpread = spread
	self.bloom = bloom
	self.bloomMax = bloomMax
	self.bloomDecay = bloomDecay
	throwSpeed = speed
	throwDamage = damage
	length = gunLength
	bullet = bulletType
	self.createBulletsLambda = _createBulletsLambda


