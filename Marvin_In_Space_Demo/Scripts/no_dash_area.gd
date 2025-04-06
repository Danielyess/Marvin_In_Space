class_name NoDashArea
extends Area2D

func _init() -> void:
	collision_layer = 0b0
	collision_mask = 0b100

func _ready() -> void:
	connect("area_entered",self.on_area_entered)
	connect("area_exited", self.on_area_exited)

func on_area_entered(area) -> void:
	if area == null:
		return
	
	area.owner.canTeleport = false
	area.owner.updateTeleportSprite()

func on_area_exited(area) -> void:
	if area == null:
		return
	
	area.owner.canTeleport = true
	area.owner.updateTeleportSprite()
