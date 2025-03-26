extends Area2D

func _init() -> void:
	collision_layer = 0
	collision_mask = 3

func _ready() -> void:
	connect("area_entered", self.showInteract)
	connect("area_exited", self.hideInteract)


func showInteract(interactionArea) -> void:
	if interactionArea == null:
		return;
	
	if owner.has_method("showInteract"):
		owner.showInteract()

func hideInteract(interactionArea) -> void:
	if interactionArea == null:
		return;
	
	if owner.has_method("hideInteract"):
		owner.hideInteract()
