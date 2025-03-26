class_name	HurtBox
extends Area2D

func _init() -> void:
	collision_layer = 0
	collision_mask = 2
	
func _ready() -> void:
	connect("area_entered",self.on_area_entered)

func on_area_entered(hitbox) -> void:
	if hitbox == null:
		return;
	
	if owner.has_method("takeDamage"):
		owner.takeDamage()
