extends Node2D

class_name damageInflicter

var shooterId = 0

func dealDamage(target,dir,knockback,damage):
	
	if target.is_in_group("player"):
		target.takeDamage(dir,knockback,damage,shooterId)
	else:
		target.takeDamage(dir,knockback,damage)
	
	


