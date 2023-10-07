extends Node

class_name gun_attributes

var gunTexture : Texture2D

var bulletTexture : Texture2D

var damage = 0
var fireRate = 0
var recoil = 0
var bulletSpread = 0
var bloom = 0
var bulletRange = 0


var throwSpeed = 0
var throwDamage = 0

var onShootLambda : Callable 
var onHitLambda : Callable
var createBulletsLambda : Callable = func():
	print("hey")




