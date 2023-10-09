extends Node

var bulletTexture : Texture2D
var texOffset : Vector2
var collisionShapeSize
var damage
var range
var speed

var onShootLambda : Callable 
var onHitLambda : Callable
