class_name Interact_Area2D
extends Area2D

func _init() -> void:
	self.collision_layer = 0b0
	self.collision_mask = 0b100

func _ready() -> void:
	connect("area_entered", self.onEnter)
	connect("area_exited", self.onExit)


func onEnter(interactionArea : Area2D) -> void:
	if interactionArea == null:
		return;
	if interactionArea.owner.has_method("addInteractable"):
		interactionArea.owner.addInteractable(self)
	
	if owner.has_method("showInteract"):
		owner.showInteract()
		

func onExit(interactionArea : Area2D) -> void:
	if interactionArea == null:
		return;
	if interactionArea.owner.has_method("removeInteractable"):
		interactionArea.owner.removeInteractable(self)
	
	if owner.has_method("hideInteract"):
		owner.hideInteract()

func interact():
	if owner.has_method("interact"):
		owner.interact()
