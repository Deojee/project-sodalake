extends Node2D

class_name bullet_attributes

#all measurements in pixels per second.

var bulletTexture : Texture2D
var texOffset : Vector2
var collisionShapeSize
var damage
var range
var speed
var knockback

var piercing

var onShootLambda : Callable = func(shooter,caller): #shooter is just an id 
	pass
var explosionPath = preload("res://scenes/explosion.tscn")
var onHitLambda : Callable = func(shooter,target,caller): #shooter is just an id ; target is an object
	pass

# Constructor for bullet_attributes class
func _init(
	texture: Texture2D,
	offset: Vector2,
	collisionSize,
	bulletDamage,
	bulletRange,
	bulletSpeed,
	knockback,
	piercing,
	onShootFunc : Callable = onShootLambda,
	onHitFunc : Callable = onHitLambda
):
	bulletTexture = texture
	texOffset = offset
	collisionShapeSize = collisionSize
	damage = bulletDamage
	range = bulletRange
	speed = bulletSpeed
	self.knockback = knockback
	self.piercing = piercing
	onShootLambda = onShootFunc
	onHitLambda = onHitFunc
