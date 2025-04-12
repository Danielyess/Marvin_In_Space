class_name	HurtBox2D
extends Area2D

func _init() -> void:
	self.collision_layer = 0b0
	self.collision_mask = 0b10
	
	
func _ready() -> void:
	connect("area_entered",self.on_area_entered)

func on_area_entered(hitbox) -> void:
	if hitbox == null:
		return;
	
	if owner.has_method("takeDamage"):
		owner.takeDamage()
