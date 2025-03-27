class_name GravityArea2D
extends Area2D

@export var gravityMult : float = 1

func _init() -> void:
	collision_layer = 0b0
	collision_mask = 0b100

func _ready() -> void:
	connect("area_entered",self.on_area_entered)
	connect("area_exited", self.on_area_exited)
	$CollisionShape2D/ColorRect.color = Color((gravityMult/5),0,(1-gravityMult/5),0.1)

func on_area_entered(area) -> void:
	if area == null:
		return
	
	if area.owner.has_method("multGravity"):
		area.owner.multGravity(gravityMult)

func on_area_exited(area) -> void:
	if area == null:
		return
	
	if area.owner.has_method("multGravity"):
		area.owner.multGravity(1/gravityMult)
