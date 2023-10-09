extends Node

class_name gun_attributes

var gunTexture : Texture2D

var texOffset


var fireRate = 0
var recoil = 0
var bulletSpread = 0
var bloom = 0


var throwSpeed = 0
var throwDamage = 0


var createBulletsLambda : Callable = func(pos, dir):
	World.createBullet(pos,dir,"pistol")




