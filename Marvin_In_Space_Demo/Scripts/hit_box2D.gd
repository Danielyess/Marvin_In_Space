class_name HitBox2D
extends Area2D

func _init() -> void:
	self.collision_layer = 0b10
	self.collision_mask = 0b0
